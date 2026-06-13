// ==UserScript==
// @name        browseWithPreview
// @namespace   mayhem
// @version     1.0.390
// @author      flowsINtomAyHeM
// @description File browser with media preview
// @downloadURL http://localhost:3333/vm/browseWithPreview.user.js
// @match       *://localhost/*/*
// @match       file:///*/*
// @grant       GM_info
// @grant       GM_addStyle
// @grant       GM_addElement
// @grant       GM_getValue
// @grant       GM_setValue
// @grant       GM_registerMenuCommand
// @grant       GM_addValueChangeListener
// @grant       GM_xmlhttpRequest
// @require     http://localhost:3333/vm/util.user.js
// @cssBaseUrl  http://localhost:3333/vm/
// @cssBaseName browseWithPreview
// @run-at      document-start
// ==/UserScript==

/**
 * // @injectIQB-into auto
 *
 */

// return {
//   filelist: defineSequence(sequences.filelist, 'hide'),
//   imageDuration: defineNumber(5),
//   includeImageFiles: defineToggle(true),
//   includeVideoFiles: defineToggle(true),
//   includeOtherFiles: defineToggle(false),
//   includeHiddenFiles: defineToggle(false),
//   playpause: defineSequence(sequences.playpause, 'playing'),
//   showGrid: defineToggle(false),
//   grid_fit: defineSequence(sequences.fit),
//   player: defineSequence(sequences.player, 'interleave'),
//   interleave_active_player_count: defineNumber(9),
//   interleave_duration_ms: defineNumber(500),
//   interleave_bpm: defineNumber(140),
//   interleave_timing: defineSequence(sequences.interleave_timing, 'bpm'),
//   repeat: defineToggle(true),
//   shuffle_on_load: defineToggle(true),
//   shuffle_on_repeat: defineToggle(true),
//   reload_on_repeat: defineToggle(true),
//   filter: defineString('.*\.mp4$'),
//   debug: defineToggle(false),
// };
// const sequences = {
//   showGrid: ['pause', 'always', 'never'],
//   fit: ['auto', 'contain', 'cover', 'fitw', 'fith'],
//   filelist: ['below', 'beside', 'hide'],
//   playpause: ['playing', 'paused'],
//   player: ['interleave', 'linear'],
//   interleave_timing: ['bpm', 'span'],
//   interleave_duration_ms: [
//     60000, 30000, 20000, 15000, 10000, 6000, 4000, 3000, 2000, 1000, 800, 750,
//     625, 600, 500, 480, 400, 375, 300, 250, 240, 200, 160, 150,
//   ],
//   interleave_bpm: [
//     1, 2, 3, 4, 6, 10, 15, 20, 30, 60, 75, 80, 96, 100, 120, 125, 150, 160, 200,
//     240, 250, 300, 375, 400,
//   ],
//   interleave_active_player_count: [2, 3, 4, 6, 9, 12, 16],
// };

