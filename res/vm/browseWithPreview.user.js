// ==UserScript==
// @name        browseWithPreview
// @namespace   mayhem
// @version     1.0.244
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
  interleave_delay: [100, 200, 300, 400, 500, 600, 700, 800, 900],
  max_interleaved: [2, 3, 4, 6, 9, 12, 16],
};

const isDirectory = (({ document }) =>
  qs`:has([href="chrome://global/skin/dirListing/dirListing.css"])`.hasSome)(
  unsafeWindow,
);

const overrideFileListClicks = () => {
  qs`a.file`.all.forEach((link) =>
    link.addEventListener('click', (e) => {
      qs`video`.all.setAttribute('src', link.getAttribute('href'));
      e.preventDefault();
      return false;
    }),
  );
};

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
  options = {
    to,
    class: `i${[...to.querySelectorAll('.vidwrap')].length + 1}`,
    autoplay: '',
    muted: '',
  },
) => {
  const wrapper = GM_addElement(to, 'div', { class: 'vidwrap' });
  const playLabel = GM_addElement(wrapper, 'label', { for: 'toggle_playing' });
  const pauseLabel = GM_addElement(wrapper, 'label', { for: 'toggle_paused' });
  const idx = () => wrapper.style.getPropertyValue('--playerIdx');
  const video = GM_addElement(wrapper, 'video', options);

  video.addEventListener(
    'play',
    () => {
      console.info(`${idx()} playing '${decodeURI(video.src)}'`);

      video.classList.remove('paused');
      video.classList.add('playing');

      document
        .querySelectorAll(
          `body > table > tbody > tr:has([href="${video.src.split('/').slice(-1)}"])`,
        )
        .forEach((tr) => {
          tr.classList.remove('paused');
          tr.classList.add('playing');
          tr.style.setProperty('--playerIdx', idx());
          tr.style.setProperty('--s-playerIdx', `'${idx()}'`);

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
      console.info(`${idx()} paused '${decodeURI(video.src)}'`);

      video.classList.remove('playing');
      video.classList.add('paused');

      document
        .querySelectorAll(
          `body > table > tbody > tr:has([href="${video.src.split('/').slice(-1)}"])`,
        )
        .forEach((tr) => {
          tr.classList.remove('playing');
          tr.classList.add('paused');
          tr.style.setProperty('--playerIdx', idx());
          tr.style.setProperty('--s-playerIdx', `'${idx()}'`);
        });
    },
    {},
  );

  /* Playback */
  video.addEventListener('volumechange', () => {
    // console.debug(`${idx()} volumechange '${decodeURI(video.src)}'`);
  });

  video.addEventListener('canplay', () => {
    console.info(`${idx()} canplay '${decodeURI(video.src)}'`);
  });
  video.addEventListener('canplaythrough', () => {
    console.info(`${idx()} canplaythrough '${decodeURI(video.src)}'`);
    video.volume = 0;
    video.muted = true;
    video.play();
  });
  video.addEventListener('seeked', () => {
    console.info(`${idx()} seeked '${decodeURI(video.src)}'`);
  });
  video.addEventListener('seeking', () => {
    // console.debug(`${idx()} seeking '${decodeURI(video.src)}'`);
  });
  video.addEventListener('timeupdate', () => {
    // console.debug(`${idx()} timeupdate '${decodeURI(video.src)}'`);
  });
  video.addEventListener('durationchange', () => {
    console.debug(`${idx()} durationchange '${decodeURI(video.src)}'`);
  });
  video.addEventListener('ratechange', () => {
    console.debug(`${idx()} ratechange '${decodeURI(video.src)}'`);
  });
  video.addEventListener('ended', () => {
    console.info(`${idx()} ended '${decodeURI(video.src)}'`);
  });
  video.addEventListener('emptied', () => {
    console.info(`${idx()} emptied '${decodeURI(video.src)}'`);
  });

  /* Loading */
  video.addEventListener('loadstart', () => {
    console.debug(`${idx()} loadstart '${decodeURI(video.src)}'`);
  });
  video.addEventListener('loadeddata', () => {
    console.debug(`${idx()} loadeddata '${decodeURI(video.src)}'`);
  });
  video.addEventListener('loadedmetadata', () => {
    console.debug(`${idx()} loadedmetadata '${decodeURI(video.src)}'`);
  });
  video.addEventListener('progress', () => {
    // console.debug(`${idx()} progress '${decodeURI(video.src)}'`);
  });
  video.addEventListener('waiting', () => {
    console.info(`${idx()} waiting '${decodeURI(video.src)}'`);
  });
  video.addEventListener('stalled', () => {
    console.info(`${idx()} stalled '${decodeURI(video.src)}'`);
  });
  video.addEventListener('suspend', () => {
    console.info(`${idx()} suspend '${decodeURI(video.src)}'`);
  });
  video.addEventListener('error', () => {
    console.warn(`${idx()} error loading '${decodeURI(video.src)}'`);
  });
  return { wrapper, player: video };
};

const initBrowsePreview = ({ document: { body } }) => {
  const players = GM_addElement(body, 'section', { class: 'players' });

  const toggles = GM_addElement(body, 'section', { class: 'toggles' });

  const config = (({}) => {
    const root = {};

    const defineString = (_val = '') => {
      const subs = new Set();

      const notify = () => {
        subs.forEach((sub) => sub(_val));
      };
      return {
        get value() {
          return _val;
        },
        set value(newValue) {
          _val = newValue;
          notify();
          return _val;
        },
        set: (newValue) => {
          _val = newValue;
          notify();
          return _val;
        },
        subscribe: (callback) => {
          subs.add(callback);
          return () => subs.remove(callback);
        },
      };
    };

    const defineNumber = (_val = 0) => {
      const subs = new Set();

      const notify = () => {
        subs.forEach((sub) => sub(_val));
      };
      return {
        get value() {
          return _val;
        },
        set value(newValue) {
          _val = newValue;
          notify();
          return _val;
        },
        set: (newValue) => {
          _val = newValue;
          notify();
          return _val;
        },
        subscribe: (callback) => {
          subs.add(callback);
          return () => subs.remove(callback);
        },
      };
    };

    const defineToggle = (_val = false) => {
      const subs = new Set();

      const notify = () => {
        subs.forEach((sub) => sub(_val));
      };

      return {
        get value() {
          return _val;
        },
        set value(newValue) {
          _val = newValue;
          notify();
          return _val;
        },
        set: (newValue) => {
          _val = newValue;
          notify();
          return _val;
        },
        toggle: () => {
          _val = !_val;
          notify();
          return _val;
        },
        subscribe: (callback) => {
          subs.add(callback);
          return () => subs.remove(callback);
        },
      };
    };

    const defineSequence = (_vals = ['a', 'b', 'c'], _val = _vals[0]) => {
      const subs = new Set();

      const notify = () => {
        subs.forEach((sub) => sub(_val));
      };
      const subscribe = (callback) => {
        subs.add(callback);
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
      playpause: defineSequence(sequences.playpause, 'paused'),
      showGrid: defineToggle(false),
      grid_fit: defineSequence(sequences.fit),
      player: defineSequence(sequences.player, 'interleave'),
      max_interleaved: defineNumber(8),
      interleave_delay: defineNumber(500),
      repeat: defineToggle(true),
      shuffle_on_repeat: defineToggle(true),
      reload_on_repeat: defineToggle(true),
      filter: defineString('.*\.mp4$'),
    };
  })({});

  (({ document: { body }, config: { max_interleaved, interleave_delay } }) => {
    /* TODO - set up @property automatically */
    max_interleaved.subscribe((newValue) => {
      body.style.setAttribute('--playerCount', `${newValue}`);
      body.style.setAttribute('--s-playerCount', `'${newValue}'`);
    });
    interleave_delay.subscribe((newValue) => {
      body.style.setAttribute('--interleave-delay', `${newValue}ms`);
      body.style.setAttribute('--s-interleave-delay', `'${newValue}ms'`);
    });
  })({ document, config });

  (({
    to,
    config: {
      filelist,
      includeImageFiles,
      includeVideoFiles,
      includeOtherFiles,
      includeHiddenFiles,
      max_interleaved,
      interleave_delay,
      showGrid,
      grid_fit,
      playpause,
      player,
      repeat,
      shuffle_on_repeat,
      reload_on_repeat,
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
      textContent: 'Max # of interleaved videos',
      bindTo: max_interleaved,
      name: 'max_interleaved',
      sequence: sequences.max_interleaved.map((n) => ({
        value: n,
      })),
      to: interleaveGrouping,
    });
    addSequenceToggle({
      textContent: 'Show each video for',
      bindTo: interleave_delay,
      name: 'interleave_delay',
      sequence: sequences.interleave_delay.map((n) => ({
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
  })({ to: toggles, config });

  const getFileList = (
    ({
      config: {
        repeat,
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
      let _shuffled = false,
        _filter = null,
        _filtered_length = null;

      function* filteredFiles() {
        yield* files.filter((x) => x.match(_filter));
        // yield* files.filter((x) => x.match(filter.value));
      }

      const load = () => {
        files = [...document.querySelectorAll('a.file')].map((file) =>
          file.getAttribute('href'),
        );
        filesOriginalOrder = [...files];
        _shuffled = false;
        _filtered_length = null;
        filesIter = filteredFiles();
      };

      const shuffle = () => {
        files ?? load();
        shuffleArray(files);
        /* shuffling ought not to change the filtered length */
        filesIter = filteredFiles();
        _shuffled = true;
      };

      const reset = () => {
        files ?? load();
        files = [...filesOriginalOrder];
        /* unshuffling ought not to change the filtered length */
        filesIter = filteredFiles();
        _shuffled = false;
      };

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
        _filter = [
          includeImageFiles.value ? matchImage : [],
          includeVideoFiles.value ? matchVideo : [],
          includeOtherFiles.value ? matchOther : [],
        ]
          .flat()
          .join('|');
      };

      const unsubs = [
        // repeat.subscribe((newValue) => ),
        // shuffle_on_repeat.subscribe(() => ),
        // reload_on_repeat.subscribe(() => ),
        // filter.subscribe(() => ),
        includeImageFiles.subscribe(() => updateFilter()),
        includeVideoFiles.subscribe(() => updateFilter()),
        includeOtherFiles.subscribe(() => updateFilter()),
      ];

      return {
        next: () => {
          files ?? load();
          const { done, value } = filesIter.next();
          if (done) {
            if (repeat.value) {
              if (reload_on_repeat.value) {
                load();
              }
              if (shuffle_on_repeat.value) {
                shuffle();
              }
              filesIter = filteredFiles();
              return filesIter.next();
            } else {
              return { done: true };
            }
          } else {
            return { done: false, value };
          }
        },
        // [Symbol.iterator]() {
        //   return this;
        // },
        async *[Symbol.asyncIterator]() {
          return this;
        },
        /**
         *  If a filter is set, this returns the filtered count
         *  This is calculated lazily the first time it is required
         */
        get length() {
          files ?? load();
          return (_filtered_length ??= [
            ...files.filter((x) => x.match(filter.value)),
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
        reset,
        reload: () => load(),
        get repeat() {
          return repeat.value;
        },
        set repeat(newValue) {
          repeat.value = newValue;
        },
        get filter() {
          return filter.value;
        },
        set filter(newValue) {
          if (filter.value !== newValue) {
            _filtered_length = null;
          }
          filter.value = newValue;
        },
        get shuffle_on_repeat() {
          return shuffle_on_repeat.value;
        },
        set shuffle_on_repeat(newValue) {
          shuffle_on_repeat.value = newValue;
        },
        get reload_on_repeat() {
          return reload_on_repeat.value;
        },
        set reload_on_repeat(newValue) {
          reload_on_repeat.value = newValue;
        },
      };
    }
  )({ config, shuffleArray: shuffle });

  const interleavePlayer = (({ to, config }) => {
    const container = GM_addElement(to, 'section', {
      class: 'player interleave paused',
    });

    const resetHandlers = [];
    const reset = () => {
      resetHandlers.forEach((f) => f?.());
    };

    const mediaPlayers = [];

    /**
     * Track count of player errors to avoid infinite fail loops
     */
    const playerErrors = new WeakMap();
    const maxErrorCount = 10,
      addToCountOnError = 1,
      addToCountOnSuccess = -2;

    const filelist = getFileList({
      repeat: true,
      shuffle: true,
      shuffle_on_repeat: true,
      include: {
        all: false,
        videos: true,
        images: false,
        match: '',
      },
    });

    const playNext = (video) => {
      video.src = decodeURI(filelist?.next().value ?? '');
    };
    const onEndedPlayNext = ({ target }) => {
      playerErrors.set(
        target,
        Math.max(0, (playerErrors.get(target) ?? 0) + addToCountOnSuccess),
      );
      playNext(target);
    };
    const onErrorPlayNext = ({ target }) => {
      playerErrors.set(
        target,
        (playerErrors.get(target) ?? 0) + addToCountOnError,
      );
      if ((playerErrors.get(target) ?? 0) > maxErrorCount) {
        target.pause();
        target.classList.add('error');
        console.warn(`player '${target.id}' exceeded max error count`);
      } else {
        playNext(target);
      }
    };

    const updateMediaPlayerCount = (count = 4) => {
      const newPlayerCount = Math.min(filelist.length, count);
      for (let i = mediaPlayers.length; i < newPlayerCount; i++) {
        const { wrapper, player } = addWrappedVideo({
          to: container,
          class: `i${i}`,
          id: `i${i}`,
        });
        wrapper.style.setProperty('--playerIdx', i);
        wrapper.style.setProperty('--s-playerIdx', `'${i}'`);

        player.addEventListener('ended', onEndedPlayNext, {});
        player.addEventListener('error', onErrorPlayNext, {});
        resetHandlers.push(() => {
          player.removeEventListener('ended', onEndedPlayNext, {});
          player.removeEventListener('error', onErrorPlayNext, {});
        });
        mediaPlayers.push(player);
      }
      mediaPlayers.forEach((mediaPlayer, i) => {
        if (i < newPlayerCount) {
          mediaPlayer.classList.remove('off');
          if (!mediaPlayer.playing) {
            playNext(mediaPlayer);
          }
        } else {
          mediaPlayer.pause();
          mediaPlayer.classList.add('off');
        }
      });
    };

    const unsub = config.max_interleaved.subscribe(updateMediaPlayerCount);
    updateMediaPlayerCount(config.max_interleaved.value);

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
      reset();
      mediaPlayers
        .filter((mediaPlayer) => !mediaPlayer.classList.contains('off'))
        .forEach((mediaPlayer) => {
          playNext(mediaPlayer);
        });
      container.classList.add('playing');
      container.classList.remove('paused');
    };
    const pause = () => {
      mediaPlayers
        .filter((mediaPlayer) => !mediaPlayer.classList.contains('off'))
        .forEach((mediaPlayer) => {
          mediaPlayer.pause();
        });
      container.classList.add('paused');
      container.classList.remove('playing');
    };

    const onClickContainer = () => {
      if (container.classList.contains('playing')) {
        pause();
      } else if (container.classList.contains('paused')) {
        play();
      }
    };
    container.addEventListener('click', onClickContainer, {});

    return {
      play,
      pause,
      reset,
    };
  })({ to: players, config });

  const linearPlayer = (({ to, config }) => {
    const container = GM_addElement(to, 'section', {
      class: 'player linear paused',
    });

    ['last', 'cue-prev', 'current', 'cue-next'].forEach((cl) =>
      addWrappedVideo({ to: container, class: cl }),
    );

    const filelist = getFileList({ repeat: true, shuffle: false });

    return {
      play: () => {
        container.querySelectorAll('current').forEach((video) => {
          video.src = filelist?.next().value;
          video.play();
        });
        container.classList.add('playing');
        container.classList.remove('paused');
      },
      pause: () => {
        container.querySelectorAll('current').forEach((video) => {
          video.pause();
        });
        container.classList.add('paused');
        container.classList.remove('playing');
      },
    };
  })({ to: players, config });

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
]).then(() =>
  Promise.race([timeout({ s: 30 }), readyStateComplete()])
    .catch(() => console.debug('timed out waiting for readyStateComplete'))
    .then(({ window, unsafeWindow }) => {
      console.debug('document ready');

      if (isDirectory) {
        initBrowsePreview(unsafeWindow);
      }
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
