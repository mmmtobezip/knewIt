"""docs/resource/판매량_가이드.csv + 판매량_실적.csv 에 '제품' 컬럼 추가.

설계자 피드백:
  - "고객사별" 행을 제품별로 split (포스코인터내셔널 = 선재/후판 5:5)
  - 단일 제품 고객사는 그냥 product 컬럼 채움
  - "제품별" 행은 자기 자신 제품으로 채움
  - "그룹별" 행은 NULL 유지

1회성 변환 스크립트. 멱등 (이미 '제품' 컬럼이 있으면 noop).

실행: cd backend && uv run python -m scripts.augment_sales_csv_product
"""
from __future__ import annotations

import csv
from pathlib import Path

CSV_DIR = Path(__file__).resolve().parent.parent.parent / "docs" / "resource"

# 단일 제품 고객사 매핑 (CUSTOMER_PROFILE.product_group 과 일치)
SINGLE_PRODUCT: dict[str, str] = {
    # 박지은 4 (선재 단일)
    "고려제강": "선재",
    "동일제강": "선재",
    "New Best Wire Industrial Co., Ltd": "선재",
    "Nissan Motor Co., Ltd": "선재",
    # 박현웅 4 (후판 단일)
    "현대중공업": "후판",
    "삼성중공업": "후판",
    "한화오션": "후판",
    "포스코건설": "후판",
}

# 다제품 고객사 split 비율 (sum=1.0)
MULTI_PRODUCT_SPLIT: dict[str, dict[str, float]] = {
    "포스코인터내셔널": {"선재": 0.55, "후판": 0.45},   # 트레이딩 비중 — 선재가 약간 우세
}


def split_value(value: float, ratio: float) -> float:
    """비율 split — 1자리 반올림 (천톤 단위)."""
    return round(value * ratio, 1)


def transform_row(row: dict, value_key: str) -> list[dict]:
    """1개 행 → 1~N개 행으로 분리."""
    cat_big = row["큰 카테고리"]
    cat_mid = row["중간 카테고리"]

    if cat_big == "그룹별":
        return [{**row, "제품": ""}]                          # NULL

    if cat_big == "제품별":
        # category_mid 자체가 제품명 (후판/선재/HR(고로밀))
        return [{**row, "제품": cat_mid}]

    if cat_big == "고객사별":
        if cat_mid in MULTI_PRODUCT_SPLIT:
            try:
                v = float(row[value_key])
            except (TypeError, ValueError):
                return [{**row, "제품": ""}]
            out = []
            for product, ratio in MULTI_PRODUCT_SPLIT[cat_mid].items():
                new_row = dict(row)
                new_row["제품"] = product
                new_row[value_key] = split_value(v, ratio)
                out.append(new_row)
            return out
        # 단일 제품 고객사
        product = SINGLE_PRODUCT.get(cat_mid)
        if product is None:
            print(f"  [WARN] 미매핑 고객사 (제품 NULL): {cat_mid}")
            return [{**row, "제품": ""}]
        return [{**row, "제품": product}]

    return [{**row, "제품": ""}]


def augment(filename: str, value_key: str) -> None:
    path = CSV_DIR / filename
    print(f"\n═══ {filename}")

    with path.open(encoding="utf-8", newline="") as fh:
        reader = csv.DictReader(fh)
        original_fieldnames = list(reader.fieldnames or [])
        if "제품" in original_fieldnames:
            print(f"  [skip] 이미 '제품' 컬럼 존재")
            return
        rows_in = list(reader)

    # 새 컬럼 순서: 큰 카테고리, 중간 카테고리, 제품, <value_key>, 단위, 연도_월
    new_fieldnames = ["큰 카테고리", "중간 카테고리", "제품", value_key, "단위", "연도_월"]

    rows_out: list[dict] = []
    for row in rows_in:
        rows_out.extend(transform_row(row, value_key))

    with path.open("w", encoding="utf-8", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=new_fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows_out)

    print(f"  {len(rows_in)}행 → {len(rows_out)}행 (split 차이 = {len(rows_out) - len(rows_in)})")


if __name__ == "__main__":
    augment("판매량_가이드.csv", "가이드값")
    augment("판매량_실적.csv", "실적")
    print("\n완료. seed_sales_data 재실행으로 DB 동기화 필요.")
