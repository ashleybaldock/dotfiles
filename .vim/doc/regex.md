Copy matching texts to buffer

```vim
qaq
g/stroke=%22%23\zs\x\{6}\ze%22/
g//
let @a=''|g//y A


let m=[] | %s//\=add(m,submatch(1))/gn
```

All (unique) matches in a list

--data-wand-\zs\d\{4}\ze:\|stroke=%22%23\zs\x\{6}\ze%22

```vim
let m=[] | %s//\=add(m,submatch(0))/gn | exec m->sort()->uniq()
let m=[] | %s/stroke=%22%23\zs\x\{6}\ze%22/\=add(m,submatch(0))/gn | call m->sort()->uniq()
```

All matches in new buffer

```vim
vnew | call append('$', m)

let m=[] | %s//\=add(m,submatch(0))/gn | vnew | call append('$', m)
let m=[] | %s//\=add(m,submatch(0))/gn | call uniq(sort(m)) | vnew | call append('$', uniq(m))
```

```vim
let m=[] | %s/--data-wand-\zs\d\{4}\ze:\|stroke=%22%23\zs\x\{6}\ze%22/\=add(m,submatch(0))/gn

/--data-wand-\(\d\{4}\): url('\(.\{-}%22%23\(\x\{6}\)%22\)\+.\{-}');/

let m=[] | %s//\=add(m,[submatch(1, 1), submatch(3, 1), submatch(5, 1), submatch(7, 1), submatch(9, 1), submatch(2, 1), submatch(4, 1), submatch(6, 1)])/gn | vnew | call append('$', m)
```

````vim
" Find first element of table to amend
" %s/\-\n| \({\)\@!\zs\(.*\)\ze$/


" Table row
" /|-\s*\zs\(\w*\)\ze\($\||\)\+

" First table heading on a line
" \1: attributes
" \2: content
" ^\s*\zs!\s*\([^|!]|\)\{-}\s*\(.\{-}\)\ze\s*\(!!\|$\)

" Next table heading

```vim
function! ReplaceWithLink(name) abort
  exec '%s/\([\|{\|\)\@!\<\zs'..a:name..'\ze\>/[[#'..a.name..']]'/c
endfunc

%s/\-\n| \({\)\@!\zs\(.*\)\ze$/\=ReplaceWithLink(submatch(0))

%s/\-\n| \({\)\@!\zs\(.*\)\ze$/\='%s^\([\|{\|\)\@!\<\zs'..submatch(0)..'\ze\>^[[#'..a.name..']]'^c
````

These six can be used to match specific columns in a buffer or string.
The "23" can be any column number. The first column is 1. Actually,
the column is the byte number (thus it's not exactly right for
multibyte characters).

`hello world`

```
  ╭ pattern             1+ branch   (OR) match first matching branch
  ╷   ╰─┬─────────┬┈┈┈┈   (OR)
  ╷   branch \| branch       1+ concat  (AND)     match if all match at same position
  ╷     ╰─┬─────────┬┈┈┈┈   (AND)
  ╷     concat \& concat         1+ piece  match if all match in sequence
  ╷       ╰─┬─────┬─────┬┈┈   (A,B,C)
  ╷       piece piece piece        1+ atom/atom+multi
  ╷         │
  ╷       atom(multi)
  ╷        │╰─┬─────┬─────┬┈┈
  ╰╴ \( \)╶┤
  ╰╴\%( \)╶╯
```

## -- atoms

### - character classes

```
    │ \i │ \I │ identifier (isident)         no digits
    │ \k │ \K │ keyword    (iskeyword)       no digits
    │ \f │ \F │ file       (isfname)         no digits
    │ \p │ \P │ printable  (isprint)         no digits


	\
    ╭──────────────────┬──────────────────────────────────────╮
    │             ┊ =⃝  │ ¬⃝
    ┟──────────────────╁──────────────────────────────────────╮
    ┃ whitespace  ┊ \s ┃ \S   [ \t]         (non-) whitespace    [^ \t]
    ┃ digit         \d ┃ \D   [0-9]         (non-) digit         [^0-9]
    ┃ hex digit   ┊ \x ┃ \X   [0-9A-Fa-f]   (non-) hex digit     [^0-9A-Fa-f]
    ┃ octal digit   \o ┃ \O   [0-7]         (non-) octal digit   [^0-7]
    ┃ word        ┊ \w ┃ \W   [0-9A-Za-z_]  (non-) word          [^0-9A-Za-z_]
    ┃ head of word  \h ┃ \H   [A-Za-z_]     (non-) head of word  [^A-Za-z_]
    ┃ alphabetic    \a ┃ \A   [A-Za-z]      (non-) alphabetic    [^A-Za-z]
    ┃ lowercase   ╵ \l ┃ \L   [a-z]         (non-) lowercase     [^a-z]
    ┃ uppercase   ┊ \u ┃ \U   [A-Z]         (non-) uppercase     [^A-Z]
    ┖──────────────────┸─╴∆╶───────────────┴─────────────────┘
            ╰──╴in,verse i.e. non-digit

    \_x  where x is any of the characters above,
         character class with end-of-line included

