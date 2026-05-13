/**
 * 인증 / 권한 / 사용자 관련 타입 정의
 *
 * 참조: main-ipo.md
 * - § 1-2 (Session / Context Input)
 * - § 1-3-9 (assigned_customers)
 * - Q15 권한 체계 (모든 role 동일 화면, 매니저는 팀원 고객사 조회 가능)
 * - Q16 동시성 (한 고객사 N담당자 가능, 한 사람 N탭 가능)
 */

import type { DateString } from './domain';

// ─────────────────────────────────────────────────────────
// 사용자 권한 (Role)
// ─────────────────────────────────────────────────────────

/**
 * 사용자 권한
 * - sales: 영업 담당자 (본인 매핑 고객사만)
 * - manager: 매니저 (본인 + 직속 팀원 매핑 합산)
 * - admin: 관리자 (전체 고객사)
 *
 * ※ 모든 role이 동일한 화면을 사용 (Q15)
 */
export type UserRole = 'sales' | 'manager' | 'admin';

// ─────────────────────────────────────────────────────────
// 사용자 (Session)
// ─────────────────────────────────────────────────────────

/**
 * 로그인 사용자 세션
 *
 * § 1-2 시스템 입력
 */
export interface SessionUser {
  /** JWT/SSO 추출 사용자 ID */
  user_id: string;
  /** 권한 */
  user_role: UserRole;
  /** 표시명 (헤더 프로필 호버 시 툴팁용) */
  name?: string;
}

// ─────────────────────────────────────────────────────────
// 사용자-고객사 매핑
// ─────────────────────────────────────────────────────────

/**
 * 매핑 역할
 * - primary: 메인 담당자
 * - support: 보조 담당자
 *
 * ※ 한 고객사를 여러 담당자가 동시 담당 가능 (Q16)
 */
export type AssignmentRole = 'primary' | 'support';

/**
 * 사용자-고객사 매핑
 *
 * § 1-3-9
 */
export interface AssignedCustomer {
  user_id: string;
  customer_id: string;
  role: AssignmentRole;
  /** 배정일 */
  assigned_at: DateString;
}
