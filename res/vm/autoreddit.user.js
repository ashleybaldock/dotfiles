// ==UserScript==
// @name        AutoReddit
// @namespace   mayhem
// @version     1.0.17
// @author      flowsINtomAyHeM
// @description Make reddit's UI suck less
// @downloadURL http://localhost:3333/vm/autoreddit.user.js
// @match       https://*.reddit.com*
// @match       https://www.reddit.com*
// @grant       GM_info
// @grant       GM_addStyle
// @grant       GM_addElement
// @grant       GM_getValue
// @grant       GM_setValue
// @grant       GM_registerMenuCommand
// @grant       GM_addValueChangeListener
// @grant       GM_registerMenuCommand
// @grant       GM_xmlhttpRequest
// @require     http://localhost:3333/vm/util.user.js
// @cssBaseUrl  http://localhost:3333/vm/
// @cssBaseName reddit
// @run-at      document-start
// ==/UserScript==

/*

 qs('[data-click-id="media"] ul figure img, [data-click-id="media"] video, [data-click-id="media"] img.ImageBox-image')


[...qs`#post-image`][0].src

qs`[slot="post-media-container"]`[0].addEventListener('click', () => window.location = qs`#post-image`[0].src, {capture: true})
 
  */

(() => {
  let {
    alt,
    tagName,
    src,
    baseURI,
    parentNode2: { href } = {},
  } = qs`.ImageBox-image`?.[0] ?? {};
  console.log(alt, tagName, src, baseURI, href);
})();

// GM_registerMenuCommand('Prevent Navigate: On', (e) => {}, { autoClose: false });

const initAutoReddit = ({ document }) => {};

const autoRedditToggleIds = addStyleToggles([
  {
    title: 'reddit content focus',
    enabled: true,
    sources: [
      {
        baseName: 'reddit',
      },
    ],
  },
]).then(() =>
  Promise.race([timeout({ s: 30 }), readyStateComplete()])
    .catch(() => console.debug('timed out waiting for readyStateComplete'))
    .then(({ window, unsafeWindow }) => {
      // console.debug('document ready');

      initAutoReddit(unsafeWindow);
    })
    .catch((e) => console.warn(e)),
);
