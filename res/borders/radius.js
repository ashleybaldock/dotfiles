import { readyStateComplete } from '/js/util.js';


readyStateComplete().then(() => {
  const sourceMap = new Map([...document.querySelectorAll('[data-source]')].map((sourceElement) => [sourceElement.getAttribute('id'), sourceElement]));

  const sinks = [...document.querySelectorAll('[data-sink]')];

  sinks.forEach((sink) =>
    sink.dataset?.sink.split(' ')
      .flatMap((sourceId) => sourceMap.has(sourceId) ? [[sourceId, sourceMap.get(sourceId)]] : [])
      .forEach(([sourceId, source]) => {
        source.addEventListener('change',
        ({target}) => {
          sink.style.setProperty(`--bdata-${sourceId}`, target.value);
          sink.style.setProperty(`--bdata-str-${sourceId}`, `'${target.value}'`);
        } );
        source.addEventListener('input',
        ({target}) => {
          sink.style.setProperty(`--input-${sourceId}`, target.value);
          sink.style.setProperty(`--input-str-${sourceId}`, `'${target.value}'`);
        } );
      })
  );


});
