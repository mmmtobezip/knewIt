"""합성 출하/주문 데이터 생성기 (당월 한정) — B2B 철강 영업 도메인 방법론.

목적:
    PRD 의 설계자 피드백 반영 — 과거 11개월은 sales_actuals 테이블이 담당
    (월별 집계), 당월 실적만 shipments raw transaction 사용. 이 스크립트는
    "당월(2026-05-01 ~ 시연 기준일 2026-05-15)" 영업 도메인 사실적 분포로 생성.

적용 방법론 (Level 10):
    ① Holt-Winters Seasonal Index (Holt 1957) — 5월=1.0
    ② Pareto / Power Law (Long Tail) — 단건 weight 정규분포 + 5% heavy-tail
    ③ Quarter-End Push (McKinsey B2B Pulse) — 월말 5영업일 가중
    ④ Weekday Effect (Steelmint) — 월 0.6 / 화수목 1.2-1.3 / 금 1.0
    ⑤ Industry Order Cycle (Bosworth Solution Selling) — 산업별 단건 weight
    ⑥ Achievement Rate (Korn Ferry) — 박지은 5월 0.61 / 박현웅 5월 0.71
    ⑦ Salesperson Performance Mix (Gartner Quota Attainment)

생성 규모 (5월 절반만):
    약 80~120 건 (박지은 + 박현웅 합). 가이드 대비 30~70% 달성.

실행: cd backend && uv run python -m scripts.seed_synthetic_sales [--dry-run]
"""
from __future__ import annotations

import argparse
import asyncio
import calendar
import random
from dataclasses import dataclass
from datetime import date as DateT
from datetime import timedelta

from sqlalchemy import delete
from sqlalchemy.dialects.postgresql import insert

from app.db import SessionLocal
from app.models import OrderLine, Shipment

random.seed(20260523)  # 결정론적 시드 — 시연 재현성

DEMO_TODAY = DateT(2026, 5, 15)
GEN_START = DateT(2026, 5, 1)     # 당월 시작 (과거 11개월은 sales_actuals 가 담당)
GEN_END = DEMO_TODAY              # 시연 기준일


# ───────────────── 방법론 ① Holt-Winters Seasonal Index ─────────────────

SEASONAL_INDEX: dict[int, float] = {
    1: 0.70, 2: 0.75, 3: 1.10, 4: 1.05, 5: 1.00, 6: 0.95,
    7: 0.85, 8: 0.85, 9: 1.15, 10: 1.10, 11: 1.05, 12: 1.20,
}

# ───────────────── 방법론 ④ Weekday Effect (0=월 .. 4=금) ─────────────────

WEEKDAY_WEIGHT: dict[int, float] = {0: 0.6, 1: 1.2, 2: 1.3, 3: 1.2, 4: 1.0}


# ───────────────── 방법론 ⑤ Industry Order Cycle ─────────────────


@dataclass(slots=True)
class CustomerProfile:
    name: str
    salesperson: str
    variant_codes: list[str]                  # 출하 가능 품종 (제품 일관성)
    avg_weight_ton: float                     # 단건 평균 (톤)
    std_weight_ton: float                     # 표준편차 (톤)
    monthly_orders_min: int
    monthly_orders_max: int
    monthly_base_kt: float                    # 정상 월(시즌 1.0)의 기대 출하량 (천톤)


# 박지은 (선재 5 고객사)
JIEUN: list[CustomerProfile] = [
    CustomerProfile("고려제강", "박지은", ["WR"], avg_weight_ton=600, std_weight_ton=200,
                    monthly_orders_min=8, monthly_orders_max=10, monthly_base_kt=15.0),
    CustomerProfile("동일제강", "박지은", ["WR"], avg_weight_ton=500, std_weight_ton=150,
                    monthly_orders_min=7, monthly_orders_max=9, monthly_base_kt=20.0),
    CustomerProfile("New Best Wire Industrial Co., Ltd", "박지은", ["WR"],
                    avg_weight_ton=800, std_weight_ton=300,
                    monthly_orders_min=6, monthly_orders_max=8, monthly_base_kt=30.0),
    CustomerProfile("Nissan Motor Co., Ltd", "박지은", ["WR"],
                    avg_weight_ton=250, std_weight_ton=80,
                    monthly_orders_min=12, monthly_orders_max=15, monthly_base_kt=10.0),
    CustomerProfile("포스코인터내셔널", "박지은", ["WR"], avg_weight_ton=550, std_weight_ton=200,
                    monthly_orders_min=10, monthly_orders_max=12, monthly_base_kt=30.0),
]

