'use client';

import Link from 'next/link';
import { motion } from 'framer-motion';
import { BarChart3, Mail, ChevronRight } from 'lucide-react';
import { cn } from '@/shared/utils/cn';

/**
 * 진입 카드 (AREA-MAIN-02)
 *
 * 메인 대시보드에서 판매 가이드 / 메일 초안 작성 화면으로 이동.
 * - NAV-01: /guide
 * - NAV-02: /mail
 * - localStorage 상태 유지 (P-08)
 */
export function QuickNav() {
  return (
    <div className="mb-3 grid grid-cols-2 gap-2.5">
      <QuickNavCard
        href="/guide"
        icon={<BarChart3 className="h-[18px] w-[18px] text-toss-blue" />}
        title="판매 가이드"
        description="고객사별 맞춤 협상 시나리오와 토킹 포인트"
      />
      <QuickNavCard
        href="/mail"
        icon={<Mail className="h-[18px] w-[18px] text-toss-blue" />}
        title="메일 초안 작성"
        description="AI가 작성하는 고객사 맞춤 메일 템플릿"
      />
    </div>
  );
}

interface QuickNavCardProps {
  href: '/guide' | '/mail';
  icon: React.ReactNode;
  title: string;
  description: string;
}

function QuickNavCard({ href, icon, title, description }: QuickNavCardProps) {
  return (
    <Link href={href} className="no-underline">
      <motion.div
        whileHover={{ y: -1 }}
        whileTap={{ scale: 0.99 }}
        transition={{ duration: 0.15 }}
        className={cn(
          'flex items-center gap-3 rounded-xl bg-white p-3 px-4 transition-colors',
          'hover:bg-toss-blue-bg cursor-pointer',
        )}
      >
        <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-md bg-toss-blue-light">
          {icon}
        </div>
        <div className="flex-1">
          <div className="text-sm font-bold tracking-tight text-gray-900">{title}</div>
          <div className="text-xs font-medium tracking-tight text-gray-600">{description}</div>
        </div>
        <ChevronRight className="h-5 w-5 text-gray-400" strokeWidth={1.5} />
      </motion.div>
    </Link>
  );
}
