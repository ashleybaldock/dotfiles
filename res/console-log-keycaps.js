(() => {
  const parseTag = (raw, ...substitutions) =>
    String.raw({ raw }, ...substitutions) ?? '';
  const css = (...args) => parseTag(...args);

  const cap = css`
    font-size: 16px;
    line-height: 18px;
    border: 1px solid #eee;
    border-radius: 4px;
    display: inline-block;
    margin: 0 0.5ch;
    height: 1lh;
    text-align: center;
    font-weight: normal;
    min-width: 1lh;
    box-sizing: content-box;
    padding: 0 0;
    font-family: SF mono;
    text-transform: uppercase;
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
  const big = css`
    font-family: SF mono;
    font-size: 20px;
    line-height: 18px;
  `;
  const std = css`
    font-size: 10px;
    line-height: 18px;
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
    ${big};
  `;
  const sqrb = css`
    ${sqr};
    border-right: none;
    border-radius: 4px 0 0 4px;
    margin: 0 0 0.5ch 0;
  `;
  const sqbb = css`
    ${cap};
    ${big};
    border: 1px solid #eee;
    border-left: none;
    border-radius: 0 4px 4px 0;
    display: inline-block;
    margin: 0 0.5ch 0 0;
    text-align: center;
  `;
  console.log(
    '%c shift %c⇧%c ctrl %c⌃%c option %c⌥%c command %c⌘%c',
    std,
    big,
    std,
    big,
    std,
    big,
    std,
    big,
    std,
  );
  console.log(
    '%c shift %c⇧%c ctrl %c⌃%c option %c⌥%c command %c⌘%c',
    sqr,
    sqb,
    sqr,
    sqb,
    sqr,
    sqb,
    sqr,
    sqb,
    std,
  );
  console.log(
    '%c shift %c⇧%c ctrl %c⌃%c option %c⌥%c command %c⌘%c',
    sqrb,
    sqbb,
    sqrb,
    sqbb,
    sqrb,
    sqbb,
    sqrb,
    sqbb,
    std,
  );
  console.log(
    '%c⇧️%c%c⌃︎%c%c⌥%c%c⌘️%c  %c⇧️%c%c⌃︎%c%c⌥%c%c⌘️%c ',
    cap,
    std,
    cap,
    std,
    cap,
    std,
    cap,
    std,
    capp,
    std,
    capp,
    std,
    capp,
    std,
    capp,
    std,
  );
  console.log(
    '%c⇧️%cr%c%c⌃︎%cc%c%c⌥%cp%c%c⌘️%cs%c  %c⇧️%cr%c%c⌃︎%cc%c%c⌥%cp%c%c⇧️%c⌘️%cs%c ',
    cap,
    capn,
    std,
    cap,
    capn,
    std,
    cap,
    capn,
    std,
    cap,
    capn,
    std,
    capp,
    capn,
    std,
    capp,
    capn,
    std,
    capp,
    capn,
    std,
    capp,
    cappn,
    capn,
    std,
  );
})();
