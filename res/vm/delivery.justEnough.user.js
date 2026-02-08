// ==UserScript==
// @name        justEnough(Delivery)
// @namespace   mayhem
// @version     1.0.143
// @description Deliver me the content, the whole content, and nothing but the content.
// @downloadURL http://localhost:3333/vm/delivery.justEnough.user.js
// @match       *://i.redd.it/*
// @match       *://preview.redd.it/*
// @match       *://external-preview.redd.it/*
// @match       *://i.imgur.com/*
// @match       *://www.reddit.com/media*
// @run-at      document-start
// @grant       window.close
// @grant       GM_info
// @grant       GM_addStyle
// @grant       GM_addElement
// @grant       GM_registerMenuCommand
// @grant       GM_xmlhttpRequest
// @require     http://localhost:3333/vm/util.user.js
// @cssBaseUrl  http://localhost:3333/vm/
// @cssBaseName delivery.justEnough
// @inject-into auto
// ==/UserScript==

const help = `
 e - image fit: auto(contain) → width → height
 w - cycle through zoom modes: auto(fit) → 1.5× (viewport width/height, based on fit) → 2.0× → 0.5×
 W - toggle hover-zoom
 d - download media   D - download and close tab
 q - close tab
`;

const sequences = {
  fit: ['auto', /*'contain', 'cover',*/ 'fitw', 'fith'],

  placeX: ['before', 'left', 'center', 'right', 'after'],
  placeY: ['above', 'top', 'center', 'bottom', 'below'],
};

const cyclicToggle = (name, states, selector = ':root') => {
  function* repeat(arr) {
    while (true) {
      yield* arr.values();
    }
  }
  const iter = repeat(states);

  let current;

  const update = () => {
    qs`${selector}`.one.setAttribute(`data-${name}`, current);
    qs`${selector}`.one.style.setProperty(`--data-${name}`, current);
  };

  return {
    update,
    next: () => {
      current = iter.next()?.value;
      update();
      return current;
    },
  };
};

/*         ˈ̩̩        above         ˈ̩̩
 *  ╶╶╶╶╶╶╶┌̍̍─︎─────────────────────┐̍̍╴︎╴╴╴╴╴╴
 *         │         top          │
 *         │                      │
 *  before │ left   center  right │ after
 *         │                      │
 *         │        bottom        │
 *  ╶╶╶╶╶╶╶└̩̩─︎─────────────────────┘̩̩╴︎╴╴╴╴╴╴
 *         ˈ̩̩        below         ˈ̩̩
 */

const getFilename = () => {
  const src =
    qs`video`.one?.currentSrc ??
    qs`img`.one?.src ??
    window.location.href.replace(location.search, '');
  return src.split('/').findLast(() => true);
};

/*
 <>
   <label>
     <img src="${url(blob)}">
     <input type="radio" name="preview" value="" id="radio_${name}_${value}"
   </label>
   <label>
     <input type="checkbox" class="hidden" name="selected" value="" id="check_${name}_${value}"
     <span>Select</span>
   </label>
   <a download="${filename}" href="${url(blob)}">Download</a>
 </>
*/
const wrapBlob = () => {
  const idGenerator = rangeIter({ start: 1 });

  return (blob, { id = idGenerator.next(), onload = () => null } = {}) => {
    const url = URL.createObjectURL(blob);

    const radioId = `radio_preview_${id}`;
    const checkId = `check_selected_${id}`;

    const wrapper = GM_addElement('div', {});
    const radiolabel = GM_addElement(wrapper, 'label', {
      for: radioId,
    });
    const img = GM_addElement(radiolabel, 'img', {
      class: 'preview',
    });
    img.addEventListener('load', onload, { once: true });
    img.src = url;
    const radio = GM_addElement(radiolabel, 'input', {
      type: 'radio',
      name: 'preview',
      value: '',
      id: radioId,
    });
    const checklabel = GM_addElement(wrapper, 'label', {
      for: checkId,
    });
    const checkbox = GM_addElement(checklabel, 'input', {
      type: 'checkbox',
      name: 'selected',
      value: '',
      id: checkId,
    });
    const a = GM_addElement(wrapper, 'a', {
      download: getFilename(),
      href: url,
      textContent: 'Download',
    });
  };
};

