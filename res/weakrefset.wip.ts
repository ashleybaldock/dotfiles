// const weakSet = new WeakSet<HTMLElement>();
// const strongSet = new Set<HTMLElement>();

// const weakMap = new WeakMap<HTMLElement, WeakRef<HTMLElement>>()
// const strongMap = new kMap<HTMLElement, WeakRef<HTMLElement>>()

// interface WeakRefSet<T extends WeakKey> extends Set<T> {
// }

// const weakRefMap = new WeakMap<HTMLElement, WeakRef<HTMLElement>>()
// const weakRefSet = new Set<WeakRef<HTMLElement>>();

// export type WeakRefMap<K extends WeakKey, V extends WeakMap
// }

// const weakRefSet = new Set<WeakRef<HTMLElement>>(mapIter(document.querySelectorAll('a').values(), (element) => new WeakRef(element)));

// // weakRefSet.values(

const getWeakRefMap = (() => {
  const weakRefMap = new Map /*<WeakRef<HTMLElement>, T>*/();
  const weakRecord = new WeakMap();
})();

const getWeakRefSet = (() => {
  /*
   * Set of WeakRefs, this is iterable, unlike a WeakSet
   * Hides the WeakRefs using a map to retrive them by ref
   */
  const weakRefSet = new Set /*<WeakRef<HTMLElement>>*/();
  /*
   * Mapping between refs and weak refs,
   * to enable lookup (deletion) by object reference
   *
   * WeakMap<K extends WeakKey, WeakRef<HTMLElement>>
   */
  const weakRecord = new WeakMap();

  /*
   * export type WeakRefMap<K extends WeakKey, V extends WeakMap
   * export type WeakRefSet<T extends WeakKey> = {
   *   add: (IterableIterator<T>)
   * }
   */

  // const weakRefSet = new Set<WeakRef<HTMLElement>>(mapIter(document.querySelectorAll('a').values(), (element) => new WeakRef(element)));
  // refsAdded.add(ref);
  // weakRefSet.add(new WeakRef(ref));

  const chainable = {
    [Symbol.iterator]: () => {
      const source = weakRefSet.values();
      return {
        return: () => {
          /* Finish checking item existence + removal */
          for (
            let {
              value: weakRef,
              done,
              ref = weakRef?.deref?.(),
            } = source.next();
            !done;
            { value: weakRef, done, ref = weakRef?.deref?.() } = source.next()
          ) {
            if (done) {
              return { done: true };
            }
            if (ref === undefined) {
              weakRefSet.delete(weakRef);
            }
          }
        },
        next: () => {
          for (
            let {
              value: weakRef,
              done,
              ref = weakRef?.deref?.(),
            } = source.next();
            !done;
            { value: weakRef, done, ref = weakRef?.deref?.() } = source.next()
          ) {
            if (done) {
              return { done: true };
            }
            if (ref === undefined) {
              weakRefSet.delete(weakRef);
            } else {
              return { value: ref, done: false };
            }
          }
        },
      };
    },
    has: (ref /*: WeakKey*/) /*: boolean*/ => weakRecord.has(ref),
    add: (ref /*: WeakKey*/) /*: this*/ => {
      if (!weakRecord.has(ref)) {
        let weakRef = new WeakRef(ref);
        weakRecord.add(ref, weakRef);
        weakRefSet.add(weakRef);
      }
      return chainable;
    },
    delete: (ref /*: WeakKey*/) => {
      if (weakRecord.has(ref)) {
        weakRefSet.delete(weakRecord.get(ref));
        return weakRecord.delete(ref);
      }
    },
  };
  // forEach(callbackfn: (value: V, key: K, map: ReadonlyMap<K, V>) => void, thisArg?: any): void;
  // forEach: (callbackfn/*: (value: V, key: K) => void*/ =>
  // update: () => {
  // }
  return chainable;
})();
