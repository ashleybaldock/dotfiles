// ==UserScript==
// @name        Utils for Userscripts
// @namespace   mayhem
// @version     1.1.120
// @author      flowsINtomAyHeM
// @downloadURL http://localhost:3333/vm/util.user.js
// @exclude-match *
// @grant       GM_addStyle
// @grant       GM_registerMenuCommand
// @grant       GM_getValue
// @grant       GM_setValue
// @grant       GM_addValueChangeListener
// @description For the avoidance of the perils of copypasta coding.
// ==/UserScript==

/*
 * // @injectIQB-into auto
 *
 */

/*{{{1 Config */

const defaultCssBaseUrl = 'http://localhost:3333/vm/';

/*{{{1 Utility */

/* Get an Over-Qualified CSS name for an element */
const cssOQN = (el) =>
  `${el.tagName.toLowerCase()}${[...new Set(['', el.id])].join('#')}${[
    '',
    ...el.classList,
  ].join('.')}`;

const setRegisteredCSSProp = (
  ({ window }) =>
  ({ on, name: _name, value, syntax }) => {
    const name = /^--/.test(_name) ? _name : `--${_name}`;
    const s_name = `--s-${name.slice(2)}`;

    on.style.setProperty(name, value);
    on.style.setProperty(s_name, `'${value}'`);
  }
)({ window: unsafeWindow });

const addRegisteredCSSProp = (({ window }) => {
  const registeredCSSProps = new Set();
  return ({ name, syntax = '*', inherits = false, initialValue = 'none' }) => {
    if (registeredCSSProps.has(name)) {
      return true;
    }
    try {
      window.CSS.registerProperty({
        name,
        syntax,
        inherits,
        initialValue,
      });
      registeredCSSProps.add(name);
      return true;
    } catch (InvalidModificationError) {
      return false;
    }
  };
})({ window: unsafeWindow });

(({ document: { body } }) => {
  const checkNode = (el) => {
    [...el.children]
      .map((child) => {
        const { width, minWidth, maxWidth } = getComputedStyle(child);
        return `${cssOQN(child)}
    min/width/max: ${minWidth}/${width}/${maxWidth}`;
      })
      .join('\n');
  };
})({ document });

const trackVisibility = (
  ({ window, window: { document }, notify }) =>
  () => {
    const show_visible = () => (document.documentElement.dataset.visible = '');
    const hide_visible = () => delete document.documentElement.dataset.visible;
    const show_hidden = () => (document.documentElement.dataset.hidden = '');
    const hide_hidden = () => delete document.documentElement.dataset.hidden;

    const on_visibilitychange = () => {
      if (document.visibilityState === 'visible') {
        notify.info('page became visible');
        show_visible();
        hide_hidden();
      }
      if (document.visibilityState === 'hidden') {
        notify.info('page became hidden');
        hide_visible();
        show_hidden();
      }
    };

    window.addEventListener('visibilitychange', on_visibilitychange);

    document.visibilityState === 'hidden' ? show_hidden() : hide_hidden();
    document.visibilityState === 'visible' ? show_visible() : hide_visible();

    return () => {
      window.removeEventListener('visibilitychange', on_visibilitychange);
      hide_hidden();
      hide_visible();
    };
  }
)({ window: unsafeWindow, notify: console });

const trackPageFocus = (
  ({ window, window: { document }, notify }) =>
  () => {
    const hide_focused = () => delete document.documentElement.dataset.focused;
    const show_focused = () => (document.documentElement.dataset.focused = '');

    const on_blur = () => {
      notify.info('page lost focus');
      hide_focused();
    };

    const on_focus = () => {
      notify.info('page gained focus');
      show_focused();
    };
    window.addEventListener('blur', on_blur);
    window.addEventListener('focus', on_focus);

    document.hasFocus() ? show_focused() : hide_focused();

    return () => {
      window.removeEventListener('blur', on_blur);
      window.removeEventListener('focus', on_focus);
      hide_focused();
    };
  }
)({ window: unsafeWindow, notify: console });

class DefaultedMap extends Map {
  #defaultValue;
  constructor(defaultValue, entries) {
    super(entries);
    this.#defaultValue = defaultValue;
  }
  get(key) {
    const valueOrUndefined = super.get(key);
    return valueOrUndefined === undefined
      ? this.#defaultValue
      : valueOrUndefined;
  }
}

/*{{{2 Logging */

/** TODO logging filters
 *  - match regex pattern, severity level etc.
 *  - change logging severity, group into hidden streams
 */
const concept = (({ window }) => {
  const _console = window.console;
  const _concept = new Proxy(_console, {
    get: (target, key) => {
      return target[key];
      // return (...args) => _console.log('proxy!', ...args);
    },
  });
  window.console = _concept;
  return {
    deconceptualise: () => (window.console = _console),
    reconceptualise: () => (window.console = _concept),
    get console() {
      return _console;
    },
    get status() {
      return `window.console === _concept: ${window.console === _concept} | window.console === _console: ${window.console === _console}`;
    },
  };
})({ window });

const tee = (({ console }) => {
  const immediate = ['error'];
  const methodsToBind = ['log', 'info', 'warn', 'error', 'debug'];
  const base = /*<T>*/ (
    sideEffect /*: (i: Readonly<T>, ...args: unknown[]) => void*/ = console.log,
    x /*: T*/,
    ...args /*: unknown[]*/
  ) => {
    sideEffect(x, ...args);
    return x;
  };
  const deferLogMessage = (method, ...x) => method('defer', ...x);
  const flush = () => {};
  const bound = Object.fromEntries(
    methodsToBind.map((methodName) => [
      methodName,
      Function.prototype.call.bind(base, base, console[methodName]),
    ]),
  );

  /* https://codepen.io/shshaw/pen/XbxvNj
   * - TODO qs`.output > a`.m(e => e.click()).all */
  methodsToBind.forEach((methodName) =>
    Object.defineProperty(base, methodName, {
      value: immediate.includes(methodName)
        ? bound[methodName]
        : Function.prototype.call.bind(
            deferLogMessage,
            deferLogMessage,
            bound[methodName],
          ),
      enumerable: false,
      configurable: false,
    }),
  );
  return base;
})(window);

/*{{{2 Events */
/**
 * Represents button states for MouseEvents
 *
 * trigger: button or key that caused the event
 * pressed: buttons and/or modifier keys when the event happened
 *
 * e.g. const { pressed, trigger } = buttonsPressed(e);
 */
