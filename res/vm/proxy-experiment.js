/**
 * Mostly this just avoids typing new
 */
const entrap = /*<T extends object>*/ (
  target /*: T*/,
  handler /*: ProxyHandler<T>*/,
) /*: T*/ => new Proxy(target, handler);

/**
 * it's a trap!
 */
const handler = {
  /**
   * Trap property get behaviour, so you can do:
   *
   * qs`a`[1]
   *
   * To get indexed results
   */
  get: (target, key) => {
    if ('symbol' === typeof key) {
      return target[key];
    }
    /**
     * Always a string, but if the string happens to be an integer…
     *
     * e.g. X[1], X[12] etc.
     */
    if ('string' === typeof key && Number.isInteger(Number(key))) {
      return target.n(Number(key));
    }
    /**
     * Instead of returning the property (as is traditional),
     * instead return a function that, when called
     *  - with no arguments, returns the property
     *  - with 1 argument, sets the curent value of the property
     */
    if (keysReturningGetSetFunction.has(key)) {
      return (...args) => {
        /* Calling a property (no arguments) e.g. qs``.x() */
        if (args.length === 0) {
          return target[key];
        }
        target[key] = value;
      };
    }
    return target[key];
  },
  /**
   * Calling directly, e.g. qs() or qs``
   * (This only works when the proxy is wrapping a Function!)
   */
  // apply(target, thisArg, argumentsList) {
  //   console.log(`called: ${argumentsList}`);
  //   return argumentsList[0] + argumentsList[1] + argumentsList[2];
  // },
  /** Property assignment via [] */
  /* set: (obj, key, value) => {
           return (typeof key === 'string' && Number.isInteger(Number(key)))
             ? (obj.data[key] = value) : (obj[key] = value);
      },*/
};

/**
 * Finally, combine Proxy with interface
 */
return entrap(target, handler);
