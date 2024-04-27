

/*
 * === Quick Start ===
 *
 * Include:
 *   <script type="application/javascript" src="entanglement.js"></script>
 * 
 * Switch on:
 *   window.addEventListener('load', (event) => {
 *     const untangle = entanglement();
 *   });
 *
 * Switch off:
 *   untangle();
 *
 * Configure:
 *   const unbind = entanglement.bindStuff({
 *     // CSS variables are prefixed with this string
 *     // Default: 'bdata'
 *     prefix: 'myCustomPrefix',
 *     // Watch DOM for addition of new data sources/sinks (TODO)
 *     // Default: true
 *     observer: true,
 *   });
 *
 * === Data Sources ===
 * data-source                  Uses element's id as data-source identifier
 * data-source="<data-id>"      Set a custom data-source identifier
 * data-source-on=              List of events that trigger data update
 *  "evt1[ evt2...]"
 *
 * ===  Data Sinks  ===
 * data-sink-all                Element is a sink for all data sources
 * data-sink=
 *  "<id_1>[ <id_2> ...]"       Element is a sink for specific data source(s)
 *
 * === Data Mapping ===
 * By default, the new data value is written to:
 *    HTML attribute: 'data-from-${id}'
 *      CSS variable: '--${prefix}-${id}'
 *  CSS var (string): '--${prefix}-str-${id}'
 *  CSS var (string): '--${prefix}-str-${id}'
 *
 *  (prefix defaults to 'bdata', customise via options passed to bindStuff() )
 *
 * data-map-attr=               Mapping between data id and attribute name
 *  "<id1>:<a1>[ <id2>:<a2>]"
 * data-map-cssv=               Mapping between data id and css variable name
 *  "<id1>:<v1>[ <id2>:<v2>]"
 */
const entanglement = ((window) => {
  const { document } = window;

  const getCurrentValue = (source, type) => {
    if (type === 'checkbox' || type === 'radio') {
      return source.checked;
    }
    return source.value;
  };

  const entangle = (document, prefix) => {
    console.log('entangle()');
    /* Auto: uses id as data source name */
    const dataSources = [...document.querySelectorAll(`[data-source]`)];

    const controller = new AbortController();
    const signal = controller.signal;

    dataSources.forEach((dataSource) => {
      const name = dataSource.getAttribute('data-source') || dataSource.getAttribute('id');
      if (typeof name !== 'string') {
        throw new Exception('Nothing to bind on');
      }
      const type = dataSource.getAttribute('type');
      const defaultEvents = ['input'];
      if (type === 'checkbox' || type === 'radio') {
        defaultEvents.push('change');
      }
      const events = dataSource.getAttribute('data-source-on')?.split?.(' ') ?? defaultEvents;
      events.forEach((evname) => {
        const updateValue = ((dataSource, name, target) => {
          const currentValue = getCurrentValue(dataSource, type);
          dataSource.setAttribute(`data-${name}`, currentValue);

          /* Update all listeners */
          document.querySelectorAll(`[data-sink-for~=${name}],[data-sink~=${name}]`).forEach((node) => {
            const sinkAttr = (node.getAttribute('data-map-attr')?.split?.(' ') ?? [])
              .flatMap((s) => ((n, v) => n === name ? [v] : [])(...s.split(':')[0]))[0] ?? `data-from-${name}`;
            node?.setAttribute?.(sinkAttr, currentValue);
          });
          /* Update nearest parent sink-all */
          (dataSource.closest(`[data-sink-all]`) ?? document.body).setAttribute(`data-from-${name}`, currentValue);
          document.documentElement.style.setProperty(`--${prefix}-str-${name}`, `"${currentValue}"`);
          document.documentElement.style.setProperty(`--${prefix}-${name}`, `${currentValue}`);
        }).bind(null, dataSource, name);

        updateValue(dataSource);
        dataSource.addEventListener(evname, (e) => updateValue(e.target), {signal});
      });
    });
    return () => signal.abort();
  };
  
  return ((options = {}) => {
  const {prefix = 'bdata'} = options;
    const promise = new Promise((resolve, reject) => { 
    const waitForComplete = () => document.readyState === 'complete' ?
      resolve(entangle(document, prefix)) : 
      document.addEventListener('readystatechange', waitForComplete);
      waitForComplete();
    });
    return promise;
})

})(window);


          /* Update nearest parent sink */
          // const closestParentSink = e.target.closest(`[data-sink-for~=${name}]`);
          // if (closestParentSink) {
          //   const sinkAttr = (closestParentSink.getAttribute('data-map-attr')?.split?.(' ') ?? [])
          //     .flatMap((s) => ((n, v) => n === name ? [v] : [])(...s.split(':')[0]))[0] ?? `data-from-${name}`;

          //   closestParentSink.setAttribute?.(sinkAttr, val);
          // }
