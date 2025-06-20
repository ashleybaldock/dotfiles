# Regex quick reference

## Pattern

```pre
    ╭  pattern             1+ branch   (OR) match first matching branch
    ∆    ╰─┬─────────┬┈┈┈┈   (OR)
    ┊    branch \| branch       1+ concat  (AND)     match if all match at same position
    ┊      ╰─┬─────────┬┈┈┈┈   (AND)
    ┊      concat \& concat         1+ piece  match if all match in sequence
    ┊        ╰─┬─────┬─────┬┈┈   (A,B,C)
    ┊        piece piece piece        1+ atom/atom+multi
    ╭        ╮ ╰─╮
    ┤  \( \) ├╴atom(multi)
    │ \%( \) │   ╰─┬─────┬─────┬┈┈
    ╰        ╯
```

## Atoms

### Atoms - Character Classes

```pre
\_[]  +EoL
  ╭──────────┬─────────────────────────────────╮┌───────┬──────────┬─────────┐
  │ \e <Esc> │ \m magic        \M nomagic      ││ range │ geedy \{ │ lazy \{-│
  │ \t <Tab> │ \v very magic   \V very nomagic │├───────┼──────────┼─────────┤
  │ \r  <CR> │ \c ignore case  \C match case   ││ 0 → 1 │ \? \{,1} │ \{-,1} ╭┴╮
  │ \b  <BS> ┢━━━━━━━┱─────────────────────────┤│ 0 → m │    \{,m} │ \{-,m} │m│
  │ \n  EoL  ┃ ATOMS ┃ ignore combining chars… ││ 0 → ∞ │ *  \{}   │ \{-}   │u│
  ├──────────┺━━━━━━━┹────────╮ \%C prev. atom │├───────┼──────────┼────────┤l│
  │ [] - any character inside │ \Z globally    ││ 1 → ∞ │ \+ \{1,} │ \{-1,} │t│
  │ \~ - last subst. string   ╰────────────────┤│ n → ∞ │    \{n,} │ \{-n,} │i│
  │ \%[] - sequence of optional atoms          ││ n → m │    \{n,m}│ \{-n,m}╰┬╯
  │ \z1…9 - indexed matches from \(\) groups   ││   n   │    \{n}  │ \{-n}   │
  │ char codes  \%d255 decimal   \%o377 octal  │└───────┴──────────┴─────────┘
  │ hex  ¹ᴮ \%xFF  ²ᴮ \%uFFFF  ⁴ᴮ \%U7FFFFFFF  │
  │ [\d25] [\o44] [\xFF] [\uFFFF] [\U7FFFFFFF] │
  ┢━━(ascii↴)━━━━━╸=⃝ ╺╸¬⃝ ╺━(character classes)━┪
  ┃ UPPER        [^0-9]╮̩̣  ╭̩̣[0-9\n]  ⎛  not:  ⎞ ┃
  ┃           [0-9]↴   ↓̍  ↓̍        ⎧⎝[^0-9\n]⎠ ┃
  ┃ digit       ╷ \d  \D \_d \_D ◁─┴[^0-9]\|\n ┃
  ┃ hex digit   ┊ \x  \X ╷  [0-9A-Fa-f]        ┃
  ┃ octal digit ┊ \o  \O ┊        [0-7] [^0-7] ┃
  ┃ whitespace  ┊ \s  \S ┊        [ \t] [^ \t] ┃
  ┃ head of…    ┊ \h  \H ┊    [A-Za-z_]        ┃
  ┃ word        ┊ \w  \W ┊ [0-9A-Za-z_]        ┃
  ┃ alphabetic  ┊ \a  \A ┊     [A-Za-z]        ┃
  ┃ lowercase   ┊ \l  \L ┊        [a-z] [^a-z] ┃
  ┃ uppercase   ╵ \u  \U ╵        [A-Z] [^A-Z] ┃
  ┡━━(multibyte↴)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
  │ ²ᴮ \%uFFFF     ⁴ᴮ \%U7FFFFFFF  │ see:      │
  │ identifier  \i  ⎧ \I ⎫         │ isident   │
  │ keyword     \k  ⎪ \K ⎬ without │ iskeyword │
  │ file        \f  ⎪ \F ⎪ digits  │ isfname   │
  │ printable   \p  ⎩ \P ⎭         │ isprint   │
  ╰────────────────────────────────────────────╯

```

### Atoms - Ordinary

