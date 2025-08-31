// ==UserScript==
// @name        AutoReddit
// @namespace   mayhem
// @version     1.0.37
// @author      flowsINtomAyHeM
// @description Make reddit's UI suck less
// @downloadURL http://localhost:3333/vm/autoreddit.user.js
// @match       https://*.reddit.com/*
// @run-at      document-start
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

const addImageInfo = ({ naturalWidth: natW, naturalHeight: natH, style }) => {
  style?.setProperty('--natW', natW);
  style?.setProperty('--natH', natH);
  style?.setProperty('--natRatio', natW / natH);
  style?.setProperty('--isPortrait', natW < natH);
  style?.setProperty('--isLandscape', natW > natH);
  style?.setProperty('--isSquareish', natW / natH < 1.1 && natW / natH > 0.9);
};

const removeCarousel = (ul) => {
  [...ul.querySelectorAll('li > img')].forEach((img) => {
    if (img.srcset === '' && img.dataset.lazySrcset !== undefined) {
      img.srcset = img.dataset.lazySrcset;
    }
    if (img.src === '' && img.dataset.lazySrc !== undefined) {
      img.src = img.dataset.lazySrc;
    }
  });
  const images = [...ul.querySelectorAll('li > img')].map(
    ({ naturalWidth: natW, naturalHeight: natH }) => ({
      w: natW,
      h: natH,
      ratio: natW / natH,
      portrait: natW < natH,
      landscape: natW > natH,
      squareish: natW / natH < 1.1 && natW / natH > 0.9,
    }),
  );
  const n_squareish = images.filter(({ squareish }) => squareish).length,
    n_portrait = images.filter(({ portrait }) => portrait).length,
    n_landscape = images.filter(({ landscape }) => landscape).length;
  const cols =
    n_squareish >= 1 ? 2 : n_portrait >= 2 ? 3 : n_landscape > 2 ? 2 : 4;
  ul.style.setProperty('--ncols', cols);
  ul.parentNode.closest('[slot="post-media-container"]').appendChild(ul);
};

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

      return Promise.all([
        waitForMatches('img').then((img) => addImageInfo(img)),
        waitForMatches('[bundlename="gallery_carousel"] > * > ul').then((ul) =>
          removeCarousel(ul),
        ),
      ]);
    })
    .catch((e) => console.warn(e)),
);
