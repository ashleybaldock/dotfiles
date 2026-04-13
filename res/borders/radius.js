import { readyStateComplete } from '/js/util.js';


readyStateComplete().then(() => {
  const sourceMap = new Map([
    ...document.querySelectorAll('[data-source], input[id]')
  ].map((source) => [source.getAttribute('id'), source]));

  const sinks = {
    data: [...document.querySelectorAll('[data-sink]')],
    auto_for: [...document.querySelectorAll('[for]')],
    // auto_label: [...document.querySelectorAll('label:not([for]):has(input)')],
  };

  const setProp = (element, property, newValue) => {
    element.style.setProperty(`--bdata-${property}`, newValue);
    element.style.setProperty(`--bdata-str-${property}`, `'${newValue}'`);
  };
  const unsetProp = (element, property) => {
    element.style.removeProperty(`--bdata-${property}`);
    element.style.removeProperty(`--bdata-str-${property}`);
  };

  sinks.data.forEach((sink) =>
    sink.dataset?.sink.split(' ')
      .forEach((sourceId) => {
        const source = sourceMap.get(sourceId);
        if (source) {
          source.addEventListener('change',
          ({target}) => {
            setProp(sink, sourceId, target.value);
            unsetProp(sink, `${sourceId}-input`);
          });
          source.addEventListener('input',
          ({target}) => setProp(sink, `${sourceId}-input`, target.value) );
          setProp(sink, sourceId, source.value);
        }
      })
  );

  sinks.auto_for.forEach((sink) =>
    sink.getAttribute('for')?.split(' ')
      .forEach((sourceId) => {
        const source = sourceMap.get(sourceId);
        if (source) {
          source.addEventListener('change',
          ({target}) => {
            setProp(sink, 'for', target.value);
            unsetProp(sink, `for-input`);
          });
          source.addEventListener('input',
          ({target}) => setProp(sink, 'for-input', target.value) );
          setProp(sink, 'for', source.value);
        }
      }));
});
