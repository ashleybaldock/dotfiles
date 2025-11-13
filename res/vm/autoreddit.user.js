// ==UserScript==
// @name        AutoReddit
// @namespace   mayhem
// @version     1.0.73
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

/*
 * 
__applyFeedsSimplification: false
__archived: false
__areReportsExpandable: false
__authorId: "t2_14xskqqt6y"
__commentCount: 4
__contentHref: "https://i.redd.it/amnb9mm9r4sf1.jpeg"
__createdTimestamp: "2025-09-29T16:27:21.206000+0000"
__deleted: false
__disabled: false
__displayPostAnalytics: false
__domain: "i.redd.it"
__eligibleCrosspostingSubreddit: undefined
__game: false
__hasMTSEOTranslationInterruption: false
__hidden: false
__hideButtonIcon: false
__hideButtonText: false
__id: "t3_1ntmn3h"
__interactionFromHotkey: false
__isAma: false
__isBanned: false
__isCompactUIExp: false
__isContestMode: false
__isCrosspost: false
__isCrosspostable: true
__isCrosspostingCoachmarkOpen: false
__isDesktopViewport: true
__isEmbed: false
__isEmbeddable: true
__isLinkPost: false
__isLocked: false
__isMTSEOUserPage: false
__isNotBrandSafe: false
__isPdpSeekerM1LO: false
__isPostBodyTranslated: false
__isPostCommentTapExp: true
__isPostLeaveEventsEnabled: false
__isPostTranslated: false
__isPromoteablePost: false
__isReportingEnabled: false
__isSlimCard: false
__isSubscribed: true
__isThumbnailSet: false
__isTranslatable: false
__isTranslationFetched: false
__isTranslationOn: false
__isUpdatingPostBody: false
__isUserLoggedIn: true
__itemState: "UNMODERATED"
__moderationVerdict: ""
__morePostsCursor: undefined
__nsfw: true
__pdpTarget: "_self"
__permalink: "/r/RileyReid/comments/1ntmn3h/good_work_in_the_gym/"
__postLanguage: "en"
__postScore: 539
__postTitle: "good work in the gym"
__postType: "image"
__postVoteType: undefined
__previousActionsFeature: true
__promoted: false
__score: 539
__shareButtonSSR: true
__shareMenuFeatureName: "ShareMenu_tv6gfD"
__shareMenuTemplateId: "share-menu-template"
__shouldAllowPropagation: false
__showExpando: false
__showFullContent: true
__showPostRemovalBanner: true
__showShareMenuProfileCoachmark: false
__source: undefined
__sourceId: ""
__spoiler: false
__subredditId: "t5_2uwys"
__subredditName: "RileyReid"
__subredditPrefixedName: "r/RileyReid"
__translationLanguage: ""
__updateAnimation: undefined
__useShortHiddenPostForm: false
__userId: "t2_a241f9xd"
__viewContext: "CommentsPage"
__viewType: "cardView"
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

const updateImageInfo = ({
  naturalWidth: natW,
  naturalHeight: natH,
  style,
}) => {
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

  const all_landscape = n_squareish === 0 && n_portrait === 0;
  const all_portrait = n_squareish === 0 && n_portrait === 0;

  const cols = all_portrait
    ? Math.min(n_portrait, 3)
    : all_landscape
      ? 1
      : n_squareish >= 1
        ? 2
        : n_portrait >= 2
          ? 3
          : n_landscape > 2
            ? 2
            : 4;

  ul.style.setProperty('--ncols', cols);
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
      // qs`:root > body:has(> .title):has(> .footer)`.mu(
      //   ({ n, has: [title, footer], addEl }) =>
      //     n.append(
      //       addEl({
      //         name: 'div',
      //         data: { title: title.innerText, footer: footer.innerText },

      //       }),
      //     ),
      // );

      return Promise.all([
        waitForMatches('img', {
          callback: (img) => {
            updateImageInfo(img);
            img.addEventListener('load', (e) => updateImageInfo(img));
          },
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
        waitForMatches('[bundlename="gallery_carousel"] > * > ul', {
          callback: (ul) => removeCarousel(ul),
        }),
        waitForMatches('.gifQualityButton', {
          callback: (el) => el.click(),
        }),
      ]);
    })
    .catch((e) => console.warn(e)),
);
