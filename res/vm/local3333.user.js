// ==UserScript==
// @name        serve3333
// @namespace   mayhem
// @version     1.0.30
// @author      flowsINtomAyHeM
// @downloadURL http://localhost:3333/vm/local3333.user.js
// @match       *://localhost:3333/*
// @run-at      document-start
// @grant       GM_info
// @grant       GM_addStyle
// @grant       GM_addElement
// @grant       GM_getValue
// @grant       GM_setValue
// @grant       GM_addValueChangeListener
// @grant       GM_registerMenuCommand
// @grant       GM_xmlhttpRequest
// @require     http://localhost:3333/vm/util.user.js
// @cssBaseUrl  http://localhost:3333/vm/
// @cssBaseName local3333
// @inject-into auto
// ==/UserScript==

const isIndex = (
  ({ qs }) =>
  () =>
    matchExistsFor('title').then((title) =>
      /^Files within /.test(title.textContent),
    )
)(unsafeWindow);

const styleToggleIds = addStyleToggles([
  {
    title: '[::1]:3333 dirlist reskin',
    enabled: isIndex(),
    sources: [{}],
  },
])
  .then(() =>
    Promise.race([timeout({ s: 30 }), readyStateComplete()])
      .catch(() => console.warn('timed out waiting for readyStateComplete'))
      .then(({ unsafeWindow }) => {
        console.debug('document ready');
        return Promise.all([
          matchExistsFor('header').then((header) => {
            if (isIndex) {
              const relic = GM_addElement(header, 'link', {
                rel: 'icon',
                href: 'data:image/svg+xml,%3Csvg style=%22fill: %23ddd; stroke: %23000; stroke-width: 20;%22 xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%22-10 -10 586 522%22%3E%3Cpath d=%22M64 32C64 14.3 49.7 0 32 0S0 14.3 0 32v96V384c0 35.3 28.7 64 64 64H256V384H64V160H256V96H64V32z%22%3E%3C/path%3E%3Cpath style=%22fill: %2300aaff; stroke: %23004488; stroke-width: 10%22 d=%22M288 192c0 17.7 14.3 32 32 32H544c17.7 0 32-14.3 32-32V64c0-17.7-14.3-32-32-32H445.3c-8.5 0-16.6-3.4-22.6-9.4L409.4 9.4c-6-6-14.1-9.4-22.6-9.4H320c-17.7 0-32 14.3-32 32V192zm0 288c0 17.7 14.3 32 32 32H544c17.7 0 32-14.3 32-32V352c0-17.7-14.3-32-32-32H445.3c-8.5 0-16.6-3.4-22.6-9.4l-13.3-13.3c-6-6-14.1-9.4-22.6-9.4H320c-17.7 0-32 14.3-32 32V480z%22%3E%3C/path%3E%3C/svg%3E',
              });
              const label = GM_addElement(header, 'label', {});
              GM_addElement(label, 'span', {
                textContent: '.hide',
                type: 'checkbox',
                id: 'hide',
              });
              const input = GM_addElement(label, 'input', {
                type: 'checkbox',
                id: 'hide',
                ...((checked) => (checked ? { checked: '' } : {}))(
                  GM_getValue('hide', true),
                ),
              });
              input.addEventListener('change', (e) =>
                GM_setValue('hide', e.target.checked),
              );
              GM_addValueChangeListener(
                'hide',
                (name, oldValue, newValue, remote) =>
                  (input.checked = newValue),
              );
            }
          }),
        ]);
      }),
  )
  .catch((e) => console.warn(e));