const buttonsPressed = ({
  /* MouseEvent */
  button = -1,
  buttons = 0,
  /* KeyboardEvent */
  key = null,
  /* Both */
  shiftKey,
  ctrlKey,
  metaKey,
  altKey,
}) => ({
  pressed: Object.fromEntries(
    ['left', 'right', 'wheel', 'back', 'forward'].reduce(
      (acc, cur, i) => [...acc, [cur, Boolean(buttons & (1 << i))]],
      [
        ['shift', shiftKey] /* ⇧️  */,
        ['ctrl', ctrlKey] /* ^️ */,
        ['meta', metaKey],
        ['command', metaKey] /* ⌘️  */,
        ['windows', metaKey] /* ⊞️ */,
        ['alt', altKey],
        ['option', altKey] /* ⌥️  */,
      ],
    ),
  ),
  // bind: (keycombos,callback,options) => {
  //   const { pd, sip } = options;
  // },
  trigger:
    button >= 0
      ? ['left', 'wheel', 'right', 'back', 'forward'][button]
      : (key ?? 'unknown'),
  wasTrigger: new Proxy(
    Object.fromEntries(
      ['left', 'wheel', 'right', 'back', 'forward'].reduce(
        (acc, cur, i) => [...acc, [cur, i === button]],
        [],
      ),
    ),
    {
      get: (target, propName) => {
        if ('symbol' === typeof propName || Object.hasOwn(target, propName)) {
          return target[propName];
        }
        return propName === key;
      },
    },
  ),
});

/*}}}1*/
/**
 * Returns a hash code from a string
 * @param  {String} str The string to hash.
 * @return {Number}    A 32bit integer
 * @see http://werxltd.com/wp/2010/05/13/javascript-implementation-of-javas-string-hashcode-method/
 */
function hashCode(str) {
  let hash = 0;
  for (let i = 0, len = str.length; i < len; i++) {
    let chr = str.charCodeAt(i);
    hash = (hash << 5) - hash + chr;
    hash |= 0; // Convert to 32bit integer
  }
  return hash;
}

/* Fisher–Yates shuffle */
function shuffle(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
}

const uniqueValues = (v, i, a) => a.indexOf(v) === i;
const uniqueArrays = (av, ai, a) =>
  a.findIndex(
    (n) => av.length === n.length && av.every((avv, avi) => avv === n[avi]),
  ) === ai;

/*{{{2 Predicates */
const isPromise = /*<T>*/ (x /*: unknown*/) /*: x is Promise<T>*/ =>
  x !== null &&
  x !== undefined &&
  typeof x === 'object' &&
  'then' in x /*!*/ &&
  typeof x.then === 'function';
/* type StyleSource = Promise<string> | string | (() => string); */

/*{{{2 Parser Tags */
/**
 * Does what untagged template strings do by default
 */
const parseTag = (raw, ...substitutions) =>
  String.raw({ raw }, ...substitutions) ?? '';

/**
 * Return a parser function that maps all arguments
 * through the provided function
 */
const parseMap =
  (mapperFn) =>
  (raw, ...substitutions) =>
    String.raw({ raw }, ...substitutions.map(mapperFn));

/**
 * for places you can't throw, yeet
 * let foo = a?.b ?? yeet`error! ${}`
 */
const yeet = (...args) => {
  throw parseTag(...args);
};

/**
 * Tag as CSS for highlighting
 * e.g. css`color: red; padding: ${pad}px`
 */
const css = (...args) => parseTag(...args);

/**
 * Tag as HTML for highlighting
 * e.g. html`<div><span class="${foo}">hello</span></div>`
 */
const html = (...args) => parseTag(...args);

/**
 * Pad start of all substituted variables so they are same width
 */
const padAllStart = (padTo) =>
  parseMap((sub) => sub?.toString?.().padStart(padTo));

const padAlternateEndStart =
  (padTo) =>
  (raw, ...substitutions) =>
    String.raw(
      { raw },
      ...substitutions.map((sub, i) =>
        i % 2
          ? sub?.toString?.().padEnd(padTo)
          : sub?.toString?.().padStart(padTo),
      ),
    );

const pad =
  (padPattern) =>
  (raw, ...substitutions) =>
    String.raw(
      { raw },
      ...substitutions.map((sub) => sub?.toString?.().padStart(padTo)),
    );

/*{{{2 Time */
const timeInMs = ({ m = 0, s = 0, ms = 0 } = {}) => m * 60000 + s * 1000 + ms;
const timeInWords = (time) => {
  const ms = timeInMs(time);
  return ms > 120000
    ? `${ms / 60000} minutes`
    : ms > 60000
      ? `1 minute ${(ms - 60000) / 1000}s`
      : ms > 1000
        ? `${ms / 1000}s`
        : `${ms}ms`;
};

/*{{{2 Set Operations */
const intersectSets = (set1, set2) => {
  const [larger, smaller] = set1.size > set2.size ? [set1, set2] : [set2, set1];

  return [...smaller.keys()].reduce(
    (resultSet, key) => (larger.has(key) ? resultSet.add(key) : resultSet),
    new Set(),
  );
};

/*{{{2 Media Players */
/* Retrieve all range stats at once */
const getMediaRanges = (el) =>
  Object.fromEntries(
    ['played', 'seekable', 'buffered'].map((range) => [
      range,
      Array(el[range].length)
        .keys()
        .map((i) => [el[range].start(i), el[range].end(i)]),
    ]),
  );

const videoIsPlaying = (video) =>
  !video.paused && video.readyState >= HTMLMediaElement.HAVE_CURRENT_DATA;

const overrideVideoClickEvents = (video) => {
  video.addEventListener(
    'click',
    (e) => {
      const { target } = e;
      const { trigger } = buttonsPressed(e);
      if (target === video && trigger === 'left') {
        if (videoIsPlaying(target)) {
          target.pause();
          e.stopImmediatePropagation();
          e.preventDefault();
        } else if (target.src !== '') {
          target.play();
          e.stopImmediatePropagation();
          e.preventDefault();
        }
      }
    },
    { capture: true },
  );
};

/*{{{2 Iterators/Generators */
function* dropIter(source, n) {
  for (
    let done = false, i = 0;
    !done && i < n;
    { done } = source.next(), i++
  ) {}
  yield* source();
}

const isIterable = (x) =>
  'object' === typeof x &&
  Symbol.iterator in x &&
  typeof x[Symbol.iterator] === 'function';

const isIterator = (x) =>
  'object' === typeof x && 'next' in x && typeof x['next'] === 'function';

const toIterator = (iterish) => {
  if (isIterable(iterish)) {
    return iterish[Symbol.iterator]();
  } else if (isIterator(iterish)) {
    return iterish;
  }
  throw new Error('Not iterish');
};

