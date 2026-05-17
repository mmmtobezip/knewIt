"""PRD 0516 — CUSTOMER_PROFILE / PRODUCT_CONFIG / USER seed.

해커톤 시연 시나리오:
- 박지은 (emp_2026003): primary_product_code="선재", 선재 거래처 5개
- 박현웅 (emp_2026004): primary_product_code="후판", 후판 거래처 5개
- 이윤진 (emp_2026001): 기존 거래처 (HR/후판/부산물 다양) 유지
- 포스코인터내셔널: product_group=["선재","후판"] 단일 행 → 박지은과 박현웅 둘 다 매핑

PRODUCT_CONFIG 정정 사항:
- "중국 수출 구매자 관리자 지수(PMI" → "(PMI)" 닫는 괄호 보강
- "미국 철스크랩 컴포짓가 " 끝 공백 trim
"""
from __future__ import annotations

import asyncio
from datetime import date

from sqlalchemy.dialects.postgresql import insert

from app.db import SessionLocal
from app.models import (
    AssignedCustomer,
    AssignmentRole,
    CustomerProfile,
    Product,
    User,
    UserRole,
)

# ── PRODUCT_CONFIG (6종, 각 10 features) ───────────────────────────
PRODUCT_CONFIG: dict[str, dict] = {
    "선재": {
        "key_features": [
            "중국 철근(Rebar) 선물가",
            "중국 철광석 수입가 - 호주산 62% 분광",
            "열연(HR) Coil 선물가 (상하이 선물거래소 1차)",
            "동아시아 철스크랩 수입가",
            "중국 10일 주기 주요 제철소 철강 재고(CISA)",
            "한국 철스크랩 생철 A (Busheling A) 가격 - 평균",
            "한국 건설 기성액(총기성액)(경상지수)",
            "다우존스 산업평균지수",
            "미국 10년 만기 국채 수익률",
            "한국은행 기준금리",
        ],
        "key_feature_cycle": ["D", "D", "D", "W", "W", "W", "M", "D", "D", "M"],
        "key_feature_importance": [0.20, 0.15, 0.15, 0.10, 0.10, 0.05, 0.05, 0.08, 0.06, 0.06],
    },
    "후판": {
        "key_features": [
            "중국 중후판(Plate) 20mm 유통가",
            "중국 철광석 수입가 - 호주산 62% 분광",
            "열연(HR) Coil 선물가 (상하이 선물거래소 1차)",
            "중국 후판(Plate) Mill 재고",
            "중국 후판(Plate) Mill 생산량",
            "중국 후판(Plate) Mill 운영률(Operating Rate)",
            "동아시아 철스크랩 수입가",
            "미국 10년 만기 국채 수익률",
            "다우존스 산업평균지수",
            "한국은행 기준금리",
        ],
        "key_feature_cycle": ["W", "D", "D", "W", "W", "W", "W", "D", "D", "M"],
        "key_feature_importance": [0.20, 0.15, 0.15, 0.10, 0.10, 0.05, 0.05, 0.08, 0.06, 0.06],
    },
    "HR(고로밀)": {
        "key_features": [
            "열연(HR) Coil 선물가 (상하이 선물거래소 1차)",
            "중국 철광석 수입가 - 호주산 62% 분광",
            "중국 열연(HR) 3.0mm 유통가",
            "중국 열연(HR) Sheet/Coil Mill 재고",
            "중국 철강제품 수출량",
            "중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)",
            "중국 열연(HR) Coil SS400 수출가",
            "중국 수출 구매자 관리자 지수(PMI)",  # 정정: 닫는 괄호 보강
            "다우존스 산업평균지수",
            "미국 10년 만기 국채 수익률",
        ],
        "key_feature_cycle": ["D", "D", "W", "W", "M", "W", "W", "M", "D", "D"],
        "key_feature_importance": [0.20, 0.15, 0.15, 0.10, 0.10, 0.05, 0.05, 0.08, 0.06, 0.06],
    },
    "냉연(CR)": {
        "key_features": [
            "일본 냉연 Coil 현물가 -FOB",
            "열연(HR) Coil 선물가 (상하이 선물거래소 1차)",
            "베트남 냉연(CR) Coil SPCC 1.0mm 가격",
            "중국 열연(HR) 3.0mm 유통가",
            "일본 철강제품 수출량",
            "미국 1차 금속 제조업체 재고율(SA)",
            "미국 가전제품 신규 주문액 NSA",
            "다우존스 산업평균지수",
            "미국 10년 만기 국채 수익률",
            "한국은행 기준금리",
        ],
        "key_feature_cycle": ["W", "D", "W", "W", "M", "M", "M", "D", "D", "M"],
        "key_feature_importance": [0.20, 0.15, 0.15, 0.10, 0.10, 0.05, 0.05, 0.08, 0.06, 0.06],
    },
    "STS 304": {
        "key_features": [
            "LME 니켈 3개월 선물",
            "중국 스테인리스(STS) 304 현물가",
            "글로벌 스테인리스강(STS) 가격 지수(CRU)",
            "중국 페로크롬(FeCr) 58~60% 현물가",
            "유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge",
            "중국 10일 주기 주요 제철소 철강 재고(CISA)",
            "중국 철강제품 수출량",
            "다우존스 산업평균지수",
            "미국 10년 만기 국채 수익률",
            "중국 수출 구매자 관리자 지수(PMI)",  # 정정: 닫는 괄호 보강
        ],
        "key_feature_cycle": ["D", "W", "M", "W", "M", "W", "M", "D", "D", "M"],
        "key_feature_importance": [0.25, 0.15, 0.15, 0.10, 0.05, 0.05, 0.05, 0.08, 0.06, 0.06],
    },
    "부산물(철스크랩)": {
        "key_features": [
            "한국 철스크랩 생철 A (Busheling A) 가격 - 평균",
            "동아시아 철스크랩 수입가",
            "미국 철스크랩 컴포짓가",  # 정정: 끝 공백 trim
            "중국 철근(Rebar) 선물가",
            "중국 247개 철강사 고로 운영률(Operating Rate)",
            "일본 조강생산량",
            "한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)",
            "다우존스 산업평균지수",
            "미국 10년 만기 국채 수익률",
            "한국은행 기준금리",
        ],
        "key_feature_cycle": ["W", "W", "W", "D", "W", "M", "W", "D", "D", "M"],
        "key_feature_importance": [0.20, 0.15, 0.15, 0.10, 0.10, 0.05, 0.05, 0.08, 0.06, 0.06],
    },
}


