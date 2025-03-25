#!/usr/bin/env node

import { minify } from 'csso';

import fs from 'fs';

const readStdin = () => fs.readFileSync(0, 'utf-8');

// const minifiedCss = minify('.test { color: #ff0000; }').css;

const options /*: MinifyOptions & CompressOptions*/ = {
  sourceMap: false,
  filename: '<unknown>',
  debug: false,
  beforeCompress: undefined,
  afterCompress: undefined,

  restructure: true,
  forceMediaMerge: false,
  clone: false,
  comments: false /* 'exclamation' | 'first-exclamation' */,
  usage: {},
  logger: console.debug,
};

console.debug(
  minify(
    process.argv.length > 2 ? process.argv.slice(2).join(' ') : readStdin(),
    options,
  ).css,
);
