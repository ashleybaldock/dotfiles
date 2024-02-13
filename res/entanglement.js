

const entanglement = (() => {

  const bindStuff = () => {
    const autoSources = [...document.querySelectorAll(`[data-source]`)];
    autoSources.map((source) => {
      source.getAttribute('id');
    })
    const namedSources = [...document.querySelectorAll(`[data-source-for]`)];
    return dataSources.map((dataSource) => {
      const controller = new AbortController();
      const signal = controller.signal;

      const name = dataSource.getAttribute('data-source-for');
      const events = dataSource.getAttribute('data-source-on').split(' ') ?? ['input'];
      events.forEach((evname) => 
        dataSource.addEventListener(evname, (e) => {
          const val = e.target.value;
          e.target.setAttribute(`data-${name}`, val);
          e.target.closest(`[data-sink-for~=${name}]`).setAttribute(`data-sink-value`, val);
          e.target.closest(`[data-sink-all]`).setAttribute(`data-from-${name}`, val);
          document.documentElement.style.setProperty(`--bound-str-${name}`, `"${val}"`);
          document.documentElement.style.setProperty(`--bound-val-${name}`, `${val}`);
        }, {signal})
      );
      return () => signal.abort();
    });
  };
  
  return {
    bindStuff
  };
})();