```

### - ordinary

```
                                 ╭─────────────────────────────────────────────────╮
         Atoms                   │            line │ file/string │ word │ pattern  │
    ┌────────────────────────────┤         ──┬─────│─────────────│──────│───────── │
    │W  = zero width             │ beginning │ BoL │    BoF/S    │ BoW  │ BoP      │
    │ B = not inside []          │       end │ EoL │    EoF/S    │ EoW  │ EoP      │
    ├──┬──────────┬──────────────┼─────────────────────────────────────────────────┤
    │  │   atom   │   matches    │  notes                                          │
    ├──┼──────────┼──────────────┼─────────────────────────────────────────────────┤
    │WB│ \_^  \_$ │   BoL / EoL  │                                                 │
    │ B│  \^   \$ │    literal   │  ⎧ ^ = BoL: @BoP or after `\|` `\(` `\n` `\%(`  │
    │~~│   ^    $ │    varies    │  ⎩ $ = EoL: @EoP or after `\|` `\)` `\n`        │
    │┈┈│┈┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
    │WB│ \zs  \ze │              │ sets start/end of match                         │
    │  │   .  \_. │  ^EoL / Any  │                                                 │
    │W │  \<   \> │   BoW / EoW  │ next/prev char is first/last of word  \<word\>  │
    ├──┼──────────┴──────────────┴─────────────────────────────────────────────────┤
    │  │                 \\%\(\^\|\$\|#\|V\|\([><]\=\(\'M\|\([N.]\+[lcv]\+\)\)\)   │
    │  │                                                                           │
    │  │   before╶  ╭╴<╶╮ ╭╴N╶╮ ← Number  ╭╴c╶─ c̲olumn ⎫(bytes)  \%<22c     \%>.c  │
    │  │       in╶ ╭┼───┼╮┴╴.╶┤ ← cursor  ├─╴v╶─ v̲.col ⎪(chars)  \%<2v \%.l \%>3v  │
    │  │    after╶ │╰╴>╶╯│    ╰───────────┴──╴l╶─ l̲ine ⎪                           │
    │W │  ╔════╗   │     ╰'M╶ mark M                   ⎬ not updated on change     │
    │W │  ║ \% ╟───┴───┬╴#╶ Cursor position  \%#       ⎭                           │
    │W │  ╚════╝       ├╴V╶ Visual area      \%Vfoo\%V   (current, or previous)    │
    │W │               ├╴^╶ Beginning ⎫      \%^                                   │
    │W │               ╰╴$╶ End       ⎭      \%$         (of file/string)          │
    └──┴───────────────────────────────────────────────────────────────────────────┘
```

### - multi

```
    ┌───────────────┬─────────┬──────────┐
    │    greedy     │  range  │   lazy   │  n,m = 0 or positive
    ├──────┬────────┼─────────┼──────────┤
    │ \= \?│ \{,1}  │  0 → 1  │  \{-,1}  │
    │      │ \{,m}  │  0 → m  │  \{-,m}  │
    │    * │ \{}    │  0 → ∞  │  \{-}    │  nomagic: \*
    ├──────┼────────┼─────────┼──────────┤
    │   \+ │ \(1,}  │  1 → ∞  │  \{-1,}  │   '\' ╭╴Optional
    │      │ \{n,}  │  n → ∞  │  \{-n,}  │       ∇
    │      │ \{n,m} │  n → m  │  \{-n,m} │  \{n,m\}
    │      │ \{n}   │    n    │  \{-n}   │
    └──────┴────────┴─────────┴──────────┘
```

### - preceding (zero width)

```
          match preceeding atom, e.g.:  \(atom\)\@=
    ┌─────────┬─────────┬─────────────────────────────────┐
    │   \@>   │  match  │   like matching whole pattern   │
    ├─────────┼─────────┼───────────────┬─────────────────┤
    │   \@=   │  match  │               │   same as \&    │
    │┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈│     here      │┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
    │   \@!   │ NOmatch │               │                 │
    ├─────────┼─────────┼───────────────┼─────────────────┤
    │ \@123<= │  match  │               │ use \zs instead │
    │┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈│  just before  │┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
    │ \@123<! │ NOmatch │               │                 │
    └───╴∆╶───┴─────────┴───────────────┴─────────────────┘
         ╰──╴look back up to N bytes for match (optional)
```
