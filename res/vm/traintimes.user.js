// ==UserScript==
// @name        traintimes
// @namespace   mayhem
// @version     1.0.31
// @author      flowsINtomAyHeM
// @description File browser with media preview
// @downloadURL http://localhost:3333/vm/traintimes.user.js
// @match       *://*.traintimes.org.uk/*
// @run-at      document-start
// @grant       GM_info
// @grant       GM_addStyle
// @grant       GM_addElement
// @grant       GM_getValue
// @grant       GM_setValue
// @grant       GM_registerMenuCommand
// @grant       GM_addValueChangeListener
// @grant       GM_registerMenuCommand
// @grant       GM_xmlhttpRequest
// @require     http://localhost:3333/vm/util.user.js
// @cssBaseName traintimes
// ==/UserScript==

// const svgFilterDots = html`
//   <svg xmlns="http://www.w3.org/2000/svg">
//     <filter id="filter-dots8" x="0" y="0" width="100%" height="100%">
//       <feFlood
//         x="-0.036lh"
//         y="-0.036lh"
//         flood-color="#f00"
//         result="fld1"
//         flood-opacity="1"
//         width="0.125lh"
//         height="0.125lh"
//       ></feFlood>
//       <feComposite
//         height="0.125lh"
//         width="0.125lh"
//         in2="SourceGraphic"
//         x="0.036lh"
//         y="0.036lh"
//         result="cmp1"
//         in="fld1"
//         operator="arithmetic"
//         k2="0"
//         k1="2"
//         k3="0"
//         k4="-1"
//       ></feComposite>
//       <feTile
//         y="0"
//         x="0"
//         height="100%"
//         width="100%"
//         result="til1"
//         in="cmp1"
//       ></feTile>
//       <feComposite in="SourceGraphic" operator="in" in2="til1"></feComposite>
//     </filter>
//   </svg>
// `;

const initTraintimes = ({ document }) => {
  (({ id, to = document.body }) => {
    const dots = 8;
    const ratio = 0.6;

    const doth = 1 / dots;
    const dotH = (1 * ratio) / dots;
    const gap = (1 - 1 * ratio) / (dots - 1);
    const gap2 = gap / 2;

    const fix3 = parseMap((x) => x.toFixed(3));

    const svg = createElementSVG('svg');
    svg.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
    to.appendChild(svg);

    const filter = createElementSVG('filter');
    svg.appendChild(filter);
    filter.setAttribute('id', 'filter-dots8');
    filter.setAttribute('x', '0');
    filter.setAttribute('y', '0');
    filter.setAttribute('width', '100%');
    filter.setAttribute('height', '100%');

    const fld1 = createElementSVG('feFlood');
    filter.appendChild(fld1);
    fld1.setAttribute('result', 'fld1');
    fld1.setAttribute('x', fix3`-${gap2}lh`);
    fld1.setAttribute('y', fix3`-${gap2}lh`);
    fld1.setAttribute('width', `${doth}lh`);
    fld1.setAttribute('height', `${doth}lh`);
    fld1.setAttribute('flood-opacity', '1');
    fld1.setAttribute('flood-color', '#f00');

    const cmp1 = createElementSVG('feComposite');
    filter.appendChild(cmp1);
    cmp1.setAttribute('x', fix3`${gap2}lh`);
    cmp1.setAttribute('y', fix3`${gap2}lh`);
    cmp1.setAttribute('width', `${doth}lh`);
    cmp1.setAttribute('height', `${doth}lh`);
    cmp1.setAttribute('result', 'cmp1');
    cmp1.setAttribute('in', 'fld1');
    cmp1.setAttribute('in2', 'SourceGraphic');
    cmp1.setAttribute('operator', 'arithmetic');
    /*result = k1*i1*i2 + k2*i1 + k3*i2 + k4*/
    cmp1.setAttribute('k1', 1); /* in*in2 */
    cmp1.setAttribute('k2', 0); /* in  */
    cmp1.setAttribute('k3', 0); /* in2 */
    cmp1.setAttribute('k4', 0); /* */

    const til1 = createElementSVG('feTile');
    filter.appendChild(til1);
    til1.setAttribute('y', '0');
    til1.setAttribute('x', '0');
    til1.setAttribute('height', '100%');
    til1.setAttribute('width', '100%');
    til1.setAttribute('result', 'til1');
    til1.setAttribute('in', 'cmp1');

    const cmp2 = createElementSVG('feComposite');
    filter.appendChild(cmp2);
    cmp2.setAttribute('in', 'SourceGraphic');
    cmp2.setAttribute('operator', 'in');
    cmp2.setAttribute('n2', 'til1');
  })({ id: 'filter-dots8' });

  // const clone = qs`#content > h2`.one.cloneNode(true);
  const textSplits = [[`#content > h1`, /\s*(to|,)\s*/]];
  qs`#content h1`.one.childNodes.forEach((node) => {
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

      return Promise.all([
        matchExistsFor('#content').then((/* node */) => {
          initTraintimes(unsafeWindow);
        }),
      ]);
    })
    .catch((e) => console.warn(e)),
);
