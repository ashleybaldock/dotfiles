// ==UserScript==
// @name        webpackErrorOverlay
// @namespace   mayhem
// @version     1.0.1
// @author      flowsINtomAyHeM
// @description Make this less annoying
// @downloadURL http://localhost:3333/vm/debug/webpack-overlay.user.js
// @match       *://localhost/*/*
// @grant       GM_info
// @grant       GM_addStyle
// @grant       GM_addElement
// @grant       GM_getValue
// @grant       GM_setValue
// @grant       GM_registerMenuCommand
// @grant       GM_addValueChangeListener
// @grant       GM_xmlhttpRequest
// @require     http://localhost:3333/vm/util.user.js
// @cssBaseUrl  http://localhost:3333/vm/debug/
// @cssBaseName webpack-overlay
// @run-at      document-start
// ==/UserScript==

document.querySelectorAll('#webpack-dev-server-client-overlay-div > button + div > div > div').forEach((div) => div.childNodes.forEach((node) => {
  if (node.nodeName === '#text') {
    console.log(node)
    const chunkWrapper = document.createElement('span');
    chunkWrapper.classList.add('text','chunk');
    chunkWrapper.dataset.original = node.textContent;
    node.textContent.split('\n').forEach((line) => {
	    const lineWrapper = document.createElement('span');
      lineWrapper.classList.add('text','line');
      line.split(/\s*([.~]?(?:\/\S+)*\/[^) ]*(?::\d*:\d*)?)\s*/).forEach((part) => {
        const match = /(?<pathloc>(?<path>(?<head>[.~]?(?:\/\S+)*\/)(?<tail>[^) ]*)):(?<line>\d*):(?<col>\d*))/.exec(part);
        if (match !== null) {
          const pathWrapper = document.createElement('a');
          pathWrapper.classList.add('text','part');
          pathWrapper.href = `${match?.groups?.path}#${match?.groups?.line}`;
          pathWrapper.textContent = `${match?.groups?.tail}:${match?.groups?.line}:${match?.groups?.col}`;
          lineWrapper.appendChild(pathWrapper);
        } else {
          const partWrapper = document.createElement('span');
          partWrapper.classList.add('text','part');
          partWrapper.textContent = part;
          lineWrapper.appendChild(partWrapper);
        }
      });
      chunkWrapper.appendChild(lineWrapper);
    })
    node.replaceWith(chunkWrapper);
  }
}))

