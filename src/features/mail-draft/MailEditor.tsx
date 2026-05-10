import { useMailStore } from '@/store/mail/useMailStore';
import type { MailStore } from '@/store/mail/useMailStore';
import type { MailBlockType } from '@/types/mail.types';
import styles from './MailEditor.module.css';

const selectDraft = (s: MailStore) => s.draft;
const selectAvailableBlocks = (s: MailStore) => s.availableBlocks;

const blockLabelMap: Record<MailBlockType, string> = {
  GREETING: '인사말',
  MARKET_SUMMARY: '시장 현황',
  NEGOTIATION_POSITION: '협상 입장',
  PRICE_PROPOSAL: '가격 제안',
  QUALITY_STRENGTH: '품질 강점',
  MEETING_REQUEST: '미팅 요청',
  CLOSING: '마무리',
};

const MailEditor = () => {
  const draft = useMailStore(selectDraft);
  const availableBlocks = useMailStore(selectAvailableBlocks);

  if (!draft) return null;

  const blockLabelFromAvailable = Object.fromEntries(
    availableBlocks.map((b) => [b.type, b.label])
  );

  return (
    <div className={styles.editor}>
      <div className={styles.metaFields}>
        <div className={styles.field}>
          <label className={styles.fieldLabel}>받는사람</label>
          <input
            className={styles.input}
            value={draft.recipient}
            onChange={(e) => useMailStore.getState().updateField('recipient', e.target.value)}
          />
        </div>
        <div className={styles.field}>
          <label className={styles.fieldLabel}>참조</label>
          <input
            className={styles.input}
            value={draft.cc}
            placeholder="선택 사항"
            onChange={(e) => useMailStore.getState().updateField('cc', e.target.value)}
          />
        </div>
        <div className={styles.field}>
          <label className={styles.fieldLabel}>제목</label>
          <input
            className={styles.input}
            value={draft.subject}
            onChange={(e) => useMailStore.getState().updateField('subject', e.target.value)}
          />
        </div>
      </div>

      <div className={styles.blocks}>
        {draft.blocks.map((b) => (
          <div key={b.blockType} className={styles.block}>
            <span className={styles.blockLabel}>
              {blockLabelFromAvailable[b.blockType] ?? blockLabelMap[b.blockType]}
            </span>
            <textarea
              className={styles.textarea}
              value={b.text}
              rows={3}
              onChange={(e) =>
                useMailStore.getState().updateBlockText(b.blockType, e.target.value)
              }
            />
          </div>
        ))}
      </div>
    </div>
  );
};

export default MailEditor;
