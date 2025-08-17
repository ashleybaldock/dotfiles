// ==UserScript==
// @name        Page focus tracking
// @namespace   mayhem
// @version     1.0.5
// @author      flowsINtomAyHeM
// @downloadURL http://localhost:3333/vm/pagefocus.user.js
// @match       *://*/*
// @match       file:///*/*
// @grant       GM_info
// @grant       GM_addStyle
// @grant       GM_registerMenuCommand
// @grant       GM_getValue
// @grant       GM_setValue
// @grant       GM_addValueChangeListener
// @grant       GM_registerMenuCommand
// @grant       GM_xmlhttpRequest
// @require     http://localhost:3333/vm/util.user.js
// @cssBaseUrl  http://localhost:3333/vm/
// @description Do things in response to blur/focus etc.
// @cssBaseName pagefocus
// @injectIQB-into auto
// ==/UserScript==

const trackPageFocus = ({ addHint = true }) => {
  // addHint && qs`window`.map(({appendChild}) => appendChild(
  //     tag`div#${hintId}.someClass[attr=val]`).now();
  addHint &&
    qs`window`
      .map(({ appendChild }) => appendChild(tag('div', { id: hintId })).build())
      .now();

  const controller = new AbortController();

  // const end = qs`window`.on`focus`(({attr}) => attr`src`()).on`blur`(() => ) dataset }) => {
  // qs`window`.onfocus(({}))
  qs`window`.map(({ addEventListener, dataset }) => {
    addEventListener('focus', () => (dataset.hasFocus = ''), {
      capture: true,
      passive: true,
      signal: controller.signal,
    });
    addEventListener('blur', () => delete dataset.hasFocus, {
      capture: true,
      passive: true,
      signal: controller.signal,
    });
  });
  // window.addEventListener(type, listener);

  // const onFocus = () => {
  //   // qs`${on}`.classList.add('focused');
  //   document.body.classList.add('focused');
  //   document.body.setAttribute('data-focused', 'true');
  // };
  // const onBlur = () => {
  //   document.body.classList.remove('focused');
  //   document.body.setAttribute('data-focused', 'false');
  // };

  document.hasFocus() ? onFocus() : onBlur();
  unsafeWindow.addEventListener('blur', onBlur);
  unsafeWindow.addEventListener('focus', onFocus);

  return () => {
    unsafeWindow.removeEventListener('blur', onBlur);
    unsafeWindow.removeEventListener('focus', onFocus);
    focusHintElement?.remove?.();
  };
};

const pageFocusHint = (({ window, qs }) => {
  const pageFocusHintId = `focusHint`;
  const pageFocusHintSelector = `#${pageFocusHintId}`;

  /* Some things are best not done when the page is embedded */
  const notEmbedded = () => window.self === window.top;

  injectStylesheet({
    name: 'focusHint',
    title: 'util',
    css: `#focusHint {
  position: fixed;
  background-color: #f00;
  width: 100vw;
  height: 0;
  z-index: 1000;
}
#focusHint.focused
{
  height: 1px;
}`,
  });

  /*
    qs`body`.add`div#focusStatus`
    
    let body = qs`body`
    let focusStatus = body.add`div#focusStatus`
    qs`window`.ev`focus`.add('focus', () => qs`#focusStatus`.cl.add('focused'));
  */

  const focusStatus = document.createElement('div');
  focusStatus.setAttribute('id', 'focusStatus');

  if (notEmbedded() && qs`#focusStatus`.empty) {
    qs`body`.first?.appendChild?.(focusStatus);
  }
  qs`window`.first?.addEventListener?.('focus', () =>
    qs`#focusStatus`?.first.classList.add('focused'),
  );

  qs`window`.first?.addEventListener('blur', () =>
    qs`#focusStatus`?.first.classList.remove('focused'),
  );

  notEmbedded() &&
    qs`window:not(:has(> #focusStatus))`.map(({ addEventListener }) => {
      qs`body`.map(({ appendChild }) =>
        appendChild(
          makeElement('div', {
            id: hintId,
            'data-focused': document.hasFocus(),
          }),
        ),
      );
      // qs`body:mutate(> span.childSpan[data-foo=>bar]'Span Text')`}) => appendChild(makeElement('div', { id: hintId })));
      // qs`div:has(img[src^="https://baz."]):mutate(:not(.old).new > img[src^="https://baz.","https://foo."])`

      addEventListener('blur', () =>
        qs`#focusStatus`?.first.classList.remove('focused'),
      );
      addEventListener('focus', () =>
        qs`#focusStatus`?.first.classList.add('focused'),
      );
    });

  return {
    selectors: {
      wrapper: pageFocusHintSelector,
    },
  };
})({ window: unsafeWindow, qs: uqs });

const styleToggleIds = addStyleToggles([
  {
    title: 'page focus hint',
    enabled: true,
    sources: [
      {
        name: 'pagefocus',
        baseName: 'debug',
        path: 'debug/',
      },
    ],
  },
])
  .then(() =>
    Promise.race([timeout({ s: 30 }), readyStateComplete()])
      .catch(() => console.log('timed out waiting for readyStateComplete'))
      .then(({ window, unsafeWindow }) => {
        console.debug('document ready');
      }),
  )
  .catch((e) => console.warn(e));
