'use client';

import { Area, AreaChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from 'recharts';
import { TOKENS } from '@/styles/tokens';
import { formatDate, formatInt } from '@/shared/utils/format';
import type { IndicatorTimeseries } from '@/types';

interface PriceChartProps {
  data: IndicatorTimeseries['series'];
}

/**
 * 가격 차트 (Recharts AreaChart)
 *
 * Toss 스타일:
 * - Line color: Toss Blue
 * - Area fill: Toss Blue 8% opacity
 * - Tooltip: 호버 시 날짜 + 가격 표시
 * - X축 6개 ticks (자동 분배)
 */
export function PriceChart({ data }: PriceChartProps) {
  const xTickFormatter = (value: string): string => {
    const d = new Date(value);
    if (Number.isNaN(d.getTime())) return value;
    return `${d.getMonth() + 1}/${d.getDate()}`;
  };

  return (
    <div className="h-[220px] w-full">
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
            width={40}
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
            formatter={(value: number) => [`$${formatInt(value)}`, '가격']}
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
