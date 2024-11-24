/** TODO
 * Adds onclick event handler to elements with the
 *  @param {data-copyable} attribute
 * When triggered, the event handler copies the current
 *  value of the data-copy attribute to the clipboard
 *
 * TODO Also uses a MutationObserver to do this to nodes created later
 */
const copyTextToClipboard = async (text) =>
  'clipboard' in navigator
    ? await navigator.clipboard.writeText(text)
    : document.execCommand('copy', true, text);

const copy = (e) => {
  const toCopy = e.target?.querySelector?.('input')?.value;
  toCopy !== null &&
    toCopy !== undefined &&
    copyTextToClipboard(toCopy)
      .then(() => {
        e.target?.classList?.add('copied');
        setTimeout(() => e.target?.classList?.remove('copied'), 2000);
      })
      .catch((err) => {
        e.target?.classList?.add('copyfail');
        setTimeout(() => e.target?.classList?.remove('copyfail'), 4000);
      });
};
