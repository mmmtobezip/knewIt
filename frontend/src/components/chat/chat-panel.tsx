'use client';

import { useEffect, useRef, useState } from 'react';
import { Send } from 'lucide-react';
import { motion } from 'framer-motion';
import { PoseokhoAvatar } from './poseokho-avatar';
import { useChatStore } from '@/stores/chat-store';
import { useSelectionStore } from '@/stores/selection-store';
import { useTriggerEvent, useCustomerProfile, useAnalysis } from '@/lib/api/queries/dashboard';
import { streamChat } from '@/services/chat-stream.service';
import { toast } from '@/stores/toast-store';
import { CHAT } from '@/shared/constants';
import { cn } from '@/shared/utils/cn';

/**
 * 채팅 패널 (AREA-MAIN-04)
 *
 * 핵심 기능:
 * - SSE 스트리밍 (Q7) 으로 AI 답변 청크 단위 표시
 * - 사용자 입력 500자 제한, 30초 타임아웃 (Q11)
 * - 추천 질문 클릭 또는 자유 입력 모두 동일 패널에서 표시
 * - 빈 입력 / 길이 초과 시 인라인 에러 (MSG-INL-01 / 02)
 * - 채팅 이력은 영속 저장 X (메모리만)
 */
export function ChatPanel() {
  const messages = useChatStore((s) => s.messages);
  const isStreaming = useChatStore((s) => s.isStreaming);
  const appendUserMessage = useChatStore((s) => s.appendUserMessage);
  const startAssistantMessage = useChatStore((s) => s.startAssistantMessage);
  const appendAssistantDelta = useChatStore((s) => s.appendAssistantDelta);
  const finishStreaming = useChatStore((s) => s.finishStreaming);
  const sessionId = useChatStore((s) => s.sessionId);

  const { customerId, productCode } = useSelectionStore();
  const profileQuery = useCustomerProfile(customerId);
  const triggerQuery = useTriggerEvent(productCode, new Date().toISOString().slice(0, 10));
  const analysisQuery = useAnalysis(triggerQuery.data?.event_id ?? null);

  const [draft, setDraft] = useState('');
  const [inlineError, setInlineError] = useState<string | null>(null);
  const abortRef = useRef<AbortController | null>(null);
  const scrollerRef = useRef<HTMLDivElement>(null);

  // 메시지 변경 시 자동 스크롤
  useEffect(() => {
    if (!scrollerRef.current) return;
    scrollerRef.current.scrollTop = scrollerRef.current.scrollHeight;
  }, [messages]);

  // 컴포넌트 unmount 시 진행 중 스트림 중단
  useEffect(() => {
    return () => abortRef.current?.abort();
  }, []);

  /** 자유 질문 전송 (P-06) */
  const handleSend = () => {
    setInlineError(null);
    const trimmed = draft.trim();
    if (!trimmed) {
      setInlineError('메시지를 입력해주세요.');
      return;
    }
    if (trimmed.length > CHAT.MAX_INPUT_LENGTH) {
      setInlineError(`최대 ${CHAT.MAX_INPUT_LENGTH}자까지 입력 가능합니다.`);
      return;
    }
    if (!customerId || !productCode || !sessionId) return;
    if (isStreaming) return;

    setDraft('');
    appendUserMessage(trimmed);
    startAssistantMessage();

    abortRef.current = streamChat(
      '/api/chat',
      {
        session_id: sessionId,
        customer_id: customerId,
        product_code: productCode,
        query: trimmed,
      },
      {
        onDelta: appendAssistantDelta,
        onComplete: finishStreaming,
        onError: (err) => {
          finishStreaming();
          // 타임아웃 vs 일반 에러 구분
          if (err.message === 'TIMEOUT') {
            toast.show('MSG-ERR-04');
          } else {
            toast.show('MSG-ERR-03');
          }
        },
      },
    );
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  // 컨텍스트 미준비 시 입력 비활성화
  const inputDisabled = !customerId || !productCode || isStreaming;

  return (
    <div className="flex min-h-[300px] flex-col rounded-2xl bg-gray-50 p-6">
      {/* 대화 영역 */}
      <div ref={scrollerRef} className="flex flex-1 flex-col gap-1.5 overflow-y-auto pr-1">
        {messages.length === 0 && (
          <div className="flex h-full items-center justify-center text-sm font-medium text-gray-500">
            왼쪽의 추천 질문을 선택하거나 직접 질문을 입력해보세요.
          </div>
        )}

        {messages.map((msg, idx) => {
          if (msg.role === 'user') {
            return (
              <div key={idx} className="flex flex-col items-end">
                <motion.div
                  initial={{ opacity: 0, y: 4 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.2 }}
                  className="max-w-[75%] rounded-[20px_20px_4px_20px] bg-toss-blue px-5 py-3.5 text-[15px] font-semibold tracking-tight text-white"
                >
                  {msg.content}
                </motion.div>
                <div className="mt-1 text-xs font-medium text-gray-500">{msg.timestamp}</div>
              </div>
            );
          }
          return (
            <div key={idx} className="flex flex-col">
              <div className="flex items-start gap-3">
                <PoseokhoAvatar />
                <motion.div
                  initial={{ opacity: 0, y: 4 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.2 }}
                  className="flex-1 whitespace-pre-wrap rounded-[4px_20px_20px_20px] bg-white px-5 py-4 text-[15px] font-medium leading-[1.7] tracking-tight text-gray-800"
                >
                  {msg.content || <StreamingDots />}
                </motion.div>
              </div>
              <div className="ml-[64px] mt-1 text-xs font-medium text-gray-500">{msg.timestamp}</div>
            </div>
          );
        })}
      </div>

      {/* 입력창 */}
      <div className="mt-5">
        <div
          className={cn(
            'flex items-center gap-2 rounded-xl bg-white px-5 py-4',
            inlineError && 'ring-1 ring-danger',
          )}
        >
          <input
            type="text"
            value={draft}
            onChange={(e) => {
              setDraft(e.target.value);
              setInlineError(null);
            }}
            onKeyDown={handleKeyDown}
            placeholder="추가 질문을 입력하세요..."
            disabled={inputDisabled}
            maxLength={CHAT.MAX_INPUT_LENGTH + 50}
            aria-label="채팅 입력"
            className="flex-1 bg-transparent text-[15px] font-medium tracking-tight text-gray-900 outline-none placeholder:text-gray-500 disabled:opacity-60"
          />
          <button
            onClick={handleSend}
            disabled={inputDisabled || !draft.trim()}
            aria-label="메시지 전송"
            className="inline-flex h-9 w-9 items-center justify-center rounded-full bg-toss-blue text-white transition-colors hover:bg-toss-blue-hover disabled:opacity-50"
          >
            <Send className="h-4 w-4" />
          </button>
        </div>
        {inlineError && <div className="ml-1 mt-1.5 text-xs font-semibold text-danger">{inlineError}</div>}
      </div>

      {/* 분석 컨텍스트 디버그 표시 (개발 환경에서만) */}
      <ChatContextSubtext
        customer={profileQuery.data?.customer_id}
        analysisReady={!!analysisQuery.data}
      />
    </div>
  );
}

function StreamingDots() {
  return (
    <span className="inline-flex items-center gap-1 text-gray-500">
      포석호가 답변 작성 중
      <motion.span
        animate={{ opacity: [0.2, 1, 0.2] }}
        transition={{ duration: 1.2, repeat: Infinity }}
      >
        ...
      </motion.span>
    </span>
  );
}

/** 채팅 컨텍스트 (어떤 분석 데이터가 주입되는지) 미니 표시 */
function ChatContextSubtext({ customer, analysisReady }: { customer?: string; analysisReady: boolean }) {
  if (!customer) return null;
  return (
    <div className="mt-2 px-1 text-[11px] font-medium text-gray-400">
      현재 분석 컨텍스트: {customer}
      {analysisReady ? ' · AI 진단 반영' : ' · 진단 준비 중'}
    </div>
  );
}