function* takeIter(source, n) {
  source = toIterator(source);
  for (
    let { value, done } = source.next(), i = 0;
    !done && i < n;
    { value, done } = source.next(), i++
  ) {
    yield value;
  }
}

function exhaustIter(source) {
  for (let { done } = source.next(); !done; { done } = source.next()) {}
}

function* filterIter(source, predicate) {
  for (const s of source) {
    if (predicate(s)) {
      yield s;
    }
  }
}
function* mapIter(source, mapper) {
  for (const s of source) {
    yield mapper(s);
  }
}
function* flatMapIter /*<T, Tout>*/(
  source /*: IterableIterator<T>*/,
  mapperFn /*: Mapper<T, Iterable<Tout>>*/,
) /*: IterableIterator<Tout>*/ {
  for (const s of source) {
    for (const i of mapperFn(s)) {
      yield i;
    }
  }
}

function* iterPairs(source) {
  source = toIterator(source);
  for (
    let { value: value1 } = source.next(), { value, done } = source.next();
    !done;
    value1 = value, { value, done } = source.next()
  ) {
    yield [value1, value];
  }
}

function* forEachSideEffect /*<T>*/(
  source /*: IterableIterator<T>*/,
  callback /*: Callback<T>*/,
) /*: IterableIterator<T>*/ {
  for (const [i, s] of mapIter(source, (s, i) => [i, s])) {
    callback(s, i);
    yield s;
  }
}

function* rangeIter({
  start,
  step = 1,
  count = Number.POSITIVE_INFINITY,
  end = start + step * count,
}) {
  for (
    let next = start, i = 0;
    i < count && step > 0 ? next < end : step < 0 ? next > end : true;
    i++, next += step
  ) {
    yield next;
  }
}

/**
 * Simple generator that returns output of a function
 */
function* repeatcall(cb) {
  while (true) {
    yield cb();
  }
}
/**
 * For a given iterable of functions, call each in sequence with
 *   args: the result of the previous chained function
 */
const chain = (...args) => args.flat().reduce((r, f) => f(r), undefined);

/*{{{1 Links, Tabs etc. */
const stopPropagation = (e) => {
  e.stopImmediatePropagation();
  e.stopPropagation();
};

/*{{{1 Events */

const readyStateComplete = () => {
  const promise = new Promise((resolve, reject) => {
    const waitForComplete = () =>
      document.readyState === 'complete'
        ? resolve({ window, unsafeWindow })
        : document.addEventListener('readystatechange', waitForComplete);
    waitForComplete();
  });
  return promise;
};

// const documentIsVisible = (({ document, once = true }) => {
const documentIsVisible = () => {
  const promise = new Promise((resolve, reject) => {
    const waitForVisible = () =>
      document.visibilityState === 'visible'
        ? resolve({ window, unsafeWindow })
        : document.addEventListener('', waitForVisible, { once });
  });
  return promise;
};

const delay = ({ m = 0, s = 1, ms = 0 } = {}) =>
  new Promise((resolve) => window.setTimeout(resolve, timeInMs({ m, s, ms })));

const timeout = ({ m = 0, s = 1, ms = 0 } = {}) =>
  new Promise((_, reject) => window.setTimeout(reject, timeInMs({ m, s, ms })));

// mutations.forEach(
//   ({ type, addedNodes }) =>
//     type === 'childList' &&
//     addedNodes.forEach((node) => {
//       if (node?.matches?.(selector)) {
//         console.debug(
//           `node matching selector '${selector}' added, firing callback`,
//           node,
//         );
//         resolve(node);
//       }
//     }),
// ),
// return new Promise((resolve) => {}).finally(() => observer.disconnect());
/**
 * Returns a promise which resolves to a node matching the
 * given selector, waiting for it to exist if needed
 */
const matchExistsFor = (selector, { root = ':root' } = {}) => {
  let { promise, resolve /*, reject */ } = Promise.withResolvers();
  const lookForMatch = (observer) => {
    const node = document.querySelector(selector);
    if (node) {
      resolve(node);
      observer.disconnect();
      return;
    }
  };
  const observer = new MutationObserver((/*mutations*/ _, observer) =>
    lookForMatch(observer),
  );
  observer.observe(document.querySelector(root), {
    subtree: true,
    childList: true,
    attributes: false,
    characterData: false,
  });
  lookForMatch(observer);
  promise.finally(() => observer.disconnect());
  return promise;
};

/* Events - Async */

/**
 * Returns an async iterator that yields all matches for the given selector (current and future)
 * Options:
 *   signal - AbortSignal used to cancel observation
 *   root - Defaults to 'body', root node for querySelectorAll
 * based on https://github.com/sindresorhus/dom-mutations/blob/main/index.js
 */
const waitForMatches = async (
  selector,
  { callback, signal, root = ':root' } = {},
) => {
  async function* matchGenerator() {
    signal?.throwIfAborted();

    let { promise, resolve, reject } = Promise.withResolvers();
    const seenBefore = new WeakSet();

    const lookForNewMatches = (/* mutations, observer */) =>
      resolve(
        [...document.querySelectorAll(selector)]
          .filter((node) =>
            seenBefore.has(node) ? false : seenBefore.add(node) && true,
          )
          .values(),
      );

    const observer = new MutationObserver(lookForNewMatches);

    signal?.addEventListener(
      'abort',
      () => {
        reject?.(signal.reason);
        observer.disconnect();
      },
      { once: true },
    );

    observer.observe(document.querySelector(root), {
      subtree: true,
      childList: true,
      attributes: false,
      characterData: false,
    });

    try {
      while (true) {
        signal?.throwIfAborted();
        for (const match of await promise) {
          yield Promise.resolve(match);
        }
        ({ promise, resolve, reject } = Promise.withResolvers());
      }
    } finally {
      observer.disconnect();
    }
  }

  if (callback !== undefined) {
    for await (match of matchGenerator()) {
      callback(match);
    }
    return Promise.reject('Aborted');
  } else {
    return {
      async *[Symbol.asyncIterator]() {
        return matchGenerator();
      },
    };
  }
};

/*{{{1 Actions */
/*{{{2 Async */

const triggerDownload = (
  ({
    window: { console },
    notify = Function.prototype.call.bind(window, window, console.log),
  }) =>
  ({ src, filename }) => {
    // notify.innerHTML = 'Downloading...';
    notify`Downloading...`;
    return fetch(src, {})
      .then((res) => res.blob())
      .then((blob) => {
        notify`Saving...`;
        const tempUrl = window.URL.createObjectURL(blob);
        // notify`tempUrl: ${tempUrl}`;
        const a = document.createElement('a');
        a.setAttribute('download', filename);
        a.href = tempUrl;
        a.click();
        window.URL.revokeObjectURL(tempUrl);
        notify`Saved`;
        return 'success';
      });
  }
)(window);

