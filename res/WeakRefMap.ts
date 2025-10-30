// const weakSet = new WeakSet<HTMLElement>();
// const strongSet = new Set<HTMLElement>();

interface WeakRef<T extends WeakKey> {
  deref: () => T;
}
interface WeakRefConstructor {
  readonly prototype: WeakRef<any>;
  new <T extends WeakKey>(target: T): WeakRef<T>;
}
declare var WeakRef: WeakRefConstructor;

// interface WeakRefSet<T extends WeakKey> extends Set<T> {
//   add: (item: T) => this;
//   clear: () => void;
//   delete: (item: T) => boolean;
//   forEach(
//     callbackfn: (value: T, value2: T, set: Set<T>) => void,
//     thisArg?: any,
//   ): void;
//   has: (item: T) => boolean;
//   readonly size: number;

//   [Symbol.iterator](): SetIterator<T>;
//   entries: () => SetIterator<[T, T]>;
//   keys(): SetIterator<T>;
//   values(): SetIterator<T>;
// }

// interface WeakRefMap<T extends WeakKey> extends WeakMap<T, WeakRef<T>> {
// }

// const weakMap = new WeakMap<HTMLElement, WeakRef<HTMLElement>>();
// const strongMap = new Map<HTMLElement, WeakRef<HTMLElement>>()

// interface WeakRefSet<T extends WeakKey> extends Set<T> {
// }

// const weakRefMap = new WeakMap<HTMLElement, WeakRef<HTMLElement>>();
// const weakRefSet = new Set<WeakRef<HTMLElement>>();

// interface IterableWeakSet<T extends WeakKey> extends WeakSet<T> {
//   clear: () => void;
//   forEach(
//     callbackfn: (value: T, value2: T, set: IterableWeakSet<T>) => void,
//     thisArg?: any,
//   ): void;

//   [Symbol.iterator](): SetIterator<T>;
//   entries: () => SetIterator<[T, T]>;
//   keys(): SetIterator<T>;
//   values(): SetIterator<T>;
// }
// interface IterableWeakSetConstructor {
//   new <T extends WeakKey = WeakKey>(values?: readonly T[] | null): IterableWeakSet<T>;
//   readonly prototype: IterableWeakSet<any>;
// }
// declare var IterableWeakSet: IterableWeakSetConstructor;

export type Mapper<T, O> = (t: T, i: number) => O;

export function* mapIter<T, Tout>(
  source: IterableIterator<T>,
  mapperFn: Mapper<T, Tout>,
): IterableIterator<Tout> {
  let i = 0;
  for (const s of source) {
    yield mapperFn(s, i++);
  }
}
class IterableWeakSet<T extends WeakKey> implements Set<T> {
  /* For ensuring uniqueness of keys, and to avoid duplicate WeakRefs */
  #refMap: WeakMap<T, WeakRef<T>>;
  /* For enumerating members of the set */
  #refSet: Set<WeakRef<T>>;

  constructor(init: readonly T[] | null) {
    let weakRefs = init?.map((value) => new WeakRef(value)) ?? [];
    this.#refMap = new WeakMap<T, WeakRef<T>>(
      weakRefs?.map((weakRef) => [weakRef.deref(), weakRef]),
    );
    this.#refSet = new Set<WeakRef<T>>(weakRefs);
  }

  get size(): number {
    let n = 0;
    for (const item of this[Symbol.iterator]()) {
      n++;
    }
    return n;
  }

  add(item: T): this {
    const weakRef = this.#refMap.get(item) ?? new WeakRef(item);
    this.#refMap.set(item, weakRef);
    this.#refSet.add(weakRef);
    return this;
  }

  clear(): void {
    this.#refMap = new WeakMap<T, WeakRef<T>>();
    this.#refSet = new Set<WeakRef<T>>();
  }

  delete(key: T): boolean {
    const weakRef = this.#refMap.get(key);
    if (weakRef === undefined) {
      return false;
    }
    return this.#refMap.delete(key) || this.#refSet.delete(weakRef);
  }

  forEach(
    callbackfn: (value: T, value2: T, set: IterableWeakSet<T>) => void,
    thisArg?: any,
  ): void {
    for (const item of this[Symbol.iterator]()) {
      thisArg === undefined
        ? callbackfn(item, item, this)
        : callbackfn.call(thisArg, item, item, this);
    }
  }

  has(item: T): boolean {
    return this.#refMap.has(item);
  }

  *entries(): SetIterator<[T, T]> {
    for (const item of this[Symbol.iterator]()) {
      yield [item, item];
    }
  }

  *keys(): SetIterator<T> {
    yield* this[Symbol.iterator]();
  }

  *values(): SetIterator<T> {
    yield* this[Symbol.iterator]();
  }

  *[Symbol.iterator](): SetIterator<T> {
    for (const weakRef of this.#refSet.values()) {
      const value = weakRef.deref();
      if (value) {
        yield value;
      } else {
        this.#refSet.delete(weakRef);
      }
    }
  }

  get [Symbol.toStringTag](): string {
    return 'IterableWeakSet';
  }
}

const weakRefSet = new Set<WeakRef<HTMLElement>>(
  mapIter(
    document.querySelectorAll('a').values(),
    (element) => new WeakRef(element),
  ),
);
