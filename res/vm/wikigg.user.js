// ==UserScript==
// @name        wiki.gg tweaks
// @namespace   mayhem
// @version     1.0.165
// @author      flowsINtomAyHeM
// @downloadURL http://localhost:3333/vm/wikigg.user.js
// @match       *://noita.wiki.gg/wiki/*
// @match       *://noita.wiki.gg/index.php*
// @grant       GM_info
// @grant       GM_addStyle
// @grant       GM_registerMenuCommand
// @grant       GM_xmlhttpRequest
// @require     http://localhost:3333/vm/util.user.js
// @cssBaseName wikigg
// @cssPath     wikigg/
// ==/UserScript==

// @require     http://localhost:3333/node_modules/html-to-image/dist/html-to-image.js
// unsafeWindow.htmlToImage = window.htmlToImage = htmlToImage;

addStyleToggles([
  {
    title: 'custom',
    enabled: true,
    sources: [{}, { name: 'gg' }, { name: 'mainmenu' }, { name: 'topnav' }],
  },

  { title: 'wip: search', sources: [{ name: 'search' }] },
  {
    title: 'wip: reskin',
    sources: [{ name: 'uitweaks' }, { name: 'cargo' }],
  },
  {
    title: 'wip: changehistory',
    sources: [
      { name: 'sticky.pagehistory' },
      { name: 'recenthistory' },
      { name: 'contributions' },
    ],
  },
  {
    title: 'codemirror',
    enabled: false,
    sources: [{ name: 'codemirror' }, { name: 'editor' }, { name: 'ace' }],
  },
]).then(() =>
  Promise.race([timeout({ s: 30 }), readyStateComplete()])
    .catch(() => console.log('timed out waiting for readyStateComplete'))
    .then(() => matchExistsFor('.ace_editor'))
    .then((node) => {
      console.log('ace resize');
      hj;
      /* After CSS has been injected */
      const ace = unsafeWindow.ace.edit(node);
      ace.setOption('maxLines', 2000);
      ace.resize();
      /* And ensure .ui-resizable container size matches */
      node.parentElement.style.height = node.style.height;
    })
    .catch((e) => console.log(e)),
);
