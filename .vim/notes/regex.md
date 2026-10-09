# Regex quick reference


```vim
" Related:
"   $VIMHOME/syntax/reg.vim
"   $VIMHOME/demo/syntax.test.reg
```

## Pattern

```pre
   ╭─────────╮
 ╭ │ pattern │  1 or more branch
 ∆ ╰─────────╯    (pattern matches if any branch matches)
 ┊  ╭───────╴ᴏʀ╶──────╴ᴏʀ╶─┈  
 ┊  │ branch \| branch \| …️   1 or more concat
 ┊  ╰──────────────────────┈    (match if all match at same position
 ┊   ╭───────╴ᴀɴᴅ╶─────╴ᴀɴᴅ╶─┈
 ┊   │ concat \& concat \& …️    1 or more piece  match if all match in sequence
 ┊   ╰───────────────────────┈   (A,B,C)
 ┊   ╰───────────┬─────┬─────┬─┈   (A,B,C)
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
 ╭──────────┬─────────────────────────────────╮
 │ \e <Esc> │ \m magic        \M nomagic      │
 │ \t <Tab> │ \v very magic   \V very nomagic │
 │ \r  <CR> │ \c ignore case  \C match case   │
 │ \b  <BS> ┢━━━━━━━┱─────────────────────────┤
 │ \n  EoL  ┃ ATOMS ┃ ignore combining chars… │
 ├──────────┺━━━━━━━┹────────╮ \%C prev. atom │
 │ [] - any character inside │ \Z globally    │
 │ \~ - last subst. string   ╰────────────────┤
 │ \%[] - sequence of optional atoms          │
 │ \1,\9 - indexed matches from \(\) groups   │
 │ \z1…️\z9 - indexed matches from \z(\) groups│
 │ char codes  \%d255 decimal   \%o377 octal  │
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
 ╭───────────────╮ ╭────────╮ │        line │ file/string │ word │ pattern      │
 │W ←︎ zero width │ │􀬚 Atoms│ │     ──┬─────│─────────────│──────│─────────     │
 │↓️B ← not in [] │ ╰────────╯ │ start │ BoL │    BoF/S    │ BoW  │ BoP          │
 ├─↓️┬────────────┬────────────┤   end │ EoL │    EoF/S    │ EoW  │ EoP          │
 │  │                         │┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│ 
 │  │  \. \^ \$  │    . ^ $      literal 
 │WB│  \_^       │ BoF/S      │                                                      │
 │WB│  \_$       │ EoF/S      │┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
 │ B│  ⟫^  \(^ \%(^ \|^ \n^   │  ⎧ ^ = BoL: @BoP or after `\(` `\|` `\n` `\%(`  │
 │~~│   $     $  │   varies   │  ⎩ $ = EoL: @EoP or before `\)` `\|` `\n`       │
 │┈┈│┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
 │WB│  \zs   \ze │   Match    │ sets start/end of match                         │
 │W │  \<    \>  │    Word    │ next/prev char is first/last of word  \<word\>  │
 │  │   .    \_. │ ^EoL / Any │                                                 │
 ├──┼────────────┴────────────┴─────────────────────────────────────────────────┤
 │  │                 \\%\(\^\|\$\|#\|V\|\([><]\=\(\'M\|\([N.]\+[lcv]\+\)\)\)   │
 │  │                                                                           │
 │  │    before⎯ ╭╴<╶╮   number⎯ ╭╴N╶╮ ╭╴c ⎯ column ⎫(bytes)  \%<22c     \%>.c  │
 │  │    within⎯ ├───┼┬──────────┤   ├─┼─╴v ⎯ v.col ⎪(chars)  \%<2v \%.l \%>3v  │
 │  │     after⎯ ├╴>╶╯│  cursor⎯ ╰╴.╶╯ ╰──╴l ⎯ l̲ine ⎪                           │
 │W │  ╔════╗    │    ╰─────────────────'M╶╴ mark M ⎬ not updated on change     │
 │W │  ║ \% ╟────┴──┬╴#╶───╴ Cursor      \%#        ⎭                           │
 │W │  ╚════╝       ├─╴V╶──╴ Visual   \%Vfoo\%V        (current, or previous)   │
 │W │               ├──╴^╶─╴  BoF/S      \%^       ⎫ ⎛ of file      ⎞           │
 │W │               ╰───╴$╶╴  EoF/S      \%$       ⎭ ⎝    or string ⎠           │
 └──┴───────────────────────────────────────────────────────────────────────────┘
```

### Atoms - Multi

```pre
 lazy╶╮         ╭╴optional
┌─────∇─────────∇────┬──────────┐
│  \{[-][n][,m][\]}  │  n,m ≥ 0 │
├───────┬────────────┴┬─────────┤
│ range │    greedy   │  lazy   │
├───────┼─────────────┼─────────┤
│ 0 →️ 1 │ \{,1} \? \= │ \{-,1}  │
│ 0 →️ m │ \{,m}       │ \{-,m}  │
│ 0 →️ ∞️ │ \{}   *  \* │ \{-}    │
├───────┼─────────────┼─────────┤
│ 1 →️ ∞️ │ \{1,} \+    │ \{-1,}  │
│ n →️ ∞️ │ \{n,}       │ \{-n,}  │
│ n →️ m │ \{n,m}      │ \{-n,m} │
│   n   │ \{n}        │ \{-n}   │
└───────┴─────────────┴─────────┘
┌───────┬──────────┬─────────┐   
│ range │ geedy \{ │ lazy \{-│   
├───────┼──────────┼─────────┤   
│ 0 →️ 1 │ \? \{,1} │ \{-,1} ╭┴╮  
│ 0 →️ m │    \{,m} │ \{-,m} │m│  
│ 0 →️ ∞ │ *  \{}   │ \{-}   │u│  
├───────┼──────────┼────────┤l│  
│ 1 →️ ∞ │ \+ \{1,} │ \{-1,} │t│  
│ n →️ ∞ │    \{n,} │ \{-n,} │i│  
│ n →️ m │    \{n,m}│ \{-n,m}╰┬╯  
│   n   │    \{n}  │ \{-n}   │   
│   n   │    \{n}  │ \{-n}   │   
└───────┴──────────┴─────────┘   
```

### - look around (zero width)
```pre
  look         match?
    ┌───────┌─∇─┌────────────┐                   ̲ ̲ ̲
    │  \@>  │ ✔︎ │ as pattern │  D\(EF\)\@>   ABCDEF
    │───────├───├────────────┤                  ̲ ̅ ̅ ̅
 ᐳᗒ │  \@=  │ ✔︎ │       (\&) │  A\(2\)\@=    A1A2A3
    │   ┈   │ ┈ │ at same    │                ̲  ̅  ̲  
    │  \@!  │ ✘ │ position   │  B\(2\)\@!    B1B2B3
    │   ┈   │ ┈ │            │                ̅    ̅
    │  \&   │   │            │  \(atom\)\&
    ╞════════════════════════╡
    │ \@N<= │ ✔︎ │      (\zs) │  \(atom\)\@4<=
 ᗕᐸ │   ┈     ┈ │ before     │
    │ \@N<! │ ✘ │ position   │  \(atom\)\@4<!
    └──╴∆╶──┴───┴────────────┘
    look back N bytes     
```

```pre

ⵈⵈⵈⵗⵗⵈⵈⵗⵘ ⵗⵘⵗⵈⵗⵂⵓⵗⵙⵔⵕⵚⵯⵯⵠⴸⴷⴻ  ⵓ〭〫  ⵛⵋⵋⵋⵔⵋⴹ ⵎⵡ ⴽⴿ〬 ⵌ 
ܢ⵰ⵡ   ⵔ⵰ⵔ⵿ⵙ ⴳ⵿ⴵ⵿ⴴ     ⵧⵧⵧⵧⵧ ⵧⵇ⸎  ⸎ ⹀⹀⹁,⸰⸱a⸱b⸱·⸱·️⸱⋯️ ⸱⸦ []⁅⁆⸠⸧⸡⸢⸣⸤⸥⸨⸩  〬〬a〪〬 a〪〭 a〭〫
 
〇〪〬〇〫〫〸〭〫〡。〪〫 ⵰ヿ・〭〫ܢ⭘ ⨟⨾⨳ ⧫⧓⧗⧖ ⬫⸦⬫⬫a⬪️a⬪️⬪️⬩⬩a⬩⬩ ⬨⬧⬥⸦⬦⬦⬥ ⬖️ ⬗️ ⬘️ ⬙️
 
              ⸜⸝          ⸮  ⸰⸱⹀⹁ⰏⰞ Ⱓⱓ ⰓⰋⰐⰑ Ⱑ ⱑ Ⰾ ⰅⰤ Ⱗ ⱗ Ⰰ Ⱇ 
〳ⷣ⸀⸁⸂⸃⸄⸅⸆⸇⸈⸉⸊⸋⸌⸍ⸯ⸎⸏⸐⸑⸒⸓⸔⸕⸖⸗⸘⸚⸛⸞⸟ ․‧• ‥ …⁖⁘⸪⸫⁝ ⁛⁘⸬⁞ ⁙⸭

〵 •⁃‣  _⵰‾ⷠ‾ⷡ‾ⷢ‾ⷣ‾ⷤ‾ⷥ‾ⷦ‾ⷧ‾ⷨ‾ⷩ‾ⷪ‾ⷫ‾ⷬ‾ⷭ‾ⷮ‾ⷯ‾ⷰ‾ⷱ‾ⷲ‾ⷳ‾ⷴ‾ⷵ‾ⷶ‾ⷷ‾ⷸ‾ⷹ‾ⷺ‾ⷻ‾ⷼ‾ⷽ‾ⷾ‾ⷿ‾︎
 ′″‴⁗‵‶‷‹›‸⁁‾_‗️‖ ⁀⁀̅⁀̅̅⁀̲̅⁀̲︎⁀̲̲⁐︎⁐̅⁐̅̅⁐̲̅⁐̲̲‿︎‿̲‿̲̲‿̲̅⁐︎‿̅̅‿⁔̲⁓⁓ ⵰̅̅⵰‾̲‾̅‾̲̲‾̅̅ 

 ⵋⵣⵥ  ⵔⵀⴲⴱⵕⵚⵁⴰⵓⴻ ⵃⵝⴴⴵⴳⵅ  ⴶⵏⴶ ⵏⵊⵜⵐⵌ ⵤⵄⰀ ⵖⵄ ⵑ ⵠⴷⴸⵦ ⵧ ⵈⴾⵗⵆⵂⵘ

┌───────┬────┬────┬────┬────┬────┬────┐
│ match │ ms │ hs │    │ me │ he │    │
├───────┼────┼────┼────┼────┼────┼────┤
│ start │ ms │ hs │ rs │    │    │    │
│ skip  │    │    │    │ me │    │    │
│ end   │    │    │    │ me │ he │ re │
└───────┴────┴────┴────┴────┴────┴────┘
```

## Useful DIY character classes

### Boundaries

#### sentance
```reg
[.!?][])"']*[\n\t ]

```


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

s/\%(<path\_s\_[^<>]*\)\@<=\&\%(\<d="\_[^"]*\)\@<=\&\%(\_[^"]*"\)\@=\&M\(\d\+\)\s\+\(\d\+\)h\(\d\+\)/M\1 \2h\3v1h-\3z/g

```
(Crudely) Add a zero to all numbers that aren't 0 (e.g. multiply by 10)
(only M and h commands)
```reg
%s/\%(\<d="\_[^"]*\)\@<=\&\%(\_[^"]*"\)\@=\&[Mhv ]\zs\([1-9]\d*\)/\10/g

   look-behind for: d="   look-ahead for "    sep      number
   \%(\<d="\_[^"]*\)\@<=  \%(\_[^"]*"\)\@=  [Mhv ]\zs  [1-9]\d*

%s/\%(\<d=%22\_[^%]*\)\@<=\&\%(\_[^%]*%22\)\@=\&[Mhv -]\zs\([1-9]\d*\)/\10/g
%s/viewBox=%22\s*\d\+\s\+\d\+\s\+\zs\(\d\+\)\(\s*\)\(\d\+\)\s*\ze%22/\10\2\30/g
```


### Match within

#### Visual selection

#### Current line

### Match contains

#### Cursor 


```reg
%(.*\%#\)\@=\(\w\+\)\(\W\+\)\(\w\+\)\%(\%#.*\)\@<=
```

### Inside & Outside

```vim
echo autocmd_add([#{event: 'CursorHold', pattern: '<buffer>', cmd: 'exec "/"..getline(".")', group:'mayhem_searchpreview', replace: v:true }])
```

#### Strings
```reg
string including unescaped delims
'test' 'test\'' 'test'
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

string including delims
/\(["'`]\).\{-}\1

string excluding delims
/\(["'`]\)\@1<=.\{-}\1\@!
```

#### Brackets


```reg

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
/|\ {{\w\+|\(\w\+\)}}.*\n|\s\?\([^|]*\)\n|\s\?\([^|]*\)\n|\s\?\([^|]*\)\n|\s\?\([^|]*\)\n\%(|-\||}\)/
```

```reg
/|\ {{\w\+|\(\w\+\)}}.*\n|\s\?\(.*\)\n|\s\?\(.*\)\n|\s\?\(.*\)\n|\s\?\(.*\)\n\%(|-\||}\)/
                         |\s\?\(.*\)\n|
                         One table cell
```

```reg
|test|
/|\ {{\w\+|\(\w\+\)}}.*\n|\s\?\(.*\)\n|\s\?\(.*\)\n|\s\?\(.*\)\n|\s\?\(.*\)\n\%(|-\||}\)/

                           |.*||\s\?\(.*\)\%(\n|\|||\)
```


## CSS

### Block comments

```reg
/\(\/\*.\{-}\*\/\)\+/
```
```reg
/(\s*\/\*\_[^*]*\*\/\s*\_s\)\+/
/(\s*\/\*[^!]\_[^*]*\*\/\s*\_s\)\+/
/(\s*\/\*!\_[^*]*\*\/\s*\_s\)\+/
```

Not including/only 'important' comments
```reg
/\(\/\*[^!].\{-}\*\/\)\+/
/\(\/\*!.\{-}\*\/\)\+/
```

Including whitespace/(& blank lines) before/after

```reg
/\(\s*\/\*.\{-}\*\/\s*\)\+/
/\(\s*\/\*[^!].\{-}\*\/\s*\)\+/
/\(\s*\/\*!.\{-}\*\/\s*\)\+/

/\(\_s*\/\*.\{-}\*\/\_s*\)\+/
/\(\_s*\/\*[^!].*\*\/\_s*\)\+/
/\(\_s*\/\*!.\{-}\*\/\_s*\)\+/
```

Remove all block comments
```reg
%s/\(\_s*\/\*.\{-}\*\/\_s*\)\+//
%s/\(\_s*\/\*.\{-}\*\/\_s*)\+/ /
```

### CSS Selectors

### Selector list

```reg
%s/\%(\%^\|}\)\_s*\zs\%(\s*\_[^} ]\)*\ze\s*{/
```

## Selector

```reg
\%(\%^\|[},]\)\_s*\zs\%(\s*\_[^}, ]\)*\ze\s*[,{]
```

### Selector under cursor

- One selector if in a list
 - No trailing whitespace
- works for one level of brackets
- doesn't work inside brackets

```reg
\(\%^\|}\)\_s*\%(\%(\_[^,({]\|(\_.\{-})\)\+,\)*\zs\%(\_[^,({]\|(\_.\{-})\)*\%#\%(\s*\%(\_[^,({ ]\|(\_.\{-})\)\+\)*\ze\s*[{,]



\(\%^\|}\)\_s*\%(\%(\_[^,({]\|(\_.\{-})\)\+,\)*\zs
\ \%(\_[^,({]\|(\_.\{-})\)*\%#\%(\s*\%(\_[^,({ ]\|(\_.\{-})\)\+\)*\ze\s*[{,]
```


## Selector & trailing comma


<!-- -->
