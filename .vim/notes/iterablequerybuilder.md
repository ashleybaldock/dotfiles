# IterableQueryBuilder

---

```
  qs`` queryselect
  qm`` querymutate

```

```
 iterableQuerySelector

 qs`#selector`  - some selectors should only return one thing


 first vs. all
                                            Equivalent to:
  qs`X`.first   first result                querySelector('X')
  qs`X`.all     all results                 querySelectorAll('X')
  qs`X`.only    assert single result
  qs`X`.n`1-10` indexed range of results    querySelectorAll('X').slice(0,10)

  Single result interface

  qs`X`.first        returns an IterableQueryResult wrapper, the interface is
  qs`X`.map(x => x)  the same as that used in the transformation functions

  qs`` always returns an iterator, which may contain 0, 1 or multiple entries

  qs`X`          iterator
  qs`X`.empty    assert zero results
  qs`X`.only     assert one result

  qS`` returns an async iterator
       entries are added dynamically if new matches appear (Uses a MutationObserver)

  qS`X`          async iterator, yields new matches as they appear
  qS`X`.empty    async, throws if anything appears as a match
  qS`X`.only     async, throws if more than one match appears, yields first match

```

```

  QueryIterator
  Convert the iterable into a single result or array of results

       qs`<query>`       Chainable
            │                ▼
            ∇─────╴IterableQueryBuilder ◁────────╮
            │                                    │ Inside these, each item
            ├──────▷ .[f]ilter( <predicate> ) ⎫  │ has the same result
            ├──────▷ .[m]ap( <mappingFn> )    │  │ interface as below
            ├──▷ .flat[M]ap( <mappingFn> )    ├──╯
            ├───▷ .dro[p]( <count> )          │  │̍
            ├──────▷ .[t]ake( <count> )       ⎭  │mappingFn: (QueryResult[])
            │                                    │
            │ Aliases for result interface       │
            │                                    │
            ├──────▷ .wrap (.map(wrap))      ⎫   │
            ├──────▷ .clad (.map(clad))      │   │
            ├──────▷ .clrm (.map(clrm))      ├───╯
            │                                │
            │                                ⎭
            │
            ∇
            ∇
 Iterable-  │ (multiple items, single result)
 QueryResult├──▷ .r(educe)╶──────
            │
            │ (single item, single result) (ordinal numbering, 1 = 1st)
 QueryResult├┬─▷ .n1/.first╶───┐ (same as .n`1`)
            │└─▷ .nn/.last╶────┤ (same as .n`-1`)
            │                  ∇
            │                  ┊         (only nodes that exist at this instant)
            │                  ┊       .foreach   sync/sequential     now
            │                  ┊       .forall    async/parallel      now
            │                  ┊
            │                  ┊          (current, and future matches)
            │                  ┊       .forever   async            now,future
            │                  ┊       .until     async            now,future
            │                  ┊
            │                  ┊       (wait for matches if needed)
            │ (multiple items  ┊       .first
 Iterable-  │ multuple results)┊       .none
 QueryResult└┬─▷ .n`1:10`╶───┐ ┊
             └─▷ (a).R(ray)╶─┤ ┊       (always 'now')
                             │️ │       .last
    ╭────────────────────────┴̌←╯       .only/.empty (asserts)
    ∇
    ∇
    ╰̩─────╴.qs       ──▶︎ query from this node
    │
    ╰̩─︎────╴.at(tr)   ──▶︎ attributes
    │
    ╰̩─︎──┬─╴.data     ⎫
    │   ├─╴.dat      ├─▶︎ data attributes
    │   └─╴…         ⎭
    │
    ╰̩─︎──┬─╴.clad     ⎫
    │   ├─╴.clrm     ├─▶︎ classList
    │   └─╴…         ⎭
    │
    ╰̩─︎────╴.dl       ──▶︎ download
    │       └───╴.then(() => ...)
    │
    ╰̩─︎──┬─╴.evad     ⎫
    │   ├─╴.evrm     ├─▶︎ addEventListener
    │   └─╴…         ⎭
    │
    ╰̩─︎────╴.obmut    ──▶︎ MutationObserver
    │
    ╰̩─︎────╴.obsec    ──▶︎ IntersectionObserver
    │̴ etc.