# ── CUSTOMER_PROFILE (15개) ────────────────────────────────────────
# 신규 후판 5 + 신규 선재 4 (포스코인터는 product_group ["선재","후판"] 단일 행) + 기존 6
CUSTOMER_PROFILE: dict[str, dict] = {
    # ── 후판 신규 5 (박현웅 담당) ─────────────────────────
    "현대중공업": {
        "industry": "조선 (상선/해양플랜트)",
        "product_group": ["후판"],
        "market_region": "글로벌",
        "sensitive_topics": ["선가(Newbuilding Price) 추이", "후판가 연동제", "수주 잔량"],
        "risk_factors": ["인건비 및 에너지 비용 상승", "글로벌 물동량 변화", "후판가 인상에 따른 수익성 악화"],
    },
    "삼성중공업": {
        "industry": "조선 (LNG선/FLNG 특화)",
        "product_group": ["후판"],
        "market_region": "글로벌",
        "sensitive_topics": ["고부가가치선 수주 현황", "니켈/원료가 변동", "탄소 중립 선박"],
        "risk_factors": ["환율 변동 리스크", "글로벌 환경 규제 강화", "특수강 소재 수급 불안"],
    },
    "한화오션": {
        "industry": "조선 (특수선/상선)",
        "product_group": ["후판"],
        "market_region": "글로벌",
        "sensitive_topics": ["방산/특수선 비중", "생산 공정 정상화", "중국재 대비 가격 경쟁력"],
        "risk_factors": ["인력 수급 문제", "원가 상승 압박", "생산 스케줄 지연"],
    },
    "포스코건설": {
        "industry": "건설 (플랜트/인프라/건축)",
        "product_group": ["후판"],
        "market_region": "국내/글로벌",
        "sensitive_topics": ["국내 건설 기성액", "사회인프라(SOC) 예산", "강구조 수요"],
        "risk_factors": ["분양 시장 위축", "공사비 증액에 따른 발주 취소", "원자재가 변동"],
    },
    # 포스코인터내셔널: 선재 + 후판 둘 다 다룸 (단일 행, product_group 다중)
    # 박지은(선재) / 박현웅(후판) 각자 다른 시나리오로 진입
    "포스코인터내셔널": {
        "industry": "글로벌 트레이딩/유통/에너지",
        "product_group": ["선재", "후판"],
        "market_region": "글로벌 (동남아/미주/유럽)",
        "sensitive_topics": [
            "중국산 선재 오퍼가 변동",
            "글로벌 물류비 및 용선료 추이",
            "지역별 선재 스폿 가격차(Price Gap)",
            "수출 환율 변동성",
            "글로벌 후판 오퍼 가격",
            "수출 쿼터 및 통상 이슈",
        ],
        "risk_factors": [
            "각국 보호무역 조치(반덤핑 등) 강화",
            "글로벌 금리 인상에 따른 재고 금융 비용 상승",
            "도착지별 재고 과잉 및 수요 둔화",
            "지정학적 리스크에 따른 운송 지연",
            "가격 하락 시 재고 평가 손실",
        ],
    },
    # ── 선재 신규 4 (박지은 담당) — 포스코인터내셔널 위에 정의됨 ──
    "고려제강": {
        "industry": "건설/인프라용 선재",
        "product_group": ["선재"],
        "market_region": "국내/글로벌",
        "sensitive_topics": ["건설 경기", "철스크랩 가격", "수입재 가격 경쟁", "국내 재고"],
        "risk_factors": ["국내 건설 수주 감소", "중국산 저가재 점유율 확대"],
    },
    "Nissan Motor Co., Ltd": {
        "industry": "완성차",
        "product_group": ["선재"],
        "market_region": "일본/글로벌",
        "sensitive_topics": ["자동차 생산", "부품 재고", "EV 전환", "공급망 안정성"],
        "risk_factors": ["공급망 중단", "신규 모델 출시 지연"],
    },
    "New Best Wire Industrial Co., Ltd": {
        "industry": "글로벌 부품 제조",
        "product_group": ["선재"],
        "market_region": "글로벌",
        "sensitive_topics": ["중국산 오퍼 가격", "글로벌 제조업 경기", "해상 물류비", "가격 경쟁"],
        "risk_factors": ["글로벌 수요 둔화", "재고 과잉"],
    },
    "동일제강": {
        "industry": "건설/산업용 선재 가공",
        "product_group": ["선재"],
        "market_region": "국내",
        "sensitive_topics": ["건설 경기", "철스크랩 가격", "유통 재고", "수입재 가격"],
        "risk_factors": ["국내 건설 경기 하락", "저가 수입재 유입"],
    },
    # ── 기존 6 (이윤진 담당 유지) ─────────────────────────
    "Borcelik Celik Sanayii VE Ticaret AS": {
        "industry": "자동차/가전 외판재",
        "product_group": ["HR(고로밀)"],
        "market_region": "유럽/터키",
        "sensitive_topics": ["글로벌 열연 가격", "에너지 비용", "유럽 제조업 경기", "환율"],
        "risk_factors": ["CBAM 규제", "터키 내수 경기 변동성"],
    },
    "Berg Steel Pipe Corp": {
        "industry": "에너지 강관(Oil & Gas)",
        "product_group": ["후판"],
        "market_region": "북미",
        "sensitive_topics": ["에너지 프로젝트", "후판 납기", "수입 규제", "원자재 가격"],
        "risk_factors": ["북미 에너지 정책 변화", "프로젝트 지연"],
    },
    "썬시멘트주식회사": {
        "industry": "시멘트/건설소재",
        "product_group": ["부산물(철스크랩)"],
        "market_region": "국내",
        "sensitive_topics": ["건설 경기", "원가 절감", "에너지 비용", "환경 규제"],
        "risk_factors": ["건설 착공 감소", "환경 규제 강화"],
    },
    "세아씨엠": {
        "industry": "컬러강판/가전/건재",
        "product_group": ["HR(고로밀)"],
        "market_region": "국내",
        "sensitive_topics": ["열연 소재 가격", "컬러강판 수요", "가전 경기", "건설 경기"],
        "risk_factors": ["가전 및 건설 경기 부진", "중국산 열연 가격 압박"],
    },
    "JFE Techno Wire Corporation": {
        "industry": "고기능성 특수 선재",
        "product_group": ["선재"],
        "market_region": "일본",
        "sensitive_topics": ["기술 스펙", "동아시아 철스크랩 가격", "일본 제조업 경기", "원재료 수급"],
        "risk_factors": ["일본 내수 시황 위축", "원재료 수급 불안"],
    },
    "Ningbo Dafeng Machinery Co., Ltd": {
        "industry": "산업기계 부품",
        "product_group": ["선재"],
        "market_region": "중국",
        "sensitive_topics": ["중국 제조업 경기", "중국 내수 가격", "가동률", "공급 과잉"],
        "risk_factors": ["중국 경기 부양 효과 약화", "현지 공급 과잉"],
    },
}


