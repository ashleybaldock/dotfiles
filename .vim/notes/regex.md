# Regex quick reference

## Pattern

```pre
    ╭  pattern             = 1+ branch (first matching branch)
    ∆    ╰─┬───────────┬─┈    branch (OR) branch (OR) branch …️
    ┊    branch  \|  branch       1+ concat  (AND)     match if all match at same position
    ┊      ╰─┬───────────┬─┈   (AND)
    ┊      concat  \&  concat         1+ piece  match if all match in sequence
    ┊        ╰─┬─────┬─────┬─┈   (A,B,C)
    ┊        piece piece piece        1+ atom/atom+multi
    ╭        ╮ ╰─╮
    ┤  \( \) ├╴atom(multi)
    │ \%( \) │   ╰─┬───┬───┬───┬─┈
    │ \z( \) │    \d* \ze \w [etc.]
    ╰        ╯   
```

## Atoms

### Atoms - Character Classes

```pre
\_[]  +EoL
  ╭──────────┬─────────────────────────────────╮┌───────┬──────────┬─────────┐
  │ \e <Esc> │ \m magic        \M nomagic      ││ range │ geedy \{ │ lazy \{-│
  │ \t <Tab> │ \v very magic   \V very nomagic │├───────┼──────────┼─────────┤
  │ \r  <CR> │ \c ignore case  \C match case   ││ 0 →️ 1 │ \? \{,1} │ \{-,1} ╭┴╮
  │ \b  <BS> ┢━━━━━━━┱─────────────────────────┤│ 0 →️ m │    \{,m} │ \{-,m} │m│
  │ \n  EoL  ┃ ATOMS ┃ ignore combining chars… ││ 0 →️ ∞ │ *  \{}   │ \{-}   │u│
  ├──────────┺━━━━━━━┹────────╮ \%C prev. atom │├───────┼──────────┼────────┤l│
  │ [] - any character inside │ \Z globally    ││ 1 →️ ∞ │ \+ \{1,} │ \{-1,} │t│
  │ \~ - last subst. string   ╰────────────────┤│ n →️ ∞ │    \{n,} │ \{-n,} │i│
  │ \%[] - sequence of optional atoms          ││ n →️ m │    \{n,m}│ \{-n,m}╰┬╯
  │ \1,\9 - indexed matches from \(\) groups   ││   n   │    \{n}  │ \{-n}   │
  │ \z1…️\z9 - indexed matches from \z(\) groups││   n   │    \{n}  │ \{-n}   │
  │ char codes  \%d255 decimal   \%o377 octal  │└───────┴──────────┴─────────┘
  │ hex  ¹ᴮ \%xFF  ²ᴮ \%uFFFF  ⁴ᴮ \%U7FFFFFFF  │
  │ [\d25] [\o44] [\xFF] [\uFFFF] [\U7FFFFFFF] │
  ┢━━(ascii↴)━━━━━╸=⃝ ╺╸¬⃝ ╺━(character classes)━┪
  ┃ UPPER        [^0-9]╮̩̣  ╭̩̣[0-9\n]  ⎛  not:  ⎞ ┃
  ┃           [0-9]↴   ↓̍️  ↓̍️        ⎧⎝[^0-9\n]⎠ ┃
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
  │W ←︎ zero width │   │ Atoms 􀬚         ──┬─────│─────────────│──────│───────── │
  │↓️B ← not in [] │   ╰───────╯│     start │ BoL │    BoF/S    │ BoW  │ BoP      │
  ├─↓️┬────────────┼────────────┤       end │ EoL │    EoF/S    │ EoW  │ EoP      │
  │  │ start  end │     of...  └┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
  │WB│  \_^   \_$ │ File/string             \^   \$  │   literal                 │
  │WB│  \_^   \_$ │    Line    └┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
  │ B│                         │  ⎧ ^ = BoL: @BoP or after `\(` `\|` `\n` `\%(`  │
  │~~│   ^     $  │   varies   │  ⎩ $ = EoL: @EoP or before `\)` `\|` `\n`       │
  │┈┈│┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
  │WB│  \zs   \ze │   Match    │ sets start/end of match                         │
  │W │  \<    \>  │    Word    │ next/prev char is first/last of word  \<word\>  │
  │  │   .    \_. │ ^EoL / Any │                                                 │
  ├──┼────────────┴────────────┴─────────────────────────────────────────────────┤
  │  │                 \\%\(\^\|\$\|#\|V\|\([><]\=\(\'M\|\([N.]\+[lcv]\+\)\)\)   │
  │  │                                                                           │
  │  │    before⎯ ╭╴<╶╮   number⎯ ╭╴N╶╮ ╭╴c╶─ c̲olumn ⎫(bytes)  \%<22c     \%>.c  │
  │  │   within⎯  ├───┼┬──────────┤   ├─┼─╴v╶─ v̲.col ⎪(chars)  \%<2v \%.l \%>3v  │
  │  │     after⎯ ├╴>╶╯│  cursor⎯ ╰╴.╶╯ ╰──╴l╶─ l̲ine ⎪                           │
  │W │  ╔════╗    │    ╰─────────────────'M╶╴ mark M ⎬ not updated on change     │
  │W │  ║ \% ╟────┴──┬╴#╶───╴ Cursor      \%#        ⎭                           │
  │W │  ╚════╝       ├─╴V╶──╴ Visual   \%Vfoo\%V        (current, or previous)   │
  │W │               ├──╴^╶─╴  BoF/S      \%^       ⎫ ⎛ of file      ⎞           │
  │W │               ╰───╴$╶╴  EoF/S      \%$       ⎭ ⎝    or string ⎠           │
  └──┴───────────────────────────────────────────────────────────────────────────┘
```

### Atoms - Multi

```pre
  ┌───────┬──────────┬─────────┐
  │ range │ \{ greedy│ \{- lazy│  n,m = 0 or +ve
  ├───────┼──────────┼─────────┤
  │ 0 →️ 1 │ \? \{,1} │ \{-,1}  │  also: \=
  │ 0 →️ m │    \{,m} │ \{-,m}  │
  │ 0 →️ ∞️ │ *  \{}   │ \{-}    │  nomagic: \*
  ├───────┼──────────┼─────────┤
  │ 1 →️ ∞️ │ \+ \{1,} │ \{-1,}  │   '\' ╭╴Optional
  │ n →️ ∞️ │    \{n,} │ \{-n,}  │       ∇
  │ n →️ m │    \{n,m}│ \{-n,m} │  \{n,m\}
  │   n   │    \{n}  │ \{-n}   │
  └───────┴──────────┴─────────┘
```

### - look around (zero width)
```pre
(no:✘)match:✔︎ 
 
 ┌─      ┌─∇─┬─────┬────────────┐
 │       │ ✔︎ │ \@> │ as pattern │  \(efg\)\@>D …️abcD̲e️fg…️
 │look   ├───┼─────┼────────────┤
 │ ahead │ ✔︎ │ \@= │       (\&) │  \(Defg\)\@=
 │┈      │┈┈┈│┈┈┈┈┈│ at same    │
 │       │ ✘ │ \@! │ position   │  \(atom\)\@!
 └─      └───┴─────┴────────────┤
 │─      ├───┬───────┬──────────┤
 │look     ✔︎ │ \@N<= │    (\zs) │  \(atom\)\@4<=
 │behind │┈┈┈│┈┈┈┈┈┈┈│ before   │
 │       │ ✘ │ \@N<! │ position │  \(atom\)\@4<!
 └─      └───┴──╴∆╶──┴──────────┘
    look back N bytes     
```

## Useful DIY character classes

### SVG path

```reg
/[MLVCSQTAmlhvcsqtaZz0-9. -]/
?[MLVCSQTAmlhvcsqtaZz0-9. -]
?[MLVCSQTAmlhvcsqtaZz\]0-9. -]
?[^MLVCSQTAmlhvcsqtaZz0-9. -]
?\_[^MLVCSQTAmlhvcsqtaZz0-9. -]
```
```reg
%s/path\_s\+d=\(["']\|%22\)\zs\_[MLVCSQTAmlhvcsqtaZz0-9. -]*\ze\1/
```

### Inside & Outside

```vim
echo autocmd_add([#{event: 'CursorHold', pattern: '<buffer>', cmd: 'exec "/"..getline(".")', group:'mayhem_searchpreview', replace: v:true }])
```

#### Strings
```reg
/\(["'`]\).\{-}\%(\\\1\)\@2<!\1
/\(["'`]\).\{-}\%(\\\1\)\@2<!\1
/\(["'`]\).\{-}\%(a,\1\)\@2<!\1
/\%(\[\|\(["'`]\).\{-}\%(a,\1\)\@2<!\1\)
/\%(\[\|\(["'`]\)/
/\%(\[\@1<=\|\(["'`]\).\{-}\%(a,\1\)\@2<!\1\)
/\(["'`]\)\zs.\{-}\%(\1\1\)\@2<!\1
/\(["'`]\)\zs.\{-}\%(\1\)\@2<!\1\%\1\)\@2
/\(["'`]\)\zs.\{-}\%(\1\)\@2<!\1\%\1\)\@2
/\(["'`]\)\zs.\{-}\%(\1\)\@2<!\1\%(\1\)\@2<=
/\(["'`]\)\zs\%(.\{-}\|\1\1\)\{-}\1\%(\1\)\@!
/\(["'`]\)\zs\%(.\{-}\%(\1\1\)\?\)\{-}\ze\1\([^\1]\)
/\(["'`]\).\{-}\1
```

#### Brackets


```reg
s/pattern/e/g
s/pattern/replacement/g
s/patt.*\>/replacement/g
s/patt\_.*\>/replacement/g
s/patt\.ern/replacement/g
s/\<pattern\>/replacement/g
substitute/pattern/replacement/g
s/pat\/tern/replac\/ement/g
:%s/pattern/replace\0ment/g
s/^pattern$/replacement/g
s/\^pattern\$/replacement/g
s/\_^pattern\_$/replacement/g
s/p^patter$n/replacement/g
s/p\^patter\$n/replacement/g
s/p\_^patter\_$n/replacement/g
:%substitute/pattern/replace\0ment/g
:%substitute|pattern|replace\0ment|g
:%substitute$pattern$replace\0ment$g
:%substitute$pattern\$replace\0ment$g
:%substitute$a\_^pattern\_$replace\0ment$g
'<,'>subs/pat\(capturing[1-9a-d]\)tern/repl\1acement/gc 23
'<,'>subs+pat\(capturing[^PQ1-9a-d]\)tern+repl\1acement+gc 23
'<,'>su/pat\%(non-capturing[1-9a-d]\)tern/repl\1acement/gc 23
'<,'>su/pat\%(non-[^-][-]\)tern/repl\1acement/gc 23
'<,'>su/pat\%(non-[^-9-][-9-]\)tern/repl\1acement/gc 23
'<,'>su/\%88c\%<76lpat\%(non-[^1--8][1--8]\)tern/repl\1acement/gc 23
'<,'>s/pat\%(alt\|er\|\(nested\)\)tern/repl\1acement/gc 23



s/ 99th…️   line   col   v.col  mark   /
s/    at  \%99l  \%99c  \%99v  \%'q   /
s/before \%<99l \%<99c \%<99v \%<'q   /
s/ after \%>99l \%>99c \%>99v \%>'q   /
s/         line   col   v.col    of   /
s/    at  \%.l    \%.c   \%.v  cursor /
s/before \%>.l   \%>.c  \%>.v         /
s/ after \%<.l   \%<.c  \%<.v         /

s/pattern/replacement/g
s/pattern/replacement/g

s/0\(1\)\(2\)\(3\)\(4\)\(5\)\(6\)\(7\)\(8\)\(9\)/\0\1\2\3\4\5\6\7\8\9/
s/0\(1\(2\(3\(4\(5\(6\(7\(8\(9\)8\)7\)6\)5\)4\)3\)2\)1\)0/\0\1\2\3\4\5\6\7\8\9/
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

### Replace matches with lookup from another buffer

```vim
" |  match in current buffer  |               |lookup buffer|    match in lookup buffer     |  lines  |N|th match
" |    removed-->|X||~~~|<--replaced(w/lookup)|  name/id    |     (lookup)     (replacement)| from to | | replacement string
%s@name\s*=\s*"\zs$\(\w*\)\ze"@\=matchbufline('common.csv', '^'..submatch(1)..',\zs[^,]*\ze,', 1, '$')[0].text@
%s/name\s*=\s*"\zs$\(\w*\)\ze"/\=matchbufline('common.csv', '^'..submatch(1)..',\zs[^,]*\ze,', 1, '$')[0].text/
"                                                                                                                     
%s@name\s*=\s*"\zs\w*\ze"@\=matchbufline(BUF, '^'..submatch(0)..',\zs[^,]*\ze,', 1, '$')->get(0, {})->get('text', 'default')@

function ReplaceWithLookup(r_in<string|buffer|list>, r_pat, l_pat, l_in<string|buffer|list>)
%s@name\s*=\s*"\zs\w*\ze"@\=matchbufline(BUF, '^'..submatch(0)..',\zs[^,]*\ze,', 1, '$')->get(0, {})->get('text', 'default')@
```

## Wiki Tables

### Find first element of table to amend

```reg
%s/\-\n| \({\)\@!\zs\(.*\)\ze$/
```

### Table row

```reg
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

```pre
 \1   =\1  \2                           \2   \1    \1
|420||420||420|| … ⮕  |data-sort-value="420"|420 - 420|| …
```

```reg
%s/^|
\([^|]*\)||
\1||
\([^|]*\)||
\ze
\%([^|]*||\)\{6}
[^|]*[^%]$

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

```reg
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

## Selector

```reg
\%(\%^\|[},]\)\_s*\zs\%(\s*\_[^}, ]\)*\ze\s*[,{]
```

## Selector & trailing comma