# 박현웅 (후판 5 고객사, 포스코인터 공유)
HYUNUNG: list[CustomerProfile] = [
    CustomerProfile("현대중공업", "박현웅", ["HE", "PJ"], avg_weight_ton=1800, std_weight_ton=700,
                    monthly_orders_min=8, monthly_orders_max=10, monthly_base_kt=20.0),
    CustomerProfile("삼성중공업", "박현웅", ["HE", "PJ"], avg_weight_ton=1500, std_weight_ton=600,
                    monthly_orders_min=6, monthly_orders_max=8, monthly_base_kt=30.0),
    CustomerProfile("한화오션", "박현웅", ["HE", "PJ"], avg_weight_ton=1200, std_weight_ton=500,
                    monthly_orders_min=8, monthly_orders_max=10, monthly_base_kt=30.0),
    CustomerProfile("포스코건설", "박현웅", ["HE", "PJ"], avg_weight_ton=900, std_weight_ton=350,
                    monthly_orders_min=5, monthly_orders_max=7, monthly_base_kt=20.0),
    CustomerProfile("포스코인터내셔널", "박현웅", ["HE", "PJ"], avg_weight_ton=700, std_weight_ton=250,
                    monthly_orders_min=10, monthly_orders_max=12, monthly_base_kt=25.0),
]


# ───────────────── 방법론 ⑥ Achievement Rate Scenario (Korn Ferry) ─────────────────

# 각 (salesperson, year_month) → 목표 달성률 배수
# 2025-06 ~ 2026-05 (12개월). 5월은 시연 기준일(2026-05-15) 까지의 부분 진행률.
ACHIEVEMENT_SCENARIO: dict[tuple[str, int, int], float] = {
    # 박지은 (선재)
    ("박지은", 2025, 6): 0.88,
    ("박지은", 2025, 7): 0.75,
    ("박지은", 2025, 8): 0.80,
    ("박지은", 2025, 9): 1.05,
    ("박지은", 2025, 10): 0.98,
    ("박지은", 2025, 11): 0.85,
    ("박지은", 2025, 12): 1.10,
    ("박지은", 2026, 1): 0.78,
    ("박지은", 2026, 2): 0.82,
    ("박지은", 2026, 3): 0.95,
    ("박지은", 2026, 4): 0.92,
    ("박지은", 2026, 5): 0.61,  # 시연 5/15 시점 (5/31 기준 평소 0.95 추세)
    # 박현웅 (후판)
    ("박현웅", 2025, 6): 0.92,
    ("박현웅", 2025, 7): 0.80,
    ("박현웅", 2025, 8): 0.78,
    ("박현웅", 2025, 9): 1.12,
    ("박현웅", 2025, 10): 1.02,
    ("박현웅", 2025, 11): 0.88,
    ("박현웅", 2025, 12): 1.15,
    ("박현웅", 2026, 1): 0.72,
    ("박현웅", 2026, 2): 0.85,
    ("박현웅", 2026, 3): 1.08,
    ("박현웅", 2026, 4): 0.95,
    ("박현웅", 2026, 5): 0.71,  # 시연 5/15 시점 (5/31 기준 평소 1.05 추세)
}


# ───────────────── Utility ─────────────────


def business_days_in(year: int, month: int) -> list[DateT]:
    _, ndays = calendar.monthrange(year, month)
    return [DateT(year, month, d) for d in range(1, ndays + 1) if DateT(year, month, d).weekday() < 5]


def quarter_end_weight(d: DateT, total_bdays: int, idx_in_month: int) -> float:
    """방법론 ③ — 마지막 5영업일 가중 + 분기말 추가 가중."""
    last5_start = total_bdays - 5
    end_boost = 1.0
    if idx_in_month >= last5_start:
        end_boost = 1.8
    if d.month in {3, 6, 9, 12} and idx_in_month >= total_bdays - 3:
        end_boost = 2.5
    return end_boost


def sample_shipment_weight_kg(profile: CustomerProfile) -> int:
    """방법론 ② Pareto/Power Law — 정규분포 + 5% heavy-tail (×2~3 spike)."""
    base = max(50.0, random.gauss(profile.avg_weight_ton, profile.std_weight_ton))
    if random.random() < 0.05:  # 5% 확률 heavy tail
        base *= random.uniform(2.0, 3.0)
    return int(round(base * 1000))  # 톤 → kg


def gen_order_number(year: int, month: int, seq: int) -> str:
    """01S0000001010 형식 — 시연 데이터 일관성."""
    yy = year % 100
    return f"{yy:02d}S{month:02d}{seq:05d}010"


