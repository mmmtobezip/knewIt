export const ROUTES = {
  DASHBOARD: '/',
  TRIGGERS: '/triggers',
  PRICING: '/pricing',
  MAIL: '/mail',
  SETTINGS: '/settings',
} as const;

export type RouteKey = keyof typeof ROUTES;
export type RoutePath = (typeof ROUTES)[RouteKey];