/*{{{2 Sync */
const preventClickInterception = (clickable) =>
  clickable.addEventListener('click', stopPropagation, {
    passive: true,
  });

const forceOpenInNewWindow = (clickable) =>
  clickable.setAttribute('target', '_blank');

const forceEnableContextMenu = (clickable) => {
  clickable.addEventListener('contextmenu', stopPropagation, {
    capture: false,
  });
  clickable.addEventListener('contextmenu', stopPropagation, {
    capture: true,
  });
  clickable.addEventListener('contextmenu', stopPropagation, false);
};
/* Temporary hack to have syntax highlighting */
const GM_addStyle = (x) => x;

/*{{{1 Menu */

/**
 * Add a toggle to the menu
 *
 * get: () => boolean|number   Function returning the current state
 *                             false/0, true/1
 *                             2 means partially true, or not entirely false
 * set: (boolean) => void  Function to call to change the state
 *
 * enabledIcon:
 *
 * toggleText:  string          Used for the menu text
 * disabledMsg: string
 */
const createMenuToggle = ({
  get,
  set,
  title,
  on = '✅ ',
  off = '❌',
  ish = '⁉️ ' /* Partially on */,
  persist = false,
}) => {
  let menuId;
  const states = [off, on, ish];
  const update = (id) => {
    menuId = GM_registerMenuCommand(
      `${states[0 + get()]} -- ${title}`,
      (_) => {
        set(!get());
        update(menuId);
      },
      { autoClose: false, id },
    );
  };
  update();
  return {
    update,
    remove: () => GM_unregisterMenuCommand(menuId),
    replace: () => GM_unregisterMenuCommand(menuId),
  };
};

/**
 * Add a menu item that triggers an async action
 *
/* title:  string         Name of the menu item,
 *                       (used to generate default menu messages)
 *
/* action: () => Promise  Function to execute upon clicking the menu item
 *                        Should return a promise, which will be awaited
 *
/* auto:   boolean        Set to true to attempt to perform the action
 *                        once automatically
/*
 * once:   boolean        Set to true if this action should only be
 *                        performed (successfully) once.
/*
 * oneTry: boolean        Set to true if action should only be attempted once
 *
/*  Automatic messages can be overriden:
 *
 *  Messages displayed...
/*   ready: string    ...before action has run for the first time
 * pending: string    ...while action executes
 * success: string    ...if most recent run of action succeded
/* failure: string    ...if most recent run of action failed
 *
 * Run 'Get materials JSON' for the first time
/* Try 'Get materials JSON' for the first and only time
 * Run 'Get materials JSON' again (last: success)
 * Try 'Get materials JSON' again (last: failure)
/* 'Get materials JSON' was run successfully.
 * 'Get materials JSON' was run, but failed..
 */
// const createMenuAction = ({ action, title, auto = false, once = false, oneTry = false, pending, success, failure }) => {
// TODO
// };

/*{{{1 Stylesheets */

/**{{{1
 * Fetch a stylesheet from a URL
 */
const getStylesheet = ({ url }) =>
  new Promise((resolve, reject) =>
    GM_xmlhttpRequest({
      method: 'GET',
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      onload: ({ status, statusText, response, finalUrl }) =>
        status >= 200 && status <= 400
          ? chain(
              () => console.debug(`GET:${status}(${statusText}):${finalUrl}`),
              () => resolve(response),
            )
          : reject(tee.error(`GET:${status}(${statusText}):${finalUrl}`)),
      onerror: ({ status, statusText, finalUrl }) =>
        reject(tee.error(`GET:${status}(${statusText}):${finalUrl}`)),
    }),
  );

const injectStylesheet = ({ title, name, css, enabled = false }) => {
  const styleElement = document.createElement('style');
  styleElement.textContent = `/* ${name} */\n/* ${Date()} */\n\n${css}`;
  styleElement.title = `${title}:${name}`;
  (document.head || document.documentElement).appendChild(styleElement);
  if (styleElement.sheet) {
    styleElement.sheet.disabled = !enabled;
  }
  return styleElement;
};

/**
 * Add a toggle-able group of CSS rules
 *
 * @param StyleToggleDefinition {
 *   title:   string  Name of the stylesheet (Used for the toggle text in the menu)
 *   enabled: boolean Should toggle begin on or off
 *   sources: StyleSource[]
 *
 */
const addStylesWithToggle = ({ title, sources, enabled = true }) => {
  const rejected = sources.filter((source) => source.status === 'rejected');
  const resolved = sources.filter((source) => source.status === 'resolved');
  const styleElements = resolved.map(({ name, css }) =>
    injectStylesheet({ name, css, title, enabled }),
  );

  return rejected.length === 0
    ? createMenuToggle({
        title: `CSS: ${title}`,
        get: () =>
          styleElements.every((styleElement) => !styleElement.sheet.disabled),
        set: (newValue) =>
          styleElements.forEach(
            (styleSheet) => (styleSheet.sheet.disabled = !newValue),
          ),
        on: '✅',
        off: '❌',
      })
    : createMenuToggle({
        title: `CSS: ${title} Err: ${
          rejected.length === sources.length
            ? rejected.length === 1
              ? `file`
              : `all`
            : `${rejected.length} of ${sources.length} file${
                rejected.length > 1 ? 's' : ''
              }`
        } for ${title} failed to load`,
        on: '⚠️ ✅',
        off: '⚠️ ❌',
        get: () =>
          styleElements.every((styleElement) => !styleElement.sheet.disabled),
        set: (newValue) =>
          styleElements.forEach(
            (styleSheet) => (styleSheet.sheet.disabled = !newValue),
          ),
      });
};

/*
 * StyleToggleDefinition: {
 *   title,    Display value for the toggle
/*   enabled,  Load automatically (true,default), or on-demand (false)
 *   sources,  StyleSourceDefinition[]
 * }
/* StyleSourceDefinition: {
 *   name:      string;
 * } & {
/*   baseName:  string;  ⎫ If not specified, use values   Formatted as:
 *   baseUrl:   string;  ⎭  set in userscript config      ${baseUrl}/[${name}.]${baseName}.user.css
 * } | {
/*   url:       string;  Full URL of a stylesheet (baseUrl & baseName fields ignored if set)
 * } | {
 *   css:       string;  Stylesheet contents as a string (url, baseUrl & baseName fields ignored if this is non-empty)
/* }
 *
 * const styleSourceStates = ['pending','rejected','resolved'] as const;
/* type StyleSourceState = (typeof styleSourceStates)[number];
 *
 * StyleSource: StyleSourceDefinition & {
/*   css?:     string;          content of CSS file
 *   status:   StyleSourceState
 *   load:     () => Promise    Resolves/rejects with updated StyleSource
/*                              If created with 'css' field non-empty, load() does nothing
 *   finalUrl?: string;    Actual URL css was loaded from
 * }
/*
 * Style
 */
