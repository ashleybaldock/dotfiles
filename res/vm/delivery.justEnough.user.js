// ==UserScript==
// @name        justEnough(Delivery)
// @namespace   mayhem
// @version     1.0.82
// @description Deliver me the content, the whole content, and nothing but the content.
// @downloadURL http://localhost:3333/vm/delivery.justEnough.user.js
// @match       *://i.redd.it/*
// @match       *://preview.redd.it/*
// @match       *://external-preview.redd.it/*
// @match       *://i.imgur.com/*
// @match       *://www.reddit.com/media*
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

const cyclicToggle = (name, states, selector = ':root') => {
  function* repeat(arr) {
    while (true) {
      yield* arr.values();
    }
  }
  const iter = repeat(states);

  let current;
  return {
    update: () => {
      qs`${selector}`.one.setAttribute(`data-${name}`, current);
      qs`${selector}`.one.style.setProperty(`--data-${name}`, current);
    },
    next: () => {
      current = iter.next()?.value;
      update();
      return current;
    },
  };
};

const overlayText = (
  text,
  image,
  options = {
    font: 'serif',
    fillstyle: '#eeeeee',
    strokestyle: '#000000',
    fitratio: 0.66,
    strokewidth: 6,
    alignX: 'center' /* left, right, before, after */,
    alignY: 'bottom' /* center, top, above, below */,
  },
) => {
  const canvas = GM_addElement('canvas', {
    width: image.naturalWidth,
    height: image.naturalHeight,
  });
  // qs`body`.one.appendChild(canvas);

  const fitw = image.naturalWidth * options.fitratio;
  const midw = image.naturalWidth * 0.5;

  const findsize = (text, ctx, maxwidth, minfontsize) => {
    ctx.strokeStyle = options.strokestyle;
    ctx.fillStyle = options.fillstyle;
    ctx.lineWidth = options.strokewidth;

    for (
      let f = Math.round(minfontsize), w = 0, sofar = minfontsize;
      w < maxwidth;
      f++
    ) {
      ctx.font = `${f}px ${options.font}`;
      w = ctx.measureText(text).width;

      sofar = Math.max(w, sofar);
      console.log(`sofar: ${sofar}`);
    }
  };

  const ctx = canvas.getContext('2d');
  ctx.drawImage(image, 0, 0);

  ctx.strokeStyle = options.strokestyle;
  ctx.fillStyle = options.fillstyle;
  ctx.lineWidth = options.strokewidth;
  ctx.textAlign = 'center';
  ctx.font = `${findsize(text, ctx, fitw, 10)}px ${options.font}`;

  ctx.strokeText(text, midw, image.naturalHeight - 50);
  ctx.fillText(text, midw, image.naturalHeight - 50);

  return {
    toImg: () =>
      canvas.toBlob((blob) => {
        // console.log(blob);
        const img = GM_addElement('img', {});
        img.src = URL.createObjectURL(blob);
        return img;
      }, 'image/png'),
    downloadAs: (filename) =>
      GM_addElement('a', {
        download: filename,
        href: canvas.toDataURL('image/png'),
      }).click(),
  };
};

/**
 * These CDNs serve different things based on referrer headers, fun.
 */
const { sourceInfo } = (({
  window: {
    document: { body },
  },
  qs,
}) => {
  // console.debug(qs`body`.one.innerHTML.trim());

  const isPlainImage = qs`body > img:only-child:not(:has(> *))`.all.length > 0;

  let video =
    qs`main video, video[src^="https://preview.redd.it"], video[poster^="//i.imgur.com"]`
      .one;
  video?.parentElement
    .querySelectorAll('source')
    .forEach((source) => video?.appendChild(source));

  let img =
    qs`#main-content img, main img, img[src^="https://i.redd.it"], img[src^="https://preview.redd.it"]`
      .one;

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
      }) /*:void*/ => {
        let src = URL.createObjectURL(response);
        const image = GM_addElement('img', {});
        image.addEventListener(
          'load',
          () => {
            console.debug(`load, src: ${src}`);
            overlayText(sourceInfo.title, image);
          },
          // { once: true },
        );
        image.setAttribute('src', src);
        qs`body`.one.appendChild(image);
      },
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

    qs`head > :not(style), body > *`.all.forEach((node) =>
      node.parentNode.removeChild(node),
    );

    // qs`window`.at('class','reset');
    // qs`window:mu(:has(.reset))`
    qs`:root`.one.setAttribute('class', 'reset');

    img?.setAttribute?.('class', 'width fitCover');
    video?.setAttribute?.('class', 'width fitCover');

    img && body.appendChild(img);
    video && body.appendChild(video);
  }
  return {
    sourceInfo,
  };
})({ window: unsafeWindow, qs: uqs });

