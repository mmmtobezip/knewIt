"""docs/resource/판매량_가이드.csv + 판매량_실적.csv 를 단일 행 단위로 재작성.

설계자 피드백 반영:
  기존 헤더: 큰 카테고리, 중간 카테고리, 제품, 가이드값(or 실적), 단위, 연도_월
  새  헤더: 판매그룹, 제품, 고객사, 가이드값(or 실적), 단위, 연도_월

변환 규칙:
  - 큰 카테고리="그룹별"   → DROP (메타행, BE 가 SUM 으로 자동 계산)
  - 큰 카테고리="제품별"   → DROP (메타행)
  - 큰 카테고리="고객사별" → KEEP
      판매그룹 = "{product}판매그룹" (예: "후판판매그룹")
      제품     = product
      고객사   = 중간 카테고리

1회성 변환 스크립트 (멱등 — 이미 새 헤더면 noop).
실행: cd backend && uv run python -m scripts.rewrite_sales_csv_unified
"""
from __future__ import annotations

import csv
from pathlib import Path

CSV_DIR = Path(__file__).resolve().parent.parent.parent / "docs" / "resource"


def rewrite(filename: str, value_key: str) -> None:
    path = CSV_DIR / filename
    print(f"\n═══ {filename}")

    with path.open(encoding="utf-8", newline="") as fh:
        reader = csv.DictReader(fh)
        fields = list(reader.fieldnames or [])
        if "판매그룹" in fields:
            print("  [skip] 이미 새 헤더 적용됨")
            return
        if "큰 카테고리" not in fields:
            print(f"  [skip] 기존 헤더 인식 실패: {fields}")
            return
        rows = list(reader)

    out_rows: list[dict] = []
    drop_count = {"그룹별": 0, "제품별": 0}
    for r in rows:
        cat_big = r.get("큰 카테고리", "").strip()
        cat_mid = r.get("중간 카테고리", "").strip()
        product = (r.get("제품") or "").strip()

        if cat_big in {"그룹별", "제품별"}:
            drop_count[cat_big] = drop_count.get(cat_big, 0) + 1
            continue
        if cat_big != "고객사별":
            print(f"  [WARN] 알 수 없는 큰 카테고리: {cat_big!r}, skip")
            continue
        if not product:
            print(f"  [WARN] 고객사별 행에 제품 누락: {cat_mid} {r.get('연도_월')}, skip")
            continue

        out_rows.append({
            "판매그룹": f"{product}판매그룹",
            "제품": product,
            "고객사": cat_mid,
            value_key: r.get(value_key, ""),
            "단위": r.get("단위", "천톤"),
            "연도_월": r.get("연도_월", ""),
        })

    new_fields = ["판매그룹", "제품", "고객사", value_key, "단위", "연도_월"]
    with path.open("w", encoding="utf-8", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=new_fields, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(out_rows)

    print(f"  {len(rows)}행 → {len(out_rows)}행")
    print(f"  drop: 그룹별={drop_count.get('그룹별',0)} / 제품별={drop_count.get('제품별',0)}")


if __name__ == "__main__":
    rewrite("판매량_가이드.csv", "가이드값")
    rewrite("판매량_실적.csv", "실적")
    print("\n완료. seed_sales_data 재실행으로 DB 동기화 필요.")
