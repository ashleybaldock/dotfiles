import {
  css,
  html,
  copyTextToClipboard,
  copyImageToClipboard,
} from '/js/util.js';

/* customElements.define( "svg-icon", class extends HTMLElement {
      connectedCallback() {
        this.innerHTML =
          `<svg xmlns='http://www.w3.org/2000/svg'>` +
            `<rect width='100%' height='100%' fill='${this.getAttribute("bg")}'/>` +
          `</svg>`;
      }});*/

// const encodeSVG = (data, { fill = '#ffffff' } = {}) =>
//   data
//     .replace(/<svg/g, `<svg style="fill: ${fill};"`)
//     .replace(/>\s{1,}</g, `><`)
//     .replace(/\s{2,}/g, ` `)
//     .replace(/[\r\n%#()"'<>?[\\\]^`{|}]/g, encodeURIComponent);

// const svgToCSSBackground = (svgHTML) =>
//   `background-image: url('data:image/svg+xml,${encodeSVG(svgHTML)}');`;
// const svgToCSSvar = (svgHTML, varName) =>
//   `--icon-${varName}: url('data:image/svg+xml,${encodeSVG(svgHTML)}');`;

/**
 * Inject a style attribute into an SVG
 *
 * TODO re-use style attribute if SVG already has one
 */
const styleSVG = (
  svg,
  { fill = '#888', stroke = null, stroke_width = null } = {},
) =>
  svg.replace(
    /<svg/g,
    `<svg style="fill: ${fill};${(stroke && `stroke: ${stroke}`) ?? ''}${
      (stroke_width && `stroke_width: ${stroke_width}`) ?? ''
    }"`,
  );

/**
 * Minimally transform SVG for use in a dataurl
 */
const encodeSVG = (svg, base64 = false) =>
  base64
    ? `data:image/svg+xml;base64,${btoa(svg)}`
    : `data:image/svg+xml,${svg
        .replace(/>\s{1,}</g, `><`) /* strip spaces between tags */
        .replace(/\s{2,}/g, ` `) /* remove multiple spaces */
        .replace(/[\r\n%#()"'<>?[\\\]^`{|}]/g, encodeURIComponent)}`;

/**
 * Encode SVG into a dataurl
 *
 * Note: output does not include trailing ';'
 */
const dataUrl = (svg, base64 = false) => `url('${encodeSVG(svg, base64)}')`;

/* Boilerplate CSS for image as content */
const defaultContent = css``;

const svgToCSSvar = (svg, varName) => css`--icon-${varName}: ${dataUrl(svg)};`;

const utf8encodeSVG = (svg) =>
  `data:image/svg+xml;charset=utf-8,${encodeURIComponent(sg)}`;

const mini = (css) => css.replaceAll(/^\n|(?<=\n) *|\n *$/g, '');

// window.addEventListener('load', (event) => {
//   const styles = [':root {'];
//   document.querySelectorAll('svg').forEach((svg) => {
//     const name = svg.getAttribute('data-name');
//     if (name !== null && name?.length > 0) {
//       styles.push(`  ${svgToCSSvar(svg.outerHTML, name)}`);
//     }
//     const div = document.createElement('div');
//     div.className = 'iconRow';
//     div.insertAdjacentHTML(
//       'afterbegin',
//       `
//         <div class="copyAs">
//           <label class="copySVG" onClick="copy(event)">
//             <input type="text"/>SVG
//           </label>
//           <label class="copyBG" onClick="copy(event)">
//             <input type="text"/>CSS
//           </label>
//         </div>
//         <div class="asSVG">${svg.outerHTML}</div>
//       `,
//     );
//     div.querySelector('.copySVG input').value = svg.outerHTML;
//     div.querySelector('.copyBG input').value = svgToCSSBackground(
//       svg.outerHTML,
//     );
//     svg.replaceWith(div);
//   });

//   styles.push('}');
//   const styleString = styles.join('\n');
//   console.log(styleString);

//   const styleNode = document.createElement('style');
//   styleNode.innerText = styleString;
//   document.head.appendChild(styleNode);
// });

const pregenerateCopyAs = (svg) =>
  Promise.allSettled([
    Promise.resolve(['svg', svg]),
    Promise.resolve(['b64', btoa(svg)]),
    Promise.resolve(['url', `${dataUrl(svg)}`]),
    Promise.resolve(['u64', `${dataUrl(svg, true)}`]),
    Promise.resolve([
      'tnt',
      mini(css`
        content: ${dataUrl(svg)};
      `),
    ]),
    /* Boilerplate CSS for mask image */
    Promise.resolve([
      'msk',
      mini(css`
        mask-position: center;
        mask-clip: content-box;
        mask-origin: content-box;
        mask-repeat: no-repeat;
        mask-size: contain;
        mask-image: ${dataUrl(svg)};
      `),
    ]),
    Promise.resolve([
      'msi',
      mini(css`
        mask-image: ${dataUrl(svg)};
      `),
    ]),
    /* Inverse mask */
    Promise.resolve([
      'msv',
      mini(css`
        mask-position: center;
        mask-clip: content-box;
        mask-origin: content-box;
        mask-repeat: no-repeat;
        mask-size: contain;
        mask-composite: exclude;
        mask-image: ${dataUrl(svg)}, linear-gradient(#000 0 0);
      `),
    ]),
    /* Boilerplate CSS for background image */
    Promise.resolve([
      'bgr',
      mini(css`
        background: #0000;
        background-position: center center;
        background-origin: content-box;
        background-size: contain;
        background-repeat: no-repeat;
        background-blend-mode: normal;
        background-attachment: scroll;
        background-image: ${dataUrl(svg)};
      `),
    ]),
    Promise.resolve([
      'bgi',
      mini(css`
        background-image: ${dataUrl(svg)};
      `),
    ]),
    Promise.resolve(['im-svg', new Blob([svg], { type: 'image/svg+xml' })]),

    new Promise((resolve, reject) => {
      const tmpImg = document.createElement('img');
      tmpImg.addEventListener('load', () => {
        const tmpCanvas = document.createElement('canvas');
        tmpCanvas.width = tmpImg.naturalWidth;
        tmpCanvas.height = tmpImg.naturalHeight;
        canvas
          .getContext('2d')
          .drawImage(tmpImg, 0, 0, tmpImg.naturalWidth, tmpImg.naturalHeight);
        canvas.toDataURL(`image/png`, 1.0);
        canvas.toBlob((blob) => resolve(['im-png', blob]));
      });
    }),
  ]);

