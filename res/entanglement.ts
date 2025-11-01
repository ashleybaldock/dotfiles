export type EntangledConfig = {
  prefix: string;
  autoId: boolean;
  autoFor: boolean;
  observe: boolean;
};

const defaultConfig: EntangledConfig = {
  prefix: 'tngl',
  autoId: false,
  autoFor: false,
  observe: false,
};

/* Defines automatically entangled event sources, and the events they produce */
const autoEventSources = new Map([
  { query: `[data-source]`, events: [``] },
  { query: `input[type=radio]`, events: [``] },
  { query: `input[type=checkbox]`, events: [``] },
]);

const awaitComplete = 13;

const parseTag = (
  raw: readonly string[] | ArrayLike<string>,
  ...substitutions: any[]
) => String.raw({ raw }, ...substitutions) ?? '';

type TagArgs = [readonly string[] | ArrayLike<string>, ...any[]];

const parseSelector = (...args: TagArgs) =>
  ((parsedSelector) => (parsedSelector.length > 1 ? parsedSelector : ':root'))(
    parseTag(...args),
  );

export const entanglement = (({ window, window: { document } }) => {
  const qsAll = document.querySelectorAll.bind(document);

  const awaitMatches = ({
    selector,
    signal,
    root = ':root',
  }: {
    selector: string;
    root?: string;
    signal?: AbortSignal;
  }) => {
    // const selector = parseSelector(...args);

    return async function* matchGenerator() {
      signal?.throwIfAborted();

      let { promise, resolve, reject } = Promise.withResolvers();
      const seenBefore = new WeakSet();

      const lookForNewMatches = (/* mutations, observer */) =>
        resolve(
          [...document.querySelectorAll(selector)]
            .filter((node) =>
              seenBefore.has(node) ? false : seenBefore.add(node) && true,
            )
            .values(),
        );

      const observer = new MutationObserver(lookForNewMatches);

      signal?.addEventListener(
        'abort',
        () => {
          reject?.(signal.reason);
          observer.disconnect();
        },
        { once: true },
      );

      observer.observe(
        document.querySelector(root) ?? document.documentElement,
        {
          subtree: true,
          childList: true,
          attributes: false,
          characterData: false,
        },
      );

      try {
        while (true) {
          signal?.throwIfAborted();
          for (const match of await promise) {
            yield Promise.resolve(match);
          }
          ({ promise, resolve, reject } = Promise.withResolvers());
        }
      } finally {
        observer.disconnect();
      }
    };
  };

  const qsAlways = (...args: TagArgs) =>
    awaitMatches({ selector: parseSelector(...args) });

  console.log('entanglement()');

  /**
   *
   */
  const wrapped = () => {};

  const entangle = (document, options: EntangledConfig) => {
    awaitMatches({ selector: '' });
  };

  return (options: Partial<EntangledConfig> = {}) =>
    new Promise((resolve, reject) => {
      const waitForComplete = () =>
        document.readyState === 'complete'
          ? resolve(entangle(document, { ...defaultConfig, ...options }))
          : document.addEventListener('readystatechange', waitForComplete);
      waitForComplete();
    });
})({ window });
