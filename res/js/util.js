export function* repeat(n, f, ...args) {
  while (n-- > 0) {
    yield f(...args);
  }
}

export const parseTag = (raw, ...substitutions) =>
  String.raw({ raw }, ...substitutions) ?? '';
export const html = (...args) => parseTag(...args);
export const css = (...args) => parseTag(...args);

/**
 * 'maybeString' in e.dataset && copy(e.dataset.maybeString)
 *
 * Object.hasOwn(e.dataset, 'maybeString') && copy(e.dataset.maybeString)
 *
 * e.dataset.maybeString !== undefined && copy(e.dataset.maybeString)
 *
 * e.dataset.maybeString?.match?.({[Symbol.match]: (s) => copy(s)})
 *
 * e.dataset.maybeString?.match?.(matchDispatch(copy))
 */
export const matchDispatch = (action) => {
  return {
    [Symbol.match]: (str) => action(str),
  };
};

export const copyTextToClipboard = async (text) =>
  'clipboard' in navigator
    ? await navigator.clipboard.writeText(text)
    : document.execCommand('copy', true, text);

export const copyImageToClipboard = async (blob) =>
  'clipboard' in navigator
    ? await navigator.clipboard.write([
        new ClipboardItem({ [blob.type]: blob }),
      ])
    : Promise.reject('Browser does not support copying images');

export const readyStateComplete = () => {
  const promise = new Promise((resolve, reject) => {
    const waitForComplete = () =>
      document.readyState === 'complete'
        ? resolve({ window })
        : document.addEventListener('readystatechange', waitForComplete);
    waitForComplete();
  });
  return promise;
};
