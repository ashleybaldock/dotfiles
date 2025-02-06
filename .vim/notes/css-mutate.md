# css-mutate

---

```

  /*  at`name`() -> get
   *  at`name`(value) -> set
   *  dat`test`() -> get (data-test)
   *  cladd()  add`.shiny[src=]`.del`.old`.toggle`.switch`
   *  .child`div`
   *  .add`div`   -> child     if doesn't start with . # or [, and is a valid tag name
   *  .add`>div` -> child
   *  .add`+div` -> sibling (insert directly after)
   *  .add`~div` -> sibling (inserted at end of parent's children)
   */

    // qs`body > img:only-child:not(:has(> *)):mutate([src="${window.location.toString()}"]:not([data-test]))`
    //                         [data-test]    set to true boolean attr (empty)
    //                         [no data-test] delete if present
    //                         [data-test=!]   toggle (add/remove attr)
    //
    // =  exactly              [data-test=>New Value] replace whole attr
    //                         [data-test=>A,B] replace whole attr value A with B
    //                         [data-test=A>B] replace whole attr value A with B
    //
    // ^= starts with          [data-test^+Prefix] prefix with
    //  (attr must exist)      [data-test^-Prefix] remove prefix (if present)
    //                         [data-test^>A,B] replace prefix (if present)
    //                         [data-test^=A>B] replace prefix A with B
    //    These avoid duplicating the prefix if the attribute already begins with it.
    //    (If duplication is desired, use [attr^>prefix,prefixprefix])
    //
    // $= ends with            [data-test$+Suffix] suffix with
    //  (attr must exist)      [data-test$-Suffix] remove suffix
    //                         [data-test$>A,B] replace suffix A (if present) with B
    // $= ends with            [data-test$=>Suffix] suffix with
    //   (attr must exist)     [data-test$=Suffix>] remove suffix
    //                         [data-test$=A>B] replace suffix A with B
    // $= ends with            [data-test$=,Suffix] suffix with
    //   (attr must exist)     [data-test$=Suffix,] remove suffix
    //                         [data-test$=A,B] replace suffix A with B
    //    These avoid duplicating the suffix if the attribute already ends with it.
    //    (If duplication is desired, use [attr$>suffix,suffixsuffix])
    //
    //       [data-test~=A-B+C] if A exists, remove B (if present) and add C (if missing)
    //       [data-test~=-B]    remove B (if present)
    //       [data-test~=+C]    add C (if missing)
    //       [data-test~=A,B,C] if A exists, remove B (if present) and add C (if missing)
    //       [data-test~=,B,]   remove B (if present)
    //       [data-test~=,,C]   add C (if missing)
    //       [data-test~=,C D]  add item(s) C & D if missing
    //       [data-test~=A B,]  remove item(s) A & B if either present
    //       [data-test~=A B, C D] if A or B is present, remove them and add C & D
    //       [data-test~=(A B), C D] if A and B are present, remove them and add C & D
    //       [data-test~=(A B), A B C D] if A and B are present, add C & D
    //       [data-test~=(A B),] remove A & B iff both present
    //       [data-test~=,(C D)]  add item(s) C & D if missing
    // ~= one of whitespace    [data-test~=A,B] replace item A with B
    //    separated list       [data-test~+Item1 Item2]  add item(s) (if not present)
    //                         [data-test~-Item1 Item2]  remove item(s) from list
    // *= contains             [data-test*>A,B]  replace match A with B
    //                         [data-test*-]  remove match
    // |= exactly, or starts with (followed by dash)
    //
```

<!-- vim: set ts=2 sw=2 conceallevel=2 nowrap: -->
