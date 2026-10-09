// ==UserScript==
// @name        browseWithPreview dev
// @namespace   mayhem
// @version     1.0.555
// @author      flowsINtomAyHeM
// @description File browser with media preview
// @downloadURL http://localhost:3333/vm/browseWithPreview.dev.user.js
// @match       *://localhost/*/*
// @match       file:///*/*
// @run-at      document-start
// @grant       GM_info
// @grant       GM_addStyle
// @grant       GM_addElement
// @grant       GM_getValue
// @grant       GM_setValue
// @grant       GM_registerMenuCommand
// @grant       GM_addValueChangeListener
// @grant       GM_xmlhttpRequest
// @require     http://localhost:3333/vm/util.user.js
// @cssBaseName browseWithPreview
// ==/UserScript==

/**
 * // @injectIQB-into auto
 *
 */

const defaultConfig = {
  playpause: {
    title: 'Playback',
    kind: ['playing', 'paused'],
    tip: 'Playback State (playing/paused)',
    kindtip: (p) => `Playback State: ${p}`,
    idx: 1,
  },
  debug: {
    title: 'Debug',
    kind: false,
    tip: 'Debug Mode',
    idx: 2,
  },
  bluronblurtimeout: {
    title: 'Blur on blur',
    kind: [30, 60, Math.POSITIVE_INFINITY, 0, 5, 15],
    tip: 'Blur screen when focus is lost',
    kindtip: (p) =>
      p === Math.POSITIVE_INFINITY
        ? `Do not blur screen when focus is lost`
        : `Blur screen when focus ${p === 0 ? `is lost` : `has been lost for ${p} seconds`}`,
  },
  pauseonblurtimeout: {
    title: 'Pause on blur',
    kind: [30, 60, Math.POSITIVE_INFINITY, 0, 5, 15],
    tip: 'Pause media when focus is lost',
    kindtip: (p) =>
      p === Math.POSITIVE_INFINITY
        ? `Do not pause media when focus is lost`
        : `Pause media when focus ${p === 0 ? `is lost` : `has been lost for ${p} seconds`}`,
  },
  onpause: {
    title: 'On Pause',
    kind: ['grid', 'none', 'blur'],
    tip: 'Behaviour when media is paused',
    kindtip: (p) =>
      `When media paused, ${p === 'blur' ? 'blur the screen' : p === 'grid' ? 'show grid view' : 'do nothing'}.`,
  },
  showGrid: {
    title: 'Grid',
    kind: false,
    tip: 'Show multiple media arranged on a grid',
  },
  grid_fit: {
    title: 'Grid fit mode',
    kind: ['contain', 'cover', 'fitw', 'fith', 'auto'],
    default: 'contain',
    tip: 'Fit used in grid mode for media',
  },
  imageduration: {
    kind: 5,
    tip: 'Default duration to display images for',
    group: 'player',
    idx: 1,
  },
  player: {
    group: 'player',
    idx: 2,
    textContent: 'Player Mode',
    kind: ['interleave', 'canvas', 'linear'],
    tip: 'Player Mode (interleave/linear)',
    kindtip: (p) => `Player Mode: ${p}`,
  },
  interleave_active_player_count: {
    group: 'interleave',
    idx: 1,
    title: 'Interleave Limit',
    kind: [9, 12, 16, 2, 3, 4, 6],
    numeric: true,
    tip: 'Max # of media to interleave',
    kindtip: (n) => `Interleave up to ${n} media`,
    cssvar: {
      name: '--interleave-active-player-count',
      syntax: '<integer>',
      inherits: true,
      selector: ':root',
    },
  },
  interleave_duration_ms: {
    title: 'Duration',
    kind: [
      500, 480, 400, 375, 300, 250, 240, 200, 160, 150, 60000, 30000, 20000,
      15000, 12000, 10000, 7500, 6000, 4000, 3000, 2000, 1000, 800, 750, 625,
      600,
    ],
    numeric: true,
    tip: 'Show each media for a fixed time',
    kindtip: (n) =>
      `Show each media for ${n >= 1000 ? `${(n / 1000).toFixed(0)}s` : `${n}ms`}`,
    cssvar: {
      name: '--interleave-duration-ms',
      syntax: '<time>',
      inherits: true,
      selector: ':root',
    },
  },
  interleave_bpm: {
    title: 'BPM',
    kind: [
      120, 125, 150, 160, 200, 240, 250, 300, 375, 400, 1, 2, 3, 4, 5, 6, 8, 10,
      15, 20, 30, 60, 75, 80, 96, 100,
    ],
    numeric: true,
    tip: 'Change media at a fixed rate',
    kindtip: (n) => `Change media ${n} times per minute`,
    cssvar: {
      name: '--interleave-bpm',
      syntax: '<number>',
      inherits: true,
      selector: ':root',
    },
  },
  interleave_timing: {
    title: 'Timing Method',
    kind: ['bpm', 'span', 'sync', 'detect'],
    tip: 'How the interval between interleaved media changes is set',
  },
  interleave_max_samples: {
    title: 'Samples Per Media',
    kind: [3, 5, 10, Number.POSITIVE_INFINITY, 1],
    numeric: true,
    tip: 'Maximum number of samples to show before changing media',
    kindtip: (n) =>
      n < Number.POSITIVE_INFINITY
        ? `Show at most ${n} samples before changing media`
        : `Show samples until media exhausted`,
  },
  interleave_sampling: {
    title: 'Sampling Method',
    tip: 'Method used to select media samples to interleave',
    kind: ['incidental', 'random', 'sequential'],
    kindtip: (p) =>
      p === 'incidental'
        ? 'Media are played simultaneously and switched between.'
        : `Samples are selected from each media ${p === 'random' ? 'randomly ' : ''}${p === 'sequential' ? 'sequentially ' : ''} to be interleaved.`,
  },
  repeat_playlist: {
    title: 'Repeat playlist',
    kind: true,
    tip: 'Repeat entire playlist',
    group: 'repeat',
    idx: 1,
  },
  repeat_playing: {
    kind: true,
    tip: 'Repeat all currently playing media (stop loading new files in interleave mode)',
    group: 'repeat',
    idx: 2,
  },
  shuffle_on_load: {
    title: 'Shuffle on load',
    kind: true,
    tip: 'Shuffle playlist on initial load of directory',
    group: 'repeat',
    idx: 3,
  },
  shuffle_on_repeat: {
    title: 'Shuffle on repeat',
    kind: true,
    tip: 'Shuffle playlist every repeat',
    group: 'repeat',
    idx: 4,
    enable: ['repeat_playlist'],
  },
  reload_on_repeat: {
    title: 'Reload on repeat',
    kind: true,
    tip: 'Reload folder contents on playlist repeat',
    group: 'repeat',
    idx: 5,
    enable: ['repeat_playlist'],
  },
  filter: { kind: '.*\.mp4$', hidden: true },
  filelist: {
    title: 'Show file listing',
    kind: ['hide', 'below', 'beside'],
    tip: 'File List location',
    kindtip: (p) =>
      `${p === 'hide' ? `Hide file list` : `Show file list ${p} media`}`,
    group: 'filelist',
    idx: 1,
  },
  includeImageFiles: {
    title: 'Include Images',
    kind: true,
    tip: 'Include image files',
    group: 'filelist',
    idx: 2,
  },
  includeVideoFiles: {
    title: 'Include Video',
    kind: true,
    tip: 'Include video files',
    group: 'filelist',
    idx: 3,
  },
  includeOtherFiles: {
    title: 'Include Other',
    kind: false,
    tip: 'Include other files',
    group: 'filelist',
    idx: 4,
  },
  includeHiddenFiles: {
    tip: 'Include Hidden',
    kind: false,
    tip: 'Include hidden files',
    group: 'filelist',
    idx: 5,
  },
};

