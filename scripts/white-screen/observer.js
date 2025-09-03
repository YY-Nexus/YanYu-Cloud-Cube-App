/**
 * 白屏检测：超阈值上报
 */
const WHITE_SCREEN_THRESHOLD_MS = 2000;
const start = performance.now();
let meaningfulShown = false;
const timer = setTimeout(() => {
  if (!meaningfulShown) {
    console.warn('[WhiteScreen] threshold exceeded', WHITE_SCREEN_THRESHOLD_MS);
    // 可上报到日志 / RUM
  }
}, WHITE_SCREEN_THRESHOLD_MS);

const mo = new MutationObserver(() => {
  const node = document.querySelector('img, main, [data-meaningful], .app-root, canvas');
  if (node) {
    meaningfulShown = true;
    clearTimeout(timer);
    mo.disconnect();
  }
});
mo.observe(document.documentElement, { childList: true, subtree: true });