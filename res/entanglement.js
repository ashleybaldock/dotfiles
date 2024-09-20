/*
## Quick Start


### Include

```html
<script type="application/javascript" src="entanglement.js"></script>
```


### Enable

```javascript
entanglement(options).then((untangle) => {
   console.log('Entangled');
});
```

Or:

```javascript
const untangle = await entanglement([options]);
```

### Disable

```javascript
untangle();
```

### Configure

```javascript
  options: {
    // CSS variables are prefixed with this string
    prefix: 'myCustomPrefix',  // Default: 'tngl'

    // Add generated data-source IDs to elements missing them
    autoId:   true,            // Default: true

    // Entangle inputs with label/output elements using 'for' attribute
    autoFor:  true,            // Default: true

    // Watch DOM for addition of new data sources/sinks (TODO)
    observe: true,
  }
  ```
 

 ## Data Sources

```
 data-source="<data-source-1>:<data-source-2>:..."
  <data-source-list> is a colon separated list of:
  <data-id>;<event-list>;<option-list>
```

### Attributes

- data-source              Identifies this element as a source.
  - Element's id attribute used as source ID by default.

Multiple data sources can be defined for an element. For each source:

- <data-id>               Source ID, used to refer to a source.
  - Defaults to element's id attribute (or an auto-generated ID if `autoId` is set)

- <event-list>             List of events to listen to
  ="<data-id>;evt1,evt2"  Map events to one or more data source identifiers
                           (which can be consumed by different sinks)
 <option-list>
  root,                   Publish source as CSS variables to :root


 ===  Data Sinks  ===

 data-sink="*"            Element is a sink for all data sources
 data-sink=
  "<id_1>[ <id_2> ...]"   Element is a sink for specific data source(s)


 === Data Mapping ===

 data-sink="<id>[:a(<name>)][:c(<name>:<as>)] ..<id>[]"

   <id> : (one of)
      id       ['id' | 'data-source'] attribute (e.g. id="" | data-source="")
      %name    'name' attribute (e.g. radio button groups)

  Default: new data value is written to:
    HTML attr: 'data-from-${id}'           (prefix defaults to 'tngl', 
      CSS var: '--${prefix}-${id}'          customise via options.prefix)
      CSS str: '--${prefix}-s-${id}'

  (Optional) Customise mapping between source and sink
    [:a(<name>)]
    [:c(<name>[:<as>])]
      name : Name for CSS variable, 
             (If this starts with '--', it defines the whole variable name
              otherwise it is prefixed like the default) e.g.:
                   user-name => (--${prefix}-user-name)
                 --user-name => (--user-name)
        as : ['string' | <omit>]
             Optionally surround value with quotes, so it is treated as a string
            (In future, 

 */
