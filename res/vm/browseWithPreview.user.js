// ==UserScript==
// @name        browseWithPreview
// @namespace   mayhem
// @version     1.0.158
// @author      flowsINtomAyHeM
// @description File browser with media preview
// @downloadURL http://localhost:3333/vm/browseWithPreview.user.js
// @match       *://localhost/*/*
// @match       file:///*/*
// @grant       GM_info
// @grantGM_addStyle
// @grant       GM_addElement
// @grant       GM_getValue
// @grant       GM_setValue
// @grant       GM_registerMenuCommand
// @grant       GM_addValueChangeListener
// @grant       GM_registerMenuCommand
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

const addToggle = ({
  to,
  tag = 'input',
  type = 'checkbox',
  bindTo,
  checked = bindTo?.value ?? false,
  textContent = '',
  icon = null,
  ...attrs
} = {}) => {
  const div = GM_addElement(to, 'div', {
    class: 'toggle',
    ...attrs,
  });
  const label = GM_addElement(div, 'label', {
    class: '',
    textContent,
  });
  icon !== null && label.style.setProperty('--icon', icon);
  const input = GM_addElement(label, tag, {
    type,
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

const addWrappedVideo = (
  parent,
  options = {
    class: `i${[...parent.querySelectorAll('.vidwrap')].length + 1}`,
    autoplay: '',
    muted: '',
  },
) => {
  const wrapper = GM_addElement(parent, 'div', { class: 'vidwrap' });
  const idx = () => wrapper.style.getPropertyValue('--playerIdx');
  const video = GM_addElement(wrapper, 'video', options);
  video.addEventListener(
    'play',
    () => {
      video.classList.remove('paused');
      video.classList.add('playing');

      console.debug(`${idx()} playing '${decodeURI(video.src)}'`);
      document
        .querySelectorAll(
          `body > table > tbody > tr:has([href="${video.src.split('/').slice(-1)}"])`,
        )
        .forEach((tr) => {
          tr.classList.remove('paused');
          tr.classList.add('playing');
          tr.style.setProperty('--playerIdx', idx());
          tr.style.setProperty('--s-playerIdx', `'${idx()}'`);

          const undo = () => {
            tr.classList.remove('playing');
            tr.classList.add('played');
            tr.style.removeProperty('--playerIdx');
            tr.style.removeProperty('--s-playerIdx');
          };
          video.addEventListener('ended', undo, { once: true });
          video.addEventListener('loadstart', undo, { once: true });
        });
    },
    {},
  );
  video.addEventListener(
    'pause',
    () => {
      video.classList.remove('playing');
      video.classList.add('paused');

      console.debug(`${idx()} paused '${decodeURI(video.src)}'`);
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
  video.addEventListener('loadstart', () => {
    console.debug(`${idx()} loadstart '${decodeURI(video.src)}'`);
  });
  video.addEventListener('error', () => {
    console.warn(`${idx()} error loading '${decodeURI(video.src)}'`);
  });
  video.addEventListener('canplaythrough', () => {
    console.debug(`${idx()} canplaythrough '${decodeURI(video.src)}'`);
    video.volume = 0;
    video.muted = true;
    video.play();
  });
  return { wrapper, player: video };
};

const initBrowsePreview = ({ document }) => {
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

    return {
      imageDuration: defineNumber(5),
      showImages: defineToggle(false),
      showVideo: defineToggle(false),
      showOther: defineToggle(false),
      showGrid: defineToggle(false),
      linear: defineToggle(false),
      interleave: defineToggle(false),
      maxInterleaved: defineNumber(8),
      interleaveDelay: defineNumber(500),
      loop: defineToggle(true),
      shuffle_on_loop: defineToggle(true),
      reload_on_loop: defineToggle(true),
      filter: defineString('.*\.mp4$'),
    };
  })({});

  const toggles = (({
    unsafeWindow: {
      document: { body },
    },
    config: { showGrid, showImages, showVideo, showOther, interleave, linear },
  }) => {
    return {
      grid: addToggle({
        to: body,
        class: 'toggle',
        id: 'toggle_grid',
        textContent: 'grid',
        name: 'grid',
        checked: false,
        bindTo: showGrid,
      }),
      interleave: addToggle({
        to: body,
        class: 'toggle',
        id: 'toggle_interleave',
        textContent: 'interleave',
        name: 'interleave',
        checked: true,
        bindTo: interleave,
      }),
      linear: addToggle({
        to: body,
        class: 'toggle',
        id: 'toggle_linear',
        textContent: 'linear',
        name: 'linear',
        checked: false,
        bindTo: linear,
      }),
      images: addToggle({
        to: body,
        class: 'toggle',
        id: 'toggle_images',
        textContent: 'images',
        name: 'images',
        checked: true,
        bindTo: showImages,
      }),
      video: addToggle({
        to: body,
        class: 'toggle',
        id: 'toggle_video',
        textContent: 'video',
        name: 'video',
        checked: true,
        bindTo: showVideo,
      }),
      other: addToggle({
        to: body,
        class: 'toggle',
        id: 'toggle_other',
        textContent: 'other',
        name: 'other',
        checked: false,
        bindTo: showOther,
      }),
    };
  })({ unsafeWindow, config });

  const getFileList = (
    ({
      config: { loop, shuffle_on_loop, reload_on_loop, filter },
      shuffleArray,
    }) =>
    () => {
      let files = null,
        filesOriginalOrder = [],
        filesIter;
      let _shuffled = false,
        _filtered_length = null;

      function* filteredFiles() {
        yield* files.filter((x) => x.match(_filter));
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

      return {
        next: () => {
          files ?? load();
          const { done, value } = filesIter.next();
          if (done) {
            if (loop.value) {
              if (reload_on_loop.value) {
                load();
              }
              if (shuffle_on_loop.value) {
                shuffleFiles();
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
        /**
         *  If a filter is set, this returns the filtered count
         *  This is calculated lazily the first time it is required
         */
        get length() {
          files ?? load();
          _filtered_length ??= [...files.filter((x) => x.match(_filter))]
            .length;
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
        get loop() {
          return loop.value;
        },
        set loop(newValue) {
          loop.value = newValue;
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
        get shuffle_on_loop() {
          return shuffle_on_loop.value;
        },
        set shuffle_on_loop(newValue) {
          shuffle_on_loop.value = newValue;
        },
        get reload_on_loop() {
          return reload_on_loop.value;
        },
        set reload_on_loop(newValue) {
          reload_on_loop.value = newValue;
        },
      };
    }
  )({ config, shuffleArray: shuffle });

  const interleavePlayer = (({ document: { body }, config }) => {
    const container = GM_addElement(body, 'section', {
      class: 'player interleave paused',
    });

    const resetHandlers = [];
    const reset = () => {
      resetHandlers.forEach((f) => f?.());
    };

    const mediaPlayers = [];
    let _showAsGrid = false;

    /**
     * Track count of player errors to avoid infinite fail loops
     */
    const playerErrors = new WeakMap();
    const maxErrorCount = 10,
      addToCountOnError = 1,
      addToCountOnSuccess = -2;

    const filelist = getFileList({
      loop: true,
      shuffle: true,
      shuffle_on_loop: true,
      include: {
        all: false,
        videos: true,
        images: true,
        match: '',
      },
    });

    const playNext = (video) => {
      video.src = filelist?.next().value ?? '';
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
        const { wrapper, player } = addWrappedVideo(container, {
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
      body.style.setProperty('--playerCount', newPlayerCount);
      body.style.setProperty('--s-playerCount', `'${newPlayerCount}'`);
    };

    const unsub = config.maxInterleaved.subscribe(updateMediaPlayerCount);
    updateMediaPlayerCount(config.maxInterleaved.value);

    const grid = (showAsGrid = !_showAsGrid) => {
      if (_showAsGrid !== showAsGrid) {
        _showAsGrid = showAsGrid;
        if (_showAsGrid) {
          container.classList.add('grid');
        } else {
          container.classList.remove('grid');
        }
      }
    };

    const play = () => {
      reset();
      mediaPlayers
        .filter((mediaPlayer) => !mediaPlayer.classList.contains('off'))
        .forEach((mediaPlayer) => {
          playNext(mediaPlayer);
        });
      container.classList.add('playing');
      container.classList.remove('paused');
      _showAsGrid
        ? container.classList.add('grid')
        : container.classList.remove('grid');
    };
    const pause = () => {
      mediaPlayers
        .filter((mediaPlayer) => !mediaPlayer.classList.contains('off'))
        .forEach((mediaPlayer) => {
          mediaPlayer.pause();
        });
      container.classList.add('paused');
      container.classList.remove('playing');
      container.classList.add('grid');
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
      grid,
    };
  })({ document, config });

  const linearPlayer = (({ document: { body } }) => {
    const container = GM_addElement(body, 'section', {
      class: 'player linear paused',
    });

    ['last', 'cue-prev', 'current', 'cue-next'].forEach((cl) =>
      addWrappedVideo(container, { class: cl }),
    );

    const filelist = getFileList({ loop: true, shuffle: false });

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
  })({ document });

  document.querySelectorAll('a.file').forEach((file) =>
    file.addEventListener('click', (e) => {
      let last = document.querySelector('.last');
      let next = document.querySelector('.cue-next');
      let prev = document.querySelector('.cue-prev');
      let current = document.querySelector('.current');

      const nextFile = file.closest('tr').parentNode.closest('tr');
      next.addEventListener(
        'canplay',
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

  document.querySelector('body').dataset.playmode = 'interleave';

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
