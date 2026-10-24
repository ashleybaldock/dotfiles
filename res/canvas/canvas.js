import { readyStateComplete, iterloop } from '/js/util.js';

(() => {
  readyStateComplete().then(() => {
    const canvas = document.getElementById('canvas1');
    let ctx = canvas.getContext('2d');

    const videos = [
      { id: 'video1', src: 'a.mp4' },
      { id: 'video2', src: 'b.mp4' },
      { id: 'video3', src: 'c.mp4' },
      { id: 'video4', src: 'd.mp4' },
    ];

    let maxVideoWidth = 0,
      maxVideoHeight = 0;

    const updateCanvasSize = () => {
      canvas.setAttribute('width', maxVideoWidth);
      canvas.setAttribute('height', maxVideoHeight);
      ctx = canvas.getContext('2d');
    };

    Promise.allSettled(
      videos.map(({ id, src }) => {
        const video = document.getElementById(id);
        video.src = src;
        video.addEventListener('loadeddata', () => {
          video.play();
          maxVideoWidth = Math.max(video.videoWidth, maxVideoWidth);
          maxVideoHeight = Math.max(video.videoHeight, maxVideoHeight);
          updateCanvasSize();
        });
        video.addEventListener('ended', () => {
          video.play();
        });
        return video;
      }),
    )
      .then((results) =>
        results.flatMap((result) =>
          result.status === 'fulfilled' ? result.value : [],
        ),
      )
      .then((loadedVideos) => iterloop(loadedVideos))
      .then((loopVideos) => {
        let lastChanged = Date.now(),
          current;
        const interval = 100;

        const update = () => {
          const now = Date.now();
          if (now >= lastChanged + interval || current === undefined) {
            lastChanged = now;
            const { done, value } = loopVideos.next();
            if (!done) {
              current = value;
            }
          }
          if (current) {
            ctx.drawImage(current, 0, 0, maxVideoWidth, maxVideoHeight);
            requestAnimationFrame(update);
          }
        };
        update();
      });

    let lastidx = 1;
  });
})();