const overlayText = (
  text,
  image,
  options = {
    font: 'serif',
    fillstyle: '#eeeeee',
    strokestyle: '#000000',
    fitwratio: 0.66,
    fithratio: 0.1,
    strokewidth: 6,
    placeTextX: 'center',
    placeTextY: 'bottom',
    bgcolor: '#00000000',
  },
) => {
  const canvas = GM_addElement('canvas', {
    id: 'scratch',
    class: 'hidden',
    width: image.naturalWidth,
    height: image.naturalHeight,
  });
  // qs`body`.one.appendChild(canvas);

  const fitw = image.naturalWidth * options.fitwratio;
  const fith = image.naturalHeight * options.fithratio;
  const midw = image.naturalWidth * 0.5;

  const findsize = (text, ctx, maxwidth, maxheight, minfontsize = 10) => {
    ctx.save();
    ctx.strokeStyle = options.strokestyle;
    ctx.fillStyle = options.fillstyle;
    ctx.lineWidth = options.strokewidth;

    let bestFit = ctx.font;
    for (
      let f = Math.round(maxheight),
        // widestFitSoFar = 0,
        renderedTextWidth = Number.POSITIVE_INFINITY;
      renderedTextWidth > maxwidth && f > minfontsize;
      f--
    ) {
      bestFit = ctx.font = `${f}px ${options.font}`;
      renderedTextWidth = ctx.measureText(text).width;

      // widestFitSoFar = Math.max(renderedTextWidth, widestFitSoFar);
      // console.log(`sofar: ${widestFitSoFar}`);
    }
    ctx.restore();
    return bestFit;
  };

  const ctx = canvas.getContext('2d');
  ctx.drawImage(image, 0, 0);

  ctx.strokeStyle = options.strokestyle;
  ctx.fillStyle = options.fillstyle;
  ctx.lineWidth = options.strokewidth;
  ctx.textAlign = 'center';
  ctx.font = findsize(text, ctx, fitw, fith, 10);

  ctx.strokeText(text, midw, image.naturalHeight - 50);
  ctx.fillText(text, midw, image.naturalHeight - 50);

  canvas.toBlob(wrapBlob, 'image/png');
};

const videoSelector = `main video, video[src^="https://preview.redd.it"], video[poster^="//i.imgur.com"]`;
const imageSelector = `#main-content img, main img, img[src^="https://i.redd.it"], img[src^="https://preview.redd.it"]`;

/**
 * These CDNs serve different things based on referrer headers, fun.
 */
const getSourceInfo = (
  ({ window, qs }) =>
  (node) => {
    // console.debug(qs`body`.one.innerHTML.trim());

    const isPlainImage =
      qs`body > img:only-child:not(:has(> *))`.all.length > 0;

    let video = qs`${videoSelector}`.one;
    video?.parentElement
      .querySelectorAll('source')
      .forEach((source) => video?.appendChild(source));

    let img = qs`${imageSelector}`.one;

    const sourceInfo = {
      imgsrc: img?.getAttribute?.('src') ?? '',
      link: qs`post-bottom-bar`.one?.getAttribute('permalink') ?? '',
      name: qs`post-bottom-bar`.one?.getAttribute('source-name') ?? '',
      title: qs`post-bottom-bar`.one?.getAttribute('title') ?? '',
    };

    if (isPlainImage) {
      console.debug(`Plain image with src: '${sourceInfo.imgsrc}'`);

      qs`body > img:only-child`.one?.setAttribute(
        'src',
        window.location.toString(),
      );
    } else {
      console.debug(`Embedded image with src: '${sourceInfo.imgsrc}'`);

      const abortRequest = GM_xmlhttpRequest({
        url: sourceInfo.imgsrc,
        method: 'GET',
        // overrideMimeType: '',
        headers: {
          Cookie: '',
          Host: 'i.redd.it',
          // Origin: '',
          Referer: 'https://www.reddit.com/',
          // 'User-Agent': '',

          Accept:
            'image/avif,image/webp,image/png,image/svg+xml,image/*;q=0.8,*/*;q=0.5',
          'Sec-Fetch-Dest': 'image',
          'Sec-Fetch-Mode': 'no-cors',
          'Sec-Fetch-Site': 'cross-site',
        },
        responseType:
          /* 'text' | 'json' | 'blob' | 'arraybuffer' | 'document' */ 'blob',
        // timeout: 20,
        // data: '' /* string | ArrayBuffer | Blob | DataView | FormData | ReadableStream | TypedArray | URLSearchParams */,
        // binary: false /* Send the data string as a blob */,
        context: sourceInfo,
        anonymous: false,

        onabort: (err) /*:void*/ => console.log('onabort', err),
        onerror: (err) /*:void*/ => console.log('onerror', err),
        ontimeout: (err) /*:void*/ => console.log('ontimeout', err),

        onload: ({
          status,
          statusText,
          readyState,
          finalUrl,
          responseHeaders,
          response,
          context: sourceInfo,
        }) /*:void*/ =>
          wrapBlob(response, {
            onload: ({ target }) => {
              console.debug(`load, src: ${target.src}`);
              overlayText(sourceInfo.title, target);
            },
          }),

        onloadstart: () /*:void*/ => console.debug('onloadstart'),
        onloadend: () /*:void*/ => console.debug('onloadend'),
        onprogress: () /*:void*/ => console.debug('onprogress'),
        onreadystatechange: () /*:void*/ => console.debug('onreadystatechange'),

        /* Response: {
        context: any          // the same context object you specified in details
        status: number
        statusText: string
        readyState: number
        finalUrl: string      // the final URL after redirection
        responseHeaders: string
        response: string | Blob | ArrayBuffer | Document | object | null
      // only provided when available:
        responseText: string | undefined
        responseXML: Document | null
        lengthComputable: boolean
        loaded: number
        total: number
    } */
      });

      qs`head > :not(style), body > *`.all.forEach((node) => node.remove());

      // qs`window`.at('class','reset');
      // qs`window:mu(:has(.reset))`
      qs`:root`.one.setAttribute('class', 'reset');

      img?.setAttribute?.('class', 'width fitCover');
      video?.setAttribute?.('class', 'width fitCover');

      img && qs`body`.one.appendChild(img);
      video && qs`body`.one.appendChild(video);
    }
    return {
      sourceInfo,
    };
  }
)({ window: unsafeWindow, qs: uqs });

