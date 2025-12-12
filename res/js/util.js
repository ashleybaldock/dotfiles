function* repeat(n, f, ...args) {
  while (n-- > 0) {
    yield f(...args);
  }
}

const parseTag = (raw, ...substitutions) =>
  String.raw({ raw }, ...substitutions) ?? '';
const html = (...args) => parseTag(...args);
const css = (...args) => parseTag(...args);

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
const matchDispatch = (action) => {
  return {
    [Symbol.match]: (str) => action(str),
  };
};

const copyTextToClipboard = async (text) =>
  'clipboard' in navigator
    ? await navigator.clipboard.writeText(text)
    : document.execCommand('copy', true, text);
