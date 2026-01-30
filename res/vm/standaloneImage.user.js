// ==UserScript==
// @name        Standalone Images
// @namespace   mayhem
// @version     1.2.306
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
    const parts = url.pathname.split(/(\/)/),
      prefix = `${url.protocol}//`,
      filename = parts.slice(-1)[0],
      extension = filename.split(/\./).slice(-1)[0],
      head = filename.slice(0, filename.length - extension.length);

    const label = GM_addElement(parent, 'label', {
      class: 'output breadcrumbs fixed',
    });
    const ul = GM_addElement(label, 'ul', {});

    const addSep = ({ text = '/', ...attrs } = {}) =>
      GM_addElement(ul, 'li', { class: 'sep', ...attrs, textContent: text });

    const addPart = ({ text = '', link = null, ...attrs } = {}) =>
      ((to) =>
        link
          ? GM_addElement(to, 'a', {
              href: link,
              ...attrs,
              textContent: text,
            })
          : to)(
        GM_addElement(ul, 'li', { ...attrs, textContent: link ? '' : text }),
      );

    hideProtocol ||
      addPart({
        text: prefix,
        class: `proto proto-${url.protocol.replaceAll(':', '')}`,
      });

    addPart({
      text: url.host || url.protocol.match(/https\?/) ? 'localhost' : 'fsroot',
      link: '/',
    });

    parts.slice(1, -1).reduce((acc, cur) => {
      '/' === cur ? addSep() : addPart({ text: cur, link: acc });
      return acc + cur;
    }, prefix);

    addPart({ text: head, class: 'filename', 'data-filename': head });
    addPart({ text: extension, class: `ext-${extension}` });
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
    const input = GM_addElement(label, tag, {
      type,
      ...(checked ? { checked: '' } : {}),
    });
    input.addEventListener('click', stopPropagation);
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

  const selecting = GM_addElement(document.body, 'aside', {
    class: 'selecting',
  });
  const selection = GM_addElement(selecting, 'div', {
    class: 'selection ants',
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

  const overlaid = GM_addElement(document.body, 'aside', {
    class: 'overlaid',
  });

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

  const viewmenu = GM_addElement(document.body, 'menu', {
    class: 'viewmenu toggles',
  });
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

  (({ document: { body }, eventLayer, console: { log, debug } }) => {
    const selecting = () => body.dataset.selecting !== undefined;
    const selection = () => body.dataset.selection !== undefined;
    const vertical = () => body.dataset.selectingVertical !== undefined;
    const horizontal = () => body.dataset.selectingHorizontal !== undefined;
    const begin = (clear) => body.dataset.selectingBegin !== undefined;
    /* Minimum distance mouse needs to move for selection to be considered to have started */
    const beginThreshold = 4;

    const selectionDisplacement = () => {
      const sX = body.style.getPropertyValue('--selectXstart');
      const sY = body.style.getPropertyValue('--selectYstart');
      const eX = body.style.getPropertyValue('--selectXend');
      const eY = body.style.getPropertyValue('--selectYend');
      const dX = Math.max(sX, eX) - Math.min(sX, eX);
      const dY = Math.max(sY, eY) - Math.min(sY, eY);
      return { taxicab: dX + dY, euclidian: Math.sqrt(dX * dX + dY * dY) };
    };

    const updateSelection = ({ clientX, clientY }) => {
      !vertical() && body.style.setProperty('--selectXend', clientX);
      !horizontal() && body.style.setProperty('--selectYend', clientY);
      begin() &&
        selectionDisplacement().taxicab > beginThreshold &&
        clearSelecting('begin');
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
      eventLayer.removeEventListener('mousemove', mousemove, {});
      body.dataset.selection = '';
    };
    const cancelSelection = () => {
      delete body.dataset.selecting;
      eventLayer.removeEventListener('mousemove', mousemove, {});
    };
    const beginSelection = ({ clientX, clientY }) => {
      body.dataset.selecting = 'begin';
      body.style.setProperty('--selectXstart', clientX);
      body.style.setProperty('--selectYstart', clientY);
      body.style.setProperty('--selectXend', clientX);
      body.style.setProperty('--selectYend', clientY);
      eventLayer.addEventListener('mousemove', mousemove, {});
    };
    const selectAll = () => {
      clearSelection();
      body.style.setProperty('--selectXstart', 0);
      body.style.setProperty('--selectYstart', 0);
      body.style.setProperty('--selectXend', naturalWidth);
      body.style.setProperty('--selectYend', naturalHeight);
      body.dataset.selection = '';
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

      eventLayer.addEventListener('mousemove', mousemove, {});
    };

    const mousemove = (e) => {
      const { clientWidth: pageW, clientHeight: pageH } =
        document.documentElement;
      const { pageX, pageY } = e;

      const { width: screenW, height: screenH } = window.screen;
      const { screenX, screenY } = e;

      const { innerWidth: viewportW, innerHeight: viewportH } = window;
      const { clientX: viewportX, clientY: viewportY } = e;

      const { offsetWidth: offsetW, offsetHeight: offsetH } =
        document.documentElement;
      const { offsetX, offsetY } = e;

      const { movementX: deltaX, movementY: deltaY } = e;

      const widest = Math.max(pageW, screenW, viewportW);
      const tallest = Math.max(pageH, screenH, viewportH);
      const padTo = Math.max(widest, tallest).toString().length;

      const pageSame = viewportX === pageX && viewportY === pageY;

      // log(pad([ ['s', 4], ['e', 4], ])`
      log(padAlternateEndStart(4)`
viewport: ${viewportX},${viewportY} (${viewportW}×${viewportH})
  screen: ${screenX},${screenY} (${screenW}×${screenH})
   delta: ${deltaX},${deltaY}
    page: ${pageX},${pageY} (${pageW}×${pageH})
  offset: ${offsetX},${offsetY} (${offsetW}×${offsetH})
  scroll: ${window.scrollX},${window.scrollY}
      `);
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
      if (trigger === 'left') {
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
      // debug(buttonsPressed(e));
      if (selecting() && (trigger === 'left' || !pressed.left)) {
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
    const keydown = (e) => {
      const { trigger, pressed } = buttonsPressed(e);
      if (selecting()) {
        if (trigger === 'Escape') {
          cancelSelection();
        }
      } else {
        if (selection()) {
          if (trigger === 'Escape') {
            clearSelection();
          }
        }
      }
      if (pressed.ctrl && trigger === 'a') {
        selectAll();
      }
    };

    eventLayer.addEventListener('mousedown', mousedown, {});
    eventLayer.addEventListener('mouseup', mouseup, {});
    // eventLayer.addEventListener('click', click, {});
    body.addEventListener('keydown', keydown, {});
  })({ img: qs`img`.one, document, eventLayer: selecting, console });
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
