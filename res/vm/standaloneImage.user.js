// ==UserScript==
// @name        Standalone Images
// @namespace   mayhem
// @version     1.2.186
// @author      flowsINtomAyHeM
// @downloadURL http://localhost:3333/vm/standaloneImage.user.js
// @match       *://*/*
// @match       file:///*/*
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
// @cssBaseName standaloneImage
// @injectIQB-into auto
// ==/UserScript==

const initStandaloneSvg = ({ document: { documentElement } }) => {};

/**
 * Customisations for viewing standalone images
 */
const initStandaloneImage = ({
  document: {
    documentElement,
    body,
    body: {
      firstChild,
      firstChild: { width, naturalWidth, height, naturalHeight },
    },
  },
}) => {
  documentElement.style.setProperty('--naturalw', naturalWidth);
  documentElement.style.setProperty('--naturalh', naturalHeight);

  const isTiny = naturalWidth + naturalHeight < 200;
  const isTransparent = firstChild?.classList.contains('transparent');

  if (isTiny) {
    firstChild.classList.add('tiny');
    body.classList.add('pixelgrid', 'dims');
  }

  const breadcrumbs = (parent, path = document.URL) => {
    const url = new URL(path);
    const parts = url.pathname.split(/(\/)/);
    const label = GM_addElement(parent, 'label', {
      class: 'output breadcrumbs',
    });
    const ul = GM_addElement(label, 'ul', {});

    const sep = (text = '/', attrs = {}) =>
      GM_addElement(ul, 'li', { class: 'sep', ...attrs, textContent: text });

    const part = (text = '', attrs = {}) =>
      GM_addElement(ul, 'li', { ...attrs, textContent: text });

    const linkpart = (text, partpath, attrs = {}) =>
      GM_addElement(part(), 'a', {
        href: partpath,
        ...attrs,
        textContent: text,
      });

    const prefix = `${url.protocol}//`;

    part(prefix, {
      class: `proto proto-${url.protocol.replaceAll(':', '')}`,
    });

    parts.slice(1, -1).reduce((acc, cur) => {
      cur === '/' ? sep(cur) : linkpart(cur, acc);
      return acc + cur;
    }, prefix);

    const filename = parts.slice(-1)[0];
    part(`${filename}`, {
      class: `filename ext-${filename.split(/\./).slice(-1)}`,
    });
  };

  const addOutput = ({ to, tag = 'output', ...attrs } = {}) => {
    const label = GM_addElement(to, 'label', attrs);
    GM_addElement(label, tag);
    return label;
  };

  const addToggle = ({
    to,
    tag = 'input',
    type = 'checkbox',
    checked = false,
    textContent = '',
    ...attrs
  } = {}) => {
    const li = GM_addElement(to, 'li', {
      class: 'tgl',
      ...attrs,
    });
    const label = GM_addElement(li, 'label', {
      class: '',
      textContent,
    });
    GM_addElement(label, tag, {
      type,
      ...(checked ? { checked: '' } : {}),
    });
    return li;
  };

  const viewmenu = GM_addElement(document.body, 'menu', {
    class: 'viewmenu toggles',
  });
  const overlaid = GM_addElement(document.body, 'aside', {
    class: 'overlaid',
  });

  const outputs = ((to) => ({
    breadcrumbs: breadcrumbs(to),
    width: addOutput({
      to,
      class: 'output one width',
      textContent: '',
    }),
    height: addOutput({
      to,
      class: 'output one height',
    }),
    clientSize: addOutput({
      to,
      class: 'output two client-size',
    }),
    fitW: addOutput({ to, class: 'output fitw' }),
    fitH: addOutput({ to, class: 'output fith' }),
  }))(overlaid);

  const toggles = ((to) => ({
    showImageDims: addToggle({
      to,
      class: 'tgl dim',
      textContent: 'dimensions',
      checked: false,
    }),
    pixelView: addToggle({
      to,
      class: 'tgl pix',
      textContent: 'pixels',
      checked: isTiny,
    }),
    gridOverlay: addToggle({
      to,
      class: 'tgl grd',
      textContent: 'grid',
      checked: isTiny,
    }),
    lightDark: addToggle({
      to,
      class: 'tgl sun',
      textContent: 'light',
      checked: false,
    }),
    hatchbg: addToggle({
      to,
      class: 'tgl tch',
      textContent: 'hatch',
      checked: false,
    }),
    outline: addToggle({
      to,
      class: 'tgl out',
      textContent: 'outline',
      checked: isTransparent,
    }),
    debug: addToggle({
      to,
      class: 'tgl dbg',
      textContent: 'debug',
      checked: false,
    }),
  }))(viewmenu);
};

const isStandaloneImage = (({ document }) => {
  return (
    1 === (document?.body?.childElementCount ?? 0) &&
    0 === (document?.body?.firstChild?.childElementCount ?? 1) &&
    'img' === (document?.body?.firstChild?.nodeName?.toLowerCase() ?? '')
  );
})(unsafeWindow);

const isStandaloneSvg = (({ document }) => {
  return 'svg' === (document?.rootElement?.tagName?.toLowerCase() ?? '');
})(unsafeWindow);

const styleToggleIds = addStyleToggles([
  {
    title: 'better standalone images',
    enabled: isStandaloneImage,
    sources: [
      {
        baseName: 'standaloneImage',
      },
    ],
  },
]).then(() =>
  Promise.race([timeout({ s: 30 }), readyStateComplete()])
    .catch(() => console.log('timed out waiting for readyStateComplete'))
    .then(({ window, unsafeWindow }) => {
      console.debug('document ready');

      if (isStandaloneImage) {
        initStandaloneImage(unsafeWindow);
      } else if (isStandaloneSvg) {
        initStandaloneSvg(unsafeWindow);
      }
    })
    .catch((e) => console.warn(e)),
);
