// ==UserScript==
// @name        Standalone Images
// @namespace   mayhem
// @version     1.2.250
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

  const breadcrumbs = ({
    to: parent,
    path = document.URL,
    url = new URL(path),
    hideProtocol = url.protocol.match(/https\?/),
  }) => {
    const parts = url.pathname.split(/(\/)/);
    const label = GM_addElement(parent, 'label', {
      class: 'output breadcrumbs fixed',
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

    linkpart(url.host, '/');

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

  const addSelectionHandle = ({
    to,
    select: { top = false, right = false, bottom = false, left = false },
    textContent = '',
    ...attrs
  }) => {
    return GM_addElement(to, 'div', {
      class: `handle${top ? ' top' : ''}${right ? ' right' : ''}${bottom ? ' bottom' : ''}${left ? ' left' : ''}`,
      textContent,
      ...attrs,
    });
  };

  const viewmenu = GM_addElement(document.body, 'menu', {
    class: 'viewmenu toggles',
  });
  const overlaid = GM_addElement(document.body, 'aside', {
    class: 'overlaid',
  });
  const selection = GM_addElement(document.body, 'div', {
    class: 'selection',
  });
  const selectionHandles = ((to) => ({
    top: addSelectionHandle({
      to,
      select: { top: true },
    }),
    topright: addSelectionHandle({
      to,
      select: { top: true, right: true },
    }),
    right: addSelectionHandle({
      to,
      select: { right: true },
    }),
    bottomright: addSelectionHandle({
      to,
      select: { bottom: true, right: true },
    }),
    bottom: addSelectionHandle({
      to,
      select: { bottom: true },
    }),
    bottomleft: addSelectionHandle({
      to,
      select: { bottom: true, left: true },
    }),
    left: addSelectionHandle({
      to,
      select: { left: true },
    }),
    topleft: addSelectionHandle({
      to,
      select: { top: true, left: true },
    }),
  }))(selection);

  const outputs = ((to) => ({
    breadcrumbs: breadcrumbs({ to }),
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
    imdisplaywh: addOutput({ to, class: 'output two imdisplaywh' }),
    imalignedwh: addOutput({ to, class: 'output two imalignedwh' }),
    pixelwh: addOutput({ to, class: 'output two pixelwh' }),
    imtopleft: addOutput({ to, class: 'output two imtopleft' }),
    imbottomright: addOutput({ to, class: 'output two imbottomright' }),
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

  (({ document: { body } }) => {
    const selecting = () => body.dataset.selecting !== undefined;
    const selection = () => body.dataset.selection !== undefined;

    const updateSelection = ({ clientX, clientY }) => {
      body.dataset.selecting !== 'vertical' &&
        body.style.setProperty('--selectXend', clientX);
      body.dataset.selecting !== 'horizontal' &&
        body.style.setProperty('--selectYend', clientY);
    };
    const clearSelection = () => {
      delete body.dataset.selecting;
      delete body.dataset.selection;
      body.style.removeProperty('--selectXstart');
      body.style.removeProperty('--selectYstart');
      body.style.removeProperty('--selectXend');
      body.style.removeProperty('--selectYend');
    };
    const endSelection = (e) => {
      updateSelection(e);
      delete body.dataset.selecting;
      body.removeEventListener('mousemove', mousemove, {});
      body.dataset.selection = '';
    };
    const cancelSelection = () => {
      delete body.dataset.selecting;
      body.removeEventListener('mousemove', mousemove, {});
    };
    const beginSelection = ({ clientX, clientY }) => {
      body.dataset.selecting = '';
      body.style.setProperty('--selectXstart', clientX);
      body.style.setProperty('--selectYstart', clientY);
      body.style.setProperty('--selectXend', clientX);
      body.style.setProperty('--selectYend', clientY);
      body.addEventListener('mousemove', mousemove, {});
    };
    const resumeSelection = ({ target: { classList } }) => {
      const sX = body.style.getPropertyValue('--selectXstart');
      const sY = body.style.getPropertyValue('--selectYstart');
      const eX = body.style.getPropertyValue('--selectXend');
      const eY = body.style.getPropertyValue('--selectYend');

      const [minX, maxX] = sX > eX ? [eX, sX] : [sX, eX];
      const [minY, maxY] = sY > eY ? [eY, sY] : [sY, eY];

      const top = classList.contains('top'),
        right = classList.contains('right'),
        bottom = classList.contains('bottom'),
        left = classList.contains('left');

      if (top) {
        body.style.setProperty('--selectYstart', maxY);
        body.style.setProperty('--selectYend', minY);
        body.dataset.selecting = left || right ? '' : 'vertical';
      }
      if (bottom) {
        body.style.setProperty('--selectYstart', minY);
        body.style.setProperty('--selectYend', maxY);
        body.dataset.selecting = left || right ? '' : 'vertical';
      }
      if (left) {
        body.style.setProperty('--selectXstart', maxX);
        body.style.setProperty('--selectXend', minX);
        body.dataset.selecting = top || bottom ? '' : 'horizontal';
      }
      if (right) {
        body.style.setProperty('--selectXstart', minX);
        body.style.setProperty('--selectXend', maxX);
        body.dataset.selecting = top || bottom ? '' : 'horizontal';
      }

      body.addEventListener('mousemove', mousemove, {});
    };

    const mousemove = (e) => {
      const { pressed } = buttonsPressed(e);
      if (selecting()) {
        if (pressed.left) {
          updateSelection(e);
        } else {
          endSelection(e);
        }
      }
    };

    const mousedown = (e) => {
      const { trigger } = buttonsPressed(e);
      if (trigger.left) {
        e.preventDefault();
        if (e.target.classList.contains('handle')) {
          e.stopPropagation();
          resumeSelection(e);
        } else {
          clearSelection();
          beginSelection(e);
        }
      }
    };
    const mouseup = (e) => {
      const { trigger, pressed } = buttonsPressed(e);
      // console.debug(buttonsPressed(e));
      if (selecting() && (trigger.left || !pressed.left)) {
        // e.stopPropagation();
        e.preventDefault();
        endSelection(e);
      }
    };
    // const click = (e) => {
    //   if (body.dataset.selecting !== undefined) {
    //     e.stopPropagation();
    //     e.preventDefault();
    //     delete body.dataset.selecting;
    //   }
    // };
    const keydown = ({ code }) => {
      if (selecting()) {
        if (code === 'Escape') {
          cancelSelection();
        }
      } else {
        if (selection()) {
          if (code === 'Escape') {
            clearSelection();
          }
        }
      }
    };

    body.addEventListener('mousedown', mousedown, {});
    body.addEventListener('mouseup', mouseup, {});
    // body.addEventListener('click', click, {});
    body.addEventListener('keydown', keydown, {});
  })({ img: qs`img`.one, document });
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
