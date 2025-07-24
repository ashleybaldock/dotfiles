const weakSet = new WeakSet<HTMLElement>();
const strongSet = new Set<HTMLElement>();

interface WeakRef<T extends object> {
  deref: () => T;
}

interface WeakRefSet<T extends WeakKey> extends Set<T> {
  add: (item: T) => this;
  clear: () => void;
  delete: (item: T) => boolean;
  forEach(
    callbackfn: (value: T, value2: T, set: Set<T>) => void,
    thisArg?: any,
  ): void;
  has: (item: T) => boolean;
  readonly size: number;

  [Symbol.iterator](): SetIterator<T>;
  entries: () => SetIterator<[T, T]>;
  keys(): SetIterator<T>;
  values(): SetIterator<T>;
}

const weakMap = new WeakMap<HTMLElement, WeakRef<HTMLElement>>();
// const strongMap = new Map<HTMLElement, WeakRef<HTMLElement>>()

// interface WeakRefSet<T extends WeakKey> extends Set<T> {
// }

const weakRefMap = new WeakMap<HTMLElement, WeakRef<HTMLElement>>();
const weakRefSet = new Set<WeakRef<HTMLElement>>();

// export type WeakRefMap<K extends WeakKey, V extends WeakMap
// }

const weakRefSet = new Set<WeakRef<HTMLElement>>(
  mapIter(
    document.querySelectorAll('a').values(),
    (element) => new WeakRef(element),
  ),
);

// weakRefSet.values(