const getStyleSourceFromDefinition = (
  {
    name = '',
    baseName = GM_info.script?.cssBaseName ?? '',
    baseUrl = GM_info.script?.cssBaseUrl ?? defaultCssBaseUrl,
    path = GM_info.script?.cssPath ?? '',
    url = `${baseUrl}${baseUrl.slice(-1) === '/' ? '' : '/'}${path}${
      path.length === 0 || path.slice(-1) === '/' ? '' : '/'
    }${name.length > 0 ? `${name}.` : ''}${
      baseName.length > 0 ? `${baseName}.` : ''
    }user.css`,
    css: cssInitial,
  } /*: StyleSourceDefinition */,
) /*: StyleSource*/ => {
  let _css = cssInitial,
    _status = 'pending',
    _local = 'string' === typeof cssInitial && cssInitial.length > 0,
    _reason;
  const source = {
    name,
    url,
    get css() {
      return _css;
    },
    get status() {
      return _status;
    },
    get reason() {
      return _reason;
    },
  };
  return _local
    ? new Promise((resolve) => resolve(source))
    : getStylesheet(source)
        .then((response) => {
          _css = response;
          _status = 'resolved';
          return source;
        })
        .catch((err) => {
          _status = 'rejected';
          _reason = err;
          return source;
        });
};
/**
 * Add toggles for groups of stylesheets
 *
 * @params StyleToggleDefinition[]
 */
const addStyleToggles = (...definitions) =>
  Promise.allSettled(
    definitions.flat().map(({ title, enabled, sources: sourceDefinitions }) =>
      Promise.allSettled(
        sourceDefinitions.map((sourceDefinition) =>
          getStyleSourceFromDefinition(sourceDefinition),
        ),
      )
        .then((sources) =>
          addStylesWithToggle({
            title,
            enabled,
            sources: sources.map(({ value }) => value),
          }),
        )
        .catch((err) => {
          console.error(`promise rejection fetching CSS: ${err}`);
        }),
    ),
  ).catch((err) => {
    console.error(`promise rejection during CSS toggle creation: ${err}`);
  });

/*{{{1 Create Elements */

() => {
  qs`td:has(>a.file)`.map((n) => {
    const img = document.createElement('img');
    img.setAttribute('src', n.querySelector('a').getAttribute('href'));
    img.style.setProperty('width', '4em');
    n.prepend(img);
  });
  qs`td:has(>a.file)`.all.forEach((n) => {
    const img = document.createElement('img');
    img.setAttribute('src', n.querySelector('a').getAttribute('href'));
    img.style.setProperty('width', '4em');
    n.prepend(img);
  });
};

/**
 * Chainable Element creation
 *
 * - Automatically add HTML/SVG element depending on context
 *
 * parent <> div
 * parent <+ div
 *
 * makeElement('.someParent:add(> div#myId.class1[href="example.com"]'))
 * qs`.someParent`.all.makeElement(`div#myId.class1[href="example.com"]`)
 */
/*
 * TODO - Attributes
 * TODO - Integrate with IQB
 */
