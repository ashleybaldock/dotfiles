/* Object.defineProperties helper functions */
// const defineAliased = (target, names, config) =>
//   Object.defineProperties(
//     target,
//     Object.fromEntries(names.map((name) => [name, config])),
//   );

// const defineAliasedFuncProp = ({ x, f, names }) =>
//   defineAliased(x, names, {
//     value: (...args) => f(x, ...args),
//     enumerable: false,
//     configurable: false,
//   });
// const defineAliasedMethod = ({ x, f, names }) =>
//   defineAliased(x, names, {
//     value: (...args) => f.call(x, ...args),
//     enumerable: false,
//     configurable: false,
//   });
// const defineAliasedGet = ({ x, f, names }) =>
//   defineAliased(x, names, {
//     get: () => f(x),
//     enumerable: false,
//     configurable: false,
//   });

// const nullObjectifier = ({ toString }) => {
//   const x = Object.create(null);

//   defineAliasedMethod({ x, f: toString, names: ['toString'] });
//   defineAliasedGet({ x, f: toString, names: [Symbol.toStringTag] });

//   const builder = {
//     defineAliasedGet: ({ chain = false, f, names }) => {
//       defineAliasedGet({ x, f, names });
//       return builder;
//     },
//     defineAliasedMethod: ({ chain = false, f, names }) => {
//       defineAliasedMethod({ x, f, names });
//       return builder;
//     },
//     defineAliasedFuncProp: ({ chain = false, f, names }) => {
//       defineAliasedFuncProp({ x, f, names });
//       return builder;
//     },
//     done: () => x,
//   };

//   return builder;
// };

// return nullObjectifier({
//   toString: () => `IQB{${selector.join('|')}}`,
// })
//   .defineAliasedFuncProp({
//     chain: true,
//     names: ['e', 'tee'],
//     f: forEachSideEffect,
//   })
//   .defineAliasedFuncProp({
//     chain: true,
//     names: ['f', 'filter'],
//     f: (predicate) => filterIter(last(), predicate),
//   })
//   .defineAliasedFuncProp({
//     chain: true,
//     names: ['m', 'map'],
//     f: (mapfn) => map(last(), mapfn),
//   })
//   .defineAliasedFuncProp({
//     chain: true,
//     names: ['M', 'flatMap'],
//     f: (mapfn) => flatMap(last(), mapfn),
//   })
//   .defineAliasedFuncProp({
//     chain: true,
//     names: ['t', 'take'],
//     f: (n) => take(last(), n),
//   })
//   .defineAliasedFuncProp({
//     chain: true,
//     names: ['p', 'drop'],
//     f: (n) => drop(last(), n),
//   })
//   .defineAliasedGet({
//     chain: false,
//     names: ['dl', 'downloader'],
//     f: () => getDownloader(last()),
//   })
//   .defineAliasedGet({ chain: false, names: ['i', 'iter'], f: () => last() })
//   .defineAliasedGet({
//     chain: false /* boolean */,
//     names: ['empty'],
//     f: () => !last()?.done?.() ?? last()?.length > 0 ?? true,
//   })
//   .defineAliasedGet({
//     chain: false /* IQBResult */,
//     names: ['n1', 'first'],
//     f: () => nth(last(), 1),
//   })
//   .defineAliasedGet({
//     chain: false /* IQBResult */,
//     names: ['n2', 'second'],
//     f: () => nth(last(), 2),
//   })
//   .defineAliasedGet({
//     chain: false /* IQBResult[] */,
//     names: ['a', 'array'],
//     f: () => last(),
//   })
//   .done();

// const defaults = (() => {
//   let notify = window.console.log;

//   const d = {};
//   Object.defineProperty(d, 'notify', {
//     get: () => notify,
//     set: (newNotify) => (notify = newNotify),
//     enumerable: false,
//     configurable: false,
//   });
//   return d;
// })();

// const injectQS = (x) => {
// Object.defineProperty(x, 'defaults', {
// get: () => defaults,
// enumerable: false,
// configurable: false,
// });
// return x;
// };
