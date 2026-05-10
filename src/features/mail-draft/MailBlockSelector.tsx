import { useMailStore } from '@/store/mail/useMailStore';
import type { MailStore } from '@/store/mail/useMailStore';
import type { MailBlock, MailContent } from '@/types/mail.types';
import styles from './MailBlockSelector.module.css';

const EMPTY_DRAFT_BLOCKS: MailContent[] = [];

const selectAvailableBlocks = (s: MailStore) => s.availableBlocks;
const selectDraftBlocks = (s: MailStore) => s.draft?.blocks ?? EMPTY_DRAFT_BLOCKS;

const BlockItem = ({ block, isActive }: { block: MailBlock; isActive: boolean }) => (
  <button
    className={`${styles.item} ${isActive ? styles.itemActive : ''}`}
    onClick={() => useMailStore.getState().toggleBlock(block.type)}
  >
    <div className={styles.itemTop}>
      <span className={styles.label}>{block.label}</span>
      <span className={`${styles.badge} ${isActive ? styles.badgeActive : ''}`}>
        {isActive ? '포함' : '미포함'}
      </span>
    </div>
    <span className={styles.desc}>{block.description}</span>
  </button>
);

const MailBlockSelector = () => {
  const blocks = useMailStore(selectAvailableBlocks);
  const draftBlocks = useMailStore(selectDraftBlocks);
  const activeTypes = new Set(draftBlocks.map((b) => b.blockType));

  return (
    <div className={styles.panel}>
      <h3 className={styles.title}>블록 구성</h3>
      <div className={styles.list}>
        {blocks.map((b) => (
          <BlockItem key={b.type} block={b} isActive={activeTypes.has(b.type)} />
        ))}
      </div>
    </div>
  );
};

export default MailBlockSelector;
