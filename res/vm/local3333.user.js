// ==UserScript==
// @name        serve3333
// @namespace   mayhem
// @version     1.0.29
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