# ───────────────── 본 생성 로직 ─────────────────


def _month_iter(start: DateT, end: DateT):
    y, m = start.year, start.month
    while (y, m) <= (end.year, end.month):
        yield y, m
        m += 1
        if m == 13:
            y += 1
            m = 1


def generate(profiles: list[CustomerProfile]) -> tuple[list[dict], list[dict]]:
    """모든 (salesperson, customer, month) 조합으로 orders + shipments 생성."""
    orders: list[dict] = []
    shipments: list[dict] = []
    global_seq = 1

    for y, m in _month_iter(GEN_START, GEN_END):
        season = SEASONAL_INDEX[m]
        bdays = business_days_in(y, m)
        if y == GEN_END.year and m == GEN_END.month:
            bdays = [d for d in bdays if d <= GEN_END]
        if not bdays:
            continue

        for prof in profiles:
            key = (prof.salesperson, y, m)
            ach = ACHIEVEMENT_SCENARIO.get(key, 1.0)
            target_kt = prof.monthly_base_kt * season * ach
            target_kg = target_kt * 1_000_000

            # 출하 건수 (Holt-Winters trend 반영)
            n_orders = max(1, round(
                random.randint(prof.monthly_orders_min, prof.monthly_orders_max) * season * ach
            ))

            # 일자 분포 (영업일 × weekday × quarter-end 가중치)
            day_weights = []
            for idx, d in enumerate(bdays):
                w = WEEKDAY_WEIGHT[d.weekday()] * quarter_end_weight(d, len(bdays), idx)
                day_weights.append(w)
            chosen_days = random.choices(bdays, weights=day_weights, k=n_orders)

            # 각 출하 weight — 합이 target_kg 근사하도록 scaling
            raw_weights = [sample_shipment_weight_kg(prof) for _ in range(n_orders)]
            if sum(raw_weights) > 0:
                scale = target_kg / sum(raw_weights)
                weights_kg = [max(1000, int(round(w * scale))) for w in raw_weights]
            else:
                weights_kg = raw_weights

            # 동일 (order_line_no, shipped_at) unique 보장
            for i, (d, kg) in enumerate(zip(sorted(chosen_days), weights_kg, strict=False)):
                variant = random.choice(prof.variant_codes)
                order_no = gen_order_number(y, m, global_seq)
                global_seq += 1
                orders.append({
                    "order_line_no": order_no,
                    "customer_name": prof.name,
                    "variant_code": variant,
                    "salesperson": prof.salesperson,
                })
                shipments.append({
                    "shipped_at": d,
                    "customer_name": prof.name,
                    "weight_kg": float(kg),
                    "weight_unit": "kg",
                    "order_line_no": order_no,
                    "variant_code": variant,
                })

    return orders, shipments


# ───────────────── DB 적재 ─────────────────


CHUNK = 1000


async def _truncate_and_insert(orders: list[dict], shipments: list[dict]) -> None:
    async with SessionLocal() as s:
        # shipments 먼저 (order_lines FK 의 참조 무결성), 단 FK 없음 — 안전상 순서.
        await s.execute(delete(Shipment))
        await s.execute(delete(OrderLine))
        await s.commit()

        # bulk insert
        for i in range(0, len(orders), CHUNK):
            await s.execute(insert(OrderLine).values(orders[i:i + CHUNK]))
        for i in range(0, len(shipments), CHUNK):
            await s.execute(insert(Shipment).values(shipments[i:i + CHUNK]))
        await s.commit()


# ───────────────── main ─────────────────


async def main(dry_run: bool = False) -> None:
    profiles = JIEUN + HYUNUNG
    orders, shipments = generate(profiles)

    # 요약 출력
    print(f"generated orders={len(orders)} shipments={len(shipments)}")
    by_sp: dict[str, int] = {}
    by_sp_kt: dict[str, float] = {}
    for o, sh in zip(orders, shipments, strict=True):
        by_sp[o["salesperson"]] = by_sp.get(o["salesperson"], 0) + 1
        by_sp_kt[o["salesperson"]] = by_sp_kt.get(o["salesperson"], 0) + sh["weight_kg"] / 1_000_000
    for sp, n in by_sp.items():
        print(f"  {sp}: {n}건  합 {by_sp_kt[sp]:,.1f} 천톤")

    if dry_run:
        print("[dry-run] DB 적재 생략")
        return

    await _truncate_and_insert(orders, shipments)
    print("DB 적재 완료 (shipments + order_lines 전체 교체)")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true", help="DB 적재 없이 통계만 출력")
    args = ap.parse_args()
    asyncio.run(main(dry_run=args.dry_run))