const isDirectory = (({ qs }) =>
  qs`:has([href="chrome://global/skin/dirListing/dirListing.css"])`.hasSome)(
  unsafeWindow,
);

const overrideFileListClicks = (({ qs }) =>
  qs`a.file`.all.forEach((link) =>
    link.addEventListener('click', (e) => {
      qs`video`.all.setAttribute('src', link.getAttribute('href'));
      e.preventDefault();
      return false;
    }),
  ))(unsafeWindow);

const addGrouping = ({ to, ...attrs }) => {
  const div = GM_addElement(to, 'div', {
    class: 'grouping',
    ...attrs,
  });
  return div;
};

const addToggle = ({
  to,
  name,
  tag = 'input',
  type = 'checkbox',
  id = `toggle_${name}`,
  bindTo,
  checked = bindTo?.value ?? false,
  textContent = `Toggle ${name}`,
  ...attrs
} = {}) => {
  const div = GM_addElement(to, 'div', {
    class: 'toggle',
    name,
    'data-text': textContent,
    ...attrs,
  });
  const label = GM_addElement(div, 'label', {
    class: '',
  });
  GM_addElement(label, 'span', {
    class: 'tip',
    textContent,
  });
  const input = GM_addElement(label, tag, {
    type,
    id,
    name,
    ...(checked ? { checked: '' } : {}),
  });
  input.addEventListener(
    'change',
    (e) => {
      bindTo.value = e.target.checked;
    },
    {},
  );
  bindTo.subscribe((checked) => {
    input.checked = checked;
  });
  return div;
};