const entanglement = ((window) => {
  console.log('entanglement()');
  const { document } = window;
  const qs = document.querySelectorAll.bind(document);

  const nameFor = (element) => element.getAttribute('name');
  const typeFor = (element) =>
    `${element.localName}:${
      (element.hasAttribute('type') && element.getAttribute('type')) || ''
    }`;

  /**
   *
   */
  const wrapped = () => {};

  const entangle = (document, options) => {
    const {
      prefix = wrapped('tngl'),
      autoId = wrapped(true),
      autoFor = wrapped(true),
      observe = wrapped(true),
    } = options;

    console.log('entangle()');

    const getUpdateQueue = (() => {
      const dataSinksMap = new Map();

      return () => ({
        enqueue: ({ source, sink, newValue }) => {
          dataSinksMap.has(sink)
            ? dataSinksMap.get(sink).set(source.id, newValue)
            : dataSinksMap.set(sink, new Map([source.id, newValue]));
        },
        /* Update everything */
        send: () => {
          for (const [sink, newValues] of dataSinksMap) {
            for (const [sourceId, newValue] of newValues) {
              sink?.setAttribute?.(`data-from-${sourceId}`, newValue);
              sink?.style?.setProperty(
                `--${prefix}-s-${sourceId}`,
                `"${newValue}"`,
              );
              sink?.style?.setProperty(
                `--${prefix}-${sourceId}`,
                `${newValue}`,
              );
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

    const nextId = (
      (id) => () =>
        ++id
    )(0);

    /**
     * Obtain a value from data source
     *
     * The value is determind in different ways depending on the kind of source
     */
    const getCurrentValue = (() => {
      const getRadioGroupValue = ({ element, name }) =>
        element.form?.elements?.namedItem?.(name)?.value ??
        [...qs(`input[type='radio'][name=${name}]:checked`)][0]?.value ??
        null;

      const getChecked = ({ checked }) => checked;

      const getValue = ({ value }) => value;

      const inputTypeValueMap = new Map([
        'checkbox',
        getChecked,
        'radio',
        getChecked,
      ]);

      return (source) =>
        inputTypeValueMap.get(source.type)?.(source) ?? getValue(source);
    })();

    const sourceDefinitions = [
      { query: `[data-source]`, events: [``] },
      { query: `input[type=radio]`, events: [``] },
      { query: `input[type=checkbox]`, events: [``] },
    ];

    /**
     *  Get an ID to use to refer to a Data Source
     *
     */
    const getOrAssignIdFor = (
      ({ nextId, options }) =>
      (element) =>
        element.getAttribute('data-source') ??
        element.getAttribute('id') ??
        options.autoId
          ? ((id) =>
              element.setAttribute(
                'data-source',
                `${prefix}${id.toString(16).padStart(6, '0')}`,
              ) ?? id)(nextId())
          : null
    )({ nextId, options });

    const validEventNames = new Map([
      ['input', ['input:radio', 'input:checkbox', 'input']],
      ['change', ['input:radio', 'input:checkbox', 'input']],
      ['close', ['dialog']],
      ['slotchange', ['slot']],
      ['toggle', ['details']],
    ]);
    const validateEvent = (eventName) =>
      validEventNames.has(eventName) ? [eventName] : [];

    const defaultEventsFor = (
      (sourceTypeMap, defaultEvents) => (sourceType) =>
        sourceTypeMap.has(sourceType)
          ? sourceTypeMap.get(sourceType)
          : defaultEvents
    )(
      new Map([
        ['input:checkbox', ['input', 'change']],
        ['input:radio', ['input', 'change']],
      ]),
      ['input'],
    );

    const eventsFor = (element) =>
      element
        .getAttribute('data-source-on')
        ?.split?.(' ')
        .flatMap(validateEvent) ?? defaultEventsFor(element);

    // : { element: sourceElement, id: sourceId }
    const entangleEvent = ({ source }) => {
      const pending = getUpdateQueue();

      const update = ({ eventName, newValue }) => {
        /* Update self */
        pending.enqueue({ source, sink: source.element, newValue });

        // TODO memoise and update via mutationobserver
        /* Update associated labels & outputs */
        qs(`:is(label,output)[for=${dataSourceId}]`).forEach((sink) => {
          pending.enqueue({ source, sink, newValue });
        });

        /* Update listeners */
        qs(`[data-sink~=${dataSourceId}]`).forEach((sink) => {
          pending.enqueue({ source, sink, newValue });
        });

        if (source.type === 'input:radio' && eventName === 'change') {
          if (source.name) {
            qs(
              `[data-sink~=name%${source.name}], [name=${source.name}]`,
            ).forEach((sink) =>
              pending.enqueue({
                source,
                sink,
                newValue: getRadioGroupValue(source),
                alias: `name-${source.name}`,
              }),
            );
          } else {
            console.warn(
              `Entanglement: Found input(radio) with no name - id: '${dAtaSourceId}'`,
            );
          }
        }

        /* Update nearest parent sink-all */
        pending.enqueue({
          source,
          sink: source.closest(`[data-sink-all]`) ?? document.body,
          newValue,
        });

        pending.send();
      };
      const eventListener = ({ type: eventName, target, currentTarget }) => {
        update({ eventName, newValue: getCurrentValue(eventName, target) });
      };

      update({ eventName: 'init', newValue: getCurrentValue('init', source) });

      return update;
    };

    /* Auto: uses id as data source name */
    // TODO memoise
    const potentialSourceElements = [
      ...qs(sourceDefinitions.map((d) => d.query)),
    ];

    const { signal, abort } = new AbortController();

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
    return abort;
  };

  return (options = {}) => {
    const promise = new Promise((resolve, reject) => {
      const waitForComplete = () =>
        document.readyState === 'complete'
          ? resolve(entangle(document, options))
          : document.addEventListener('readystatechange', waitForComplete);
      waitForComplete();
    });
    return promise;
  };
})(window);

/* Update nearest parent sink */
// const closestParentSink = e.target.closest(`[data-sink-for~=${name}]`);
// if (closestParentSink) {
//   const sinkAttr = (closestParentSink.getAttribute('data-map-attr')?.split?.(' ') ?? [])
//     .flatMap((s) => ((n, v) => n === name ? [v] : [])(...s.split(':')[0]))[0] ?? `data-from-${name}`;

//   closestParentSink.setAttribute?.(sinkAttr, val);
// }
