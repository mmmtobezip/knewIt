/**
 * 메시지 사전 (i18n 키-텍스트 매핑)
 *
 * 참조: main-ipo.md § 3-5 사용자 알림 / 메시지 표준
 *
 * Q11: MVP는 한국어만 / Phase 2 다국어 확장 시 키 그대로 사용
 */

import type { MessageId } from './ui';

// ─────────────────────────────────────────────────────────
// 한국어 메시지 (MVP)
// ─────────────────────────────────────────────────────────

export const MESSAGES_KO: Record<MessageId, string> = {
  // 성공 토스트 (§ 3-5-2 성공 토스트)
  'MSG-TST-01': '데이터가 갱신되었습니다 ({time} 기준)',

  // 에러 토스트 (§ 3-5-2 에러 토스트)
  'MSG-ERR-01': '요청 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
  'MSG-ERR-02': '이미 갱신 중입니다. 잠시 후 다시 시도해주세요.',
  'MSG-ERR-03': '분석 데이터를 불러오지 못했습니다.',
  'MSG-ERR-04': '응답 시간이 초과되었습니다. 다시 시도해주세요.',
  'MSG-ERR-05': '해당 고객사를 조회할 권한이 없습니다.',
  'MSG-ERR-06': '네트워크 연결을 확인해주세요.',
  'MSG-ERR-07': '세션이 만료되었습니다. 다시 로그인해주세요.',

  // 정보 안내 (§ 3-5-2 정보 안내)
  'MSG-INF-01': '오늘은 주요 변동이 없습니다.',
  'MSG-INF-02': '최신 분석 갱신 중입니다. 직전 데이터를 표시합니다.',
  'MSG-INF-03': '출처 데이터 일시 미수집',
  'MSG-INF-04': '담당 고객사가 배정되지 않았습니다.',

  // 입력 인라인 에러 (§ 3-5-2 입력 인라인 에러)
  'MSG-INL-01': '최대 500자까지 입력 가능합니다.',
  'MSG-INL-02': '메시지를 입력해주세요.',
};

// ─────────────────────────────────────────────────────────
// 메시지 노출 시간 (ms)
// ─────────────────────────────────────────────────────────

export const MESSAGE_DURATION: Partial<Record<MessageId, number>> = {
  'MSG-TST-01': 2_200,
  'MSG-ERR-01': 3_000,
  'MSG-ERR-02': 2_000,
  'MSG-ERR-03': 3_000,
  'MSG-ERR-04': 3_000,
  'MSG-ERR-05': 3_000,
  'MSG-ERR-06': 3_000,
  'MSG-ERR-07': 3_000,
};

// ─────────────────────────────────────────────────────────
// 헬퍼: 메시지 텍스트 가져오기 (변수 치환)
// ─────────────────────────────────────────────────────────

/**
 * 메시지 ID에 대한 텍스트 반환 (변수 치환 지원)
 *
 * @example
 *   getMessage('MSG-TST-01', { time: '14:30' })
 *   // → "데이터가 갱신되었습니다 (14:30 기준)"
 */
export function getMessage(
  id: MessageId,
  vars?: Record<string, string | number>,
): string {
  let text = MESSAGES_KO[id];
  if (!vars) return text;
  for (const [key, value] of Object.entries(vars)) {
    text = text.replace(new RegExp(`\\{${key}\\}`, 'g'), String(value));
  }
  return text;
}

// ─────────────────────────────────────────────────────────
// 에러 코드 → 메시지 ID 매핑 (§ 3-7-2)
// ─────────────────────────────────────────────────────────

import type { ErrorCode } from './api';

export const ERROR_CODE_TO_MESSAGE: Record<ErrorCode, MessageId> = {
  'E_AUTH_001': 'MSG-ERR-07',
  'E_AUTH_002': 'MSG-ERR-07',
  'E_PERM_001': 'MSG-ERR-05',
  'E_VALD_001': 'MSG-INL-02',
  'E_VALD_002': 'MSG-INL-01',
  'E_DATA_001': 'MSG-ERR-01',
  'E_DATA_002': 'MSG-INF-01',
  'E_LLM_001':  'MSG-ERR-03',
  'E_LLM_002':  'MSG-ERR-04',
  'E_LLM_003':  'MSG-ERR-01',
  'E_NEWS_001': 'MSG-INF-03',
  'E_CACH_001': 'MSG-ERR-02',
  'E_SYS_001':  'MSG-ERR-01',
  'E_SYS_002':  'MSG-ERR-01',
};
