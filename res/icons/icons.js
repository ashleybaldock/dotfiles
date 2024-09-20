const encodeSVG = (data, { fill = '#ffffff' } = {}) =>
  data
    .replace(/<svg/g, `<svg style="fill: ${fill};"`)
    .replace(/>\s{1,}</g, `><`)
    .replace(/\s{2,}/g, ` `)
    .replace(/[\r\n%#()"'<>?[\\\]^`{|}]/g, encodeURIComponent)

const svgToCSSBackground = (svgHTML) =>
  `background-image: url('data:image/svg+xml,${encodeSVG(svgHTML)}');`
const svgToCSSvar = (svgHTML, varName) =>
  `--icon-${varName}: url('data:image/svg+xml,${encodeSVG(svgHTML)}');`

window.addEventListener('load', (event) => {
  const styles = [':root {']
  document.querySelectorAll('svg').forEach((svg) => {
    const name = svg.getAttribute('data-name')
    if (name !== null && name?.length > 0) {
      styles.push(`  ${svgToCSSvar(svg.outerHTML, name)}`)
    }
    const div = document.createElement('div')
    div.className = 'iconRow'
    div.insertAdjacentHTML(
      'afterbegin',
      `
        <div class="copyAs">
          <label class="copySVG" onClick="copy(event)">
            <input type="text"/>SVG
          </label>
          <label class="copyBG" onClick="copy(event)">
            <input type="text"/>CSS
          </label>
        </div>
        <div class="asSVG">${svg.outerHTML}</div>
      `,
    )
    div.querySelector('.copySVG input').value = svg.outerHTML
    div.querySelector('.copyBG input').value = svgToCSSBackground(svg.outerHTML)
    svg.replaceWith(div)
  })

  styles.push('}')
  const styleString = styles.join('\n')
  console.log(styleString)

  const styleNode = document.createElement('style')
  styleNode.innerText = styleString
  document.head.appendChild(styleNode)
})
