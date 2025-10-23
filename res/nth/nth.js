(({ document }) => {
  const container = '.nths';
  const row = '.nth';
  const dataNth = 'nth';
  const pseudoClasses = ['nth-child', 'nth-last-child'];

  const n = [''];
  const nthTemplate = css`
    ${container}:has(> [data-${dataNth}='-n']:hover, > ${row} > :${pseudoClass}(-n):hover)
  :where([data-${dataNth}='-n'], .nth > :${pseudoClass}(-n)) {
      --c-badge: #9dd;
      --badge-content: '-n';
    }
  `;
})(window);
