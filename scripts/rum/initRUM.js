/**
 * 简化版 RUM 初始化示例：采集启动阶段关键事件。
 * 实际可换 Sentry/Faro/自研 SDK。
 */
export function initRUM() {
  const sessionId = crypto.randomUUID();
  const t0 = performance.timeOrigin || Date.now();
  const events = [];
  function log(stage, extra={}) {
    events.push({
      stage,
      ts: Date.now(),
      rel: performance.now(),
      session_id: sessionId,
      ...extra
    });
  }

  log('startup_init');
  window.addEventListener('DOMContentLoaded', () => log('dom_content_loaded'));
  window.addEventListener('load', () => log('window_load'));

  // Largest Contentful Paint
  if ('PerformanceObserver' in window) {
    try {
      const po = new PerformanceObserver((list) => {
        const entries = list.getEntries();
        const last = entries[entries.length - 1];
        if (last) log('lcp', { value: last.renderTime || last.loadTime || last.startTime });
      });
      po.observe({ type: 'largest-contentful-paint', buffered: true });
    } catch {}
  }

  // 白屏时间：首个非空文本或图片节点出现
  const startPaint = performance.now();
  const observer = new MutationObserver(() => {
    const meaningful = document.querySelector('img, h1, h2, h3, main, [data-meaningful]');
    if (meaningful) {
      log('first_meaningful_paint', { white_screen_ms: performance.now() - startPaint });
      observer.disconnect();
    }
  });
  observer.observe(document.documentElement, { childList: true, subtree: true });

  // 交互可用：简单近似（无长任务 > 50ms 且 DOMContentLoaded + LCP 就绪）
  let interactiveCheck = setInterval(() => {
    const longTasks = performance.getEntriesByType('longtask') || [];
    const recentLong = longTasks.some(t => (performance.now() - t.startTime) < 500);
    if (!recentLong && document.readyState === 'complete') {
      log('interactive_ready', { tti_ms: performance.now() });
      clearInterval(interactiveCheck);
    }
  }, 300);

  window.__flushRUM = function flushRUM() {
    // TODO: Replace with actual transport (fetch/beacon)
    console.debug('[RUM] events', events);
  };

  window.addEventListener('beforeunload', () => window.__flushRUM());
}