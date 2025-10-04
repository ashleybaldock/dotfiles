// ==UserScript==
// @name        traintimes
// @namespace   mayhem
// @version     1.0.4
// @author      flowsINtomAyHeM
// @description File browser with media preview
// @match       *://*.traintimes.org/*
// @downloadURL http://localhost:3333/vm/traintimes.user.js
// @require     http://localhost:3333/vm/util.user.js
// @cssBaseUrl  http://localhost:3333/vm/
// @cssBaseName traintimes
// @run-at      document-start
// ==/UserScript==

const initTraintimes = ({ document }) => {
  // const clone = qs`#content > h2`.one.cloneNode(true);
  const textSplits = [[`#content > h2`, /\s*(to|,)\s*/]];
  qs`#content > h2`.one.childNodes.forEach((node) => {
    if (node.nodeName === '#text') {
      const wrapper = document.createElement('span');
      wrapper.dataset.orig = node.textContent;
      const parts = [...node.textContent.split(/\s*([,.;–])\s*/)].filter(
        (s) => s.length > 0,
      );
      if (parts.length > 1) {
        parts.forEach((s) => {
          const part = document.createElement('span');
          part.innerText = part.dataset.text = s.trim();
          wrapper.appendChild(part);
        });
      } else {
        wrapper.innerText = wrapper.dataset.text = node.textContent.trim();
      }
      node.replaceWith(wrapper);
    }
  });
};

const traintimesToggleIds = addStyleToggles([
  {
    title: 'traintimes',
    enabled: true,
    sources: [
      {
        baseName: 'traintimes',
      },
    ],
  },
]).then(() =>
  Promise.race([timeout({ s: 30 }), readyStateComplete()])
    .catch(() => console.debug('timed out waiting for readyStateComplete'))
    .then(({ window, unsafeWindow }) => {
      console.debug('document ready');

      initTraintimes(unsafeWindow);
    })
    .catch((e) => console.warn(e)),
);
