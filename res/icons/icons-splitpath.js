splitpath = (path) => {
  const makeElement = ((document, console) => {
    // prettier-ignore
    const svgTagNames = new Set([ 'a', 'altGlyph', 'altGlyphDef', 'altGlyphItem', 'animate', 'animateColor', 'animateMotion', 'animateTransform', 'animation', 'audio', 'canvas', 'circle', 'clipPath', 'color-profile', 'cursor', 'defs', 'desc', 'discard', 'ellipse', 'feBlend', 'feColorMatrix', 'feComponentTransfer', 'feComposite', 'feConvolveMatrix', 'feDiffuseLighting', 'feDisplacementMap', 'feDistantLight', 'feDropShadow', 'feFlood', 'feFuncA', 'feFuncB', 'feFuncG', 'feFuncR', 'feGaussianBlur', 'feImage', 'feMerge', 'feMergeNode', 'feMorphology', 'feOffset', 'fePointLight', 'feSpecularLighting', 'feSpotLight', 'feTile', 'feTurbulence', 'filter', 'font', 'font-face', 'font-face-format', 'font-face-name', 'font-face-src', 'font-face-uri', 'foreignObject', 'g', 'glyph', 'glyphRef', 'handler', 'hkern', 'iframe', 'image', 'line', 'linearGradient', 'listener', 'marker', 'mask', 'metadata', 'missing-glyph', 'mpath', 'path', 'pattern', 'polygon', 'polyline', 'prefetch', 'radialGradient', 'rect', 'script', 'set', 'solidColor', 'stop', 'style', 'svg', 'switch', 'symbol', 'tbreak', 'text', 'textArea', 'textPath', 'title', 'tref', 'tspan', 'unknown', 'use', 'video', 'view', 'vkern' ]);
    // prettier-ignore
    const htmlTagNames = new Set([ 'a', 'abbr', 'acronym', 'address', 'applet', 'area', 'article', 'aside', 'audio', 'b', 'base', 'basefont', 'bdi', 'bdo', 'bgsound', 'big', 'blink', 'blockquote', 'body', 'br', 'button', 'canvas', 'caption', 'center', 'cite', 'code', 'col', 'colgroup', 'command', 'content', 'data', 'datalist', 'dd', 'del', 'details', 'dfn', 'dialog', 'dir', 'div', 'dl', 'dt', 'element', 'em', 'embed', 'fieldset', 'figcaption', 'figure', 'font', 'footer', 'form', 'frame', 'frameset', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'header', 'hgroup', 'hr', 'html', 'i', 'iframe', 'image', 'img', 'input', 'ins', 'isindex', 'kbd', 'keygen', 'label', 'legend', 'li', 'link', 'listing', 'main', 'map', 'mark', 'marquee', 'math', 'menu', 'menuitem', 'meta', 'meter', 'multicol', 'nav', 'nextid', 'nobr', 'noembed', 'noframes', 'noscript', 'object', 'ol', 'optgroup', 'option', 'output', 'p', 'param', 'picture', 'plaintext', 'pre', 'progress', 'q', 'rb', 'rbc', 'rp', 'rt', 'rtc', 'ruby', 's', 'samp', 'script', 'search', 'section', 'select', 'shadow', 'slot', 'small', 'source', 'spacer', 'span', 'strike', 'strong', 'style', 'sub', 'summary', 'sup', 'svg', 'table', 'tbody', 'td', 'template', 'textarea', 'tfoot', 'th', 'thead', 'time', 'title', 'tr', 'track', 'tt', 'u', 'ul', 'var', 'video', 'wbr', 'xmp' ]);
    const intersectSets = (set1, set2) => {
      const [larger, smaller] =
        set1.size > set2.size ? [set1, set2] : [set2, set1];

      return [...smaller.keys()].reduce(
        (resultSet, key) => (larger.has(key) ? resultSet.add(key) : resultSet),
        new Set(),
      );
    };
    const ambiguousTagNames = intersectSets(svgTagNames, htmlTagNames);

    const addAttributesTo = (el, attributes = {}) => {
      for (const [name, value] of Object.entries(attributes)) {
        el.setAttribute(name, value);
      }
      return el;
    };

    const makeHtmlElement = (tagName, attributes) =>
      addAttributesTo(document.createElement(tagName), attributes);

    const makeSvgElement = (tagName, attributes) =>
      addAttributesTo(
        document.createElementNS('http://www.w3.org/2000/svg', tagName),
        attributes,
      );

    return (tagName, { attributes } = {}) => {
      if (svgTagNames.has(tagName)) {
        if (ambiguousTagNames.has(tagName)) {
          console.warn(
            `makeElement: ambiguous tag name '${tagName}' - assuming html`,
          );
        } else {
          return makeSvgElement(tagName, attributes);
        }
        if (!htmlTagNames.has(tagName)) {
          console.warn(
            `makeElement: unknown tag name '${tagName}' - assuming html`,
          );
        }
        return makeHtmlElement(tagName, attributes);
      }
    };
  })(document, console);

  const hashCode = (str) => {
    let hash = 0;
    for (let i = 0, len = str.length; i < len; i++) {
      let chr = str.charCodeAt(i);
      hash = (hash << 5) - hash + chr;
      hash |= 0; // Convert to 32bit integer
    }
    return hash;
  };
  /*
   * Split SVG path into parts
   *
   * Split locations:
   *
   * ClosePath: zZ
   *
   * zM => ClosePath followed by abs Move
   * zm => ClosePath followed by rel move, convert rel move to abs:
   *       look back to find the last zM, and then subtract m from M
   *
   * z[LHVCQA] => ClosePath followed by abs drawing command
   * z[lhvcqa] => ClosePath followed by rel drawing command
   *     -> Probably shouldn't split here
   * z[SsTt]   => ClosePath followed by follow-on Bezier curve command
   *     -> Probably shouldn't split here
   *
   * Holes:
   *
   * If a feature has a hole in it, detect that and ensure the hole
   * isn't split from its parent.
   *
   */
  const parentSvg = path.parentNode.closest('svg');
  const svg = parentSvg.cloneNode();
  path.attributes.d.value.split(/(?<=z)(?=M)/g).map((part) =>
    svg.appendChild(
      ((pathGroup) => {
        const pathId = `path_${hashCode(part)}`;
        const clipPathId = `clip_${hashCode(part)}`;
        pathGroup.appendChild(
          makeElement('path', {
            attributes: {
              d: part,
              id: pathId,
              'clip-path': `url(#${clipPathId})`,
            },
          }),
        );
        const clippath = makeElement('clipPath', {
          attributes: {
            id: clipPathId,
          },
        });
        clippath.appendChild(
          makeElement('use', {
            attributes: {
              href: `#${pathId}`,
            },
          }),
        );
        pathGroup.appendChild(clippath);
        return pathGroup;
      })(makeElement('g')),
    ),
  );

  const [x, y, w, h] = svg.attributes.viewBox.value
    .split(' ')
    .map((i) => parseInt(i, 10));

  const scale = 0.8;

  svg.setAttribute(
    'viewBox',
    `${((w / scale - w) * -0.5).toFixed(2)} ${((h / scale - h) * -0.5).toFixed(
      2,
    )} ${(w / scale).toFixed(2)} ${(h / scale).toFixed(2)}`,
  );

  parentSvg.parentNode.appendChild(svg);
};

document
  .querySelectorAll('svg > path:first-child')
  .forEach((path) => splitpath(path));
