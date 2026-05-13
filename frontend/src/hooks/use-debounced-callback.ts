import { useCallback, useRef } from 'react';

/**
 * 디바운스 콜백 훅
 *
 * 새로고침 버튼 5초 잠금 (Q12, P-04) 등 중복 호출 방지에 사용.
 *
 * @example
 *   const debounced = useDebouncedCallback(handler, 5000);
 *   <button onClick={debounced} />
 */
export function useDebouncedCallback<T extends (...args: never[]) => void>(
  callback: T,
  delayMs: number,
): T {
  const lastCallRef = useRef<number>(0);

  return useCallback(
    ((...args) => {
      // 마지막 호출로부터 delayMs 이내 재호출은 무시 (leading-edge debounce)
      const now = Date.now();
      if (now - lastCallRef.current < delayMs) return;
      lastCallRef.current = now;
      callback(...args);
    }) as T,
    [callback, delayMs],
  );
}
