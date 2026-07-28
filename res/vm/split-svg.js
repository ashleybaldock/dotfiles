((node) => {
  const createElementSVG = Function.prototype.call.bind(
    document.createElementNS,
    document,
    'http://www.w3.org/2000/svg',
  );

  [...node.querySelectorAll('path')].forEach((path) => {
    path.after(
      ...path
        .getAttribute('d')
        .split(/(?<=[zZ])\s*(?=[MLHVCSQTA])/)
        .map((zAbsPart) => {
          const absPosition = zAbsPart.split(/\s*(?=[MLHVCSQTAmlhvcsqta])/)[0];
          const g = createElementSVG('g');
          g.replaceChildren(
            ...zAbsPart.split(/(?<=[zZ])\s*(?=[mlhvcsqta])/).map((zRelPart) => {
              const path = createElementSVG('path');
              path.setAttribute('d', `${absPosition}${zRelPart}`);
              return path;
            }),
          );
          return g;
        }),
    );
    path.style.visibility = 'hidden';
  });
})(temp1);