const deliver = ({
  window: {
    document: { body },
  },
  qs,
  sourceInfo,
}) => {
  const config = document.createElement('div');
  config.setAttribute('class', 'config');
  body.appendChild(config);

  const notify = document.createElement('div');
  notify.setAttribute('class', 'notify');
  body.appendChild(notify);

  const source = document.createElement('a');
  source.setAttribute('class', 'source');
  source.setAttribute('href', sourceInfo.href);
  source.setAttribute('data-name', sourceInfo.name);
  source.innerText = '';
  body.appendChild(source);

  const title = document.createElement('div');
  title.setAttribute('class', 'title');
  title.setAttribute('data-title', sourceInfo.title);
  source.innerText = sourceInfo.title;
  body.appendChild(notify);

  const triggerDownload = (src, filename) => {
    notify.innerHTML = 'downloading...';
    return fetch(src, {})
      .then((res) => res.blob())
      .then((blob) => {
        notify.innerHTML = 'saving...';
        const tempUrl = window.URL.createObjectURL(blob);
        // console.log(tempUrl);
        const a = document.createElement('a');
        a.setAttribute('download', filename);
        a.href = tempUrl;
        a.click();
        window.URL.revokeObjectURL(tempUrl);
        notify.innerHTML = 'saved ✔︎';
        return 'success';
      });
  };

  const toggles = {
    fit: cyclicToggle('fit', ['auto', 'width', 'height']),

    alignX: cyclicToggle('alignX', [
      'before',
      'left',
      'center',
      'right',
      'after',
    ]),

    alignY: cyclicToggle('alignY', [
      'above',
      'top',
      'center',
      'bottom',
      'below',
    ]),
  };

  /* Initial state */
  toggles.forEach((toggle) => toggle.update());

  // const align = cyclicToggle('align', ['top left', 'top center', 'top right', 'center right', 'bottom right', 'bottom center', 'bottom left', 'center left']);
  // align.update();

  // todo - use vm-shortcut
  const keydownEventHandler = (e) => {
    const { key, code, shiftKey, ctrlKey, metaKey } = e;
    console.groupCollapsed(
      `keydown[${code}] <shift ${shiftKey ? '✔' : '✘'}, ctrl ${
        ctrlKey ? '✔' : '✘'
      }, meta ${metaKey ? '✔' : '✘'}>`,
    );
    console.log(
      `key: '${key}', code: '${code}', shift: '${shiftKey}', ctrl: '${ctrlKey}', meta: '${metaKey}'`,
    );
    console.groupEnd();

    if (code === 'KeyT' && !shiftKey && !metaKey && !ctrlKey) {
      align.next();
    }

    if (code === 'KeyE' && !shiftKey && !metaKey && !ctrlKey) {
      fit.next();
    }

    if (code === 'KeyQ' && !shiftKey && !metaKey && !ctrlKey) {
      window.close();
    }

    if (code === 'KeyP' && !shiftKey && !metaKey && !ctrlKey) {
      overlayText(sourceInfo.title);
    }

    if (code === 'KeyG' && !shiftKey && !metaKey && !ctrlKey) {
      alignX.next();
      overlayText(sourceInfo.title);
    }

    if (code === 'KeyT' && !shiftKey && !metaKey && !ctrlKey) {
      alignY.next();
      overlayText(sourceInfo.title);
    }

    if (code === 'KeyD') {
      if (!metaKey && !ctrlKey) {
        const src =
          qs`video`.one?.currentSrc ??
          qs`img`.one?.src ??
          window.location.href.replace(location.search, '');
        const filename = src.split('/').findLast(() => true);

        const closeAfterDownload = shiftKey;
        triggerDownload(src, filename).then((outcome) => {
          outcome === 'success' && closeAfterDownload && window.close();
        });
      }
    }
  };
  window.document.addEventListener('keydown', keydownEventHandler);
};

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
        // console.debug(qs`body`.one.innerHTML.trim());
        // console.debug(sourceInfo);
        deliver({ window: unsafeWindow, qs: uqs, sourceInfo });
      }),
  )
  .catch((e) => console.warn(e));
