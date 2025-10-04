(() => {
  const parseTag = (raw, ...substitutions) =>
    String.raw({ raw }, ...substitutions) ?? '';
  const css = (...args) => parseTag(...args).replace('\n', '');

  const cap = css`
    font-size: 16px;
    font-weight: normal;
    font-family: SF mono;
    line-height: 18px;
    text-align: center;
    text-transform: uppercase;
    border: 1px solid #eee;
    border-radius: 4px;
    display: inline-block;
    margin: 0 0.5ch;
    height: 1lh;
    min-width: 1lh;
    box-sizing: content-box;
    padding: 0 0;
  `;
  const capn = css`
    ${cap};
    margin-left: -0.4ch;
    border-left: none;
    border-radius: 0 4px 4px 0;
    padding-left: 0ch;
  `;
  const capp = css`
    ${cap};
    font-weight: bold;
    background-color: #eee;
    color: #111;
  `;
  const cappn = css`
    ${capp};
    ${capn}font-weight: bold;
    background-color: #eee;
    color: #111;
    margin-left: -0.8ch;
  `;
  const std = css`
    font-size: 10px;
    line-height: 18px;
  `;
  const big = css`
    font-size: 20px;
    line-height: 18px;
  `;
  const mono = css`
    font-family: SF mono;
  `;
  const key = css`
    ${mono}
    ${big}
  `;
  const sqr = css`
    ${std};
    border: 1px solid #eee;
    border-radius: 4px;
    display: inline-block;
    margin: 0 0.5ch;
    text-align: center;
  `;
  const sqb = css`
    ${key};
  `;
  const sqrb = css`
    ${sqr};
    border-right: none;
    border-radius: 4px 0 0 4px;
    margin: 0 0 0.5ch 0;
  `;
  const sqbb = css`
    ${cap};
    ${key};
    border: 1px solid #eee;
    border-left: none;
    border-radius: 0 4px 4px 0;
    display: inline-block;
    margin: 0 0.5ch 0 0;
    text-align: center;
  `;

  const logf = (raw, ...substitutions) =>
    console.log(raw.join('%c'), ...substitutions);

  logf`${std} shift ${key}⇧${std} ctrl ${key}⌃${std} option ${key}⌥${std} command ${key}⌘${std}`;

  logf`${sqr} shift ${sqb}⇧${sqr} ctrl ${sqb}⌃${sqr} option ${sqb}⌥${sqr} command ${sqb}⌘${std}`;

  logf`${sqrb} shift ${sqbb}⇧${sqrb} ctrl ${sqbb}⌃${sqrb} option ${sqbb}⌥${sqrb} command ${sqbb}⌘${std}`;

  logf`${cap}⇧️${std}${cap}⌃︎${std}${cap}⌥${std}${cap}⌘️${std}  ${capp}⇧️${std}${capp}⌃︎${std}${capp}⌥${std}${capp}⌘️${std}`;

  logf`${cap}⇧️${capn}r${std}${cap}⌃︎${capn}c${std}${cap}⌥${capn}p${std}${cap}⌘️${capn}s${std}`;

  logf`${capp}⇧️${capn}r${std}${capp}⌃︎${capn}c${std}${capp}⌥${capn}p${std}${capp}⇧️${cappn}⌘️${capn}s${std}`;
})();