```pre



                               ╭─────────────────────────────────────────────────╮
  ╭───────────────╮   ╭───────╮│            line │ file/string │ word │ pattern  │
  │W ← zero width │   │ Atoms 􀬚         ──┬─────│─────────────│──────│───────── │
  │↓̍B ← not in [] │   ╰───────╯│     start │ BoL │    BoF/S    │ BoW  │ BoP      │
  ├─↓̍┬────────────┼────────────┤       end │ EoL │    EoF/S    │ EoW  │ EoP      │
  │  │ start  end │     of...  └┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
  │WB│  \_^   \_$ │ File/string             \^   \$  │   literal
  │WB│  \_^   \_$ │    Line    └┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
  │ B│                         │  ⎧ ^ = BoL: @BoP or after `\(` `\|` `\n` `\%(`  │
  │~~│   ^     $  │   varies   │  ⎩ $ = EoL: @EoP or after `\)` `\|` `\n`        │
  │┈┈│┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
  │WB│  \zs   \ze │   Match    │ sets start/end of match                         │
  │W │  \<    \>  │    Word    │ next/prev char is first/last of word  \<word\>  │
  │  │   .    \_. │ ^EoL / Any │                                                 │
  ├──┼────────────┴────────────┴─────────────────────────────────────────────────┤
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

### Atoms - Multi

```pre
  ┌───────┬──────────┬─────────┐
  │ range │ \{ greedy│ \{- lazy│  n,m = 0 or +ve
  ├───────┼──────────┼─────────┤
  │ 0 → 1 │ \? \{,1} │ \{-,1}  │  also: \=
  │ 0 → m │    \{,m} │ \{-,m}  │
  │ 0 → ∞ │ *  \{}   │ \{-}    │  nomagic: \*
  ├───────┼──────────┼─────────┤
  │ 1 → ∞ │ \+ \{1,} │ \{-1,}  │   '\' ╭╴Optional
  │ n → ∞ │    \{n,} │ \{-n,}  │       ∇
  │ n → m │    \{n,m}│ \{-n,m} │  \{n,m\}
  │   n   │    \{n}  │ \{-n}   │
  └───────┴──────────┴─────────┘
```

### - preceding (zero width)

```pre
  (no:✘)match:✔︎  preceeding atom, e.g.: \(atom\)\@=
  ┌─∇─┬─────┬────────────┐┌───────┬──────────┬─────────┐
  │ ✔︎ │ \@> │ as pattern ││ range │ \{ greedy│ \{- lazy│
  ├───┼─────┼────────────┤├───────┼──────────┼─────────┤
  │ ✔︎ │ \@= │       (\&) ││ 0 → 1 │ \? \{,1} │ \{-,1}  │
  │┈┈┈│┈┈┈┈┈│ at same    ││ 0 → m │    \{,m} │ \{-,m}  │
  │ ✘ │ \@! │ position   ││ 0 → ∞ │ *  \{}   │ \{-}    │
  ├───┼─────┴─┬──────────┤├───────┼──────────┼─────────┤
  │ ✔︎ │ \@N<= │    (\zs) ││ 1 → ∞ │ \+ \(1,} │ \{-1,}  │
  │┈┈┈│┈┈┈┈┈┈┈│ before   ││ n → ∞ │    \{n,} │ \{-n,}  │
  │ ✘ │ \@N<! │ position ││ n → m │    \{n,m}│ \{-n,m} │
  └───┴──╴∆╶──┴──────────┘│   n   │    \{n}  │ \{-n}   │
    look back N bytes     └───────┴──────────┴─────────┘
```

## Copy matching texts to buffer

```vim
qaq
g/stroke=%22%23\zs\x\{6}\ze%22/
g//
let @a=''|g//y A


let m=[] | %s//\=add(m,submatch(1))/gn
```

## All (unique) matches in a list

```pre
--data-wand-\zs\d\{4}\ze:\|stroke=%22%23\zs\x\{6}\ze%22
```

```vim
let m=[] | %s//\=add(m,submatch(0))/gn | exec sort(m)->uniq()
let m=[] | %s/stroke=%22%23\zs\x\{6}\ze%22/\=add(m,submatch(0))/gn
       \ | call m->sort()->uniq()
```

## All matches in new buffer

```vim
vnew | call append('$', m)
vnew | call append('$', sort(m)->uniq())

let m=[] | %s//\=add(m,submatch(0))/gn | vnew | call append('$', m)
let m=[] | %s//\=add(m,submatch(0))/gn
       \ | vnew | call append('$', sort(m)->uniq())
```

```vim
let m=[] | %s/--data-wand-\zs\d\{4}\ze:\|stroke=%22%23\zs\x\{6}\ze%22/\=add(m,submatch(0))/gn

/--data-wand-\(\d\{4}\): url('\(.\{-}%22%23\(\x\{6}\)%22\)\+.\{-}');/

let m=[] | %s//\=add(m,[submatch(1, 1), submatch(3, 1), submatch(5, 1), submatch(7, 1), submatch(9, 1), submatch(2, 1), submatch(4, 1), submatch(6, 1)])/gn | vnew | call append('$', m)
```

## Wiki Tables

### Find first element of table to amend

```vim
%s/\-\n| \({\)\@!\zs\(.*\)\ze$/
```

### Table row

```vim
/|-\s*\zs\(\w*\)\ze\($\||\)\+
```

### First table heading on a line

```pre
\1: attributes
\2: content
```

```reg
^\s*\zs!\s*\([^|!]|\)\{-}\s*\(.\{-}\)\ze\s*\(!!\|$\)
```

### Next table heading

```vim
function! ReplaceWithLink(name) abort
  exec '%s/\([\|{\|\)\@!\<\zs'..a:name..'\ze\>/[[#'..a.name..']]'/c
endfunc

%s/\-\n| \({\)\@!\zs\(.*\)\ze$/\=ReplaceWithLink(submatch(0))

%s/\-\n| \({\)\@!\zs\(.*\)\ze$/\='%s^\([\|{\|\)\@!\<\zs'..submatch(0)..'\ze\>^[[#'..a.name..']]'^c
```

These six can be used to match specific columns in a buffer or string.
The "23" can be any column number. The first column is 1. Actually,
the column is the byte number (thus it's not exactly right for
multibyte characters).

## Merging table cells

```pre
│ A │ A │ B │ … │  ⮕   │data-sort-value="B"||   A   │...│
│ A │ B │ C │ … │      │data-sort-value="C"|| A - B │...│
```

### pass 1, same value in first two cells

```reg
%s/^|
\([^|]*\)||
\1||
\([^|]*\)||
\ze
\%([^|]*||\)\{6}
[^|]*[^%]$

 \1   =\1  \2                           \2   \1    \1
|420||420||420|| … ⮕  |data-sort-value="420"|420 - 420|| …

%s/^|\([^|]*\)||\1||\([^|]*\)||\ze\%([^|]*||\)\{6}[^|]*[^%]$/|data-sort-value="\2"|\1||/
```

### pass 2, the rest

```reg
%s/^|
\([^|]*\)||
\([^|]*\)||
\([^|]*\)||
\ze
\%([^|]*||\)\{6}

 \1   \2   \3                                \3   \1    \2
|743||757||750|| …    ⮕    |data-sort-value="750"|743 - 757|| …

%s/^|\([^|]*\)||\([^|]*\)||\([^|]*\)||\ze\%([^|]*||\)\{6}/|data-sort-value="\3"|\1 - \2||/
```

## Template from each Table Row

```reg
%s/|\ {{\w\+|\(\w\+\)}}.*\n|\s\?\([^|]*\)\n|\s\?\([^|]*\)\n|\s\?\([^|]*\)\n|\s\?\([^|]*\)\n\%(|-\||}\)
```

```vim
%s/|\ {{\w\+|\(\w\+\)}}.*\n|\s\?\(.*\)\n|\s\?\(.*\)\n|\s\?\(.*\)\n|\s\?\(.*\)\n\%(|-\||}\)
                           |\s\?\(.*\)\n|
                           One table cell
```

```reg
%s|test|
%s/|\ {{\w\+|\(\w\+\)}}.*\n|\s\?\(.*\)\n|\s\?\(.*\)\n|\s\?\(.*\)\n|\s\?\(.*\)\n\%(|-\||}\)/

                           |.*||\s\?\(.*\)\%(\n|\|||\)
```

## Match all block comments

Including whitespace before/after

```reg
%s/\(\_s*\/\*.\{-}\*\/\_s*\)\+//
```

## CSS

Selector list

```reg
%s/\%(\%^\|}\)\_s*\zs\%(\s*\_[^} ]\)*\ze\s*{/
```

##Selector

```reg
\%(\%^\|[},]\)\_s*\zs\%(\s*\_[^}, ]\)*\ze\s*[,{]
```

Selector & trailing comma
