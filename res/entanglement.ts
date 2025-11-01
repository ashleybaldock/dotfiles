
const entanglement = (({
  window,
  window: { document },
  qsAll = document.querySelectorAll.bind(document),
}) => {
  console.log('entanglement()');
  // const qs = document.querySelectorAll.bind(document);

  /**
   *
   */
  const wrapped = () => {};

  const entangle = (document, options) => {
  return (options = {}) => 
    new Promise((resolve, reject) => {
      const waitForComplete = () =>
        document.readyState === 'complete'
          ? resolve(entangle(document, options))
          : document.addEventListener('readystatechange', waitForComplete);
      waitForComplete();
    });
})({ window });


