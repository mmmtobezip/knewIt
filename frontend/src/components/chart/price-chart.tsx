'use client';

import { Area, AreaChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from 'recharts';
import { TOKENS } from '@/styles/tokens';
import { formatDate } from '@/shared/utils/format';
import { cn } from '@/shared/utils/cn';
import type { IndicatorPoint } from '@/types';

interface PriceChartProps {
  data: IndicatorPoint[];
  unit?: string;
  /** 외부에서 높이/크기를 제어할 때 사용. 미지정 시 기본 220px. */
  className?: string;
}

/**
 * 가격 차트 (Recharts AreaChart) — PRD 0514 차트1 시계열.
 */
export function PriceChart({ data, unit, className }: PriceChartProps) {
  const xTickFormatter = (value: string): string => {
    const d = new Date(value);
    if (Number.isNaN(d.getTime())) return value;
    return `${String(d.getMonth() + 1).padStart(2, '0')}/${String(d.getDate()).padStart(2, '0')}`;
  };

  return (
    <div className={cn('h-[220px] w-full', className)}>
      <ResponsiveContainer width="100%" height="100%">
        <AreaChart data={data} margin={{ top: 8, right: 8, left: 0, bottom: 0 }}>
          <defs>
            <linearGradient id="priceFill" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor={TOKENS.color.tossBlue} stopOpacity={0.18} />
              <stop offset="100%" stopColor={TOKENS.color.tossBlue} stopOpacity={0} />
            </linearGradient>
          </defs>
          <XAxis
            dataKey="date"
            tickFormatter={xTickFormatter}
            tick={{ fill: TOKENS.color.gray[400], fontSize: 11 }}
            axisLine={false}
            tickLine={false}
            minTickGap={28}
          />
          <YAxis
            tick={{ fill: TOKENS.color.gray[400], fontSize: 11 }}
            axisLine={false}
            tickLine={false}
            width={48}
            domain={['auto', 'auto']}
          />
          <Tooltip
            cursor={{ stroke: TOKENS.color.gray[300], strokeDasharray: '3 3' }}
            contentStyle={{
              backgroundColor: TOKENS.color.gray[900],
              border: 'none',
              borderRadius: 10,
              padding: '8px 12px',
              color: '#fff',
              fontSize: 12,
              fontWeight: 600,
            }}
            labelFormatter={(label) => formatDate(String(label))}
            formatter={(value: number) => [`${value.toLocaleString()} ${unit ?? ''}`, '값']}
          />
          <Area
            type="monotone"
            dataKey="value"
            stroke={TOKENS.color.tossBlue}
            strokeWidth={2.5}
            fill="url(#priceFill)"
            dot={false}
            activeDot={{ r: 5, fill: TOKENS.color.tossBlue, stroke: '#fff', strokeWidth: 2 }}
          />
        </AreaChart>
      </ResponsiveContainer>
    </div>
  );
}
