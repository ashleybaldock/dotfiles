// ==UserScript==
// @name        browseWithPreview
// @namespace   mayhem
// @version     1.0.340
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

const sequences = {
  fit: ['auto', 'contain', 'cover', 'fitw', 'fith'],
  filelist: ['below', 'beside', 'hide'],
  playpause: ['playing', 'paused'],
  player: ['interleave', 'linear'],
  interleave_timing: ['bpm', 'span'],
  interleave_duration_ms: [100, 200, 300, 400, 500, 600, 700, 800, 900],
  interleave_bpm: [
    60, 70, 80, 90, 100, 110, 120, 140, 150, 160, 170, 180, 190, 200,
  ],
  interleave_active_player_count: [2, 3, 4, 6, 9, 12, 16],
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
  const span = GM_addElement(label, 'span', {
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
  ...attrs
} = {}) => {
  const div = GM_addElement(to, 'div', {
    class: 'sequence toggle',
    'data-text': textContent,
    ...attrs,
  });
  sequence.forEach(
    ({
      value,
      checked = bindTo?.value === value ?? false,
      textContent = name,
    }) => {
      const label = GM_addElement(div, 'label', {
        class: '',
        'data-name': name,
        'data-value': value,
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
            bindTo.value = e.target.checked;
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

const addWrappedVideo = (
  ({
    window: {
      notify: { log, info },
    },
  }) =>
  ({ to, idx, nextFile, autoplay = true, muted = true, ...attrs } = {}) => {
    const wrapper = GM_addElement(to, 'div', { class: `vidwrap i${idx}` });
    wrapper.style.setProperty('--playerIdx', idx);
    wrapper.style.setProperty('--s-playerIdx', `'${idx}'`);

    const playLabel = GM_addElement(wrapper, 'label', {
      for: 'playpause_playing',
    });
    const pauseLabel = GM_addElement(wrapper, 'label', {
      for: 'playpause_paused',
    });
    const video = GM_addElement(wrapper, 'video', {
      autoplay,
      muted,
      ...attrs,
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
        info(`${idx} playing '${decodeURI(video.src)}'`);

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
        info`${idx} paused '${decodeURI(video.src)}'`;

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
      // notify.debug(`${idx} volumechange '${decodeURI(video.src)}'`);
    });

    video.addEventListener('canplay', () => {
      info`${idx} canplay '${decodeURI(video.src)}'`;
    });
    video.addEventListener('canplaythrough', () => {
      info`${idx} canplaythrough '${decodeURI(video.src)}'`;
      video.volume = 0;
      video.muted = true;
      video.play();
    });
    video.addEventListener('seeked', () => {
      info`${idx} seeked '${decodeURI(video.src)}'`;
    });
    video.addEventListener('seeking', () => {
      // debug`${idx} seeking '${decodeURI(video.src)}'`;
    });
    video.addEventListener('timeupdate', () => {
      // debug`${idx} timeupdate '${decodeURI(video.src)}'`;
    });
    video.addEventListener('durationchange', () => {
      debug`${idx} durationchange '${decodeURI(video.src)}'`;
    });
    video.addEventListener('ratechange', () => {
      debug`${idx} ratechange '${decodeURI(video.src)}'`;
    });
    video.addEventListener('ended', () => {
      info`${idx} ended '${decodeURI(video.src)}'`;

      _playbackErrors = Math.max(0, _playbackErrors + addToCountOnSuccess);

      playNext();
    });
    video.addEventListener('emptied', () => {
      info(`${idx} emptied '${decodeURI(video.src)}'`);
    });

    /* Loading */
    video.addEventListener('loadstart', () => {
      debug(`${idx} loadstart '${decodeURI(video.src)}'`);
    });
    video.addEventListener('loadeddata', () => {
      debug(`${idx} loadeddata '${decodeURI(video.src)}'`);
    });
    video.addEventListener('loadedmetadata', () => {
      debug(`${idx} loadedmetadata '${decodeURI(video.src)}'`);
    });
    video.addEventListener('progress', () => {
      // debug(`${idx} progress '${decodeURI(video.src)}'`);
    });
    video.addEventListener('waiting', () => {
      info(`${idx} waiting '${decodeURI(video.src)}'`);
    });
    video.addEventListener('stalled', () => {
      info(`${idx} stalled '${decodeURI(video.src)}'`);
    });
    video.addEventListener('suspend', () => {
      info(`${idx} suspend '${decodeURI(video.src)}'`);
    });
    video.addEventListener('error', () => {
      warn(`${idx} error loading '${decodeURI(video.src)}'`);

      if ((_playbackErrors += addToCountOnError) > maxErrorCount) {
        video.pause();
        video.classList.add('error');
        warn`${idx} exceeded max error count`;
      } else {
        playNext();
      }
    });

    if (autoplay !== false) {
      playNext();
    }
    return { wrapper, player: video, play: video.play(), pause: video.pause() };
  }
)({ window });

const initBrowsePreview = ({ document: { body } }) => {
  const players = GM_addElement(body, 'section', { class: 'players' });

  const toggles = GM_addElement(body, 'section', { class: 'toggles' });

  const config = (({}) => {
    const root = {};

    const defineString = (_val = '') => {
      const subs = new Set();

      const notify = () =>
        Promise.allSettled(subs.map((sub) => Promise.resolve(sub(_val))));

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
        Promise.allSettled(subs.map((sub) => Promise.resolve(sub(_val))));

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
        Promise.allSettled(subs.map((sub) => Promise.resolve(sub(_val))));

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
        Promise.allSettled(subs.map((sub) => Promise.resolve(sub(_val))));

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
    return {
      filelist: defineSequence(sequences.filelist, 'below'),
      imageDuration: defineNumber(5),
      includeImageFiles: defineToggle(true),
      includeVideoFiles: defineToggle(true),
      includeOtherFiles: defineToggle(false),
      includeHiddenFiles: defineToggle(false),
      playpause: defineSequence(sequences.playpause, 'playing'),
      showGrid: defineToggle(false),
      grid_fit: defineSequence(sequences.fit),
      player: defineSequence(sequences.player, 'interleave'),
      interleave_active_player_count: defineNumber(6),
      interleave_duration_ms: defineNumber(500),
      interleave_bpm: defineNumber(120),
      interleave_timing: defineSequence(sequences.interleave_timing, 'bpm'),
      repeat: defineToggle(true),
      shuffle_on_load: defineToggle(true),
      shuffle_on_repeat: defineToggle(true),
      reload_on_repeat: defineToggle(true),
      filter: defineString('.*\.mp4$'),
      debug: defineToggle(false),
    };
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
      setRegisteredCSSProp({
        name: '--interleave-active-player-count',
        value: newValue,
        syntax: '<integer>',
      });
    });
    interleave_bpm.subscribe((newValue) => {
      setRegisteredCSSProp({
        name: '--interleave-bpm',
        value: `${newValue}`,
        syntax: '<number>',
      });
    });
    interleave_duration_ms.subscribe((newValue) => {
      setRegisteredCSSProp({
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
      sequence: sequences.playpause.map((p) => ({
        value: p,
        textContent: `Playback State: ${p}`,
      })),
    });
    const playerGrouping = addGrouping({ to });
    addSequenceToggle({
      textContent: 'Player Mode (interleave/linear)',
      bindTo: player,
      name: 'player',
      sequence: sequences.player.map((p) => ({
        value: p,
        textContent: `Player Mode: ${p}`,
      })),
      to: playerGrouping,
    });
    const interleaveGrouping = addGrouping({ to: playerGrouping });
    addSequenceToggle({
      textContent: 'Interleave timing method',
      bindTo: interleave_timing,
      name: 'interleave_timing',
      sequence: sequences.interleave_timing.map((n) => ({
        value: n,
        textContent: `Interleave timing: ${n}`,
      })),
      to: interleaveGrouping,
    });
    addSequenceToggle({
      textContent: 'Max # of interleaved videos',
      bindTo: interleave_active_player_count,
      name: 'interleave_active_player_count',
      sequence: sequences.interleave_active_player_count.map((n) => ({
        value: n,
        textContent: `Max of ${n} interleaved videos`,
      })),
      to: interleaveGrouping,
    });
    addSequenceToggle({
      textContent: 'Change video to match bpm',
      bindTo: interleave_bpm,
      name: 'interleave_bpm',
      sequence: sequences.interleave_bpm.map((n) => ({
        value: n,
        textContent: `Change video to match ${n}bpm`,
      })),
      to: interleaveGrouping,
    });
    addSequenceToggle({
      textContent: 'Show each video for',
      bindTo: interleave_duration_ms,
      name: 'interleave_duration_ms',
      sequence: sequences.interleave_duration_ms.map((n) => ({
        value: n,
        textContent: `Show each video for ${n}ms`,
      })),
      to: interleaveGrouping,
    });
    const gridGrouping = addGrouping({ to: playerGrouping });
    addToggle({
      textContent: 'Show as Grid',
      bindTo: showGrid,
      name: 'grid',
      to: gridGrouping,
    });
    addSequenceToggle({
      textContent: 'Grid fit mode',
      bindTo: grid_fit,
      name: 'grid_fit',
      sequence: sequences.fit.map((fit) => ({
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
      textContent: 'File List (below/beside/hide)',
      bindTo: filelist,
      name: 'filelist',
      sequence: sequences.filelist.map((v) => ({
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
  })({ to: toggles, config });

  const getFileList = (
    ({
      config: {
        repeat,
        shuffle_on_load,
        shuffle_on_repeat,
        reload_on_repeat,
        filter,
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
        // filesIter = filteredFiles();
        _shuffled = false;
      };

      async function* filteredFiles() {
        files ?? load();

        while (true) {
          for (const file of files.filter((x) => _filter.test(x))) {
            // yield Promise.resolve({ done: false, value: file });
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

      const unsubs = [
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
    const container = GM_addElement(to, 'section', {
      class: 'player interleave paused',
    });

    const filelist = getFileList();

    const nextFile = async () => decodeURI(await filelist.next());

    const mediaPlayers = [
      ...mapIter(
        rangeIter({
          start: 0,
          count: Math.max(...sequences.interleave_active_player_count),
        }),
        (i) =>
          addWrappedVideo({
            to: container,
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

    const updateMediaPlayers = (activePlayerCount) => {
      mediaPlayers.forEach((mediaPlayer, i) => {
        if (i < activePlayerCount) {
          mediaPlayer.classList.remove('off');
        } else {
          mediaPlayer.pause();
          mediaPlayer.src = '';
          mediaPlayer.classList.add('off');
        }
      });
    };

    interleave_active_player_count.subscribe(updateMediaPlayers);

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
      // updateMediaPlayers();
      activeMediaPlayers().forEach((mediaPlayer) => {
        mediaPlayer.querySelector('video').play();
      });
      container.classList.add('playing');
      container.classList.remove('paused');
    };
    const pause = () => {
      // updateMediaPlayers();
      mediaPlayers.forEach((mediaPlayer) => {
        mediaPlayer.pause();
      });
      container.classList.add('paused');
      container.classList.remove('playing');
    };

    // const onClickContainer = () => {
    //   if (container.classList.contains('playing')) {
    //     pause();
    //   } else if (container.classList.contains('paused')) {
    //     play();
    //   }
    // };
    // container.addEventListener('click', onClickContainer, {});

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
        (e) => {
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

  // document.querySelector('body').dataset.playmode = 'interleave';

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
    .then(({ window, unsafeWindow }) => {
      console.debug('document ready');

      return Promise.all([
        matchExistsFor('a.file').then((node) => {
          if (isDirectory) {
            initBrowsePreview(unsafeWindow);

            bluronblur({ timeout: 10 });
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
