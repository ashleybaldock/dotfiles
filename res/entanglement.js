

/*
 * === Quick Start ===
 *
 *
 * Include:
 *
 *   <script type="application/javascript" src="entanglement.js"></script>
 * 
 *
 * Enable:
 *
 *   entanglement([options]).then((untangle) => {
 *      console.log('Entangled');
 *   });
 *
 * Or:
 *
 *   const untangle = await entanglement([options]);
 *
 *
 * Switch off:
 *   untangle();
 *
 * Configure:
 *   options: {
 *     // CSS variables are prefixed with this string
 *     prefix: 'myCustomPrefix',  // Default: 'bdata'
 *
 *     // Add generated data-source IDs to elements missing them
 *     autoId:   true,            // Default: true
 *
 *     // Entangle inputs with label/output elements using 'for' attribute
 *     autoFor:  true,            // Default: true
 *
 *     // Watch DOM for addition of new data sources/sinks (TODO)
 *     observe: true,
 *   }
 *
 * === Data Sources ===
 *
 *
 * data-source="<data-source-1>:<data-source-2>:..."
 *  <data-source-list> is a colon separated list of:
 *  <data-id>;<event-list>;<option-list>
 *
 * data-source              Identifies this element as a source      ⎫ Uses id attr as data-
 * <data-id>                Set a custom data-source identifier
 *                           If element has an id, this is used instead
 * <event-list>             List of events to listen to
 *  ="<data-id>;evt1,evt2"  Map events to one or more data source identifiers
 *                           (which can be consumed by different sinks)
 * <option-list>
 *  root,                   Publish source as CSS variables to :root
 *
 * ===  Data Sinks  ===
 * data-sink="*"            Element is a sink for all data sources
 * data-sink=
 *  "<id_1>[ <id_2> ...]"   Element is a sink for specific data source(s)
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
  console.log('entanglement()');
  const { document } = window;
  const { querySelectorAll: qs } = document;

  const entangle = (document, options) => {
    const {
      prefix = 'tngl',
      autoId = true,
      autoFor = true,
      observe = true,
    } = options;

    console.log('entangle()');

    const getUpdateQueue = (() => {
      const dataSinksMap = new Map();

      return () => ({
        enqueue: ({source, sink, newValue}) => {
          dataSinksMap.has(sink)
            ? dataSinksMap.get(sink).set(source.id, newValue)
            : dataSinksMap.set(sink, new Map([source.id, newValue]));
        },
        /* Update everything */
        send: () => {
          for ([sink, newValues] of dataSinksMap) {
            for ([sourceId, newValue] of newValues) {
              sink?.setAttribute?.(`data-from-${sourceId}`, newValue);
              sink?.style?.setProperty(`--${prefix}-s-${dataSourceId}`, `"${currentValue}"`);
              sink?.style?.setProperty(`--${prefix}-${dataSourceId}`, `${currentValue}`);
            }
          }
        },
            /* Map output TODO */
            // const sinkAttr = (dataSink.getAttribute('data-map-attr')?.split?.(' ') ?? [])
            //   .flatMap((s) => ((n, v) => n === dataSourceId
            //     ? [v] 
            //     : [])(...s.split(':')[0]))[0] ?? `data-from-${dataSourceId}`;
            // dataSink?.setAttribute?.(sinkAttr, currentValue);
      });
    })();

    const getCurrentValue = (source) => {
      const type = source.getAttribute('type');
      if (type === 'checkbox' || type === 'radio') {
        return source.checked;
      }
      return source.value;
    };

    const getRadioGroupValue = ({ element, name }) =>
        element.form?.elements?.namedItem?.(name)?.value ?? 
        [...qs(`input[type='radio'][name=${name}]:checked`)][0]?.value ?? null;

    const sourceDefinitions = [
      { query: `[data-source]`, events: [``], },
      { query: `input[type=radio]`, events: [``], },
      { query: `input[type=checkbox]`, events: [``], },
    ];

    const nextId = ((id) => () => ++id)(0);

    const getOrAssignIdFor = (element) =>
      (element.hasAttribute('data-source') && element.getAttribute('data-source'))
        || (element.hasAttribute('id') && getAttribute('id'))
        || autoId
          ? ((id) => element.setAttribute('data-source',
              `${prefix}${id.toString(16).padStart(6, '0')}`) ?? id)(nextId())
          : null;

    const typeFor = (element) =>
      `${element.localName}:${(element.hasAttribute('type') && element.getAttribute('type')) || ''}`

    const nameFor = (element) => element.getAttribute('name');

    const defaultEventsFor = ((sourceTypeMap, defaultEvents) =>
      (sourceType) => sourceTypeMap.has(sourceType)
        ? sourceTypeMap.get(sourceType)
        : defaultEvents)(new Map([
          ['input:checkbox', ['input', 'change']],
          ['input:radio', ['input', 'change']]]),
        ['input']);

    const eventsFor = (element) => (element.hasAttribute('data-source-on') && 
          element.getAttribute('data-source-on')?.split?.(' ')) ?? defaultEventsFor(element);

  // : { element: sourceElement, id: sourceId }
    const entangleEvent = ({ source }) => {
      const pending = getUpdateQueue();

      const update = ({ eventName, newValue }) => {
        /* Update self */
        pending.enqueue({ source, sink: source.element, newValue });

        /* Update associated labels & outputs */
        // TODO memoise and update via mutationobserver
        qs(`:is(label,output)[for=${dataSourceId}]`).forEach((sink) => {
          pending.enqueue({ source, sink, newValue });
        });
        /* Update listeners */
        qs(`[data-sink~=${dataSourceId}]`).forEach((sink) => {
          pending.enqueue({ source, sink, newValue });
        });

        if (source.type === 'input:radio' && eventName === 'change') {
          if (source.name) {
            qs(`[data-sink~=name%${source.name}], [name=${source.name}]`).forEach((sink) => 
              pending.enqueue({source, sink, newValue: getRadioGroupValue(source), alias: `name-${source.name}`}));
          } else {
            console.warn(`Entanglement: Found input(radio) with no name - id: '${dataSourceId}'`);
          }
        }

        /* Update nearest parent sink-all */
        pending.enqueue({ source, sink: source.closest(`[data-sink-all]`) ?? document.body, newValue });

        pending.send();
      };

      update();

      return update; 
    };

    /* Auto: uses id as data source name */
    const potentialSourceElements = [...qs(sourceDefinitions.map((d) => d.query))]; // TODO memoise

    const controller = new AbortController();
    const signal = controller.signal;

    const sources = potentialSourceElements.flatMap((element) => {
      const source = {
        element,
        id: getOrAssignIdFor(element),
        type: typeFor(element),
        name: nameFor(element),
        events: eventsFor(element),
      };

      if (source.id === null) {
        console.log(`Could not find an id for source element`, source);
        return [];
      }

      const valueUpdater = entangleEvent({ source });

      eventsFor(sourceElement).forEach((eventName) => {
        source.addEventListener(eventName, valueUpdater, { signal });
      });
    });
    return () => signal.abort();
  };
  
  return ((options = {}) => {
    const promise = new Promise((resolve, reject) => { 
    const waitForComplete = () => document.readyState === 'complete' ?
      resolve(entangle(document, options)) : 
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