# ── USER_SEED ──────────────────────────────────────────────────────
USER_SEED: list[dict] = [
    # 박지은: 선재 1:1 (해커톤 시연 메인 사원 A)
    {
        "user_id": "emp_2026003",
        "name": "박지은",
        "role": UserRole.SALES,
        "primary_product_code": "선재",
    },
    # 박현웅: 후판 1:1 (해커톤 시연 메인 사원 B)
    {
        "user_id": "emp_2026004",
        "name": "박현웅",
        "role": UserRole.SALES,
        "primary_product_code": "후판",
    },
    # 이윤진: 기존 다중 제품 담당 (HR/후판/부산물 등)
    {
        "user_id": "emp_2026001",
        "name": "이윤진",
        "role": UserRole.SALES,
        "primary_product_code": None,
    },
    {
        "user_id": "emp_2026002",
        "name": "김매니저",
        "role": UserRole.MANAGER,
        "primary_product_code": None,
    },
    {
        "user_id": "emp_2026099",
        "name": "관리자",
        "role": UserRole.ADMIN,
        "primary_product_code": None,
    },
]


# ── 담당자별 매핑 ─────────────────────────────────────────────────
# user_id → 담당 customer_id 목록
ASSIGNMENTS: dict[str, list[str]] = {
    "emp_2026003": [  # 박지은 (선재 5개)
        "포스코인터내셔널",
        "고려제강",
        "Nissan Motor Co., Ltd",
        "New Best Wire Industrial Co., Ltd",
        "동일제강",
    ],
    "emp_2026004": [  # 박현웅 (후판 5개)
        "현대중공업",
        "삼성중공업",
        "한화오션",
        "포스코건설",
        "포스코인터내셔널",  # 박지은과 공유 (다른 제품)
    ],
    "emp_2026001": [  # 이윤진 (기존 6개)
        "Borcelik Celik Sanayii VE Ticaret AS",
        "Berg Steel Pipe Corp",
        "썬시멘트주식회사",
        "세아씨엠",
        "JFE Techno Wire Corporation",
        "Ningbo Dafeng Machinery Co., Ltd",
    ],
}


