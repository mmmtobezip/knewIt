'use client';

import { useCallback, useEffect, useRef, useState } from 'react';
import { motion } from 'framer-motion';
import { Lightbulb } from 'lucide-react';
import { useTodayQuestions, useTriggerEvent } from '@/lib/api/queries/dashboard';
import { useSelectionStore } from '@/stores/selection-store';
import { useChatStore } from '@/stores/chat-store';
import { streamChat } from '@/services/chat-stream.service';
import { toast } from '@/stores/toast-store';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/shared/utils/cn';

/**
 * 추천 질문 패널 (AREA-MAIN-03)
 *
 * 동작 (index.html 원본 패턴 동일):
 * - 화면 진입 시 첫 번째 질문이 자동 active + 답변이 채팅에 자동 표시
 * - 고객사 변경 시 채팅 세션이 새로 발급되면 → 신규 세션에서 다시 자동 선택
 * - 사용자가 다른 카드 클릭 시 active 전환 + 새 답변 스트리밍
 *
 * 자동 발사 가드:
 * - sessionId 별로 1회만 실행 (autoFiredRef)
 * - 채팅에 메시지가 이미 있거나 스트리밍 중이면 미발사
 */
export function QuestionsPanel() {
  const { customerId, productCode } = useSelectionStore();
  const questionsQuery = useTodayQuestions(customerId);
  const triggerQuery = useTriggerEvent(productCode, new Date().toISOString().slice(0, 10));

  const appendUserMessage = useChatStore((s) => s.appendUserMessage);
  const startAssistantMessage = useChatStore((s) => s.startAssistantMessage);
  const appendAssistantDelta = useChatStore((s) => s.appendAssistantDelta);
  const finishStreaming = useChatStore((s) => s.finishStreaming);
  const clearMessages = useChatStore((s) => s.clearMessages);
  const sessionId = useChatStore((s) => s.sessionId);
  const messagesLen = useChatStore((s) => s.messages.length);

  const [activeIdx, setActiveIdx] = useState<number>(0);
  /** 세션별 자동 발사 1회 가드 */
  const autoFiredRef = useRef<string | null>(null);
  /** 진행 중인 SSE 스트림 중단용 */
  const abortRef = useRef<AbortController | null>(null);

  /**
   * 질문 선택 → 채팅 초기화 + 새 SSE 스트리밍
   *
   * index.html 원본 패턴: 질문 클릭 시 채팅 영역이 통째로 새 답변으로 교체됨.
   * 따라서 누적 표시가 아니라 매번 fresh 한 단일 Q&A 만 표시.
   */
  const fireQuestion = useCallback(
    (idx: number) => {
      const question = questionsQuery.data?.[idx];
      if (!question) return;
      if (!sessionId || !customerId || !productCode) return;

      // 이전 스트림 진행 중이면 즉시 중단 (스트리밍 중 다른 카드 클릭 대응)
      abortRef.current?.abort();
      abortRef.current = null;

      // 채팅 초기화 → 새 Q&A 만 보이도록
      clearMessages();
      setActiveIdx(idx);
      // 자동 발사 가드 — 사용자 클릭으로도 가드를 마킹해 두면 useEffect 재발사 차단
      autoFiredRef.current = sessionId;

      appendUserMessage(question.question);
      startAssistantMessage();

      const controller = streamChat(
        '/api/chat/question',
        {
          session_id: sessionId,
          customer_id: customerId,
          product_code: productCode,
          question_id: question.question_id,
        },
        {
          onDelta: appendAssistantDelta,
          onComplete: finishStreaming,
          onError: (err) => {
            finishStreaming();
            toast.show(err.message === 'TIMEOUT' ? 'MSG-ERR-04' : 'MSG-ERR-03');
          },
        },
      );
      abortRef.current = controller;
    },
    [
      questionsQuery.data,
      sessionId,
      customerId,
      productCode,
      clearMessages,
      appendUserMessage,
      startAssistantMessage,
      appendAssistantDelta,
      finishStreaming,
    ],
  );

  /** 컴포넌트 unmount / 고객사 변경 시 진행 중 스트림 정리 */
  useEffect(() => {
    return () => {
      abortRef.current?.abort();
      abortRef.current = null;
    };
  }, [sessionId]);

  /**
   * 신규 세션 진입 시 첫 번째 질문 자동 발사
   * - 세션 새로 시작될 때마다 (고객사/제품 변경 또는 최초 진입)
   * - 채팅이 비어있고, 질문 데이터 준비되었을 때만
   */
  useEffect(() => {
    if (!sessionId) return;
    if (autoFiredRef.current === sessionId) return;
    if (!questionsQuery.data || questionsQuery.data.length === 0) return;
    if (messagesLen > 0) return;
    if (!customerId || !productCode) return;

    autoFiredRef.current = sessionId;
    setActiveIdx(0);
    fireQuestion(0);
  }, [sessionId, questionsQuery.data, messagesLen, customerId, productCode, fireQuestion]);

  /** 세션 변경 시 active idx 0 으로 시각 리셋 (자동 발사 useEffect 가 이어서 처리) */
  useEffect(() => {
    setActiveIdx(0);
  }, [sessionId]);

  return (
    <div>
      <h3 className="mb-4 flex items-center gap-2 text-[17px] font-bold tracking-tighter text-gray-900">
        <Lightbulb className="h-5 w-5 text-warning" fill="currentColor" />
        오늘의 추천 질문
      </h3>

      {questionsQuery.isLoading && (
        <div className="space-y-2.5">
          <Skeleton className="h-16 w-full" />
          <Skeleton className="h-16 w-full" />
          <Skeleton className="h-16 w-full" />
        </div>
      )}

      {questionsQuery.data && (
        <div className="space-y-2.5">
          {questionsQuery.data.map((q, idx) => (
            <motion.button
              key={q.question_id}
              whileTap={{ scale: 0.99 }}
              onClick={() => fireQuestion(idx)}
              aria-pressed={activeIdx === idx}
              className={cn(
                'flex w-full items-start gap-3 rounded-xl p-4 text-left transition-colors',
                activeIdx === idx ? 'bg-toss-blue-light' : 'bg-gray-100 hover:bg-toss-blue-bg',
              )}
            >
              <div
                className={cn(
                  'flex h-[26px] w-[26px] shrink-0 items-center justify-center rounded-full text-xs font-bold',
                  activeIdx === idx ? 'bg-toss-blue text-white' : 'bg-gray-300 text-gray-600',
                )}
              >
                {idx + 1}
              </div>
              <p className="flex-1 text-sm font-semibold leading-snug tracking-tight text-gray-800">
                {q.question}
              </p>
            </motion.button>
          ))}
        </div>
      )}

      {/* trigger_event 없음 안내 (보조 메시지) */}
      {!triggerQuery.isLoading && !triggerQuery.data && (
        <div className="mt-4 rounded-xl bg-toss-blue-bg p-3 text-xs font-medium text-gray-700">
          오늘은 주요 변동이 없습니다.
        </div>
      )}
    </div>
  );
}
