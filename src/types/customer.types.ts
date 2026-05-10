import type { AlertLevel, ProductType } from './common.types';

export interface Customer {
  id: string;
  name: string;
  country: string;
  products: ProductType[];
  monthlyVolumeTon: number;
  annualContractTon: number;
  riskLevel: AlertLevel;
  riskScore: number;
  contactName: string;
  contactEmail: string;
  salesRepId: string;
  notes?: string;
}

export interface CustomerRisk {
  customerId: string;
  customerName: string;
  riskLevel: AlertLevel;
  riskScore: number;
  affectedProducts: ProductType[];
  riskReason: string;
}

export interface AffectedCustomer {
  customerId: string;
  customerName: string;
  product: ProductType;
  monthlyVolumeTon: number;
  riskLevel: AlertLevel;
  riskScore: number;
}
