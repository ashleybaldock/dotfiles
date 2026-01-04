// ==UserScript==
// @name        Global Util
// @namespace   mayhem
// @version     1.2.160
// @author      flowsINtomAyHeM
// @downloadURL http://localhost:3333/vm/global.user.js
// @match       *://*/*
// @match       file:///*/*
// @run-at      document-start
// @grant       GM_info
// @grant       GM_addStyle
// @grant       GM_addElement
// @grant       GM_getValue
// @grant       GM_setValue
// @grant       GM_addValueChangeListener
// @grant       GM_registerMenuCommand
// @grant       GM_xmlhttpRequest
// @require     http://localhost:3333/vm/util.user.js
// @cssBaseUrl  http://localhost:3333/vm/
// @cssBaseName global
// @inject-into auto
// ==/UserScript==

// TODO - configure per-site:
//  - list of classes to target
//  - auto-enable
const removeClickJacksToggleId = (() => {
  let hasRun = 0;
  const addEvents = () => {
    document
      .querySelectorAll('div.thumbnail-info-wrapper span.title a')
      .forEach(preventClickInterception);
    hasRun++;
  };
  createMenuToggle({
    title: 'Unjack Clicks',
    get: () => hasRun > 0,
    set: addEvents,
  });
})();

// TODO - make this configurable per-site + path (auto-enable)
const preventNavigateToggleIds = (() => {
  const key = 'preventNavigateDefault';
  const initial = false;
  let preventNavigate = GM_getValue(key, initial);

  window.addEventListener(
    'beforeunload',
    (e) => preventNavigate && e.preventDefault(),
  );

  /* 🗌🞼🞼🟆🟬🧭🚫🔗🌐🪧🪨🪤🫷🚫
   * ↔️ ⏩️🚫❌ 🚷 ❄️ ⛓️ ⭕️  🔴🔵🟢
   * ᚛  ᚜ */

  /*
   * Prevent Navigate: Off
   * Prevent Navigate: On(Auto)
   * Prevent Navigate: On(Temp)
   *
   */
  return [
    createMenuToggle({
      title: `Prevent Navigate by default`,
      get: () => GM_getValue(key, initial),
      set: (newValue) => GM_setValue(key, newValue),
    }),
    createMenuToggle({
      title: `Prevent Navigate`,
      get: () => preventNavigate,
      set: (newValue) => (preventNavigate = newValue),
    }),
  ];
})();

const styleToggleIds = addStyleToggles([
  {
    title: 'global tweaks',
    enabled: true,
    sources: [{}],
  },
  {
    title: 'webpack-overlay',
    enabled: false,
    sources: [
      {
        name: 'webpack-overlay',
        path: 'debug/',
      },
    ],
  },
  {
    title: 'debug:hover',
    enabled: false,
    sources: [
      {
        name: 'hover',
        baseName: 'debug',
        path: 'debug/',
      },
    ],
  },
  {
    title: 'debug:focus',
    enabled: false,
    sources: [
      {
        name: 'hover',
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
