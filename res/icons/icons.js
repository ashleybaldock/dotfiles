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
    (svg) => css`
      content: ${dataUrl(svg)};
    `,
  ],
  /* Boilerplate CSS for mask image */
  [
    'msk',
    (svg) => css`
      mask-position: center;
      mask-clip: content-box;
      mask-origin: content-box;
      mask-repeat: no-repeat;
      mask-size: contain;
      mask-image: ${dataUrl(svg)};
    `,
  ],
  [
    'msi',
    (svg) => css`
      mask-image: ${dataUrl(svg)};
    `,
  ],
  /* Inverse mask */
  [
    'msv',
    (svg) => css`
      mask-position: center;
      mask-clip: content-box;
      mask-origin: content-box;
      mask-repeat: no-repeat;
      mask-size: contain;
      mask-composite: exclude;
      mask-image: ${dataUrl(svg)}, linear-gradient(#000 0 0);
    `,
  ],
  /* Boilerplate CSS for background image */
  [
    'bgr',
    (svg) => css`
      background: #0000;
      background-position: center center;
      background-origin: content-box;
      background-size: contain;
      background-repeat: no-repeat;
      background-blend-mode: normal;
      background-attachment: scroll;
      background-image: ${dataUrl(svg)};
    `,
  ],
  [
    'bgi',
    (svg) => css`
      background-image: ${dataUrl(svg)};
    `,
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

  copyTextToClipboard(copyAsMapping.get(copyAs)(svgData))
    .then(() => {
      notifyCopied(target);
    })
    .catch((err) => {
      notifyFail(target, `Copy failed, err: ${err}`);
    });
};

window.addEventListener('load', (event) => {
  document.querySelectorAll('.autoWrap svg').forEach((svg) => {
    const name = svg.getAttribute('data-name');
    /*const cssvar = (name !== null && name?.length > 0) ? svgToCSSvar(svg.outerHTML, name) : null;
      cssvar && styles.push(`  ${svgToCSSvar(svg.outerHTML, name)}`);*/

    /*<label class="down" data-down="svg" onClick="down(event, 'svg')">svg</label>*/

    const div = document.createElement('div');
    div.className = 'iconRow';
    div.insertAdjacentHTML(
      'afterbegin',
      html`
        <div class="outer">
          <div class="inner">
            <div class="wrappedSVG">${svg.outerHTML}</div>
            <div class="svgActions">
              <label data-copyas="svg">svg</label>
              <label data-copyas="b64">base64</label>
              <label data-copyas="sym">symbol</label>
              <label data-copyas="url">url(svg)</label>
              <label data-copyas="u64">url(b64)</label>
              <label data-copyas="tnt">content</label>
              <label data-copyas="msk">mask</label>
              <label data-copyas="msk">mask-image</label>
              <label data-copyas="bgr">background</label>
              <label data-copyas="bgi">background-image</label>
            </div>
          </div>
        </div>
      `,
    );
    svg.replaceWith(div);
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
    const svgTarget =
      target.parentElement
        ?.closest?.('.iconRow')
        ?.querySelector?.('.wrappedSVG') ?? false;
    if (
      svgTarget &&
      !svgTarget.classList.contains('duplicated') &&
      !svgTarget.classList.contains('duplicate')
    ) {
      svgTarget.classList.add('duplicated');
      for (let i = 2; i > 0; i--) {
        const clone = svgTarget.cloneNode(true);
        clone.classList.add('duplicate');
        svgTarget.parentElement.append(clone);
      }
    }
  });
});