def _customer_rows() -> list[dict]:
    return [{"customer_id": cid, **fields} for cid, fields in CUSTOMER_PROFILE.items()]


def _product_rows() -> list[dict]:
    return [{"code": code, **config} for code, config in PRODUCT_CONFIG.items()]


def _assignment_rows() -> list[dict]:
    today_iso = date.today().isoformat()
    rows: list[dict] = []
    for user_id, customer_ids in ASSIGNMENTS.items():
        for cid in customer_ids:
            rows.append(
                {
                    "user_id": user_id,
                    "customer_id": cid,
                    "role": AssignmentRole.PRIMARY,
                    "assigned_at": today_iso,
                }
            )
    return rows


async def seed() -> None:
    async with SessionLocal() as s:
        await s.execute(
            insert(CustomerProfile)
            .values(_customer_rows())
            .on_conflict_do_nothing(index_elements=["customer_id"])
        )
        await s.execute(
            insert(Product)
            .values(_product_rows())
            .on_conflict_do_nothing(index_elements=["code"])
        )
        await s.execute(
            insert(User).values(USER_SEED).on_conflict_do_nothing(index_elements=["user_id"])
        )
        await s.execute(
            insert(AssignedCustomer)
            .values(_assignment_rows())
            .on_conflict_do_nothing(index_elements=["user_id", "customer_id"])
        )
        await s.commit()

    assignment_rows = _assignment_rows()
    print(
        f"seeded customers={len(CUSTOMER_PROFILE)} "
        f"products={len(PRODUCT_CONFIG)} "
        f"users={len(USER_SEED)} "
        f"assignments={len(assignment_rows)}"
    )


if __name__ == "__main__":
    asyncio.run(seed())
