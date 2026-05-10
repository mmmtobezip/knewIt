import {
  Radar,
  RadarChart as RechartsRadarChart,
  PolarGrid,
  PolarAngleAxis,
  ResponsiveContainer,
  Legend,
} from 'recharts';
import type { RadarDataPoint } from '@/types/pricing.types';
import styles from './RadarChart.module.css';

interface RadarChartProps {
  data: RadarDataPoint[];
  currentLabel?: string;
  pastLabel?: string;
  currentColor?: string;
  pastColor?: string;
}

const RadarChart = ({
  data,
  currentLabel = '현재',
  pastLabel = '과거',
  currentColor = '#2D6AFF',
  pastColor = '#AEAEB2',
}: RadarChartProps) => {
  return (
    <div className={styles.wrapper}>
      <ResponsiveContainer width="100%" height={260}>
        <RechartsRadarChart data={data}>
          <PolarGrid stroke="var(--border)" />
          <PolarAngleAxis
            dataKey="subject"
            tick={{ fontSize: 11, fill: 'var(--text-secondary)' }}
          />
          <Radar
            name={currentLabel}
            dataKey="current"
            stroke={currentColor}
            fill={currentColor}
            fillOpacity={0.15}
            strokeWidth={2}
          />
          <Radar
            name={pastLabel}
            dataKey="past"
            stroke={pastColor}
            fill={pastColor}
            fillOpacity={0.1}
            strokeWidth={1.5}
            strokeDasharray="4 3"
          />
          <Legend
            iconType="circle"
            iconSize={8}
            wrapperStyle={{ fontSize: '11px', color: 'var(--text-secondary)' }}
          />
        </RechartsRadarChart>
      </ResponsiveContainer>
    </div>
  );
};

export default RadarChart;
