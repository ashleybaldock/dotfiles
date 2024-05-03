

/*
 * === Quick Start ===
 *
 * Include:
 *   <script type="application/javascript" src="entanglement.js"></script>
 * 
 * Enable:
 *   entanglement([options]).then((untangle) => {
 *      console.log('Entangled');
 *   });
 * Or:
 *   const untangle = await entanglement([options]);
 *
 * Switch off:
 *   untangle();
 *
 * Configure:
 *   options: {
 *     // CSS variables are prefixed with this string
 *     prefix: 'myCustomPrefix',  // Default: 'bdata'
 *
 *     // Automatically wire up inputs with their labels
 *     autoLabel: true,           // Default: true         (TODO)
 *
 *     // Watch DOM for addition of new data sources/sinks (TODO)
 *     observer: true,
 *   }
 *
 * === Data Sources ===
 * data-source                  Identifies this element as a source      ⎫ Uses id attr as data-
 * data-source=":evt1,evt2"     List of events that trigger data update  ⎭  source identifier
 * data-source="<data-id>"      Set a custom data-source identifier
 * data-source="<data-id>:evt1,evt2"
 *                              Map events to one or more data source identifiers
 *                               (which can be consumed by different sinks)
 *
 * ===  Data Sinks  ===
 * data-sink="*"                Element is a sink for all data sources
 * data-sink=
 *  "<id_1>[ <id_2> ...]"       Element is a sink for specific data source(s)
 *
 * === Data Mapping ===
 *
 * data-sink="<id>[:a(<name>)][:c(<name>:<as>)] ..<id>[]"
 *
 *   <id> : (one of)
 *      id       ['id' | 'data-source'] attribute (e.g. id="" | data-source="")
 *      %name    'name' attribute (e.g. radio button groups)
 *
 *  Default: new data value is written to:
 *    HTML attr: 'data-from-${id}'           (prefix defaults to 'bdata', 
 *      CSS var: '--${prefix}-${id}'          customise via options.prefix)
 *      CSS str: '--${prefix}-s-${id}'
 *
 *  (Optional) Customise mapping between source and sink
 *    [:a(<name>)]
 *    [:c(<name>:<as>)]
 *      name : Name for CSS variable, 
 *             (If this starts with '--', it defines the whole variable name
 *              otherwise it is prefixed like the default) e.g.:
 *                    user-name => (--${prefix}-user-name)
 *                  --user-name => (--user-name)
 *      as :   Type of CSS variable
 *
 */
const entanglement = ((window) => {
  const { document } = window;

  const getCurrentValue = (source) => {
    const type = source.getAttribute('type');
    if (type === 'checkbox' || type === 'radio') {
      return source.checked;
    }
    return source.value;
  };

  const getRadioGroupValue = (name) => {
    // Only works if the radio buttons are inside a form
    if (dataSource.form?.elements?.namedItem?.(name)?.value ?? false) {
      return dataSource.form?.elements?.namedItem?.(name)?.value;
    } else {
      return [...qs(`input[type='radio'][name=${name}]:checked`)][0]?.value ?? null;
    }
  };

  const entangle = (document, prefix) => {
    console.log('entangle()');

    const { querySelectorAll: qs } = document;

    /* Auto: uses id as data source name */
    const dataSources = [...qs(`[data-source], input[type=radio], input[type=checkbox]`)];

    const controller = new AbortController();
    const signal = controller.signal;

    dataSources.forEach((dataSource) => {
      const dataSourceId = dataSource.getAttribute('data-source') || dataSource.getAttribute('id');
      if (typeof dataSourceId !== 'string') {
        throw new Exception('Nothing to bind on');
      }

      const dataSourceType = dataSource.getAttribute('type');

      const defaultEvents = ['input'];
      if (dataSourceType === 'checkbox' || dataSourceType === 'radio') {
        defaultEvents.push('change');
      }
      const events = dataSource.getAttribute('data-source-on')?.split?.(' ') ?? defaultEvents;

      events.forEach((event) => {
        const updateValue = ((dataSource, dataSourceId, target) => {
          const currentValue = getCurrentValue(dataSource);

          /* Update self */
          queueUpdate({dataSource, dataSink: dataSource});

          /* Update associated labels */
          qs(`label[for=${dataSourceId}]`).forEach((dataSink) => {
            queueUpdate({dataSource, dataSink});
          });

          if (dataSourceType === 'radio' && event === 'change') {
            if (dataSource.hasAttribute('name')) {
              const dataSourceName = dataSource.getAttribute('name');
              qs(`[data-sink~=name%${dataSourceName}], [name=${dataSourceName}]`).forEach((dataSink) => {
                queueUpdate({dataSource, dataSink, value: () => getRadioGroupValue(dataSourceName), alias: `name-${dataSourceName}`});
              });
            } else {
              console.warn(`Entanglement: Found input(radio) with no name - id: '${dataSourceId}'`);
            }
          }

          /* Update listeners */
          qs(`[data-sink~=${dataSourceId}]`).forEach((dataSink) => {
            queueUpdate({dataSource, dataSink});
          });

          /* Update nearest parent sink-all */
          queueUpdate({dataSource, dataSink: dataSource.closest(`[data-sink-all]`) ?? document.body});

          sendQueuedUpdates();


          const queueUpdate = ({dataSource, dataSink, value = () => getCurrentValue(dataSource), alias = `TODO`}) => {

          };  //TODO

          const sendQueuedUpdates = () => {  //TODO
            /* Update everything */
            dataSinksToUpdate.forEach(([dataSinkNode, getValue = () => , name]) => {
              /* Map output */
              // const sinkAttr = (dataSink.getAttribute('data-map-attr')?.split?.(' ') ?? [])
              //   .flatMap((s) => ((n, v) => n === dataSourceId
              //     ? [v] 
              //     : [])(...s.split(':')[0]))[0] ?? `data-from-${dataSourceId}`;
              // dataSink?.setAttribute?.(sinkAttr, currentValue);
              dataSink?.setAttribute?.(`data-from-${dataSourceId}`, currentValue);
              dataSink?.style?.setProperty(`--${prefix}-s-${dataSourceId}`, `"${currentValue}"`);
              dataSink?.style?.setProperty(`--${prefix}-${dataSourceId}`, `${currentValue}`);
            });
          };
        }).bind(null, dataSource, dataSourceId);

        updateValue(dataSource);
        dataSource.addEventListener(event, (e) => updateValue(e.target), {signal});
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
