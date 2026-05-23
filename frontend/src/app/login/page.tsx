'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { motion } from 'framer-motion';
import { LogIn } from 'lucide-react';
import { useQueryClient } from '@tanstack/react-query';
import { useLogin } from '@/lib/api/queries/dashboard';
import { useAuthStore } from '@/stores/auth-store';
import { useSelectionStore } from '@/stores/selection-store';
import { useChatStore } from '@/stores/chat-store';
import { toast } from '@/stores/toast-store';
import { ApiClientError } from '@/lib/api/client';
import { cn } from '@/shared/utils/cn';

/**
 * 로그인 페이지 (PRD 0523).
 *
 * Toss 스타일 중앙 카드 — id(사번 또는 user_id) + password 입력 후 로그인.
 * 성공 시 localStorage 에 토큰 저장 + 메인 대시보드(`/`) 리다이렉트.
 *
 * 시연 계정:
 *  - 박지은 사번 `301096` (또는 `emp_2026003`) / 비밀번호 `1234`
 *  - 박현웅 사번 `299810` (또는 `emp_2026004`) / 비밀번호 `1234`
 */
export default function LoginPage() {
  const router = useRouter();
  const [loginId, setLoginId] = useState('');
  const [password, setPassword] = useState('');
  const [errorMsg, setErrorMsg] = useState<string | null>(null);
  const login = useLogin();
  const setUser = useAuthStore((s) => s.setUser);
  const resetSelection = useSelectionStore((s) => s.reset);
  const startNewChat = useChatStore((s) => s.startNewSession);
  const qc = useQueryClient();

  // 이미 로그인 상태면 메인으로 리다이렉트
  useEffect(() => {
    if (typeof window === 'undefined') return;
    const token = localStorage.getItem('auth-token');
    if (token) router.replace('/');
  }, [router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg(null);
    if (!loginId.trim() || !password.trim()) {
      setErrorMsg('사번/아이디와 비밀번호를 모두 입력해주세요.');
      return;
    }
    try {
      const result = await login.mutateAsync({
        login_id: loginId.trim(),
        password: password.trim(),
      });
      localStorage.setItem('auth-token', result.token);
      // 이전 사용자의 선택/채팅/캐시 모두 초기화 → 새 사용자 깨끗한 상태로
      resetSelection();
      startNewChat();
      qc.clear();
      setUser({
        user_id: result.user.user_id,
        user_role: result.user.role,
        name: result.user.name ?? undefined,
        primary_product_code: result.user.primary_product_code,
        employee_no: result.user.employee_no,
        department: result.user.department,
        email: result.user.email,
      });
      toast.show('MSG-TST-01', { time: result.user.name ?? '' });
      router.replace('/');
    } catch (err) {
      if (err instanceof ApiClientError) {
        setErrorMsg(err.detail ?? err.message);
      } else {
        setErrorMsg('로그인 중 오류가 발생했습니다.');
      }
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-gray-50 via-white to-toss-blue-bg px-4">
      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.3 }}
        className="w-full max-w-[420px]"
      >
        {/* 로고 + 서비스명 */}
        <div className="mb-8 flex flex-col items-center text-center">
          <div className="mb-3 flex h-14 w-14 items-center justify-center rounded-2xl bg-toss-blue text-2xl font-extrabold text-white shadow-toss-md">
            P
          </div>
          <h1 className="text-[24px] font-extrabold tracking-tight text-gray-900">
            POS-Pricing Navigator
          </h1>
          <p className="mt-1.5 text-sm font-medium text-gray-500">
            AI 기반 영업 시황 어시스턴트
          </p>
        </div>

        {/* 카드 */}
        <form
          onSubmit={handleSubmit}
          className="rounded-3xl bg-white p-7 shadow-toss-md"
        >
          {/* 사번/아이디 */}
          <label className="block text-[13px] font-semibold tracking-tight text-gray-700">
            사번 또는 아이디
          </label>
          <input
            type="text"
            value={loginId}
            onChange={(e) => {
              setLoginId(e.target.value);
              setErrorMsg(null);
            }}
            placeholder="301096 또는 emp_2026003"
            autoComplete="username"
            autoFocus
            className={cn(
              'mt-2 h-12 w-full rounded-xl bg-gray-100 px-4 text-[15px] font-medium tracking-tight text-gray-900',
              'transition-all placeholder:font-normal placeholder:text-gray-400',
              'focus:bg-white focus:outline-none focus:ring-2 focus:ring-toss-blue',
            )}
          />

          {/* 비밀번호 */}
          <label className="mt-4 block text-[13px] font-semibold tracking-tight text-gray-700">
            비밀번호
          </label>
          <input
            type="password"
            value={password}
            onChange={(e) => {
              setPassword(e.target.value);
              setErrorMsg(null);
            }}
            placeholder="••••"
            autoComplete="current-password"
            className={cn(
              'mt-2 h-12 w-full rounded-xl bg-gray-100 px-4 text-[15px] font-medium tracking-tight text-gray-900',
              'transition-all placeholder:font-normal placeholder:text-gray-400',
              'focus:bg-white focus:outline-none focus:ring-2 focus:ring-toss-blue',
            )}
          />

          {errorMsg && (
            <p className="mt-3 text-[13px] font-semibold text-danger" role="alert">
              {errorMsg}
            </p>
          )}

          {/* 로그인 버튼 */}
          <motion.button
            type="submit"
            disabled={login.isPending}
            whileTap={{ scale: 0.98 }}
            className={cn(
              'mt-6 inline-flex h-12 w-full items-center justify-center gap-1.5 rounded-xl bg-toss-blue text-[15px] font-bold tracking-tight text-white shadow-toss',
              'transition-all hover:bg-toss-blue-hover disabled:opacity-60',
            )}
          >
            {login.isPending ? (
              <span>로그인 중…</span>
            ) : (
              <>
                <LogIn className="h-4 w-4" />
                로그인
              </>
            )}
          </motion.button>

          {/* 시연 안내 */}
          <div className="mt-5 rounded-xl bg-toss-blue-bg px-4 py-3 text-[12px] font-medium leading-relaxed text-gray-700">
            <div className="mb-1 font-bold text-toss-blue">시연 계정</div>
            <div>박지은 — 사번 <span className="font-mono font-bold">301096</span> · 비밀번호 <span className="font-mono font-bold">1234</span></div>
            <div>박현웅 — 사번 <span className="font-mono font-bold">299810</span> · 비밀번호 <span className="font-mono font-bold">1234</span></div>
          </div>
        </form>

        {/* 하단 footer */}
        <p className="mt-6 text-center text-[11px] font-medium text-gray-400">
          POSCO HACKATHON 2026 · POS-Pricing Navigator
        </p>
      </motion.div>
    </div>
  );
}