const mu = (({ document, console }) => {
  // prettier-ignore
  const svgTags = new Set([ 'a', 'altGlyph', 'altGlyphDef', 'altGlyphItem',
    'animate', 'animateColor', 'animateMotion', 'animateTransform', 'animation',
    'audio', 'canvas', 'circle', 'clipPath', 'color-profile', 'cursor', 'defs',
    'desc', 'discard', 'ellipse', 'feBlend', 'feColorMatrix',
    'feComponentTransfer', 'feComposite', 'feConvolveMatrix',
    'feDiffuseLighting', 'feDisplacementMap', 'feDistantLight', 'feDropShadow',
    'feFlood', 'feFuncA', 'feFuncB', 'feFuncG', 'feFuncR', 'feGaussianBlur',
    'feImage', 'feMerge', 'feMergeNode', 'feMorphology', 'feOffset',
    'fePointLight', 'feSpecularLighting', 'feSpotLight', 'feTile',
    'feTurbulence', 'filter', 'font', 'font-face', 'font-face-format',
    'font-face-name', 'font-face-src', 'font-face-uri', 'foreignObject', 'g',
    'glyph', 'glyphRef', 'handler', 'hkern', 'iframe', 'image', 'line',
    'linearGradient', 'listener', 'marker', 'mask', 'metadata', 'missing-glyph',
    'mpath', 'path', 'pattern', 'polygon', 'polyline', 'prefetch',
    'radialGradient', 'rect', 'script', 'set', 'solidColor', 'stop', 'style',
    'svg', 'switch', 'symbol', 'tbreak', 'text', 'textArea', 'textPath',
    'title', 'tref', 'tspan', 'unknown', 'use', 'video', 'view', 'vkern' ]);
  // prettier-ignore
  const htmlTags = new Set([ 'a', 'abbr', 'acronym', 'address', 'applet',
    'area', 'article', 'aside', 'audio', 'b', 'base', 'basefont', 'bdi', 'bdo',
    'bgsound', 'big', 'blink', 'blockquote', 'body', 'br', 'button', 'canvas',
    'caption', 'center', 'cite', 'code', 'col', 'colgroup', 'command',
    'content', 'data', 'datalist', 'dd', 'del', 'details', 'dfn', 'dialog',
    'dir', 'div', 'dl', 'dt', 'element', 'em', 'embed', 'fieldset',
    'figcaption', 'figure', 'font', 'footer', 'form', 'frame', 'frameset', 'h1',
    'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'header', 'hgroup', 'hr', 'html', 'i',
    'iframe', 'image', 'img', 'input', 'ins', 'isindex', 'kbd', 'keygen',
    'label', 'legend', 'li', 'link', 'listing', 'main', 'map', 'mark',
    'marquee', 'math', 'menu', 'menuitem', 'meta', 'meter', 'multicol', 'nav',
    'nextid', 'nobr', 'noembed', 'noframes', 'noscript', 'object', 'ol',
    'optgroup', 'option', 'output', 'p', 'param', 'picture', 'plaintext', 'pre',
    'progress', 'q', 'rb', 'rbc', 'rp', 'rt', 'rtc', 'ruby', 's', 'samp',
    'script', 'search', 'section', 'select', 'shadow', 'slot', 'small',
    'source', 'spacer', 'span', 'strike', 'strong', 'style', 'sub', 'summary',
    'sup', 'svg', 'table', 'tbody', 'td', 'template', 'textarea', 'tfoot', 'th',
    'thead', 'time', 'title', 'tr', 'track', 'tt', 'u', 'ul', 'var', 'video',
    'wbr', 'xmp' ]);

  const ambiguousTags = intersectSets(svgTags, htmlTags);

  const addAttributesTo = (el, attributes = {}) => {
    for (const [name, value] of Object.entries(attributes)) {
      if (undefined === value || null === value || false === value) {
        continue;
      }
      if (true === value) {
        el.setAttribute(name, '');
      }
      el.setAttribute(name, value);
    }
    return el;
  };

  const makeHtmlElement = ({
    name,
    attributes = {},
    data = {},
    style = {},
  } = {}) => addAttributesTo(document.createElement(name), attributes);

  const makeSvgElement = ({ name, attributes = {}, data = {} } = {}) =>
    addAttributesTo(
      document.createElementNS('http://www.w3.org/2000/svg', name),
      attributes,
    );

  // const splitSvgPath = (...pathElements) =>
  //   pathElements.flat().map((path) => {
  //   path.getAttribute('d').split(/(?<=[zZ])\s*(?=[MLHVCSQTA])/).map((zAbsPart) => {
  // const absPosition = zAbsPart.split(/\s*(?=[MLHVCSQTAmlhvcsqta])/)[0];
  // const g = makeSvgElement('g');
  // g.replaceChildren(...(
  // zAbsPart.split(/(?<=[zZ])\s*(?=[mlhvcsqta])/).map((zRelPart) => {
  // const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
  // path.setAttribute('d', `${absPosition}${zRelPart}`);
  // return path;
  // //   zRelPart.split(/\s*(?=[mlhvcsqta])/).map((part) => )
  // })
  // ))
  // return g;
  // })));
  //   path.style.visibility = 'hidden';
  // })
  // })(temp1)

  // qs`td:has(>a[href])`.forEach((n, _i, _a, img = document.createElement('img')) => img.setAttribute('src', n.querySelector('a')?.getAttribute('href')) || n.prepend(img)).all

  const makeElement = ({
    tagName = 'div',
    text = '',
    attributes = {},
    data = {},
    styles = {},
  } = {}) =>
    svgTags.has(tagName) && !ambiguousTags.has(name)
      ? makeSvgElement({ name, attributes, data, styles })
      : makeHtmlElement({ name, attributes, data, styles, text });
  /*
   * Wrap node in a new element of the type specified
   *
   * TODO - specify wrapper using CSS selector style string
   * e.g. 'div.class#id a[href=""] &'
   *   - multiple levels of wrapping
   *   - check wrapper node type can have children
   */
  const wrap = (nodeToWrap, { wrapper = 'div', attributes = {} } = {}) => {
    const wrapperElement = makeElement(wrapper, attributes);
    nodeToWrap.replaceWith?.(wrapperElement, nodeToWrap);
    wrapperElement.appendChild(nodeToWrap);
  };

  const wrapText = (
    parentNode,
    {
      match = /.*/su,
      split = undefined,
      trim = true,
      wrapper = ({ matched, text }) =>
        makeHtmlElement({
          name: 'span',
          text,
          attributes: {},
          data: { text, orig: matched },
        }),
    },
  ) =>
    parentNode.childNodes.forEach(
      (childNode) =>
        childNode.nodeName === '#text' && match.test(childNode.textContent),
    ) &&
    childNode.replaceWith(
      ...childNode.textContent
        .split(split)
        .filter((s) => (trim ? s.trim().length : s.length) > 0)
        .map((s) =>
          wrapper({ matched: childNode.textContent, text: s.trim() }),
        ),
    );

  /**
   * mu`div.foo#bar[baz="99"]` -> <div class="foo" id="bar" baz="99"></div>
   */
  return (...args) => {
    const parsedSelector = parseTag(...args);
    const selector = parsedSelector.length > 1 ? parsedSelector : 'body';

    const elementMethods = {
      // [Symbol.toStringTag]: `html{${selector.join('|')}}`,
      // Child tag
      tag: (...args) => {
        makeElement(...args);
        return elementMethods;
      },
      wrap: (...args) => {
        wrap(...args);
        return elementMethods;
      },
      wrapText: (...args) => {
        wrapText(...args);
        return elementMethods;
      },
    };

    return {
      mu: elementMethods,
      makeElement: elementMethods.tag,
    };
  };
})(window);

const csvGroupCols = (csvString) => {
  const ol = document.createElement('ol');
  ol.append(
    ...csvString.split('\n').map((csvRow) => {
      const li = document.createElement('li');
      li.append(
        ...csvRow.split(',').map((csvField) => {
          const s = document.createElement('span');
          s.innerText = csvField;
          return s;
        }),
      );
      return li;
    }),
  );
  return ol;
};

/**
 * qs`.wrapMe`.forEach(wrapWith(() => document.createElement('pre')));
 *
 * qs`.wrapThese`.
 */
// function* wrapWith(nodes, getWrapper = () => makeElement('div')) {
//   for (const nodeToWrap in nodes) {
//     const wrapper = getWrapper();
//     wrapper.classList.add('outer');
//     nodeToWrap.parentNode?.replaceChild?.(wrapper, nodeToWrap);
//     wrapper.appendChild(nodeToWrap);
//     yield wrapper;
//   }
// }

const sortByExtract = (({ document, ex }) =>
  [...document.querySelectorAll('.special > li')]
    .sort((a, b) => (ex(a) < ex(b) ? 1 : -1))
    .forEach((n) => document.querySelector('.special').appendChild(n)))({
  document,
  ex: (n) =>
    ((x, k) => x * Math.pow(1024, { bytes: 0, KB: 1, MB: 2 }[k]))(
      n.innerText.split(' . . ')[2],
    ).split(' '),
});

const sortNodes = (
  () =>
  (
    nodes,
    extract = (n) => n.innerText,
    compare = (a, b) => (extract(a) < extract(b) ? 1 : -1),
    parent = nodes[0].parentNode,
  ) =>
    nodes.sort(compare).forEach((n) => parent.appendChild(n))
)();

