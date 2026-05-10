import { usePersonalizationStore } from '@/store/personalization/usePersonalizationStore';
import type { PersonalizationStore } from '@/store/personalization/usePersonalizationStore';
import type { ProductType } from '@/types/common.types';
import styles from './ProductWeightPanel.module.css';

const selectConfigs = (s: PersonalizationStore) => s.productConfigs;
const selectWeights = (s: PersonalizationStore) => s.weights;
const selectSelected = (s: PersonalizationStore) => s.selectedProduct;

const PRODUCTS: ProductType[] = ['선재', 'HR(고로밀)', 'STS후판'];

const ProductWeightPanel = () => {
  const configs = usePersonalizationStore(selectConfigs);
  const weights = usePersonalizationStore(selectWeights);
  const selected = usePersonalizationStore(selectSelected);

  const config = configs.find((c) => c.product === selected);
  const productWeights = weights[selected] ?? {};

  return (
    <div className={styles.panel}>
      <div className={styles.tabs}>
        {PRODUCTS.map((p) => (
          <button
            key={p}
            className={`${styles.tab} ${selected === p ? styles.tabActive : ''}`}
            onClick={() => usePersonalizationStore.getState().setSelectedProduct(p)}
          >
            {p}
          </button>
        ))}
      </div>

      {config && (
        <div className={styles.sliders}>
          {config.indicators.map((ind) => {
            const val = productWeights[ind.id] ?? ind.defaultWeight;
            return (
              <div key={ind.id} className={styles.sliderRow}>
                <div className={styles.sliderMeta}>
                  <span className={styles.sliderLabel}>{ind.label}</span>
                  <span className={styles.sliderValue}>{Math.round(val * 100)}%</span>
                </div>
                <input
                  type="range"
                  className={styles.range}
                  min={0}
                  max={100}
                  value={Math.round(val * 100)}
                  onChange={(e) =>
                    usePersonalizationStore
                      .getState()
                      .setWeight(selected, ind.id, Number(e.target.value) / 100)
                  }
                />
              </div>
            );
          })}
          <button
            className={styles.resetBtn}
            onClick={() => usePersonalizationStore.getState().resetWeights(selected)}
          >
            기본값으로 초기화
          </button>
        </div>
      )}
    </div>
  );
};

export default ProductWeightPanel;
