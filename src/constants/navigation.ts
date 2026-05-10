import { ROUTES } from './routes';

export interface NavItem {
  label: string;
  path: string;
  badgeKey?: 'triggerAlertCount';
}

export const GNB_NAV_ITEMS: NavItem[] = [
  { label: '대시보드', path: ROUTES.DASHBOARD },
  { label: 'AI 변동분석', path: ROUTES.TRIGGERS, badgeKey: 'triggerAlertCount' },
  { label: '판매가격 가이드', path: ROUTES.PRICING },
  { label: '메일 초안', path: ROUTES.MAIL },
  { label: '개인화 설정', path: ROUTES.SETTINGS },
];
