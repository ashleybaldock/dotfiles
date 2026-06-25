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

const copyAsMapping = new Map([
  ['svg', (svg) => svg],
  ['b64', (svg) => btoa(svg)],
  ['url', (svg) => `${dataUrl(svg)}`],
  ['u64', (svg) => `${dataUrl(svg, true)}`],
  [
    'tnt',
    (svg) =>
      mini(css`
        content: ${dataUrl(svg)};
      `),
  ],
  /* Boilerplate CSS for mask image */
  [
    'msk',
    (svg) =>
      mini(css`
        mask-position: center;
        mask-clip: content-box;
        mask-origin: content-box;
        mask-repeat: no-repeat;
        mask-size: contain;
        mask-image: ${dataUrl(svg)};
      `),
  ],
  [
    'msi',
    (svg) =>
      mini(css`
        mask-image: ${dataUrl(svg)};
      `),
  ],
  /* Inverse mask */
  [
    'msv',
    (svg) =>
      mini(css`
        mask-position: center;
        mask-clip: content-box;
        mask-origin: content-box;
        mask-repeat: no-repeat;
        mask-size: contain;
        mask-composite: exclude;
        mask-image: ${dataUrl(svg)}, linear-gradient(#000 0 0);
      `),
  ],
  /* Boilerplate CSS for background image */
  [
    'bgr',
    (svg) =>
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
  ],
  [
    'bgi',
    (svg) =>
      mini(css`
        background-image: ${dataUrl(svg)};
      `),
  ],
  [
    'im-svg',

    (svg) =>
      new Blob([svg], {
        type: 'image/svg+xml',
      }),
  ],
  [
    'im-png',

    async (svg) => {
      const tmpImg = document.createElement('img');
      return await new Promise((resolve, reject) => {
        tmpImg.addEventListener('load', () => {
          const tmpCanvas = document.createElement('canvas');
          tmpCanvas.width = tmpImg.naturalWidth;
          tmpCanvas.height = tmpImg.naturalHeight;
          canvas
            .getContext('2d')
            .drawImage(tmpImg, 0, 0, tmpImg.naturalWidth, tmpImg.naturalHeight);
          canvas.toDataURL(`image/png`, 1.0);
          canvas.toBlob((blob) => resolve(blob));
        });
      });
    },
  ],
]);

const copy = (target, copyAs) => {
  const notifyCopied = (target) =>
    target &&
    (target.classList.add('copied') ||
      setTimeout(() => target.classList.remove('copied'), 3000));

  const notifyFail = (target, message) =>
    (target &&
      (target.classList.add('copyfail') ||
        setTimeout(() => target.classList.remove('copyfail'), 4000))) ||
    (message && console.warn(message));

  const svgData = target
    ?.closest?.(':has(> .wrappedSVG)')
    ?.querySelector?.('.wrappedSVG')?.innerHTML;

  if (svgData === null) {
    notifyFail(target, 'SVG missing');
    return;
  }
  if (!copyAsMapping.has(copyAs)) {
    notifyFail(target, 'Invalid copyAs method');
    return;
  }

  const toCopy = copyAsMapping.get(copyAs)(svgData);

  ('string' === typeof toCopy ? copyTextToClipboard : copyImageToClipboard)(
    toCopy,
  )
    .then(() => {
      notifyCopied(target);
    })
    .catch((err) => {
      notifyFail(target, `Copy failed, err: ${err}`);
    });
};

window.addEventListener('load', (event) => {
  document.querySelectorAll('.svgListing svg').forEach((svg) => {
    const name =
      svg.dataset.name ?? svg.querySelector('[data-name]')?.dataset.name;
    /*const cssvar = (name !== null && name?.length > 0) ? svgToCSSvar(svg.outerHTML, name) : null;
      cssvar && styles.push(`  ${svgToCSSvar(svg.outerHTML, name)}`);*/

    /*<label class="down" data-down="svg" onClick="down(event, 'svg')">svg</label>*/

    const iconRow = (() =>
      document.createElement('div').insertAdjacentHTML(
        'afterbegin',
        html`
          <div class="iconRow">
            <div class="wrappedSVG"></div>
          </div>
        `,
      ).firstChild)();
    svg.replaceWith(iconRow);
    iconRow.querySelector('.wrappedSVG').appendChild(svg);
  });

  document.body.addEventListener(
    'click',
    ({ target }) =>
      target.dataset.copyas?.match?.({
        [Symbol.match]: (copyAs) => copy(target, copyAs),
      }),
    {},
  );

  document.addEventListener('mouseover', ({ target }) => {
    const cloneSvg = (svgTarget, classesToAdd = []) => {
      const clone = svgTarget.cloneNode(true);
      clone.classList.add('duplicate', ...[classesToAdd].flat());
      svgTarget.parentElement.append(clone);
    };
    const svgTarget =
      target.parentElement
        ?.closest?.('.iconRow')
        ?.querySelector?.('.wrappedSVG') ?? false;
    if (
      svgTarget &&
      !svgTarget.classList.contains('duplicated') &&
      !svgTarget.classList.contains('duplicate')
    ) {
      svgTarget.classList.add('duplicated', 'large');
      cloneSvg(svgTarget, ['small']);
      cloneSvg(svgTarget, ['medium']);
    }
  });
});
