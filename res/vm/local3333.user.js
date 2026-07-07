// ==UserScript==
// @name        serve3333
// @namespace   mayhem
// @version     1.0.19
// @author      flowsINtomAyHeM
// @downloadURL http://localhost:3333/vm/local3333.user.js
// @match       *://localhost:3333/*
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
// @cssBaseName local3333
// @inject-into auto
// ==/UserScript==

const isDirectoryListing = (({ qs }) =>
  qs`:has([href="chrome://global/skin/dirListing/dirListing.css"])`.hasSome)(
  unsafeWindow,
);

const styleToggleIds = addStyleToggles([
  {
    title: '[::1]:3333 dirlist reskin',
    enabled: matchExistsFor('title').then((title) =>
      /^Files within /.test(title.textContent),
    ),
    sources: [{}],
  },
])
  .then(() =>
    Promise.race([timeout({ s: 30 }), readyStateComplete()])
      .catch(() => console.log('timed out waiting for readyStateComplete'))
      .then(() => {
        console.debug('document ready');
      }),
  )
  .catch((e) => console.warn(e));