```

```
  ◢ Single item ◣
  ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
  from start:                  ┌──────────────────────────────────────────┐
   .n`1` / .first  / .n1       │  1ˢᵗ  2ⁿᵈ  3ʳᵈ  4ᵗʰ  5ᵗʰ  6ᵗʰ  7ᵗʰ  8ᵗʰ  │
   .n`2` / .second / .n2       │   ╵    ╵    ╵    ╵    ╵    ╵    ╵    ╵   │
     …                         │ [ a,   b,   c,   d,   e,   f,   g,   h ] │
   .n`9` / .ninth  / .n9       │   ╷    ╷    ╷    ╷    ╷    ╷    ╷    ╷   │
   .n`10`       (no '.tenth')  │  8th… 7th… 6th… 5th… 4th… 3rd… 2nd… last │
                               │              (…to last)                  │
  from end:                    └──────────────────────────────────────────┘
   .n`-1` / .last  / .m1
   .n`-2` /        / .m2 etc.


  ◢️ Multiple items◣️     (in the order asked for; repeated items NOT deep copies)
  ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
   .n`1,4,7` first, fourth and seventh     [a, d, g]

   .n`7,4,1` seventh, fourth, first        [g, d, a]

   .n`1,-1`  first, last                   [a, h]

   .n`1,1,1` first, first, first           [a, a, a]


  ◢ Range of items ◣    (always inclusive; if range reads end-to-start, output reversed)
  ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
   .n`2:6`   second through sixth          [b, c, d, e, f]      (same as .n`2,3,4,5,6`)

   .n`6:2`   sixth through second          [f, e, d, c, b]      (reversed)

   .n`2:-6`  second through sixth to last  [b, c]

  .n`-6:2`   sixth to last through second  [c, b]               (reversed)

  .n`-2:-6`  second to last through sixth to last
                                           [g, f, e, d, c, b]   (reversed)

    .n`:4`   first through fourth          [a, b, c, d]         (same as .n`1:4`)

   .n`4:`    fourth through last           [d, e, f, g, h]      (same as .n`4:-1`)

  .n`-1:4`   last through fourth           [h, g, f, e, d]      (reversed)


   ──────────────────────────────────────────────────────────────────────────────
  .first ❮❮                                                             ❯❯ .last
     .n1  .n2  .n3  .n4  .n5  .n6  .n7  .n8  .n9  .na  .nb  .nc  .nd  .ne  .nf
     1ˢᵗ  2ⁿᵈ  3ʳᵈ  4ᵗʰ  5ᵗʰ  6ᵗʰ  7ᵗʰ  8ᵗʰ  9ᵗʰ  Aᵗʰ  Bᵗʰ  Cᵗʰ  Dᵗʰ  Eᵗʰ  Fᵗʰ   from start
      ❘    ╵    ╵    ╵    ╵    ╵    ╵    ╵    ╵    ╵    ╵    ╵    ╵    ╵    ╵
    [ a,   b,   c,   d,   e,   f,   g,   h    i,   j,   k,   l,   m,   n,   o ]
      ❘    ╷   ╷    ╷    ╷    ╷    ╷    ╷    ╷    ╷    ╷    ╷    ╷    ╷    ╷
     Fᵗʰ   Eᵗʰ  Dᵗʰ  Cᵗʰ  Bᵗʰ  Aᵗʰ  9ᵗʰ  8ᵗʰ  7ᵗʰ  6ᵗʰ  5ᵗʰ  4ᵗʰ  3ʳᵈ  2ⁿᵈ  1ˢᵗ  from end
     .mf  .me  .md  .mc  .mb  .ma  .m9  .m8  .m7  .m6  .m5  .m4  .m3  .m2  .m1
                 (…to last)                                (…to last)
   ──────────────────────────────────────────────────────────────────────────────
```

<!-- vim: set ts=2 sw=2 conceallevel=2 nowrap: -->