const deliver = (
  ({ window, qs }) =>
  ({ sourceInfo }) => {
    const config = GM_addElement('div', {
      class: 'config',
    });
    const notify = GM_addElement('div', {
      class: 'notify',
    });

    const info = GM_addElement('div', {
      class: 'info',
      'data-title': sourceInfo.title,
      'data-link': sourceInfo.link,
      'data-name': sourceInfo.name,
    });

    const link = GM_addElement(info, 'a', {
      class: 'link',
      href: sourceInfo.link,
      textContent: `/r/${sourceInfo.name}/…`,
    });

    const title = GM_addElement(info, 'span', {
      class: 'title',
      textContent: sourceInfo.title,
    });

    // const triggerDownload = (src, fileame) => {
    //   notify.innerHTML = 'downloading...';
    //   return fetch(src, {})
    //     .then((res) => res.blob())
    //     .then((blob) => {
    //       notify.innerHTML = 'saving...';
    //       const tempUrl = window.URL.createObjectURL(blob);
    //       // console.log(tempUrl);
    //       const a = document.createElement('a');
    //       a.setAttribute('download', filename);
    //       a.href = tempUrl;
    //       a.click();
    //       window.URL.revokeObjectURL(tempUrl);
    //       notify.innerHTML = 'saved ✔︎';
    //       return 'success';
    //     });
    // };

    const toggles = {
      fit: cyclicToggle('fit', sequences.fit),

      placeTextX: cyclicToggle('placeTextX', sequences.placeX),
      placeTextY: cyclicToggle('placeTextY', sequences.placeY),
    };

    /* Initial state */
    Object.values(toggles).forEach((toggle) => toggle.update());

    const keydownEventHandler = (e) => {
      const {
        pressed: { shift, ctrl, command, option },
        trigger,
      } = buttonsPressed(e);
      console.groupCollapsed(
        `keydown[${trigger}] <shift ${shift ? '✔' : '✘'}, ctrl ${
          ctrl ? '✔' : '✘'
        }, meta ${option ? '✔' : '✘'}>`,
      );
      console.log(
        `trigger: '${trigger}', shift: '${shift}', ctrl: '${ctrl}', meta: '${option}'`,
      );
      console.groupEnd();

      if (trigger === 'e' && !shift && !ctrl && !option && !command) {
        toggles.fit.next();
      }

      if (trigger === 'q' && !shift && !ctrl && !option && !command) {
        window.close();
      }

      if (trigger === 'p' && !shift && !ctrl && !option && !command) {
        overlayText(sourceInfo.title);
      }

      if (trigger === 'g' && !shift && !ctrl && !option && !command) {
        placeTextX.next();
        overlayText(sourceInfo.title);
      }

      if (trigger === 't' && !shift && !ctrl && !option && !command) {
        placeTextY.next();
        overlayText(sourceInfo.title);
      }

      if (trigger === 'd' && !ctrl && !option && !command) {
        qs`label:has(> [name="selected"]:checked) ~ [download]`.forEach((a) => {
          a.click();
          a.classList.add('clicked');
        }).all;

        shift && window.close();
      }
    };
    window.document.addEventListener('keydown', keydownEventHandler);
  }
)({ window: unsafeWindow, qs: uqs });

const styleToggleIds = addStyleToggles([
  {
    title: 'just enough delivery',
    enabled: true,
    sources: [{}],
  },
])
  .then(() =>
    Promise.race([timeout({ s: 30 }), readyStateComplete()])
      .catch(() => console.log('timed out waiting for readyStateComplete'))
      .then(({ window, unsafeWindow }) => {
        console.debug('document ready');

        return Promise.all([
          waitForImagesToAddInfoTo(),
          matchExistsFor(`${imageSelector}, ${videoSelector}`).then((node) => {
            deliver(getSourceInfo(node));
          }),
        ]);
      }),
  )
  .catch((e) => console.warn(e));
