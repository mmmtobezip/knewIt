import type { ProductConfig, AlertPreviewItem } from '@/types/personalization.types';
import {
  mockProductConfigs,
  mockAlertPreview,
} from '@/mocks/fixtures/personalization.fixture';

const SIMULATED_DELAY_MS = 400;

const delay = (ms: number) =>
  new Promise<void>((resolve) => setTimeout(resolve, ms));

export const mockGetProductConfigs = async (): Promise<ProductConfig[]> => {
  await delay(SIMULATED_DELAY_MS);
  return [...mockProductConfigs];
};

export const mockGetAlertPreview = async (): Promise<AlertPreviewItem[]> => {
  await delay(SIMULATED_DELAY_MS);
  return [...mockAlertPreview];
};
