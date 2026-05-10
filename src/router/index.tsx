import { createBrowserRouter } from 'react-router-dom';
import AppLayout from '@/layouts/AppLayout';
import DashboardPage from '@/pages/DashboardPage';
import TriggerAnalysisPage from '@/pages/TriggerAnalysisPage';
import PricingGuidePage from '@/pages/PricingGuidePage';
import MailDraftPage from '@/pages/MailDraftPage';
import PersonalizationPage from '@/pages/PersonalizationPage';
import NotFoundPage from '@/pages/NotFoundPage';

export const router = createBrowserRouter([
  {
    path: '/',
    element: <AppLayout />,
    children: [
      { index: true, element: <DashboardPage /> },
      { path: 'triggers', element: <TriggerAnalysisPage /> },
      { path: 'pricing', element: <PricingGuidePage /> },
      { path: 'mail', element: <MailDraftPage /> },
      { path: 'settings', element: <PersonalizationPage /> },
      { path: '*', element: <NotFoundPage /> },
    ],
  },
]);
