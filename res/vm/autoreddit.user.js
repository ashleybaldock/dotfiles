// ==UserScript==
// @name        AutoReddit
// @namespace   mayhem
// @version     1.0.86
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

  const getGridLayout = (images) => {
    const n_images = images.length;
    const n_squareish = images.filter(({ squareish }) => squareish).length,
      n_portrait = images.filter(({ portrait }) => portrait).length,
      n_landscape = images.filter(({ landscape }) => landscape).length;

    const all_landscape = n_portrait === 0;
    const all_portrait = n_landscape === 0;

    Map([[1, [1,1]], [2, [2,1]], [3, [3,1]], [4, [2,2]], [[5,6], [3,2]],[[7,8,9], [3,3]], [[10,11,12], [4,3]], [[13,14,15,16], [4,4]], [[17,18,19,20], [5,4]], [[21,22,23,24,25], [5,5]], [[26,27,28,29,30], [6,5]], [[31,32,33,34,35,36], [6,6]]].reduce(([acc, cur]) => , [])

    if (all_landscape) {
      return {
        portrait: {
          cols: 1,
          rowsperpage: 9
        },
        landscape: {
          cols: 2,
          rowsperpage: 9
        },
      };
    }
    if (all_portrait) {
      return {
        portrait: {
          cols: 2,
          rowsperpage: 9
        },
        landscape: {
          cols: Math.min(n_images / 3, 3),
          rowsperpage: 9
        },
      };
    }
  const rowsper = all_portrait ? (n_portrait <= 3 ? 1 : 2) : 9;
  const cols = all_portrait
    ? Math.max(2, Math.min(n_portrait, 3))
    : all_landscape
      ? 1
      : n_squareish >= 1
        ? 2
        : n_portrait >= 2
          ? 3
          : n_landscape > 2
            ? 2
            : 4;
  };

  const {portrait, landscape } = getGridLayout(images);

  ul.style.setProperty('--ver-ncols', portrait.cols);
  ul.style.setProperty('--ver-rowsper', portrait.rowsperpage);
  ul.style.setProperty('--hoz-ncols', landscape.cols);
  ul.style.setProperty('--hoz-rowsper', landscape.rowsperpage);
  ul.parentNode.closest('[slot="post-media-container"]').appendChild(ul);
};

const imageSet = (({ document }) => {
  const container = document.createElement('div');
  const imageSet = document.createElement('div');
  imageSet.classList.add('imageSet');
  container.classList.add('container');
  container.append(imageSet);

  return matchExistsFor(':root > body')
    .then((match) => match.prepend(container))
    .then(() =>
      Promise.all([
        waitForMatches(
          'shreddit-post shreddit-media-lightbox-listener #post-image',
          {
            callback: (img) => {
              img.classList = ['img-preview'];
              imageSet.append(img);
            },
          },
        ),
        waitForMatches(
          'shreddit-post shreddit-media-lightbox-listener zoomable-img img',
          {
            callback: (img) => {
              img.classList = ['img-fullsize'];
              img.complete
                ? img.classList.add('loaded')
                : img.addEventListener('load', (e) =>
                    img.classList.add('loaded'),
                  );
              imageSet.append(img);
            },
          },
        ),
      ]),
    )
    .catch((e) => console.warn(e));
})(unsafeWindow);

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
      console.debug('document ready');

      initAutoReddit(unsafeWindow);

      return Promise.all([
          waitForImagesToAddInfoTo()
        ,
        waitForMatches('[bundlename="gallery_carousel"] > * > ul', {
          callback: (ul) => removeCarousel(ul),
        }),
        waitForMatches('.gifQualityButton', {
          callback: (el) => el.click(),
        }),

        // waitForMatches(
        //   'shreddit-post shreddit-media-lightbox-listener #post-image',
        //   {
        //     callback: (img) => {
        //       img.classList = ['img-preview'];
        //       imageSet.append(img);
        //     },
        //   },
        // ),
        // waitForMatches(
        //   'shreddit-post shreddit-media-lightbox-listener zoomable-img img',
        //   {
        //     callback: (img) => {
        //       img.classList = ['img-fullsize'];
        //       imageSet.append(img);
        //     },
        //   },
        // ),
      ]);
    })
    .catch((e) => console.warn(e)),
);
