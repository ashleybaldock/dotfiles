#!/usr/bin/env node

var fs = require('fs');
const readStdin = () => fs.readFileSync(0, 'utf-8');

/**
 * Minimally transform SVG for use in a dataurl
 */
const encodeSVG = (svg) =>
  `data:image/svg+xml,${svg
    .replace(/>\s{1,}</g, `><`) /* strip spaces between tags */
    .replace(/\s{2,}/g, ` `) /* remove multiple spaces */
    .replace(/[\r\n]$/g, ``) /* remove trailing newline(s) */
    .replace(/[\r\n%#()"'<>?[\\\]^`{|}]/g, encodeURIComponent)}`;

/**
 * Encode SVG into a dataurl
 *
 * Note: output does not include trailing ';'
 */
const dataurlSVG = (svg) => `url('${encodeSVG(svg)}')`;

// console.log(process.argv);

console.log(
  dataurlSVG(
    process.argv.length > 2 ? process.argv.slice(2).join(' ') : readStdin(),
  ),
);
