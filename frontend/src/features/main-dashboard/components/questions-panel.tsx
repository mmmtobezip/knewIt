'use client';

import { useCallback, useEffect, useRef, useState } from 'react';
import { motion } from 'framer-motion';
import { Lightbulb } from 'lucide-react';
import { useTodayQuestions } from '@/lib/api/queries/dashboard';
import { useSelectionStore } from '@/stores/selection-store';
import { useChatStore } from '@/stores/chat-store';
import { toast } from '@/stores/toast-store';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/shared/utils/cn';

/**
 * 추천 질문 패널 (PRD 0514 SMI-Bot v1.1).
 *
 * - 제품(product) 단위 질문 3개 조회
 * - 질문 카드 클릭 시 JSON 답변(POST /api/today-questions/answer) 호출
 * - 답변은 채팅 store 의 마지막 assistant 메시지로 표시
 */
const API_BASE = process.env.NEXT_PUBLIC_API_BASE_URL ?? 'http://localhost:3001';

function getAuthToken(): string {
  if (typeof window === 'undefined') return 'mock-token-emp_2026001';
  return localStorage.getItem('auth-token') ?? 'mock-token-emp_2026001';
}

export function QuestionsPanel() {
  const { productCode, customerId } = useSelectionStore();
  const questionsQuery = useTodayQuestions(productCode);

  const appendUserMessage = useChatStore((s) => s.appendUserMessage);
  const startAssistantMessage = useChatStore((s) => s.startAssistantMessage);
  const replaceLastAssistantMessage = useChatStore((s) => s.replaceLastAssistantMessage);
  const finishStreaming = useChatStore((s) => s.finishStreaming);
  const clearMessages = useChatStore((s) => s.clearMessages);
  const sessionId = useChatStore((s) => s.sessionId);
  const messagesLen = useChatStore((s) => s.messages.length);

  const [activeIdx, setActiveIdx] = useState(0);
  const autoFiredRef = useRef<string | null>(null);
  // 동시 호출 차단 — auto-fire 와 사용자 클릭 간 race 로 답변이 2번 누적되는 버그 방지
  const firingRef = useRef(false);

  const fireQuestion = useCallback(
    async (idx: number) => {
      if (firingRef.current) return;
      const q = questionsQuery.data?.questions?.[idx];
      if (!q || !productCode) return;
      firingRef.current = true;
      clearMessages();
      setActiveIdx(idx);
      autoFiredRef.current = sessionId;

      appendUserMessage(q.text);
      startAssistantMessage();

      try {
        const response = await fetch(`${API_BASE}/api/today-questions/answer/stream`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${getAuthToken()}`,
          },
          body: JSON.stringify({
            product: productCode,
            qid: q.qid,
            text: q.text,
            trigger_indicators: q.trigger_indicators,
            related_groups_internal: q.related_groups_internal,
            customer_id: customerId ?? null,
          }),
        });

        if (!response.ok || !response.body) throw new Error('stream error');

        const reader = response.body.getReader();
        const decoder = new TextDecoder();
        let buffer = '';

        while (true) {
          const { done, value } = await reader.read();
          if (done) break;

          buffer += decoder.decode(value, { stream: true });
          const lines = buffer.split('\n');
          buffer = lines.pop() ?? '';

          for (const line of lines) {
            if (!line.startsWith('data: ')) continue;
            const raw = line.slice(6).trim();
            if (raw === '[DONE]') break;

            try {
              const event = JSON.parse(raw) as {
                type: string;
                message?: string;
                answer?: { briefing: string; sales_rep_script: string };
              };
              if (event.type === 'step' && event.message) {
                replaceLastAssistantMessage(event.message);
              } else if (event.type === 'result' && event.answer) {
                const ans = event.answer;
                replaceLastAssistantMessage(
                  `${ans.briefing}\n\n[추천 대응 방안]\n${ans.sales_rep_script}`,
                );
              }
            } catch {
              // malformed JSON 무시
            }
          }
        }
      } catch {
        toast.show('MSG-ERR-03');
      } finally {
        finishStreaming();
        firingRef.current = false;
      }
    },
    [
      questionsQuery.data,
      productCode,
      customerId,
      sessionId,
      clearMessages,
      appendUserMessage,
      startAssistantMessage,
      replaceLastAssistantMessage,
      finishStreaming,
    ],
  );

  useEffect(() => {
    if (!sessionId) return;
    if (autoFiredRef.current === sessionId) return;
    const list = questionsQuery.data?.questions;
    if (!list || list.length === 0) return;
    if (messagesLen > 0) return;
    if (!productCode) return;
    autoFiredRef.current = sessionId;
    setActiveIdx(0);
    void fireQuestion(0);
  }, [sessionId, questionsQuery.data, messagesLen, productCode, fireQuestion]);

  useEffect(() => {
    setActiveIdx(0);
  }, [sessionId]);

  const list = questionsQuery.data?.questions ?? [];

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

      {list.length > 0 && (
        <div className="space-y-2.5">
          {list.map((q, idx) => (
            <motion.button
              key={q.qid}
              whileTap={{ scale: 0.99 }}
              onClick={() => void fireQuestion(idx)}
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
                {q.text}
              </p>
            </motion.button>
          ))}
        </div>
      )}
    </div>
  );
}