const addSequenceToggle = ({
  to,
  name,
  bindTo,
  tag = 'input',
  type = 'radio',
  tip = `Toggle for ${name}`,
  textContent = tip,
  sequence = [],
  defaultPrefix = '',
  defaultSuffix = '',
  numeric = false,
  ...attrs
} = {}) => {
  const container = GM_addElement(to, 'fieldset', {
    class: `sequence toggle ${numeric ? 'numeric' : ''}`,
    'data-text': textContent,
    ...attrs,
  });
  sequence.forEach(
    ({
      value,
      prefix = defaultPrefix,
      suffix = defaultSuffix,
      display = `${value}`,
      id = `toggle_${name}_${value}`,
      tip = `Toggle ${name} withvalue ${display}`,
    }) => {
      const label = GM_addElement(container, 'label', {
        class: '',
        'data-name': name,
        'data-value': `${value}`,
        'data-value-len': `${value}`.length,
        'data-value-display': `${display}`,
        'data-value-display-len': `${display}`.length,
        'data-value-prefix': `${prefix}`,
        'data-value-prefix-len': `${prefix}`.length,
        'data-value-suffix': `${suffix}`,
        'data-value-suffix-len': `${suffix}`.length,
        for: id,
      });
      GM_addElement(label, 'span', {
        class: 'prefix',
        textContent: `${prefix}`,
      });
      GM_addElement(label, 'span', {
        class: 'value',
        textContent: `${display}`,
      });
      GM_addElement(label, 'span', {
        class: 'suffix',
        textContent: `${suffix}`,
      });
      GM_addElement(label, 'span', {
        class: 'tip',
        textContent: tip,
      });
      const input = GM_addElement(label, tag, {
        type,
        ...(bindTo?.value === value ? { checked: '' } : {}),
        name,
        value,
        id,
      });
      input.addEventListener(
        'change',
        (e) => {
          if (e.target.checked) {
            bindTo.value = e.target.value;
          }
        },
        {},
      );
      bindTo.subscribe((checkedValue) => {
        input.checked = checkedValue === input.value;
      });
    },
  );
  return container;
};

const addAction = ({
  to,
  name,
  tag = 'button',
  id = `action_${name}`,
  action,
  textContent = `Perform ${name}`,
  ...attrs
} = {}) => {
  const div = GM_addElement(to, 'div', {
    class: 'toggle action',
    name,
    'data-text': textContent,
    ...attrs,
  });
  const label = GM_addElement(div, 'label', {
    class: '',
  });
  GM_addElement(label, 'span', {
    class: 'tip',
    textContent,
  });
  const input = GM_addElement(label, tag, {
    id,
    name,
  });
  input.addEventListener('click', () => action(), {});
  return div;
};