/* querySelector(sm)All
 *
 * Intended for use with haste
 *
 * Use:
 *  Call `qs\`\`` with a CSS selector to obtain an IterableQueryBuilder,
 *  which can be used to refine and preprocess the results of the selector.
 *
 *  Once configured, the Query can be executed once() (this can be done repeatedly), or set to run asynchronously until() being aborted:
 *
 *  qs``.once() -> Returns itself, for chaining.
 *  qs``.once(console.log) -> Provide optional method to receive result info
 *                 Info about previous once() can be found via the last() method
 *  qs``.once().last((info) => console.log(info))
 *
 *  qs``.until()            -> Returns an abort method to cancel
 *  qs``.until(abortsignal) -> Same, but use the provided abort signal
 *
 *  You can also use the standard Iterator interface to get an Iterable (either sync or async) to consume:
 *
 *  [Symbol.iterator]() -> IterableQueryResult,
 *                           (new instance returned for each call)
 *                          represents 'moment in time' set of results
 *  IterableQueryResult
 *            next() -> IteratorResult{done:boolean,value:any|undefined}
 *     return(value) -> IteratorResult
 *  throw(exception) -> IteratorResult
 *
 *  [Symbol.asyncIterator]() -> IterableQueryObserver,
 *                           (same one returned for all calls)
 *                          represents an event stream of new results
 *
 *                          if the builder specified mutations, these are
 *                          applied to new matches until the observer is stopped
 *  IterableQueryObserver
 *            next() -> Promise<IteratorResult>{done:boolean,value:any|undefined}
 *     return(value) -> Promise<IteratorResult>
 *  throw(exception) -> Promise<IteratorResult>
 *
 */

const addListenerTo = (target, eventName, callback, options = {}) => {
  const cbwrapper = (e) =>
    callback(e, {
      listener: target,
      eventName,
      options,
      remove: () => target.removeEventListener(eventName, cbwrapper),
    });
  target.addEventListener(eventName, cbwrapper, options);
  return target;
};

const getDownloader = (x) => () =>
  Promise.all(
    x.map((n) => {
      const src =
        n?.currentSrc ??
        n?.src ??
        window.location.href.replace(location.search, '');
      const filename = src.split('/').findLast(() => true);
      console.debug(n, src, filename);
      return triggerDownload({ src, filename });
    }),
  );

/**
 * Result Utility functions
 */
const injectRES = (x) => {
  if (x === undefined || x === null) {
    return x;
  }
  x.on = x.onEvent = (eventName, callback, options) =>
    injectRES(addListenerTo.call(x, eventName, callback, options));
  x.cl = x.classList;
  return x;
};

/**
 * IterableQueryBuilder chainable wrapper
 */
