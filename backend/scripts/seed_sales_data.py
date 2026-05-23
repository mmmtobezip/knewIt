"""docs/resource/*.csv → 5개 sales-guide 테이블 upsert.

처리 흐름 (PRD 2.10 데이터 조인 준수):
    1. 제품_품종.csv       → product_variants
    2. 판매량_가이드.csv   → sales_guides
    3. 판매량_실적.csv     → sales_actuals
    4. 주문.csv            → order_lines (판매사원 매핑)
    5. 출하실적.csv        → shipments (매출계상일 ISO parsing)

PRD 의 컬럼명(한글) → 모델 컬럼(영문) 매핑은 _ROW_MAP 에 명시.
asyncpg short-int(32,767) prepared statement 한계로 chunked upsert.

실행: cd backend && uv run python -m scripts.seed_sales_data
"""
from __future__ import annotations

import asyncio
import csv
from collections.abc import Iterator
from datetime import date, datetime
from pathlib import Path
from typing import Any

from sqlalchemy.dialects.postgresql import insert

from app.db import SessionLocal
from app.models import OrderLine, ProductVariant, SalesActual, SalesGuide, Shipment

CSV_DIR = Path(__file__).resolve().parent.parent.parent / "docs" / "resource"
CHUNK = 500


def _read_csv(name: str) -> Iterator[dict[str, Any]]:
    path = CSV_DIR / name
    with path.open(encoding="utf-8", newline="") as fh:
        for row in csv.DictReader(fh):
            yield {k.strip(): (v.strip() if isinstance(v, str) else v) for k, v in row.items()}


async def _upsert(model, rows: list[dict[str, Any]], conflict: list[str]) -> int:
    if not rows:
        return 0
    async with SessionLocal() as s:
        for i in range(0, len(rows), CHUNK):
            chunk = rows[i : i + CHUNK]
            stmt = insert(model).values(chunk)
            update_cols = {c.name: stmt.excluded[c.name] for c in model.__table__.c
                           if c.name not in conflict and c.name not in {"id", "created_at", "updated_at"}}
            await s.execute(stmt.on_conflict_do_update(index_elements=conflict, set_=update_cols))
        await s.commit()
    return len(rows)


async def _replace(model, rows: list[dict[str, Any]]) -> int:
    """전체 삭제 후 bulk insert. PG ON CONFLICT 가 NULL 컬럼(product)을 distinct
    로 처리하기 때문에 sales_guides/sales_actuals 에는 upsert 대신 replace 사용."""
    from sqlalchemy import delete
    if not rows:
        return 0
    async with SessionLocal() as s:
        await s.execute(delete(model))
        for i in range(0, len(rows), CHUNK):
            await s.execute(insert(model).values(rows[i:i + CHUNK]))
        await s.commit()
    return len(rows)


# ─────────────────── per-CSV loaders ───────────────────


def _load_product_variants() -> list[dict[str, Any]]:
    """제품_품종.csv: 제품,품종,품명,상세내용"""
    out: dict[tuple[str, str], dict[str, Any]] = {}
    for r in _read_csv("제품_품종.csv"):
        key = (r["품종"], r["품명"])
        out[key] = {
            "variant_code": r["품종"],
            "variant_name": r["품명"],
            "product": r["제품"],
            "detail": r.get("상세내용") or None,
        }
    return list(out.values())


def _load_sales(name: str, value_key: str, target_col: str) -> list[dict[str, Any]]:
    """판매량_가이드.csv / 판매량_실적.csv 공통 로더.

    스키마: 큰 카테고리, 중간 카테고리, 제품(NEW), <value_key>, 단위, 연도_월
    "그룹별" 행은 제품=빈 문자열 → product=NULL.
    "제품별"/"고객사별" 행은 product 채워짐 (고객사별 + 다제품 = split 결과).
    """
    out: dict[tuple[str, str, str | None, str], dict[str, Any]] = {}
    for r in _read_csv(name):
        cat_big = r["큰 카테고리"]
        cat_mid = r["중간 카테고리"]
        product_raw = (r.get("제품") or "").strip()
        product = product_raw or None
        ym = str(r["연도_월"]).strip()
        key = (cat_big, cat_mid, product, ym)
        try:
            value = float(r[value_key])
        except (TypeError, ValueError):
            continue
        out[key] = {
            "category_big": cat_big,
            "category_mid": cat_mid,
            "product": product,
            target_col: value,
            "unit": r.get("단위") or "천톤",
            "ym_str": ym,
        }
    return list(out.values())


def _load_orders() -> list[dict[str, Any]]:
    """주문.csv: 주문번호_라인,고객사명,품종,판매사원"""
    out: dict[str, dict[str, Any]] = {}
    for r in _read_csv("주문.csv"):
        out[r["주문번호_라인"]] = {
            "order_line_no": r["주문번호_라인"],
            "customer_name": r["고객사명"],
            "variant_code": r["품종"],
            "salesperson": r["판매사원"],
        }
    return list(out.values())


def _parse_shipped_date(value: str) -> date | None:
    """매출계상일 — ISO(2026-05-12) 우선, 실패 시 YYYYMMDD."""
    s = value.strip()
    if not s:
        return None
    try:
        return datetime.fromisoformat(s).date()
    except ValueError:
        pass
    if s.isdigit() and len(s) == 8:
        try:
            return date(int(s[:4]), int(s[4:6]), int(s[6:8]))
        except ValueError:
            return None
    return None


def _load_shipments() -> list[dict[str, Any]]:
    """출하실적.csv: 매출계상일,고객사명,중량,중량_단위,주문번호_라인,품종"""
    out: dict[tuple[str, date], dict[str, Any]] = {}
    for r in _read_csv("출하실적.csv"):
        shipped = _parse_shipped_date(r["매출계상일"])
        if shipped is None:
            continue
        try:
            weight = float(r["중량"])
        except (TypeError, ValueError):
            continue
        key = (r["주문번호_라인"], shipped)
        out[key] = {
            "shipped_at": shipped,
            "customer_name": r["고객사명"],
            "weight_kg": weight,
            "weight_unit": r.get("중량_단위") or "Kg",
            "order_line_no": r["주문번호_라인"],
            "variant_code": r["품종"],
        }
    return list(out.values())


# ─────────────────── main ───────────────────


async def main() -> None:
    pv = _load_product_variants()
    sg = _load_sales("판매량_가이드.csv", "가이드값", "guide_value")
    sa_ = _load_sales("판매량_실적.csv", "실적", "actual_value")
    ol = _load_orders()
    sh = _load_shipments()

    print(f"product_variants : {len(pv)}")
    print(f"sales_guides     : {len(sg)}")
    print(f"sales_actuals    : {len(sa_)}")
    print(f"order_lines      : {len(ol)}")
    print(f"shipments        : {len(sh)}")

    n_pv = await _upsert(ProductVariant, pv, ["variant_code", "variant_name"])
    n_sg = await _replace(SalesGuide, sg)
    n_sa = await _replace(SalesActual, sa_)
    n_ol = await _upsert(OrderLine, ol, ["order_line_no"])
    n_sh = await _upsert(Shipment, sh, ["order_line_no", "shipped_at"])

    print(f"upserted: pv={n_pv} sg={n_sg} sa={n_sa} ol={n_ol} sh={n_sh}")


if __name__ == "__main__":
    asyncio.run(main())
