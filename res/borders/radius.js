import { readyStateComplete } from '/js/util.js';


readyStateComplete().then(() => {
  const sourceMap = new Map([...document.querySelectorAll('[data-source]')].map((sourceElement) => [sourceElement.getAttribute('id'), sourceElement]));

  const sinks = [...document.querySelectorAll('[data-sink]')];

  const setStyleProperty = (element, property, newValue) => {
    element.style.setProperty(`--bdata-${property}`, newValue);
    element.style.setProperty(`--bdata-str-${property}`, `'${newValue}'`);
  };

  sinks.forEach((sink) =>
    sink.dataset?.sink.split(' ')
      .flatMap((sourceId) => sourceMap.has(sourceId) ? [[sourceId, sourceMap.get(sourceId)]] : [])
      .forEach(([sourceId, source]) => {
        source.addEventListener('change',
        ({target}) => setStyleProperty(sink, sourceId, target.value) );
        source.addEventListener('input',
        ({target}) => setStyleProperty(sink, sourceId, target.value) );
        setStyleProperty(sink, sourceId, source.value);
      })
  );
});