const IterableQueryBuilder = ({
  window: {
    document,
    qsAll = document.querySelectorAll.bind(document),
    console,
  },
  notify = Function.prototype.call.bind(window, window, console.log),
}) => {
  return (...args) => {
    let gone = 0;
    const parsedSelector = parseTag(...args);
    const selector = parsedSelector.length > 1 ? parsedSelector : 'body';

    /**
     * Stores iterable for each link in the query chain
     * First one being the initial result of querySelectorAll
     */
    const iterChain = ((sourceIterable) => {
      let _nodesAsResult = true;

      const step = (_iter) => {
        let _peeked;
        return {
          get peek() {
            return (_peeked ??= _iter.next());
          },
          get done() {
            return this.peek.done;
          },
          *[Symbol.iterator]() {
            if (_peeked?.done === false) {
              yield _peeked.value;
            }
            yield* _iter;
          },
          get iter() {
            return this[Symbol.iterator]();
          },
          entries: () => this[Symbol.iterator],
          values: () => this[Symbol.iterator],
          keys: () => this[Symbol.iterator],
        };
      };
      const steps = [step(sourceIterable)];

      const end = () => steps[steps.length - 1];

      return {
        /**
         * Add a new step to the chain of iterators
         */
        extend: (f /**/, ...args) => {
          steps.push(step(f(end(), ...args)));
        },

        /**
         * Last of the chain of iterators, the result
         */
        get nodesAsResult() {
          return _nodesAsResult;
        },
        set nodesAsResult(newValue) {
          return (_nodesAsResult = newValue);
        },

        /**
         * Modify the Result of the iteration
         *
         * These steps are added to the current end of the chain,
         * and run (in sequence) just after the step completes.
         *
         * The result of the last one is passed as the second argument
         * to the next one, allowing you to accumulate and pass extra
         * information between steps.
         *
         * Additionally, the third argument permits access to a Map()
         * shared between all items iterated over.
         */
        extract: (f) => {
          _nodesAsResult = false;
          // f(x: Element, xresult: IQBResult, imap: Map<
        },

        *[Symbol.iterator]() {
          yield* end();
        },
        /**
         * Last of the chain of iterators, the result
         */
        get iter() {
          return end().iter;
        },
        /**
         * Look at the next item without consuming it
         */
        get peek() {
          return end().peek;
        },
        /**
         * Is the end of the chain empty
         */
        get done() {
          return end().done;
        },
      };
    })(qsAll(selector).values());

    const iqb = {
      [Symbol.toStringTag]: `IQB\`${selector}\` |toStringTag|`,

      toString: `IQB\`${selector}\` |toString|`,

      [Symbol.toPrimitive](hint) {
        return `IQB\`${selector}\` |toPrimitive(${hint})|`;
      },

      // [Symbol.asyncIterator]: ,
      [Symbol.iterator]: () => iterChain.iter,

      get iter() {
        return iterChain.iter;
      },
      entries: () => iterChain.iter,
      values: () => iterChain.iter,
      keys: () => iterChain.iter,

      // tee: (f) => chain[chain.push(forEachSideEffect(last(), f)) - 1],
      forEach: (sideEffect /*: SideEffect<T> = (t: readonly T) => void */) => {
        iterChain.extend(forEachSideEffect, sideEffect);
        return iqb;
      },

      /**
       * Filter nodes in iterator chain via a predicate
       * - Chain continues
       */
      filter: (predicate) => {
        iterChain.extend(filterIter, predicate);
        return iqb;
      },

      /**
       * Map each node from iterator chain into:
       * - same or replacement node -> chain continues
       * - something that isn't a node -> chain ends
       */
      map: (
        mapperFn /*: Mapper<T, TOut> = (t: T, i: number) => TOut */,
      ) /*: */ => {
        iterChain.extend(mapIter, mapperFn);
        return iqb;
      },

      /**
       * Map each node in iter chain to zero or more nodes
       */
      flat: (flatMapperFn) => {
        iterChain.extend(flatMapIter, flatMapperFn);
        return iqb;
      },

      /**
       * Limit iteration by count
       * */
      take: (count) => {
        iterChain.extend(takeIter, count);
        return iqb;
      },

      /**
       * Skip by count
       */
      drop: (count) => {
        iterChain.extend(dropIter, count);
        return iqb;
      },

      /**
       * Wrap each node with a new element
       */
      wrap: ({ nodeName, attributes }) => {
        iterChain.extend(mapIter, (node) =>
          mu.wrap(node, { wrapper: nodeName, attributes }),
        );
        return iqb;
      },
      /**
       * Make text nodes into elements
       *
       *   match : process only text nodes matching this pattern
       *   split : matching text nodes are further split by this pattern, with each being wrapped
       *    trim : remove whitespace from ends of split matches
       * wrapper : function that returns the node to wrap each split match with
       *           takes one argument, an object:
       *           matched: string  The full original text string matched
       *           split: string    The split, trimmed part of the full text match
       */
      wrapText: (options) => {
        iterChain.extend(mapIter, (node) => mu.wrapText(node, options));
        return iqb;
      },
      /**
       * mu(tate) nodes
       *
       * @arg mutator
       */
      mu: (mutator) => {
        iterChain.extend(flatMapIter, (node) =>
          mutator({
            n: node,
            addEl: mu.makeElement,
            // has: [],
            querySelectorAll: node.querySelectorAll.bind(node),
            createElement: node.createElement.bind(node),
          }),
        );
        return iqb;
      },
      /**
       * get or set attribute values
       *
       * qs`a`.at.href  - get attribute 'href' from all 'a' elements
       * qs`a`.at('with-dash')  - get attribute 'href' from all 'a' elements
       * qs`a`.at.href('new value')  - set attribute 'href' for all 'a' elements
       * qs`test`.at`src` - get attribute 'src' from all 'test' elements
       *
       * with 1 argument:
       *   get value of attribute
       *     qs('test') -> 'some value'
       *
       *   get multiple attribute values
       *     qs(['src', 'data-abc', 'alt'])
       *   -> {'src': …, 'data-abc': …, 'alt': …}
       *
       * with 2 arguments:
       *   set vaue of attribute
       *     qs('test', 'newval') -> test="newval"
       *
       *   set multiple:
       *     qs({'src': 'newsrc', 'alt': 'newalt'})
       *
       * with lambda:
       *     at(({src, alt}) => ({}))
       *
       * */
      at: (...args) => {
        /* Single argument, retrieve attr value(s) */
        if (args.length === 1) {
          const parsed = parseTag(...args);
          // return flatMapIter(iterChain.iter, (x, xresult) =>
          // x.hasAttribute(parsed) ? xresult.at[parsed] = x.getAttribute(parsed) && xresult : xresult,
          // );

          /*
           * Extract data from the current iterator state
           * This can be updated in subsequent steps and
           * returned at the end of the chain
           *
           * @param (x: Node, xresult: IQBResult) => void
           *
           * IQBResult {
           *   at: Attributes,
           *   dt: Datalist,
           *   cl: ClassList,
           * }
           */
          iterChain.extract(forEachSideEffect, (x, xresult) => {
            if (x.hasAttribute(parsed)) {
              xresult.at[parsed] = x.getAttribute(parsed);
            }
          });
          return iqb;
        }
        /* Two arguments, set attr value */
        if (args.length === 2) {
          const parsed = parseTag(...args[0]);

          iterChain.extend(forEachSideEffect, (x) => {
            x.setAttribute(parsed, args[1]);
          });
          return iqb;
        }
      },
      /**
       * Predicates
       */

      /**
       * assert
       *
       * if true, return chainable, else throw
       *  e.g.
       *       qs`span`.many.map(...)
       */
      // get assertOnly(/* 1 = n */) {
      //   return iterChain.length === 1 ? iqb : yeet`assertOnly:false`;
      // },
      // get assertMany(/* 1 < n */) {
      //   return iterChain.length > 1 ? iqb : yeet`assertMany:false`;
      // },
      get assertSome(/* 0 < n */) {
        return !iterChain.done ? iqb : yeet`assertSome:false`;
      },
      get assertNone(/* 0 = n */) {
        return iterChain.done ? iqb : yeet`assertNone:false`;
      },

      get hasSome() {
        return !(iterChain.done ?? false);
      },
      get hasNone() {
        return iterChain.done ?? false;
      },
      /**
       * option
       *
       * if true, return chainable, else null
       *  e.g.
       *       qs`span`.many?.map(...)
       */
      get some(/* 0 < n */) {
        return (iterChain.done ?? false) ? null : iqb;
      },
      get none(/* 0 = n */) {
        return (iterChain.done ?? false) ? iqb : null;
      },
      // get only(/* 1 = n */) {
      //   return iterChain.length === 1 ? iqb : null;
      // },
      // get many(/* 1 < n */) {
      //   return iterChain.length > 1 ? iqb : null;
      // },

      /**
       * when condition is true
       * qs`a`.when.some  qs`a`.when.none
       *
       * until condition is true
       * qs`a`.until.some qs`a`.until.none
       */

      /**
       * Process results present at time of execution
       *  (If none, does not wait for a match to appear)
       */
      get now() {
        return iqb;
      },
      /**
       * Wait forever for new results, processing them as they occur
       * - Use ./abort(signal).forever to make forever shorter
       */
      get forever() {
        return iqb;
      },
      /**
       * Provide an abort signal which ends search early
       */
      abort: (signal /*: AbortSignal*/) => {
        return iqb;
      },
      /**
       * now & forever & take(inf)    TODO
       */
      get always() {
        return iqb;
      },
      /**
       * Implies .now, ends chain
       * Collapse iterator to array of all results
       */
      get all() {
        return [...iterChain.iter];
      },
      /** Collapse iterator to first result; ends chain */
      get one() {
        return [...takeIter(iterChain.iter, 1)][0];
      },
      /** Collapse iterator, ignore result */
      get go() {
        gone += 1;
        exhaustIter(iterChain.iter);
        return iqb;
      },
      /** By default, if a Result has been created, it is returned
       * Add this flag to request the nodes instead */
      get nodes() {
        iterChain.nodesAsResult = true;
        return iqb;
      },
      /**
       * Implies: .forever, .first; ends chain
       * Process exactly one result, waiting for it to appear if needed
       * .now.first
       */
      get now() {
        return [...takeIter(iterChain.iter, 1)][0];
      },
      get once() {
        return [...takeIter(iterChain.iter, 1)][0];
      },
      /** Collapse iterator to first result; ends chain */
      get first() {
        return [...takeIter(iterChain.iter, 1)][0];
      },
      /** Collapse iterator to given range of results; ends chain */
      n: (a, b) => nth(iterChain.iter, a, b),
    };
    return iqb;
  };
};

const qs = (window.qs = (
  (iqb) =>
  (...selector) =>
    iqb(...selector)
)(IterableQueryBuilder(window)));

const uqs = (unsafeWindow.qs = (
  (iqb) =>
  (...selector) =>
    iqb(...selector)
)(IterableQueryBuilder(unsafeWindow)));
