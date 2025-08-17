/**
 * Returns an async iterator that yields all matches for the given selector (current and future)
 * Options:
 *   signal - AbortSignal used to cancel observation
 *   root - Defaults to 'body', root node for querySelectorAll
 * based on https://github.com/sindresorhus/dom-mutations/blob/main/index.js
 */
const waitForMatches = (selector, { signal, root = 'body' } = {}) => ({
  async *[Symbol.asyncIterator]() {
    signal?.throwIfAborted();

    let { promise, resolve, reject } = Promise.withResolvers();
    const seenBefore = new WeakSet();

    const lookForNewMatches = (/* mutations, observer */) =>
      document.querySelectorAll(selector).forEach((node) => {
        if (!seenBefore.has(node)) {
          seenBefore.add(node);
          resolve(node);
        }
      });

    const observer = new MutationObserver(lookForNewMatches);

    signal?.addEventListener(
      'abort',
      () => {
        reject?.(signal.reason);
        observer.disconnect();
      },
      { once: true },
    );

    observer.observe(document.querySelector(root), {
      subtree: true,
      childList: true,
      attributes: false,
      characterData: false,
    });

    try {
      while (true) {
        signal?.throwIfAborted();
        yield await promise;
        ({ promise, resolve, reject } = Promise.withResolvers());
      }
    } finally {
      observer.disconnect();
    }
  },
});
