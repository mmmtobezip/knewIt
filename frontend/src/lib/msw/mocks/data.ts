/**
 * PRD 0514 카탈로그 (CUSTOMERS / PRODUCTS).
 * MSW Mock 데이터는 더 이상 사용하지 않음 (.env.local: NEXT_PUBLIC_API_MOCKING=disabled).
 */

export const CUSTOMERS = [
  { id: '고려제강', name: '고려제강' },
  { id: 'Borcelik Celik Sanayii VE Ticaret AS', name: 'Borcelik (TR)' },
  { id: 'Nissan Motor Co., Ltd', name: 'Nissan Motor' },
  { id: 'Berg Steel Pipe Corp', name: 'Berg Steel Pipe' },
  { id: '썬시멘트주식회사', name: '썬시멘트' },
  { id: 'New Best Wire Industrial Co., Ltd', name: 'New Best Wire' },
  { id: 'JFE Techno Wire Corporation', name: 'JFE Techno Wire' },
  { id: '동일제강', name: '동일제강' },
  { id: '세아씨엠', name: '세아씨엠' },
  { id: 'Ningbo Dafeng Machinery Co., Ltd', name: 'Ningbo Dafeng' },
] as const;

export type CustomerId = (typeof CUSTOMERS)[number]['id'];

export const PRODUCTS = [
  { code: 'HR(고로밀)', name: 'HR(고로밀)' },
  { code: '후판', name: '후판' },
  { code: '냉연(CR)', name: '냉연(CR)' },
  { code: 'STS 304', name: 'STS 304' },
  { code: '부산물(철스크랩)', name: '부산물(철스크랩)' },
] as const;

export type ProductCode = (typeof PRODUCTS)[number]['code'];
