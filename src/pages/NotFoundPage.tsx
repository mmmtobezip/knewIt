import { useNavigate } from 'react-router-dom';
import { ROUTES } from '@/constants/routes';

const NotFoundPage = () => {
  const navigate = useNavigate();

  return (
    <div
      style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        minHeight: '60vh',
        gap: '16px',
      }}
    >
      <h1 style={{ fontSize: '48px', fontWeight: 700, color: 'var(--text-tertiary)' }}>404</h1>
      <p style={{ color: 'var(--text-secondary)' }}>페이지를 찾을 수 없습니다.</p>
      <button
        onClick={() => navigate(ROUTES.DASHBOARD)}
        style={{
          padding: '8px 20px',
          background: 'var(--blue)',
          color: 'white',
          borderRadius: 'var(--radius-sm)',
          fontWeight: 600,
        }}
      >
        대시보드로 이동
      </button>
    </div>
  );
};

export default NotFoundPage;
