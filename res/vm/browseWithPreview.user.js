// ==UserScript==
// @name        browseWithPreview
// @namespace   mayhem
// @version     1.0.474
// @author      flowsINtomAyHeM
// @description File browser with media preview
// @downloadURL http://localhost:3333/vm/browseWithPreview.user.js
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
    kind: ['playing', 'paused'],
    default: 'playing',
    tip: 'Playback State (playing/paused)',
    kindtip: (p) => `Playback State: ${p}`,
    idx: 1,
  },
  debug: { kind: 'toggle', default: false, tip: 'Debug Mode', idx: 2 },
  bluronblurtimeout: {
    kind: [0, 5, 15, 30, 60, Math.POSITIVE_INFINITY],
    default: 30,
    tip: 'Blur screen when focus is lost',
    kindtip: (p) =>
      p === Math.POSITIVE_INFINITY
        ? `Do not blur screen when focus is lost`
        : `Blur screen when focus ${p === 0 ? `is lost` : `has been lost for ${p} seconds`}`,
  },
  pauseonblurtimeout: {
    kind: [0, 5, 15, 30, 60, Math.POSITIVE_INFINITY],
    default: 30,
    tip: 'Pause media when focus is lost',
    kindtip: (p) =>
      p === Math.POSITIVE_INFINITY
        ? `Do not pause media when focus is lost`
        : `Pause media when focus ${p === 0 ? `is lost` : `has been lost for ${p} seconds`}`,
  },
  onpause: {
    kind: ['blur', 'grid', 'none'],
    default: 'grid',
    tip: 'Behaviour when media is paused',
    kindtip: (p) =>
      `When media paused, ${p === 'blur' ? 'blur the screen' : p === 'grid' ? 'show grid view' : 'do nothing'}.`,
  },
  showGrid: {
    kind: 'toggle',
    default: false,
    tip: 'Show multiple media arranged on a grid',
  },
  grid_fit: {
    kind: ['auto', 'contain', 'cover', 'fitw', 'fith'],
    default: 'contain',
    tip: 'Fit used in grid mode for media',
  },
  imageduration: {
    kind: 'number',
    default: 5,
    tip: 'Default duration to display images for',
    group: 'player',
    idx: 1,
  },
  player: {
    kind: ['linear', 'interleave'],
    default: 'interleave',
    tip: 'Player Mode (interleave/linear)',
    kindtip: (p) => `Player Mode: ${p}`,
    group: 'player',
    idx: 2,
  },
  interleave_active_player_count: {
    kind: [2, 3, 4, 6, 9, 12, 16],
    default: 9,
    tip: 'Max # of interleaved videos',
    kindtip: (n) => `Max of ${n} interleaved videos`,
    numeric: true,
    group: 'interleave',
    idx: 1,
  },
  interleave_duration_ms: {
    kind: [
      60000, 30000, 20000, 15000, 12000, 10000, 7500, 6000, 4000, 3000, 2000,
      1000, 800, 750, 625, 600, 500, 480, 400, 375, 300, 250, 240, 200, 160,
      150,
    ],
    default: 500,
    numeric: true,
    tip: 'Show each media for a fixed time',
    kindtip: (n) => `Show each media for ${n}ms`,
  },
  interleave_bpm: {
    kind: [
      1, 2, 3, 4, 5, 6, 8, 10, 15, 20, 30, 60, 75, 80, 96, 100, 120, 125, 150,
      160, 200, 240, 250, 300, 375, 400,
    ],
    default: 120,
    numeric: true,
    tip: 'Change media at a fixed rate',
    kindtip: (n) => `Change media ${n} times per minute`,
  },
  interleave_timing: { kind: ['bpm', 'span'], default: 'bpm' },
  interleave_max_samples: {
    kind: [1, 3, 5, 10, Number.POSITIVE_INFINITY],
    default: 3,
    numeric: true,
    tip: 'Maximum number of samples to show before changing media',
    kindtip: (n) =>
      n < Number.POSITIVE_INFINITY
        ? `Show at most ${n} samples before changing media`
        : `Show samples until media exhausted`,
  },
  interleave_sampling: {
    tip: 'Method used to select media samples to interleave',
    kind: ['random', 'sequential', 'incidental'],
    default: 'incidental',
    kindtip: (p) =>
      p === 'incidental'
        ? 'Media are played simultaneously and switched between.'
        : `Samples are selected from each media ${p === 'random' ? 'randomly ' : ''}${p === 'sequential' ? 'sequentially ' : ''} to be interleaved.`,
  },
  repeat_playlist: {
    kind: 'toggle',
    default: true,
    tip: 'Repeat playlist',
    group: 'repeat',
    idx: 1,
    tip: 'Change media at a fixed rate',
    kindtip: (n) => `Change media ${n} times per minute`,
  },
  repeat_playing: {
    kind: 'toggle',
    default: true,
    tip: 'Repeat all currently playing media (stop loading new files in interleave mode)',
    group: 'repeat',
    idx: 2,
  },
  shuffle_on_load: {
    kind: 'toggle',
    default: true,
    tip: 'Shuffle playlist on initial load of directory',
    group: 'repeat',
    idx: 3,
  },
  shuffle_on_repeat: {
    kind: 'toggle',
    default: true,
    tip: 'Shuffle playlist every repeat',
    group: 'repeat',
    idx: 4,
    enable: ['repeat_playlist'],
  },
  reload_on_repeat: {
    kind: 'toggle',
    default: true,
    tip: 'Reload folder contents on playlist repeat',
    group: 'repeat',
    idx: 5,
    enable: ['repeat_playlist'],
  },
  filter: { kind: 'string', default: '.*\.mp4$', hidden: true },
  filelist: {
    kind: ['below', 'beside', 'hide'],
    default: 'hide',
    tip: 'File List location (below/beside/hide)',
    group: 'filelist',
    idx: 1,
  },
  includeImageFiles: {
    kind: 'toggle',
    default: true,
    tip: 'Include image files',
    group: 'filelist',
    idx: 2,
  },
  includeVideoFiles: {
    kind: 'toggle',
    default: true,
    tip: 'Include video files',
    group: 'filelist',
    idx: 3,
  },
  includeOtherFiles: {
    kind: 'toggle',
    default: false,
    tip: 'Include other files',
    group: 'filelist',
    idx: 4,
  },
  includeHiddenFiles: {
    kind: 'toggle',
    default: false,
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

const addGrouping = ({ to, ...attrs } = {}) => {
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
      tip = `Toggle ${name} with value ${display}`,
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

  const toggles = GM_addElement(body, 'section', { class: 'toggles' });

  const actions = (({}) => {
    /**
     * Add current media to a list for review
     */
    const flag = () => {};

    return {
      flag,
    };
  })({});

  const config = (({}) => {
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

    const defineSequence = (defaultValue, values = ['a', 'b', 'c']) => {
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
    const defineConfig = ([name, { kind, default: defaultValue }]) => [
      configTypeMap.has(typeof kind)
        ? [name, configTypeMap.get(typeof kind)(defaultValue, kind)]
        : tee.warn([], `invalid config type for entry ${name}`),
    ];
    return Object.fromEntries(
      Object.entries(defaultConfig).flatMap(defineConfig),
    );
  })({});

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

  (({ to, config, actions }) => {
    const repeatGrouping = addGrouping({ to });
    addToggle({
      textContent: 'Repeat playlist',
      bindTo: config.repeat_playlist,
      name: 'repeat_playlist',
      to: repeatGrouping,
    });
    addToggle({
      textContent: defaultConfig.repeat_playing.tip,
      bindTo: config.repeat_playing,
      name: 'repeat_playing',
      to: repeatGrouping,
    });
    addToggle({
      textContent: 'Shuffle playlist on load',
      bindTo: config.shuffle_on_load,
      name: 'shuffle_on_load',
      to: repeatGrouping,
    });
    addToggle({
      textContent: 'Shuffle playlist every repeat',
      bindTo: config.shuffle_on_repeat,
      name: 'shuffle_on_repeat',
      to: repeatGrouping,
    });
    addToggle({
      textContent: 'Reload folder contents on playlist repeat',
      bindTo: config.reload_on_repeat,
      name: 'reload_on_repeat',
      to: repeatGrouping,
    });
    addSequenceToggle({
      textContent: 'Playback State (playing/paused)',
      bindTo: config.playpause,
      name: 'playpause',
      to,
      sequence: defaultConfig.playpause.kind.map((p) => ({
        value: p,
        tip: `Playback State: ${p}`,
      })),
    });
    addSequenceToggle({
      textContent: 'Pause on blur',
      bindTo: config.pauseonblurtimeout,
      name: 'pauseonblurtimeout',
      defaultSuffix: 's',
      to,
      sequence: defaultConfig.pauseonblurtimeout.kind.map((p) => ({
        value: p,
        tip: defaultConfig.pauseonblurtimeout.kindtip(p),
      })),
    });
    addSequenceToggle({
      textContent: 'Blur on blur',
      bindTo: config.bluronblurtimeout,
      name: 'bluronblurtimeout',
      defaultSuffix: 's',
      to,
      sequence: defaultConfig.bluronblurtimeout.kind.map((p) => ({
        value: p,
        tip: defaultConfig.bluronblurtimeout.kindtip(p),
      })),
    });
    addSequenceToggle({
      textContent: 'On Pause',
      bindTo: config.onpause,
      name: 'onpause',
      to,
      sequence: defaultConfig.onpause.kind.map((p) => ({
        value: p,
        tip: defaultConfig.onpause.kindtip(p),
      })),
    });
    const playerGrouping = addGrouping({ to });
    addSequenceToggle({
      textContent: 'Player Mode (interleave/linear)',
      bindTo: config.player,
      name: 'player',
      sequence: defaultConfig.player.kind.map((p) => ({
        value: p,
        textContent: `Player Mode: ${p}`,
      })),
      to: playerGrouping,
    });
    const interleaveGrouping = addGrouping({ to: playerGrouping });
    addSequenceToggle({
      textContent: 'Max # of media to interleave',
      bindTo: config.interleave_active_player_count,
      name: 'interleave_active_player_count',
      numeric: true,
      sequence: defaultConfig.interleave_active_player_count.kind.map((n) => ({
        value: n,
        textContent: `Interleave up to ${n} media`,
      })),
      to: interleaveGrouping,
    });
    addSequenceToggle({
      textContent: defaultConfig.interleave_max_samples.tip,
      bindTo: config.interleave_max_samples,
      name: 'interleave_max_samples',
      numeric: true,
      sequence: defaultConfig.interleave_max_samples.kind.map((n) => ({
        value: n,
        textContent: defaultConfig.interleave_max_samples.kindtip(n),
      })),
      to: interleaveGrouping,
    });
    addSequenceToggle({
      textContent: defaultConfig.interleave_sampling.tip,
      bindTo: config.interleave_sampling,
      name: 'interleave_sampling',
      numeric: true,
      sequence: defaultConfig.interleave_sampling.kind.map((n) => ({
        value: n,
        textContent: defaultConfig.interleave_sampling.kindtip(n),
      })),
      to: interleaveGrouping,
    });
    addSequenceToggle({
      textContent: 'Interleave timing method',
      bindTo: config.interleave_timing,
      name: 'interleave_timing',
      sequence: defaultConfig.interleave_timing.kind.map((n) => ({
        value: n,
        textContent: `Interleave timing: ${n}`,
      })),
      to: interleaveGrouping,
    });
    addSequenceToggle({
      textContent: 'Change media at a fixed rate',
      bindTo: config.interleave_bpm,
      name: 'interleave_bpm',
      defaultSuffix: 'bpm',
      numeric: true,
      sequence: defaultConfig.interleave_bpm.kind.map((n) => ({
        value: n,
        textContent: `Change media ${n} times per minute`,
      })),
      to: interleaveGrouping,
    });
    addSequenceToggle({
      textContent: 'Show each media for a fixed time',
      bindTo: config.interleave_duration_ms,
      name: 'interleave_duration_ms',
      defaultSuffix: 'ms',
      numeric: true,
      sequence: defaultConfig.interleave_duration_ms.kind.map((n) => ({
        value: n,
        textContent: `Show each media for ${n}ms`,
      })),
      to: interleaveGrouping,
    });
    const gridGrouping = addGrouping({ to: playerGrouping });
    addToggle({
      textContent: 'Display multiple media on a grid',
      bindTo: config.showGrid,
      name: 'grid',
      to: gridGrouping,
    });
    addSequenceToggle({
      textContent: 'Grid fit mode',
      bindTo: config.grid_fit,
      name: 'grid_fit',
      sequence: defaultConfig.grid_fit.kind.map((fit) => ({
        value: fit,
        textContent: `Grid fit mode: ${fit}`,
      })),
      to: gridGrouping,
    });
    const filesGrouping = addGrouping({ to });
    addToggle({
      textContent: 'Include image files',
      bindTo: config.includeImageFiles,
      name: 'images',
      to: filesGrouping,
    });
    addToggle({
      textContent: 'Include video files',
      bindTo: config.includeVideoFiles,
      name: 'video',
      to: filesGrouping,
    });
    addToggle({
      textContent: 'Include other files',
      bindTo: config.includeOtherFiles,
      name: 'other',
      to: filesGrouping,
    });
    addToggle({
      textContent: 'Include hidden files',
      bindTo: config.includeHiddenFiles,
      name: 'hidden',
      to: filesGrouping,
    });
    addSequenceToggle({
      textContent: 'File List location (below/beside/hide)',
      bindTo: config.filelist,
      name: 'filelist',
      sequence: defaultConfig.filelist.kind.map((v) => ({
        value: v,
        textContent: `File List: ${v}`,
      })),
      to: filesGrouping,
    });
    addToggle({
      textContent: 'Debug Mode',
      bindTo: config.debug,
      name: 'debug',
      to,
    });
    const actionsGrouping = addGrouping({ to });
    addAction({
      textContent: 'Flag for review',
      action: actions.flag,
      name: 'flag',
      to: actionsGrouping,
    });
  })({ to: toggles, config, actions });

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

      let currentSrc = null;

      const play = () => {
        currentSrc ??= nextMedia();
        video.volume = 0;
        video.muted = true;
        video.play();
      };
      const pause = () => {
        video.pause();
      };

      let _playbackErrors = 0;
      const maxErrorCount = 10,
        addToCountOnError = 1,
        addToCountOnSuccess = -2;

      const videoA = GM_addElement(wrapper, 'video', {
        preload: '',
        muted: '',
        class: 'a',
        ...attrs,
      });

      const videoB = GM_addElement(wrapper, 'video', {
        preload: '',
        muted: '',
        class: 'b',
        ...attrs,
      });

      const imageI = GM_addElement(wrapper, 'img', {});

      const imageJ = GM_addElement(wrapper, 'img', {});

      const video = videoA;

      /**
       * To ensure every file gets seen when interleaved
       * repeat files shorter than the total time to cycle through all media
       *
       * Cue next media to switch in while not visible, e.g. half a cycle offset
       */
      const oneMinute = 60 * 1000;

      const stepTime = () => (interleave_timing.value === 'bpm' ? (oneMinute / interleave_bpm.value) : interleave_timing.value === 'span' ? interleave_duration_ms.value : Number.POSITIVE_INFINITY);

      const cycleTime = () => stepTime() * interleave_active_player_count.value;

      const cycleOffsetTime = () => stepTime() * idx;

      const nextMediaAfter = (mediaDuration) => mediaDuration > (cycleTime() * interleave_max_samples.value) ? : 
      };

      const nextMedia = async () => {
        const { url, isImage, isVideo } = await nextFile();
        console.debug(
          `nextMedia idx: ${idx}, url: ${url}, isImage: ${isImage}, isVideo: ${isVideo}`,
        );
        if (isVideo) {
          if (wrapper.dataset.active === 'a') {
            videoB.src = url;
            videoB.load();
          } else {
            videoA.src = url;
            videoA.load();
            videoA.addEventListener(
              'canplaythrough',
              () => {
                vide
              },
              { once: true },
            );

          }
          image.removeAttribute('src');
          video.src = url;
          wrapper.dataset.active = 'a';
        } else if (isImage) {
          if (wrapper.dataset.active === 'i') {
            imageJ.src = url;
          } else {
            imageI.src = url;
          }
          video.removeAttribute('src');
          wrapper.dataset.active = 'i';
          setTimeout(nextMedia, imageduration.value * 1000);
        } else {
          setTimeout(nextMedia, 100);
          wrapper.dataset.active = 'x';
        }
      };

      const onLoad = (image) => {};

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

      imageI.addEventListener('load', () => onLoad(imageI), {});

      imageJ.addEventListener('load', () => onLoad(imageJ), {});

      [
        'play',
        'pause',
        'volumechange',
        'canplay',
        'seeked',
        'seeking',
        'timeupdate',
        'durationchange',
        'ratechange',
        'ended',
        'emptied',
        'loadstart',
        'loadeddata',
        'loadedmetadata',
        'progress',
        'waiting',
        'stalled',
        'suspend',
        'error',
      ];
      /* Playback */
      video.addEventListener('volumechange', () => {
        // console.debug(`${idx} volumechange '${decodeURI(video.src)}'`);
      });

      // video.addEventListener('canplay', () => {
      // console.info(`${idx} canplay '${decodeURI(video.src)}'`);
      // });
      video.addEventListener('canplaythrough', () => {
        // console.info(`${idx} canplaythrough '${decodeURI(video.src)}'`);
        play();
      });
      video.addEventListener('seeked', () => {
        console.info`${idx} seeked '${decodeURI(video.src)}'`;
      });
      video.addEventListener('seeking', () => {
        // console.debug(`${idx} seeking '${decodeURI(video.src)}'`);
      });
      video.addEventListener('timeupdate', () => {
        // console.debug(`${idx} timeupdate '${decodeURI(video.src)}'`);
      });
      video.addEventListener('durationchange', () => {
        // console.debug(`${idx} durationchange '${decodeURI(video.src)}'`);
      });
      video.addEventListener('ratechange', () => {
        // console.debug(`${idx} ratechange '${decodeURI(video.src)}'`);
      });
      video.addEventListener('ended', () => {
        // console.info`${idx} ended '${decodeURI(video.src)}'`;

        _playbackErrors = Math.max(0, _playbackErrors + addToCountOnSuccess);

        nextMedia();
      });
      video.addEventListener('emptied', () => {
        // console.info(`${idx} emptied '${decodeURI(video.src)}'`);
      });

      /* Loading */
      video.addEventListener('loadstart', () => {
        // console.debug(`${idx} loadstart '${decodeURI(video.src)}'`);
      });
      video.addEventListener('loadeddata', () => {
        // console.debug(`${idx} loadeddata '${decodeURI(video.src)}'`);
      });
      video.addEventListener('loadedmetadata', () => {
        // console.debug(`${idx} loadedmetadata '${decodeURI(video.src)}'`);
      });
      video.addEventListener('progress', () => {
        // console.debug(`${idx} progress '${decodeURI(video.src)}'`);
      });
      video.addEventListener('waiting', () => {
        // console.info(`${idx} waiting '${decodeURI(video.src)}'`);
      });
      video.addEventListener('stalled', () => {
        console.info(`${idx} stalled '${decodeURI(video.src)}'`);
      });
      video.addEventListener('suspend', () => {
        // console.info(`${idx} suspend '${decodeURI(video.src)}'`);
      });
      video.addEventListener('error', () => {
        console.warn(`${idx} error loading '${decodeURI(video.src)}'`);

        if ((_playbackErrors += addToCountOnError) > maxErrorCount) {
          video.pause();
          video.classList.add('error');
          console.warn(`${idx} exceeded max error count`);
        } else {
          nextMedia();
        }
      });

      return {
        wrapper,
        player: video,
        play,
        pause,
        enable: () => {
          video.classList.remove('off');
        },
        disable: () => {
          video.pause();
          video.removeAttribute('src');
          video.classList.add('off');
          image.removeAttribute('src');
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

  breadcrumbs({ to: qs`body`.one });

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