const notifyCopied = (target) =>
  target &&
  (target.classList.add('copied') ||
    setTimeout(() => target.classList.remove('copied'), 3000));

const notifyCopyFailed = (target, message) =>
  (target &&
    (target.classList.add('copyfail') ||
      setTimeout(() => target.classList.remove('copyfail'), 4000))) ||
  (message && console.warn(message));

window.addEventListener('load', (event) => {
  // document.querySelectorAll('.svgListing svg').forEach((svg) => {
  /*const cssvar = (name !== null && name?.length > 0) ? svgToCSSvar(svg.outerHTML, name) : null;
      cssvar && styles.push(`  ${svgToCSSvar(svg.outerHTML, name)}`);*/

  /*<label class="down" data-down="svg" onClick="down(event, 'svg')">svg</label>*/

  // const iconRow = ((wrapper = document.createElement('div')) =>
  //   wrapper.insertAdjacentHTML(
  //     'afterbegin',
  //     html`
  //       <div class="iconRow">
  //         <div class="wrappedSVG"></div>
  //       </div>
  //     `,
  //   ).firstChild)();
  // svg.replaceWith(iconRow);
  // iconRow.querySelector('.wrappedSVG').appendChild(svg);
  // });

  let currentSvg = null;
  const svgMap = new WeakMap();

  const copy = (target, copyAs) => {
    if (!svgMap.has(currentSvg)) {
      notifyCopyFailed(target, 'SVG missing');
      return;
    }
    if (!svgMap.get(currentSvg)?.has(copyAs)) {
      notifyCopyFailed(target, 'Invalid copyAs method');
      return;
    }

    const toCopy = svgMap.get(currentSvg)?.get(copyAs);

    ('string' === typeof toCopy ? copyTextToClipboard : copyImageToClipboard)(
      toCopy,
    )
      .then(() => {
        notifyCopied(target);
      })
      .catch((err) => {
        notifyCopyFailed(target, `Copy failed, err: ${err}`);
      });
  };
  document.addEventListener('mouseover', ({ target }) => {
    if (target.matches(':not(.wrapped) > svg')) {
      const button = document.createElement('button');
      target.replaceWith(button);
      button.appendChild(target);
      button.classList.add('wrapped');
      button.setAttribute('command', 'toggle-popover');
      button.setAttribute('commandfor', 'svgActions-menu');

      currentSvg = target;
      if (!svgMap.has(target)) {
        pregenerateCopyAs(target.innerHTML).then((pregenerated) =>
          svgMap.set(target, new Map(pregenerated)),
        );
      }

      target.style.setProperty(
        '--svg-name',
        target.dataset.name ??
          target.querySelector('[data-name]')?.dataset.name ??
          '',
      );
    }
  });
  document.body.addEventListener(
    'click',
    ({ target }) =>
      target.matches('.svgActions [data-copyas]') &&
      target.dataset.copyas?.match?.({
        [Symbol.match]: (copyAs) => copy(target, copyAs),
      }),
    {},
  );

  document.addEventListener(
    'mouseover',
    ({ target }) =>
      target.matches('.svgListing [commandfor="svgActions-menu"]') &&
      document.querySelector('.svgActions')?.showPopover(),
  );

  // document.addEventListener('mouseover', ({ target }) => {
  //   if (target.matches('svg')) {
  //     const cloneSvg = (svgTarget, classesToAdd = []) => {
  //       const clone = svgTarget.cloneNode(true);
  //       clone.classList.add('duplicate', ...[classesToAdd].flat());
  //       svgTarget.parentElement.append(clone);
  //     };
  //     const svgTarget =
  //       target.parentElement
  //         ?.closest?.('.iconRow')
  //         ?.querySelector?.('.wrappedSVG') ?? false;
  //     if (
  //       svgTarget &&
  //       !svgTarget.classList.contains('duplicated') &&
  //       !svgTarget.classList.contains('duplicate')
  //     ) {
  //       svgTarget.classList.add('duplicated', 'large');
  //       cloneSvg(svgTarget, ['small']);
  //       cloneSvg(svgTarget, ['medium']);
  //     }
  //   }
  // });
});
