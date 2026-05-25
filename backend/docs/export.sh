#!/bin/bash
# 로컬 DB를 dump해서 db_export.sql 생성
# 실행: bash backend/docs/export.sh

CONTAINER="pos-pn-postgres"
DB_USER="pos"
DB_NAME="pos_pricing_navigator"
OUTPUT="$(dirname "$0")/db_export.sql"

docker exec "$CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" > "$OUTPUT"
echo "export 완료: $OUTPUT"
