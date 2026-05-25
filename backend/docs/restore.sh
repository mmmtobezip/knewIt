#!/bin/bash
#
# db_export.sql 을 로컬 DB 에 복원
#
# 안정성 보강 (2026-05-25):
#   1. 모든 시연 테이블 TRUNCATE CASCADE — 기존 row 와 PK 충돌 회피
#   2. dump 적용 시 CREATE/INDEX/CONSTRAINT 의 "already exists" 에러는 stderr 만
#      출력 (무해, 스키마는 alembic 으로 관리됨)
#   3. 복원 후 Redis FLUSHALL — 옛 LLM 응답 캐시 자동 제거
#   4. 마지막에 테이블 행수 출력 (검증용)
#
# 실행: bash backend/docs/restore.sh

set -euo pipefail

CONTAINER="${PG_CONTAINER:-pos-pn-postgres}"
DB_USER="${PG_USER:-pos}"
DB_NAME="${PG_DB:-pos_pricing_navigator}"
REDIS_CONTAINER="${REDIS_CONTAINER:-pos-pn-redis}"
INPUT="$(dirname "$0")/db_export.sql"

# ─── 사전 점검 ──────────────────────────────────────────────────
if [ ! -f "$INPUT" ]; then
  echo "❌ db_export.sql 파일이 없습니다: $INPUT"
  exit 1
fi
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
  echo "❌ Docker 컨테이너 '${CONTAINER}' 가 실행 중이 아닙니다."
  echo "   먼저: cd backend && docker compose up -d"
  exit 1
fi

# ─── 1) 기존 시연 데이터 TRUNCATE ────────────────────────────────
echo "▶ 1/3 기존 시연 데이터 TRUNCATE (CASCADE)"
docker exec "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -q -c "
DO \$\$
DECLARE
  t text;
  tables text[] := ARRAY[
    'shipments', 'order_lines',
    'sales_guides', 'sales_actuals',
    'product_variants', 'products',
    'assigned_customers', 'customer_profiles',
    'org_hierarchy', 'trigger_events',
    'indicators', 'users',
    'alembic_version'
  ];
BEGIN
  FOREACH t IN ARRAY tables LOOP
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = t) THEN
      EXECUTE format('TRUNCATE TABLE %I RESTART IDENTITY CASCADE', t);
    END IF;
  END LOOP;
END \$\$;
" >/dev/null

# ─── 2) dump 적용 ──────────────────────────────────────────────
# - 스키마(CREATE/INDEX/CONSTRAINT) 는 이미 alembic 으로 생성됨 →
#   "already exists" 에러는 stderr 만 출력 (무해)
# - dump 의 COPY 순서가 FK 위반을 야기할 수 있어 (예: assigned_customers
#   가 customer_profiles 보다 먼저 적용) session_replication_role = 'replica'
#   로 FK 트리거 임시 비활성화. 세션 종료 시 자동 복구.
echo "▶ 2/3 dump 적용 (db_export.sql)"
{ echo "SET session_replication_role = 'replica';"; cat "$INPUT"; } \
  | docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -q \
  2> >(grep -vE "already exists|multiple primary keys|invalid command" >&2 || true) \
  >/dev/null

# ─── 3) Redis 캐시 비우기 (옛 LLM 응답 무효화) ───────────────────
echo "▶ 3/3 Redis FLUSHALL"
if docker ps --format '{{.Names}}' | grep -q "^${REDIS_CONTAINER}$"; then
  docker exec "${REDIS_CONTAINER}" redis-cli FLUSHALL >/dev/null
else
  echo "   ⚠️ Redis 컨테이너 '${REDIS_CONTAINER}' 없음 — skip"
fi

# ─── 결과 검증 ──────────────────────────────────────────────────
echo ""
echo "✅ Restore 완료. 주요 테이블 행수:"
docker exec "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -t -A -F'=' -c "
SELECT 'shipments         ', COUNT(*) FROM shipments UNION ALL
SELECT 'order_lines       ', COUNT(*) FROM order_lines UNION ALL
SELECT 'sales_guides      ', COUNT(*) FROM sales_guides UNION ALL
SELECT 'sales_actuals     ', COUNT(*) FROM sales_actuals UNION ALL
SELECT 'indicators        ', COUNT(*) FROM indicators UNION ALL
SELECT 'customer_profiles ', COUNT(*) FROM customer_profiles UNION ALL
SELECT 'assigned_customers', COUNT(*) FROM assigned_customers UNION ALL
SELECT 'users             ', COUNT(*) FROM users
ORDER BY 1;
" 2>/dev/null | sed 's/^/  /'

echo ""
echo "▶ 다음 단계:"
echo "   • BE 가 떠 있으면 자동 반영 (코드 변경 없음 → restart 불필요)"
echo "   • 브라우저: Cmd+Shift+R 하드 리프레시"