const initBrowsePreview = ({ document: { body } }) => {
  const players = GM_addElement(body, 'section', { class: 'players' });

  const actions = (({}) => {
    /**
     * Add current media to a list for review
     */
    const flag = () => {};

    return {
      flag,
    };
  })({});

  const config = (({ defaultConfig }) => {
    const defineString = (_val = '') => {
      const subs = new Set();

      const notify = () =>
        Promise.allSettled(
          subs.values().map((sub) => Promise.resolve(sub(_val))),
        );

      const subscribe = (callback) => {
        subs.add(callback);
        Promise.resolve(_val).then(callback);
        return () => subs.remove(callback);
      };

      const set = (newValue) => {
        _val = newValue;
        notify();
        return _val;
      };

      return {
        get value() {
          return _val;
        },
        set value(newValue) {
          return set(newValue);
        },
        set,
        subscribe,
      };
    };

    const defineNumber = (_val = 0) => {
      const subs = new Set();

      const notify = () =>
        Promise.allSettled(
          subs.values().map((sub) => Promise.resolve(sub(_val))),
        );

      const subscribe = (callback) => {
        subs.add(callback);
        Promise.resolve(_val).then(callback);
        return () => subs.remove(callback);
      };

      const set = (newValue) => {
        _val = newValue;
        notify();
        return _val;
      };

      return {
        get value() {
          return _val;
        },
        set value(newValue) {
          return set(newValue);
        },
        set,
        subscribe,
      };
    };

    const defineToggle = (_val = false) => {
      const subs = new Set();

      const notify = () =>
        Promise.allSettled(
          subs.values().map((sub) => Promise.resolve(sub(_val))),
        );

      const subscribe = (callback) => {
        subs.add(callback);
        Promise.resolve(_val).then(callback);
        return () => subs.remove(callback);
      };

      const set = (newValue) => {
        _val = newValue;
        notify();
        return _val;
      };
      const toggle = () => set(!_val);

      return {
        get value() {
          return _val;
        },
        set value(newValue) {
          return set(newValue);
        },
        set,
        toggle,
        subscribe,
      };
    };

    const defineSequence = (
      values = ['a', 'b', 'c'],
      defaultValue = values[0],
    ) => {
      const toHtmlValue = (v) => `${v}`;
      const _values = values.map(toHtmlValue);
      let _val = toHtmlValue(defaultValue ?? values[0]);
      const subs = new Set();

      const notify = () =>
        Promise.allSettled(
          subs.values().map((sub) => Promise.resolve(sub(_val))),
        );

      const subscribe = (callback) => {
        subs.add(callback);
        Promise.resolve(_val).then(callback);
        return () => subs.remove(callback);
      };

      const set = (newValue) => {
        if (_values.indexOf(toHtmlValue(newValue)) > -1) {
          _val = toHtmlValue(newValue);
          notify();
        }
        return _val;
      };

      const next = () =>
        set(_values[(_values.indexOf(_val) + 1) % _values.length]);
      const prev = () =>
        set(_values[(_values.indexOf(_val) - 1) % _values.length]);

      return {
        get value() {
          return _val;
        },
        set value(newValue) {
          return set(newValue);
        },
        set,
        toggle: next,
        next,
        prev,
        subscribe,
      };
    };

    const configTypeMap = new Map([
      ['string', defineString],
      ['object', defineSequence],
      ['number', defineNumber],
      ['boolean', defineToggle],
    ]);

    const defineConfig = ([name, { kind }]) => [
      configTypeMap.has(typeof kind)
        ? [name, configTypeMap.get(typeof kind)(kind)]
        : tee.warn([], `invalid config type for entry ${name}`),
    ];

    const configBindings = Object.fromEntries(
      Object.entries(defaultConfig).flatMap(defineConfig),
    );

    return configBindings;
  })({ defaultConfig });

  (({
    config: {
      interleave_active_player_count,
      interleave_duration_ms,
      interleave_bpm,
    },
  }) => {
    /* TODO - set up @property automatically */
    interleave_active_player_count.subscribe((newValue) => {
      setRegisteredCSSProperty({
        name: '--interleave-active-player-count',
        value: newValue,
        syntax: '<integer>',
      });
    });
    interleave_bpm.subscribe((newValue) => {
      setRegisteredCSSProperty({
        name: '--interleave-bpm',
        value: `${newValue}`,
        syntax: '<number>',
      });
    });
    interleave_duration_ms.subscribe((newValue) => {
      setRegisteredCSSProperty({
        name: '--interleave-duration-ms',
        value: `${newValue}ms`,
        syntax: '<time>',
      });
    });
  })({ config });

  (({ configBindings, defaultConfig, actions }) => {
    const defaultContainer = GM_addElement(body, 'section', {
      class: 'toggles',
    });

    const uiTypeMap = new Map([
      ['string', () => {}],
      [
        'object',
        (name, configBinding, { title, kind, kindtip, to }) =>
          addSequenceToggle({
            textContent: title,
            bindTo: configBinding,
            name,
            to: to ?? defaultContainer,
            sequence: kind.map((p) => ({
              value: p,
              tip: (kindtip ?? ((n) => `${n}`))(p),
            })),
          }),
      ],
      ['number', () => {}],
      [
        'boolean',
        (name, configBinding, { title, to }) =>
          addToggle({
            textContent: title,
            bindTo: configBinding,
            name,
            to: to ?? defaultContainer,
          }),
      ],
    ]);

    const createUI = (configBindings, name, conf) => [
      uiTypeMap.has(typeof conf.kind)
        ? [
            name,
            uiTypeMap.get(typeof conf.kind)(
              name,
              Object.hasOwn(configBindings, name) ? configBindings[name] : null,
              conf,
            ),
          ]
        : tee.warn([], `createUI: invalid config type for entry ${name}`),
    ];

    const groups = new DefaultedMap(defaultContainer);

    Object.entries(defaultConfig).forEach(([name, conf]) => {
      const { group } = conf;

      group &&
        !groups.has(group) &&
        groups.set(group, addGrouping({ to: defaultContainer }));

      const bindTo = Object.hasOwn(configBindings, name)
        ? configBindings[name]
        : null;

      createUI(configBindings, name, {
        ...conf,
        bindTo,
        to: groups.get(group),
      });
    });
    /**
     * - define a config entry for each key
     * - extract grouping info
     *   - order within groups
     * - add a UI element for each key as configured
     *   - boolean: toggle
     *   - []: sequencetoggle
     *   - number:
     *   - string:
     * - configure dependent elements
     * - set up css variable bindings
     */
  })({ configBindings: config, defaultConfig, actions });

  // (({ to, config, actions }) => {
  // const repeatGrouping = addGrouping({ to });
  // const playerGrouping = addGrouping({ to });
  // const interleaveGrouping = addGrouping({ to: playerGrouping });
  // const gridGrouping = addGrouping({ to: playerGrouping });
  // const filesGrouping = addGrouping({ to });
  // const actionsGrouping = addGrouping({ to });
  // addAction({
  // textContent: 'Flag for review',
  // action: actions.flag,
  // name: 'flag',
  // to: actionsGrouping,
  // });
  // })({ to: toggles, configBindings: config, defaultConfig, actions });

  const addWrappedMedia = (
    ({
      window: { console },
      config: {
        imageduration,
        interleave_active_player_count,
        interleave_duration_ms,
        interleave_bpm,
        interleave_timing,
        interleave_max_samples,
        interleave_sampling,
        repeat_playing,
      },
    }) =>
    ({
      to,
      idx,
      nextFile,
      autoplay = false,
      muted = true,
      class: attr_class = '',
      id,
      ...attrs
    } = {}) => {
      const wrapper = GM_addElement(to, 'div', { class: `vidwrap i${idx}` });
      wrapper.style.setProperty('--playerIdx', idx);
      wrapper.style.setProperty('--s-playerIdx', `'${idx}'`);

      let _playbackErrors = 0;
      const maxErrorCount = 10,
        addToCountOnError = 1,
        addToCountOnSuccess = -2;

      const noMedia = GM_addElement(wrapper, 'nomedia', {
        textContent: 'no media',
        'data-media': 'x',
      });

      const videoA = GM_addElement(wrapper, 'video', {
        preload: '',
        muted: '',
        class: 'a',
        'data-media': 'a',
        ...attrs,
      });

      const videoB = GM_addElement(wrapper, 'video', {
        preload: '',
        muted: '',
        class: 'b',
        'data-media': 'b',
        ...attrs,
      });

      const imageI = GM_addElement(wrapper, 'img', {
        class: 'i',
        'data-media': 'i',
      });

      const imageJ = GM_addElement(wrapper, 'img', {
        class: 'j',
        'data-media': 'j',
      });

      const video = videoA;

      // const cue = ()

      /**
       * To ensure every file gets seen when interleaved
       * repeat files shorter than the total time to cycle through all media
       *
       * Cue next media to switch in while not visible, e.g. half a cycle offset
       */
      const oneMinute = 60 * 1000;

      const stepTime = () =>
        interleave_timing.value === 'bpm'
          ? oneMinute / interleave_bpm.value
          : interleave_timing.value === 'span'
            ? interleave_duration_ms.value
            : Number.POSITIVE_INFINITY;

      const cycleTime = () => stepTime() * interleave_active_player_count.value;

      const cycleOffsetTime = () => stepTime() * idx;

      // const nextMediaAfter = (mediaDuration) => mediaDuration > (cycleTime() * interleave_max_samples.value) ? :
      // };

      const nextMedia = (() => {
        let id = null,
          expected = null,
          resumeDelay = 0;

        const cue = (delay = 100) => {
          expected = Date.now() + delay;
          id =
            clearTimeout(id) ??
            setTimeout(() => {
              expected = null;
              resumeDelay = 0;
              next();
            }, delay);
        };

        const next = async () => {
          const { url, isImage, isVideo } = await nextFile();
          console.debug(
            `nextMedia ${isImage ? '􀏆' : isVideo ? '􀍊' : '􂇲'} idx: ${idx}, url: '${decodeURI(url)}'`,
          );
          if (isVideo) {
            isActive(videoA) ? cueB() : cueA();
          } else if (isImage) {
            isActive(imageI) ? cueJ() : cueI();
            cue(imageduration.value * 1000);
          } else {
            cue(100);
          }
          wrapperUpdateActive();
        };

        return {
          /**
           *  cue changing to the next media, switching to it after
           *  a delay (given in milliseconds, default: 100)
           */
          cue,
          /**
           * Pause next cue until resume() is called
           *
           * The remaining delay before the cue is stored
           */
          pause: () => {
            resumeDelay = Math.max(
              0,
              Date.now() - (expected ?? Number.POSITIVE_INFINITY),
            );
            id = clearTimeout(id);
          },
          /**
           * Resume cue, with the delay remaining when it was paused
           */
          resume: () => cue(resumeDelay),
        };
      })();

      const wrapperUpdateActive = () => {
        wrapper.dataset.active = 'a';
      };

      const cueNone = () => {
        videoA.removeAttribute('src');
        videoA.load();
        videoB.removeAttribute('src');
        videoB.load();
        imageI.removeAttribute('src');
        imageJ.removeAttribute('src');
      };

      const cueA = () => {
        videoA.src = url;
        videoA.addEventListener(
          'canplaythrough',
          () => {
            videoB.removeAttribute('src');
            videoB.load();
            imageJ.removeAttribute('src');
            imageI.removeAttribute('src');
          },
          { once: true },
        );
        videoA.load();
      };

      const cueB = () => {
        videoB.src = url;
        videoB.addEventListener(
          'canplaythrough',
          () => {
            videoA.removeAttribute('src');
            videoA.load();
            imageJ.removeAttribute('src');
            imageI.removeAttribute('src');
          },
          { once: true },
        );
        videoB.load();
      };

      const cueI = () => {
        imageI.addEventListener(
          'load',
          () => {
            videoA.removeAttribute('src');
            videoA.load();
            videoB.removeAttribute('src');
            videoB.load();
            imageJ.removeAttribute('src');
          },
          { once: true },
        );
        imageI.src = url;
      };

      const cueJ = () => {
        imageJ.addEventListener(
          'load',
          () => {
            videoA.removeAttribute('src');
            videoA.load();
            videoB.removeAttribute('src');
            videoB.load();
            imageI.removeAttribute('src');
          },
          { once: true },
        );
        imageJ.src = url;
      };

      /**
       * Resume playback using last active media player
       */
      const play = () => {
        nextMedia.cue();
        video.volume = 0;
        video.muted = true;
        video.play();
      };
      /**
       * Pause playback
       */
      const pause = () => {
        video.pause();
      };

      const onPlay = (video) => {
        // console.info(`${idx} playing '${decodeURI(video.src)}'`);

        video.classList.remove('paused');
        video.classList.add('playing');

        document
          .querySelectorAll(
            `body > table > tbody > tr:has([href="${video.src.split('/').slice(-1)}"])`,
          )
          .forEach((tr) => {
            tr.classList.remove('paused');
            tr.classList.add('playing');
            tr.style.setProperty('--playerIdx', idx);
            tr.style.setProperty('--s-playerIdx', `'${idx}'`);

            const undo = (() => {
              let undone = false;
              return () => {
                if (!undone) {
                  undone = true;
                  tr.classList.remove('playing');
                  tr.classList.add('played');
                }
              };
            })();
            video.addEventListener(
              'ended',
              () => {
                tr.classList.remove('playing');
                tr.classList.add('played');
              },
              { once: true },
            );

            video.addEventListener('loadstart', undo, { once: true });
          });
      };

      const onPause = (video) => {
        // console.info(`${idx} paused '${decodeURI(video.src)}'`);

        video.classList.remove('playing');
        video.classList.add('paused');

        document
          .querySelectorAll(
            `body > table > tbody > tr:has([href="${video.src.split('/').slice(-1)}"])`,
          )
          .forEach((tr) => {
            tr.classList.remove('playing');
            tr.classList.add('paused');
            tr.style.setProperty('--playerIdx', idx);
            tr.style.setProperty('--s-playerIdx', `'${idx}'`);
          });
      };

      videoA.addEventListener('play', () => onPlay(videoA), {});
      videoA.addEventListener('pause', () => onPause(videoA), {});

      videoB.addEventListener('play', () => onPlay(videoB), {});
      videoB.addEventListener('pause', () => onPause(videoB), {});

      (({ idx }) =>
        [
          [videoA, 'A'],
          [videoB, 'B'],
        ].forEach(([video, videoIdx]) =>
          [
            ['play', 'debug'],
            ['pause', 'debug'],
            ['volumechange', 'debug'],
            ['canplay', 'info'],
            ['canplaythrough', 'info'],
            ['seeked', 'info'],
            ['seeking', 'debug'],
            ['timeupdate', 'debug'],
            ['durationchange', 'debug'],
            ['ratechange', 'debug'],
            ['ended', 'info'],
            ['emptied', 'debug'],
            ['loadstart', 'debug'],
            ['loadeddata', 'debug'],
            ['loadedmetadata', 'debug'],
            ['progress', 'debug'],
            ['waiting', 'debug'],
            ['stalled', 'info'],
            ['suspend', 'debug'],
            ['error', 'warn'],
          ].forEach((eventName, loglevel) =>
            video.addEventListener(eventName, () =>
              console?.[loglevel]?.(
                `${idx}${videoIdx} ${eventName} '${decodeURI(video.src)}'`,
              ),
            ),
          ),
        ))({ idx });

      /* Playback */
      const onCanplaythroughA = () => {
        imageI.removeAttribute('src');
        imageJ.removeAttribute('src');
        videoA.play();
        videoB.pause();
        videoB.removeAttribute('src');
        videoB.load();
      };
      const onCanplaythroughB = () => {
        imageI.removeAttribute('src');
        imageJ.removeAttribute('src');
        videoB.play();
        videoA.pause();
        videoA.removeAttribute('src');
        videoA.load();
      };
      const onEnded = (video) => {
        _playbackErrors = Math.max(0, _playbackErrors + addToCountOnSuccess);

        nextMedia.cue();
      };
      videoA.addEventListener('canplaythrough', () => onCanplaythroughA());
      videoB.addEventListener('canplaythrough', () => onCanplaythroughB());
      videoA.addEventListener('ended', () => onEnded());
      videoB.addEventListener('ended', () => onEnded());

      video.addEventListener('error', () => {
        console.warn(`${idx} error loading '${decodeURI(video.src)}'`);

        if ((_playbackErrors += addToCountOnError) > maxErrorCount) {
          video.pause();
          video.classList.add('error');
          console.warn(`${idx} exceeded max error count`);
        } else {
          nextMedia.cue();
        }
      });

      return {
        wrapper,
        player: video,
        play,
        pause,
        enable: () => {
          wrapper.classList.remove('off');
          nextMedia.resume();
        },
        disable: () => {
          wrapper.classList.add('off');
          nextMedia.pause();
          videoA.pause();
          videoA.removeAttribute('src');
          videoA.load();
          videoB.pause();
          videoB.removeAttribute('src');
          videoB.load();
          imageI.removeAttribute('src');
          imageJ.removeAttribute('src');
        },
      };
    }
  )({ window, config });

  const getFileList = (
    ({
      config: {
        /* repeat, */
        shuffle_on_load,
        shuffle_on_repeat,
        reload_on_repeat,
        /* filter, */
        includeImageFiles,
        includeVideoFiles,
        includeOtherFiles,
      },
      shuffleArray,
    }) =>
    () => {
      let files = null,
        filesOriginalOrder = [],
        filesIter;

      const exts = {
        video: ['mp4', 'mov'],
        image: ['jpg', 'jpeg', 'png'],
      };
      const matchVideo = `^.*\.(?:${exts.video.join('|')})`;
      const matchImage = `^.*\.(?:${exts.image.join('|')})`;
      const matchOther = `^.*(?<!\.(?:${[...exts.video, ...exts.image].join('|')}))$`;

      const isVideoRegex = new RegExp(matchVideo);
      const isImageRegex = new RegExp(matchImage);

      const updateFilter = () =>
        // filter: defineString('.*\.mp4$'),
        // ^.*\.(?:mp4|mov)$|^.*\.(?:jpg|jpeg|png|)$|^.*\.(?:)$
        new RegExp(
          [
            includeImageFiles.value ? matchImage : [],
            includeVideoFiles.value ? matchVideo : [],
            includeOtherFiles.value ? matchOther : [],
          ]
            .flat()
            .join('|'),
        );

      let _shuffled = false,
        _filter = updateFilter(),
        _filtered_length = null;

      const load = () => {
        files = [...document.querySelectorAll('a.file')]
          .map((file) => file.getAttribute('href'))
          .map((url) => ({
            url,
            isImage: isImageRegex.test(url),
            isVideo: isVideoRegex.test(url),
          }));
        filesOriginalOrder = [...files];
        _shuffled = false;
        _filtered_length = null;

        if (shuffle_on_load.value) {
          shuffle();
        }
      };

      const shuffle = () => {
        files ?? load();
        shuffleArray(files);
        /* shuffling ought not to change the filtered length */
        filesIter = filteredFiles();
        _shuffled = true;
      };

      const unshuffle = () => {
        files ?? load();
        files = [...filesOriginalOrder];
        /* unshuffling ought not to change the filtered length */
        _shuffled = false;
      };

      async function* filteredFiles() {
        files ?? load();

        while (true) {
          for (const file of files.filter(({ url }) => _filter.test(url))) {
            yield Promise.resolve(file);
          }
          if (reload_on_repeat.value) {
            load();
          } else {
            if (shuffle_on_repeat.value) {
              shuffle();
            }
          }
        }
      }

      /* const unsubs = */ [
        // repeat_playlist.subscribe((newValue) => ),
        // shuffle_on_repeat.subscribe(() => ),
        // reload_on_repeat.subscribe(() => ),
        // filter.subscribe(() => ),
        includeImageFiles.subscribe(() => {
          _filter = updateFilter();
          _filtered_length = null;
        }),
        includeVideoFiles.subscribe(() => {
          _filter = updateFilter();
          _filtered_length = null;
        }),
        includeOtherFiles.subscribe(() => {
          _filter = updateFilter();
          _filtered_length = null;
        }),
      ];

      filesIter = filteredFiles();

      return {
        async next() {
          return (await filesIter.next()).value;
        },
        async *[Symbol.asyncIterator]() {
          return filesIter;
        },
        /**
         *  If a filter is set, this returns the filtered count
         *  This is calculated lazily the first time it is required
         */
        get length() {
          files ?? load();
          return (_filtered_length ??= [
            ...files.filter(({ url }) => url.match(_filter)),
          ].length);
        },
        /**
         * Always returns the full, unfiltered length
         */
        get fullLength() {
          files ?? load();
          return files.length;
        },
        get shuffled() {
          return _shuffled;
        },
        shuffle,
        unshuffle,
        reload: () => load(),
      };
    }
  )({ config, shuffleArray: shuffle });

  (({ to, config: { player, playpause, interleave_active_player_count } }) => {
    const interleavePlayerContainer = GM_addElement(to, 'section', {
      class: 'player interleave',
    });

    GM_addElement(interleavePlayerContainer, 'label', {
      for: 'toggle_playpause_playing',
    });
    GM_addElement(interleavePlayerContainer, 'label', {
      for: 'toggle_playpause_paused',
    });
    const filelist = getFileList();

    const nextFile = async () => await filelist.next();

    const mediaPlayers = [
      ...mapIter(
        rangeIter({
          start: 0,
          count: Math.max(...defaultConfig.interleave_active_player_count.kind),
        }),
        (i) =>
          addWrappedMedia({
            to: interleavePlayerContainer,
            class: `i${i}`,
            id: `i${i}`,
            idx: i,
            nextFile,
            autoplay: false,
          }),
      ),
    ];
    const activeMediaPlayers = () => [
      ...takeIter(mediaPlayers.values(), interleave_active_player_count.value),
    ];

    const updateActivePlayerCount = (activePlayerCount) =>
      mediaPlayers.forEach((mediaPlayer, i) =>
        i < activePlayerCount ? mediaPlayer.enable() : mediaPlayer.disable(),
      );

    interleave_active_player_count.subscribe(updateActivePlayerCount);

    const play = () => {
      activeMediaPlayers().forEach((mediaPlayer) => {
        mediaPlayer.play();
      });
    };
    const pause = () => {
      mediaPlayers.forEach((mediaPlayer) => {
        mediaPlayer.pause();
      });
    };

    const updatePlaybackState = (playbackState, activePlayer) =>
      activePlayer === 'interleave' && playbackState === 'playing'
        ? play()
        : pause();

    playpause.subscribe((playbackState) =>
      updatePlaybackState(playbackState, player.value),
    );
    player.subscribe((activePlayer) =>
      updatePlaybackState(playpause.value, activePlayer),
    );

    return {
      play,
      pause,
    };
  })({ to: players, config });

  // const linearPlayer = (({ to, config }) => {
  //   const container = GM_addElement(to, 'section', {
  //     class: 'player linear paused',
  //   });

  //   ['last', 'cue-prev', 'current', 'cue-next'].forEach((cl) =>
  //     addWrappedMedia({ to: container, class: cl }),
  //   );

  //   const filelist = getFileList({ repeat_playlist: true, shuffle: false });

  //   return {
  //     play: () => {
  //       container.querySelectorAll('current').forEach((video) => {
  //         video.src = filelist?.next().value;
  //         video.play();
  //       });
  //       container.classList.add('playing');
  //       container.classList.remove('paused');
  //     },
  //     pause: () => {
  //       container.querySelectorAll('current').forEach((video) => {
  //         video.pause();
  //       });
  //       container.classList.add('paused');
  //       container.classList.remove('playing');
  //     },
  //   };
  // })({ to: players, config });

  document.querySelectorAll('a.file').forEach((file) =>
    file.addEventListener('click', (e) => {
      let last = document.querySelector('.last');
      let next = document.querySelector('.cue-next');
      let prev = document.querySelector('.cue-prev');
      let current = document.querySelector('.current');

      const nextFile = file.closest('tr').parentNode.closest('tr');
      next.addEventListener(
        'canplaythrough',
        () => {
          next.play();
          current.pause();
          last.classList.replace('last', 'last2');
          current.classList.replace('current', 'last');
          next.classList.replace('cue-next', 'current');

          /* set src of new next & prev to new neighbouring files */
          prev.classList.replace('cue-prev', 'cue-next');
          next.setAttribute('src', nextFile.getAttribute('href'));
        },
        { once: true },
      );
      next.setAttribute('src', nextFile.getAttribute('href'));
      e.preventDefault();
      return false;
    }),
  );

  breadcrumbs({ to: qs`body`.one, classList: 'top right fixed' });

  (({ bluronblur, config: { bluronblurtimeout } }) => {
    const { setHiddenTimeout } = bluronblur({
      hiddenTimeout: bluronblurtimeout,
    });
    bluronblurtimeout.subscribe((newTimeout) => setHiddenTimeout(newTimeout));
  })({ bluronblur, breadcrumbs, config });
};

const browsePreviewToggleIds = addStyleToggles([
  {
    title: 'browse with preview',
    enabled: isDirectory,
    sources: [
      {
        baseName: 'browseWithPreview',
      },
      {
        baseName: 'browseWithPreview.debug',
      },
      {
        baseName: 'browseWithPreview.filelisting',
      },
    ],
  },
]).then(() =>
  Promise.race([timeout({ s: 30 }), readyStateComplete()])
    .catch(() => console.debug('timed out waiting for readyStateComplete'))
    .then(({ /* window, */ unsafeWindow }) => {
      console.debug('document ready');

      return Promise.all([
        matchExistsFor('a.file').then((/* node */) => {
          if (isDirectory) {
            initBrowsePreview(unsafeWindow);
          }
        }),
      ]);
    })
    .catch((e) => console.warn(e)),
);
