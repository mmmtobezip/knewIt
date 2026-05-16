'use client';

import { useEffect, useRef } from 'react';
import { motion } from 'framer-motion';
import { PoseokhoAvatar } from './poseokho-avatar';
import { useChatStore } from '@/stores/chat-store';

/**
 * 답변 표시 패널 (PRD 0514 SMI-Bot v1.1).
 *
 * 추천 질문 클릭 시 questions-panel 이 chat store 를 채우고,
 * 이 패널은 1분 브리핑 + 응대 스크립트를 표시한다.
 * 자유 입력 SSE 는 PRD 0514 에서 제거됨.
 */
export function ChatPanel() {
  const messages = useChatStore((s) => s.messages);
  const scrollerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!scrollerRef.current) return;
    scrollerRef.current.scrollTop = scrollerRef.current.scrollHeight;
  }, [messages]);

  return (
    <div className="flex min-h-[300px] flex-col rounded-2xl bg-gray-50 p-6">
      <div ref={scrollerRef} className="flex flex-1 flex-col gap-1.5 overflow-y-auto pr-1">
        {messages.length === 0 && (
          <div className="flex h-full items-center justify-center text-center text-sm font-medium text-gray-500">
            왼쪽의 추천 질문 카드를 선택하면<br />
            1분 브리핑 + 판매담당자 응대 스크립트가 표시됩니다.
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
