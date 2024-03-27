

/*
 * === Quick Start ===
 *
 * Include:
 *   <script type="application/javascript" src="entanglement.js"></script>
 * 
 * Switch on:
 *   window.addEventListener('load', (event) => {
 *     const unbind = entanglement.bindStuff();
 *   });
 *
 * Switch off:
 *   unbind();
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
const entanglement = (() => {

  const bindStuff = (prefix = 'bdata') => {
    /* Auto: uses id as data source name */
    const dataSources = [...document.querySelectorAll(`[data-source]`)];

    return dataSources.map((dataSource) => {
      const controller = new AbortController();
      const signal = controller.signal;

      const name = dataSource.getAttribute('data-source') || dataSource.getAttribute('id');
      if (typeof name !== 'string') {
        throw new Exception('Nothing to bind on');
      }
      const events = dataSource.getAttribute('data-source-on')?.split?.(' ') ?? ['input'];
      events.forEach((evname) => {
        const updateValue = ((dataSource, name, target) => {
          const val = dataSource.value;
          dataSource.setAttribute(`data-${name}`, val);

          /* Update all listeners */
          document.querySelectorAll(`[data-sink-for~=${name}],[data-sink~=${name}]`).forEach((node) => {
            const sinkAttr = (node.getAttribute('data-map-attr')?.split?.(' ') ?? [])
              .flatMap((s) => ((n, v) => n === name ? [v] : [])(...s.split(':')[0]))[0] ?? `data-from-${name}`;
            node?.setAttribute?.(sinkAttr, val);
          });
          /* Update nearest parent sink-all */
          (dataSource.closest(`[data-sink-all]`) ?? document.body).setAttribute(`data-from-${name}`, val);
          document.documentElement.style.setProperty(`--${prefix}-str-${name}`, `"${val}"`);
          document.documentElement.style.setProperty(`--${prefix}-${name}`, `${val}`);
        }).bind(null, dataSource, name);

        updateValue(dataSource);
        dataSource.addEventListener(evname, (e) => updateValue(e.target), {signal});
      });
      return () => signal.abort();
    });
  };
  
  return {
    bindStuff
  };
})();



          /* Update nearest parent sink */
          // const closestParentSink = e.target.closest(`[data-sink-for~=${name}]`);
          // if (closestParentSink) {
          //   const sinkAttr = (closestParentSink.getAttribute('data-map-attr')?.split?.(' ') ?? [])
          //     .flatMap((s) => ((n, v) => n === name ? [v] : [])(...s.split(':')[0]))[0] ?? `data-from-${name}`;

          //   closestParentSink.setAttribute?.(sinkAttr, val);
          // }
