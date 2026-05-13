# 명세 문서 인덱스

이 폴더는 POS-Pricing Navigator 프로젝트의 **결정된 계약 문서**만 보관합니다.
브레인스토밍/회의록 등 흐름성 문서는 포함하지 않습니다.

---

## 📚 문서 목록

| 문서 | 내용 | 우선순위 |
|------|------|---------|
| [main-ipo.md](./main-ipo.md) | Input/Process/Output 통합 명세 + Q1~Q18 결정 사항 + API 명세 + 에러 코드 체계 | 🔴 필독 |
| [tech-stack.md](./tech-stack.md) | 권장 기술 스택 (Frontend 중심) | 🟡 권장 |
| [flow-chart.md](./flow-chart.md) | 사용자 흐름 / Process / 상태 / 에러 처리 흐름도 (Mermaid) | 🟡 권장 |
| [mockup/index.html](./mockup/index.html) | 메인 대시보드 원본 UI 목업 | 🟢 시각 참조 |

---

## 🔑 핵심: `main-ipo.md` 한 줄 요약

> POSCO 영업담당자가 담당 고객사의 시장 변동 트리거(|change_rate| ≥ 3%)를 감지하면,
> LLM 이 원인 분석 + 영향 + 전략을 생성하고, SSE 스트리밍 채팅으로 협상 가이드를 제공한다.

`main-ipo.md` 한 문서만 정독해도 다음이 파악됩니다:
- 입력 (User Input / Session / Data Source)
- 처리 (P-01 ~ P-09 프로세스)
- 출력 (UI 영역 매핑 / API 응답 / 메시지 / 에러)
- 저장소·캐시·권한·동시성 정책

---

## 🔄 변경 이력

문서가 변경되면 각 문서의 "변경 이력" 섹션에 버전과 변경 내용을 기록합니다.
