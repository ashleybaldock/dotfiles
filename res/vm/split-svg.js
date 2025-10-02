((node) => {
  [...node.querySelectorAll('path')].forEach((path) => {
    path.after(
      ...path
        .getAttribute('d')
        .split(/(?<=[zZ])\s*(?=[MLHVCSQTA])/)
        .map((zAbsPart) => {
          const absPosition = zAbsPart.split(/\s*(?=[MLHVCSQTAmlhvcsqta])/)[0];
          const g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
          g.replaceChildren(
            ...zAbsPart.split(/(?<=[zZ])\s*(?=[mlhvcsqta])/).map((zRelPart) => {
              const path = document.createElementNS(
                'http://www.w3.org/2000/svg',
                'path',
              );
              path.setAttribute('d', `${absPosition}${zRelPart}`);
              return path;
              //   zRelPart.split(/\s*(?=[mlhvcsqta])/).map((part) => )
            }),
          );
          return g;
        }),
    );
    path.style.visibility = 'hidden';
  });
})(temp1);
