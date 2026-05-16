"""PRD 0514 기반 CUSTOMER_PROFILE / PRODUCT_CONFIG seed.

데이터 출처: 노션 [새버전 0514] 문서 (메인 대시보드 + 추천 질문 Agent PRD).
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

CUSTOMER_PROFILE: dict[str, dict] = {
    "고려제강": {
        "industry": "건설/인프라용 선재",
        "product_group": ["선재"],
        "market_region": "국내/글로벌",
        "sensitive_topics": ["건설 경기", "철스크랩 가격", "수입재 가격 경쟁", "국내 재고"],
        "risk_factors": ["국내 건설 수주 감소", "중국산 저가재 점유율 확대"],
    },
    "Borcelik Celik Sanayii VE Ticaret AS": {
        "industry": "자동차/가전 외판재",
        "product_group": ["HR(고로밀)"],
        "market_region": "유럽/터키",
        "sensitive_topics": ["글로벌 열연 가격", "에너지 비용", "유럽 제조업 경기", "환율"],
        "risk_factors": ["CBAM 규제", "터키 내수 경기 변동성"],
    },
    "Nissan Motor Co., Ltd": {
        "industry": "완성차",
        "product_group": ["선재"],
        "market_region": "일본/글로벌",
        "sensitive_topics": ["자동차 생산", "부품 재고", "EV 전환", "공급망 안정성"],
        "risk_factors": ["공급망 중단", "신규 모델 출시 지연"],
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
    "New Best Wire Industrial Co., Ltd": {
        "industry": "글로벌 부품 제조",
        "product_group": ["선재"],
        "market_region": "글로벌",
        "sensitive_topics": ["중국산 오퍼 가격", "글로벌 제조업 경기", "해상 물류비", "가격 경쟁"],
        "risk_factors": ["글로벌 수요 둔화", "재고 과잉"],
    },
    "JFE Techno Wire Corporation": {
        "industry": "고기능성 특수 선재",
        "product_group": ["선재"],
        "market_region": "일본",
        "sensitive_topics": ["기술 스펙", "동아시아 철스크랩 가격", "일본 제조업 경기", "원재료 수급"],
        "risk_factors": ["일본 내수 시황 위축", "원재료 수급 불안"],
    },
    "동일제강": {
        "industry": "건설/산업용 선재 가공",
        "product_group": ["선재"],
        "market_region": "국내",
        "sensitive_topics": ["건설 경기", "철스크랩 가격", "유통 재고", "수입재 가격"],
        "risk_factors": ["국내 건설 경기 하락", "저가 수입재 유입"],
    },
    "세아씨엠": {
        "industry": "컬러강판/가전/건재",
        "product_group": ["HR(고로밀)"],
        "market_region": "국내",
        "sensitive_topics": ["열연 소재 가격", "컬러강판 수요", "가전 경기", "건설 경기"],
        "risk_factors": ["가전 및 건설 경기 부진", "중국산 열연 가격 압박"],
    },
    "Ningbo Dafeng Machinery Co., Ltd": {
        "industry": "산업기계 부품",
        "product_group": ["선재"],
        "market_region": "중국",
        "sensitive_topics": ["중국 제조업 경기", "중국 내수 가격", "가동률", "공급 과잉"],
        "risk_factors": ["중국 경기 부양 효과 약화", "현지 공급 과잉"],
    },
}


PRODUCT_CONFIG: dict[str, dict] = {
    "HR(고로밀)": {
        "key_features": [
            "열연(HR) Coil 선물가 (상하이 선물거래소 1차)",
            "중국 철광석 수입가 - 호주산 62% 분광",
            "중국 열연(HR) Sheet/Coil Mill 재고",
            "중국 수출 구매자 관리자 지수(PMI)",
            "중국 철강제품 수출량",
        ],
        "key_feature_importance": [0.35, 0.25, 0.15, 0.15, 0.10],
        "axis": {
            "원료 역동성": {
                "indicators": ["중국 철광석 수입가 - 호주산 62% 분광", "글로벌 강점탄 수출가"],
                "weights": [0.7, 0.3],
            },
            "시장가격": {
                "indicators": [
                    "열연(HR) Coil 선물가 (상하이 선물거래소 1차)",
                    "중국 열연(HR) 3.0mm 유통가",
                ],
                "weights": [0.8, 0.2],
            },
            "수급현황": {
                "indicators": [
                    "중국 열연(HR) Sheet/Coil Mill 재고",
                    "중국 철강제품 수출량",
                    "중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)",
                ],
                "weights": [0.4, 0.3, 0.3],
            },
            "거시경제": {
                "indicators": ["중국 수출 구매자 관리자 지수(PMI)", "중국 소비자 물가지수 연간 변동률"],
                "weights": [0.6, 0.4],
            },
            "전방산업": {
                "indicators": ["중국 부동산 개발 투자율 YoY", "미국 자동차 판매대수SAAR"],
                "weights": [0.5, 0.5],
            },
        },
    },
    "후판": {
        "key_features": [
            "중국 중후판(Plate) 20mm 유통가",
            "중국 철광석 수입가 - 호주산 62% 분광",
            "중국 후판(Plate) Mill 생산량",
            "중국 후판(Plate) Mill 재고",
            "중국 수출 구매자 관리자 지수(PMI)",
        ],
        "key_feature_importance": [0.30, 0.25, 0.20, 0.15, 0.10],
        "axis": {
            "원료 역동성": {
                "indicators": ["중국 철광석 수입가 - 호주산 62% 분광", "동아시아 철스크랩 수입가"],
                "weights": [0.8, 0.2],
            },
            "시장가격": {
                "indicators": ["중국 중후판(Plate) 20mm 유통가", "중국 후판(Plate) 현물가-FOB(상하이시)"],
                "weights": [0.7, 0.3],
            },
            "수급현황": {
                "indicators": ["중국 후판(Plate) Mill 재고", "중국 후판(Plate) Mill 운영률(Operating Rate)"],
                "weights": [0.6, 0.4],
            },
            "거시경제": {
                "indicators": ["중국 수출 구매자 관리자 지수(PMI)", "미국 10년 만기 국채 수익률"],
                "weights": [0.6, 0.4],
            },
            "전방산업": {
                "indicators": ["한국 건설 기성액(총기성액)(경상지수)", "일본 조강생산량"],
                "weights": [0.7, 0.3],
            },
        },
    },
    "냉연(CR)": {
        "key_features": [
            "일본 냉연 Coil 현물가 -FOB",
            "열연(HR) Coil 선물가 (상하이 선물거래소 1차)",
            "베트남 냉연(CR) Coil SPCC 1.0mm 가격",
            "일본 자동차 생산량 YoY(월)",
            "미국 제조업 신뢰지수 SA",
        ],
        "key_feature_importance": [0.30, 0.25, 0.20, 0.15, 0.10],
        "axis": {
            "원료 역동성": {
                "indicators": [
                    "열연(HR) Coil 선물가 (상하이 선물거래소 1차)",
                    "중국 열연(HR) 3.0mm 유통가",
                ],
                "weights": [0.7, 0.3],
            },
            "시장가격": {
                "indicators": ["일본 냉연 Coil 현물가 -FOB", "베트남 냉연(CR) Coil SPCC 1.0mm 가격"],
                "weights": [0.6, 0.4],
            },
            "수급현황": {
                "indicators": ["일본 철강제품 수출량", "미국 1차 금속 제조업체 재고율(SA)"],
                "weights": [0.5, 0.5],
            },
            "거시경제": {
                "indicators": ["미국 제조업 신뢰지수 SA", "한국은행 기준금리"],
                "weights": [0.5, 0.5],
            },
            "전방산업": {
                "indicators": ["일본 자동차 생산량 YoY(월)", "미국 가전제품 신규 주문액 NSA"],
                "weights": [0.7, 0.3],
            },
        },
    },
    "STS 304": {
        "key_features": [
            "LME 니켈 3개월 선물",
            "중국 스테인리스(STS) 304 현물가",
            "글로벌 스테인리스강(STS) 가격 지수(CRU)",
            "중국 수출 구매자 관리자 지수(PMI)",
            "중국 철강제품 수출량",
        ],
        "key_feature_importance": [0.45, 0.25, 0.10, 0.10, 0.10],
        "axis": {
            "원료 역동성": {
                "indicators": ["LME 니켈 3개월 선물", "중국 페로크롬(FeCr) 58~60% 현물가"],
                "weights": [0.8, 0.2],
            },
            "시장가격": {
                "indicators": [
                    "중국 스테인리스(STS) 304 현물가",
                    "글로벌 스테인리스강(STS) 가격 지수(CRU)",
                ],
                "weights": [0.7, 0.3],
            },
            "수급현황": {
                "indicators": ["중국 10일 주기 주요 제철소 철강 재고(CISA)", "중국 철강제품 수출량"],
                "weights": [0.5, 0.5],
            },
            "거시경제": {
                "indicators": ["중국 수출 구매자 관리자 지수(PMI)", "미국 10년 만기 국채 수익률"],
                "weights": [0.5, 0.5],
            },
            "전방산업": {
                "indicators": ["일본 전기제품 출하액", "인도 전자제품 수출액"],
                "weights": [0.6, 0.4],
            },
        },
    },
    "부산물(철스크랩)": {
        "key_features": [
            "한국 철스크랩 생철 A (Busheling A) 가격 - 평균",
            "동아시아 철스크랩 수입가",
            "미국 철스크랩 컴포짓가",
            "일본 조강생산량",
            "중국 247개 철강사 고로 운영률(Operating Rate)",
        ],
        "key_feature_importance": [0.40, 0.20, 0.15, 0.15, 0.10],
        "axis": {
            "원료 역동성": {
                "indicators": [
                    "한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)",
                    "중국 철광석 수입가 - 호주산 62% 분광",
                ],
                "weights": [0.7, 0.3],
            },
            "시장가격": {
                "indicators": [
                    "한국 철스크랩 생철 A (Busheling A) 가격 - 평균",
                    "미국 철스크랩 컴포짓가",
                ],
                "weights": [0.7, 0.3],
            },
            "수급현황": {
                "indicators": ["중국 247개 철강사 고로 운영률(Operating Rate)", "일본 조강생산량"],
                "weights": [0.5, 0.5],
            },
            "거시경제": {
                "indicators": ["미국 제조업 신뢰지수 SA", "한국은행 기준금리"],
                "weights": [0.5, 0.5],
            },
            "전방산업": {
                "indicators": ["주택건설실적(착공)소계", "일본 자동차 생산량 YoY(월)"],
                "weights": [0.6, 0.4],
            },
        },
    },
}


USER_SEED: list[dict] = [
    {"user_id": "emp_2026001", "name": "이윤진", "role": UserRole.SALES},
    {"user_id": "emp_2026002", "name": "김매니저", "role": UserRole.MANAGER},
    {"user_id": "emp_2026099", "name": "관리자", "role": UserRole.ADMIN},
]


def _customer_rows() -> list[dict]:
    return [{"customer_id": cid, **fields} for cid, fields in CUSTOMER_PROFILE.items()]


def _product_rows() -> list[dict]:
    return [{"code": code, **config} for code, config in PRODUCT_CONFIG.items()]


def _assignment_rows() -> list[dict]:
    # 잔여 태스크 #10 (BACKLOG): 영업담당자별 분할 매핑 추후 도입.
    # MVP: 모든 거래처를 emp_2026001 에게 primary 로 배정.
    today_iso = date.today().isoformat()
    return [
        {
            "user_id": "emp_2026001",
            "customer_id": cid,
            "role": AssignmentRole.PRIMARY,
            "assigned_at": today_iso,
        }
        for cid in CUSTOMER_PROFILE
    ]


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
    print(
        f"seeded customers={len(CUSTOMER_PROFILE)} products={len(PRODUCT_CONFIG)} "
        f"users={len(USER_SEED)} assignments={len(_assignment_rows())}"
    )


if __name__ == "__main__":
    asyncio.run(seed())
