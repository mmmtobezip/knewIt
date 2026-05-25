#!/bin/bash
# db_export.sql을 로컬 DB에 복원
# 실행: bash backend/docs/restore.sh

CONTAINER="pos-pn-postgres"
DB_USER="pos"
DB_NAME="pos_pricing_navigator"
INPUT="$(dirname "$0")/db_export.sql"

if [ ! -f "$INPUT" ]; then
  echo "db_export.sql 파일이 없습니다: $INPUT"
  exit 1
fi

docker exec -i "$CONTAINER" psql -U "$DB_USER" "$DB_NAME" < "$INPUT"
echo "restore 완료"