const defaultConfig = {
  filelist: { kind: ['below', 'beside', 'hide'], default: 'hide' },
  includeImageFiles: { kind: 'toggle', default: true },
  includeVideoFiles: { kind: 'toggle', default: true },
  includeOtherFiles: { kind: 'toggle', default: false },
  includeHiddenFiles: { kind: 'toggle', default: false },
  playpause: {
    kind: ['playing', 'paused'],
    default: 'playing',
    tip: 'Playback State (playing/paused)',
    kindtip: `Playback State: ${p}`,
    idx: 1,
  },
  showGrid: { kind: ['pause', 'always', 'never'], default: 'pause' },
  blurOn: { kind: ['pause', 'blur', 'never'], default: 'blur' },
  grid_fit: {
    kind: ['auto', 'contain', 'cover', 'fitw', 'fith'],
    default: 'contain',
  },
  imageDuration: { kind: 'number', default: 5 },
  player: {
    kind: ['linear', 'interleave'],
    default: 'interleave',
    tip: 'Player Mode (interleave/linear)',
    kindtip: `Player Mode: ${p}`,
    group: 'player',
    idx: 1,
  },
  interleave_active_player_count: {
    kind: [2, 3, 4, 6, 9, 12, 16],
    default: 9,
    tip: 'Max # of interleaved videos',
    kindtip: `Max of ${n} interleaved videos`,
    numeric: true,
    group: 'interleave',
    idx: 1,
  },
  interleave_duration_ms: {
    kind: [
      60000, 30000, 20000, 15000, 10000, 6000, 4000, 3000, 2000, 1000, 800, 750,
      625, 600, 500, 480, 400, 375, 300, 250, 240, 200, 160, 150,
    ],
    default: 500,
  },
  interleave_bpm: {
    kind: [
      1, 2, 3, 4, 6, 10, 15, 20, 30, 60, 75, 80, 96, 100, 120, 125, 150, 160,
      200, 240, 250, 300, 375, 400,
    ],
    default: 120,
  },
  interleave_timing: { kind: ['bpm', 'span'], default: 'bpm' },
  repeat: {
    kind: 'toggle',
    default: true,
    tip: 'Repeat playlist',
    group: 'repeat',
    idx: 1,
  },
  shuffle_on_load: {
    kind: 'toggle',
    default: true,
    tip: 'Shuffle playlist on load',
    group: 'repeat',
    idx: 2,
  },
  shuffle_on_repeat: {
    kind: 'toggle',
    default: true,
    tip: 'Shuffle playlist every repeat',
    group: 'repeat',
    idx: 3,
  },
  reload_on_repeat: {
    kind: 'toggle',
    default: true,
    tip: 'Reload folder contents on playlist repeat',
    group: 'repeat',
    idx: 4,
  },
  filter: { kind: 'string', default: '.*\.mp4$' },
  debug: { kind: 'toggle', default: false },
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
  tag = 'input',
  type = 'radio',
  name = '',
  bindTo,
  textContent = `Toggle for ${name}`,
  sequence = [],
  numeric = false,
  ...attrs
} = {}) => {
  const div = GM_addElement(to, 'div', {
    class: `sequence toggle ${numeric ? 'numeric' : ''}`,
    'data-text': textContent,
    ...attrs,
  });
  sequence.forEach(
    ({
      value,
      display = value,
      checked = bindTo?.value === value ?? false,
      textContent = name,
    }) => {
      const label = GM_addElement(div, 'label', {
        class: '',
        'data-name': name,
        'data-value': `${value}`,
        'data-value-len': `${value}`.length,
        'data-value-display': `${display}`,
        'data-value-display-len': `${display}`.length,
        'data-text': textContent,
        for: `${name}_${value}`,
      });
      GM_addElement(label, 'span', {
        class: 'tip',
        textContent,
      });
      const input = GM_addElement(label, tag, {
        type,
        ...(checked ? { checked: '' } : {}),
        name,
        value,
        id: `${name}_${value}`,
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
  return div;
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

    const defineSequence = (_vals = ['a', 'b', 'c'], _val = _vals[0]) => {
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
        if (_vals.indexOf(newValue) > -1) {
          _val = newValue;
          notify();
        }
        return _val;
      };
      const toggle = () => set(_vals[(_vals.indexOf(_val) + 1) % _vals.length]);

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
    const configTypeMap = new Map([
      ['string', defineString],
      ['object', defineSequence],
      ['number', defineNumber],
      ['boolean', defineToggle],
    ]);
    const defineConfig = ([name, { kind, default: defaultValue }]) => [
      configTypeMap.has(typeof kind)
        ? [name, configTypeMap.get(typeof kind)(defaultValue)]
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

  (({
    to,
    config: {
      filelist,
      includeImageFiles,
      includeVideoFiles,
      includeOtherFiles,
      includeHiddenFiles,
      interleave_active_player_count,
      interleave_duration_ms,
      interleave_timing,
      interleave_bpm,
      showGrid,
      grid_fit,
      playpause,
      player,
      repeat,
      shuffle_on_load,
      shuffle_on_repeat,
      reload_on_repeat,
      debug,
    },
    actions: { flag },
  }) => {
    const repeatGrouping = addGrouping({ to });
    addToggle({
      textContent: 'Repeat playlist',
      bindTo: repeat,
      name: 'repeat',
      to: repeatGrouping,
    });
    addToggle({
      textContent: 'Shuffle playlist on load',
      bindTo: shuffle_on_load,
      name: 'shuffle_on_load',
      to: repeatGrouping,
    });
    addToggle({
      textContent: 'Shuffle playlist every repeat',
      bindTo: shuffle_on_repeat,
      name: 'shuffle_on_repeat',
      to: repeatGrouping,
    });
    addToggle({
      textContent: 'Reload folder contents on playlist repeat',
      bindTo: reload_on_repeat,
      name: 'reload_on_repeat',
      to: repeatGrouping,
    });
    addSequenceToggle({
      textContent: 'Playback State (playing/paused)',
      bindTo: playpause,
      name: 'playpause',
      to,
      sequence: defaultConfig.playpause.kind.map((p) => ({
        value: p,
        textContent: `Playback State: ${p}`,
      })),
    });
    const playerGrouping = addGrouping({ to });
    addSequenceToggle({
      textContent: 'Player Mode (interleave/linear)',
      bindTo: player,
      name: 'player',
      sequence: defaultConfig.player.kind.map((p) => ({
        value: p,
        textContent: `Player Mode: ${p}`,
      })),
      to: playerGrouping,
    });
    const interleaveGrouping = addGrouping({ to: playerGrouping });
    addSequenceToggle({
      textContent: 'Max # of interleaved videos',
      bindTo: interleave_active_player_count,
      name: 'interleave_active_player_count',
      numeric: true,
      sequence: defaultConfig.interleave_active_player_count.kind.map((n) => ({
        value: n,
        textContent: `Max of ${n} interleaved videos`,
      })),
      to: interleaveGrouping,
    });
    addSequenceToggle({
      textContent: 'Interleave timing method',
      bindTo: interleave_timing,
      name: 'interleave_timing',
      sequence: defaultConfig.interleave_timing.kind.map((n) => ({
        value: n,
        textContent: `Interleave timing: ${n}`,
      })),
      to: interleaveGrouping,
    });
    addSequenceToggle({
      textContent: 'Change media at a fixed rate',
      bindTo: interleave_bpm,
      name: 'interleave_bpm',
      numeric: true,
      sequence: defaultConfig.interleave_bpm.kind.map((n) => ({
        value: n,
        textContent: `Change media ${n} times per minute`,
      })),
      to: interleaveGrouping,
    });
    addSequenceToggle({
      textContent: 'Show each media for a fixed time',
      bindTo: interleave_duration_ms,
      name: 'interleave_duration_ms',
      numeric: true,
      sequence: defaultConfig.interleave_duration_ms.kind.map((n) => ({
        value: n,
        textContent: `Show each media for ${n}ms`,
      })),
      to: interleaveGrouping,
    });
    const gridGrouping = addGrouping({ to: playerGrouping });
    addSequenceToggle({
      textContent: 'Display multiple media on a grid',
      bindTo: showGrid,
      name: 'grid',
      sequence: defaultConfig.showGrid.kind.map((p) => ({
        value: p,
        textContent: `Show multiple media on a grid (${p})`,
      })),
      to: gridGrouping,
    });
    addSequenceToggle({
      textContent: 'Grid fit mode',
      bindTo: grid_fit,
      name: 'grid_fit',
      sequence: defaultConfig.fit.kind.map((fit) => ({
        value: fit,
        textContent: `Grid fit mode: ${fit}`,
      })),
      to: gridGrouping,
    });
    const filesGrouping = addGrouping({ to });
    addToggle({
      textContent: 'Include image files',
      bindTo: includeImageFiles,
      name: 'images',
      to: filesGrouping,
    });
    addToggle({
      textContent: 'Include video files',
      bindTo: includeVideoFiles,
      name: 'video',
      to: filesGrouping,
    });
    addToggle({
      textContent: 'Include other files',
      bindTo: includeOtherFiles,
      name: 'other',
      to: filesGrouping,
    });
    addToggle({
      textContent: 'Include hidden files',
      bindTo: includeHiddenFiles,
      name: 'hidden',
      to: filesGrouping,
    });
    addSequenceToggle({
      textContent: 'File List location (below/beside/hide)',
      bindTo: filelist,
      name: 'filelist',
      sequence: defaultConfig.filelist.kind.map((v) => ({
        value: v,
        textContent: `File List: ${v}`,
      })),
      to: filesGrouping,
    });
    addToggle({
      textContent: 'Debug Mode',
      bindTo: debug,
      name: 'debug',
      to,
    });
    const actionsGrouping = addGrouping({ to });
    addAction({
      textContent: 'Flag for review',
      action: flag,
      name: 'flag',
      to: actionsGrouping,
    });
  })({ to: toggles, config, actions });

  const addWrappedVideo = (
    ({ window: { console }, config: { playpause } }) =>
    ({ to, idx, nextFile, autoplay = false, muted = true, ...attrs } = {}) => {
      const wrapper = GM_addElement(to, 'div', { class: `vidwrap i${idx}` });
      wrapper.style.setProperty('--playerIdx', idx);
      wrapper.style.setProperty('--s-playerIdx', `'${idx}'`);

      const video = GM_addElement(wrapper, 'video', {
        autoplay,
        muted,
        ...attrs,
      });

      playpause.subscribe((newValue) => {
        newValue === 'playing' && video.play();
        newValue === 'paused' && video.pause();
      });

      const playNext = async () => {
        video.src = (await nextFile()) ?? video.src;
      };
      let _playbackErrors = 0;
      const maxErrorCount = 10,
        addToCountOnError = 1,
        addToCountOnSuccess = -2;

      video.addEventListener(
        'play',
        () => {
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
        },
        {},
      );
      video.addEventListener(
        'pause',
        () => {
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
        },
        {},
      );

      /* Playback */
      video.addEventListener('volumechange', () => {
        // console.debug(`${idx} volumechange '${decodeURI(video.src)}'`);
      });

      video.addEventListener('canplay', () => {
        // console.info(`${idx} canplay '${decodeURI(video.src)}'`);
      });
      video.addEventListener('canplaythrough', () => {
        // console.info(`${idx} canplaythrough '${decodeURI(video.src)}'`);
        video.volume = 0;
        video.muted = true;
        video.play();
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

        playNext();
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
          playNext();
        }
      });

      if (autoplay !== false) {
        playNext();
      }
      return {
        wrapper,
        player: video,
        play: () => video.play(),
        pause: () => video.pause(),
        enable: () => {
          wrapper.classList.remove('off');
          playNext();
          video.play();
        },
        disable: () => {
          video.pause();
          video.src = '';
          video.classList.add('off');
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

      const updateFilter = () => {
        const exts = {
          video: ['mp4', 'mov'],
          image: ['jpg', 'jpeg', 'png'],
        };
        // filter: defineString('.*\.mp4$'),
        // ^.*\.(?:mp4|mov)$|^.*\.(?:jpg|jpeg|png|)$|^.*\.(?:)$
        const matchVideo = `^.*\.(?:${exts.video.join('|')})`;
        const matchImage = `^.*\.(?:${exts.image.join('|')})`;
        const matchOther = `^.*(?<!\.(?:${[...exts.video, ...exts.image].join('|')}))$`;
        return new RegExp(
          [
            includeImageFiles.value ? matchImage : [],
            includeVideoFiles.value ? matchVideo : [],
            includeOtherFiles.value ? matchOther : [],
          ]
            .flat()
            .join('|'),
        );
      };

      let _shuffled = false,
        _filter = updateFilter(),
        _filtered_length = null;

      const load = () => {
        files = [...document.querySelectorAll('a.file')].map((file) =>
          file.getAttribute('href'),
        );
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
          for (const file of files.filter((x) => _filter.test(x))) {
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
        // repeat.subscribe((newValue) => ),
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
            ...files.filter((x) => x.match(_filter)),
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

  const interleavePlayer = (({
    to,
    config: { interleave_active_player_count },
  }) => {
    const interleavePlayerContainer = GM_addElement(to, 'section', {
      class: 'player interleave paused',
    });

    GM_addElement(interleavePlayerContainer, 'label', {
      for: 'playpause_playing',
    });
    GM_addElement(interleavePlayerContainer, 'label', {
      for: 'playpause_paused',
    });
    const filelist = getFileList();

    const nextFile = async () => decodeURI(await filelist.next());

    const mediaPlayers = [
      ...mapIter(
        rangeIter({
          start: 0,
          count: Math.max(...defaultConfig.interleave_active_player_count.kind),
        }),
        (i) =>
          addWrappedVideo({
            to: interleavePlayerContainer,
            class: `i${i}`,
            id: `i${i}`,
            idx: i,
            src: '',
            nextFile,
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

    // const grid = (showAsGrid = !_showAsGrid) => {
    //   if (_showAsGrid !== showAsGrid) {
    //     _showAsGrid = showAsGrid;
    //     if (_showAsGrid) {
    //       container.classList.add('grid');
    //     } else {
    //       container.classList.remove('grid');
    //     }
    //   }
    // };

    const play = () => {
      activeMediaPlayers().forEach((mediaPlayer) => {
        mediaPlayer.play();
      });
      interleavePlayerContainer.classList.add('playing');
      interleavePlayerContainer.classList.remove('paused');
    };
    const pause = () => {
      mediaPlayers.forEach((mediaPlayer) => {
        mediaPlayer.pause();
      });
      interleavePlayerContainer.classList.add('paused');
      interleavePlayerContainer.classList.remove('playing');
    };

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
  //     addWrappedVideo({ to: container, class: cl }),
  //   );

  //   const filelist = getFileList({ repeat: true, shuffle: false });

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

  interleavePlayer.play();
};

const browsePreviewToggleIds = addStyleToggles([
  {
    title: 'browse with preview',
    enabled: isDirectory,
    sources: [
      {
        baseName: 'browseWithPreview',
      },
    ],
  },
  {
    title: 'blur on blur',
    enabled: true,
    sources: [
      {
        baseName: 'bluronblur',
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

            // bluronblur({ timeout: 10 });
          }
        }),
      ]);
    })
    .catch((e) => console.warn(e)),
);

//     Object.defineProperties(target, {
//       [name]: {
//       get: () => _val,
//       set: (newVal) => {
//         _val = newVal;
//         subs.forEach((sub) => sub(_val));
//         return _val;
//       },
//       enumerable: false,
//       configurable: false,
//     },
//       [`toggle_${name}`]: {
//       get: () => _val,
//       set: (newVal) => {
//         _val = newVal;
//         subs.forEach((sub) => sub(_val));
//         return _val;
//       },
//       enumerable: false,
//       configurable: false,
//     },
//     })
