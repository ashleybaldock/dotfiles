
```
" Find first element of table to amend
" %s/\-\n| \({\)\@!\zs\(.*\)\ze$/


" Table row
" /|-\s*\zs\(\w*\)\ze\($\||\)\+

" First table heading on a line
" \1: attributes
" \2: content
" ^\s*\zs!\s*\([^|!]|\)\{-}\s*\(.\{-}\)\ze\s*\(!!\|$\)

" Next table heading

function! ReplaceWithLink(name) abort
  exec '%s/\([\|{\|\)\@!\<\zs'..a:name..'\ze\>/[[#'..a.name..']]'/c
endfunc

%s/\-\n| \({\)\@!\zs\(.*\)\ze$/\=ReplaceWithLink(submatch(0))

%s/\-\n| \({\)\@!\zs\(.*\)\ze$/\='%s^\([\|{\|\)\@!\<\zs'..submatch(0)..'\ze\>^[[#'..a.name..']]'^c

```

These six can be used to match specific columns in a buffer or string.
The "23" can be any column number.  The first column is 1.  Actually,
the column is the byte number (thus it's not exactly right for
multibyte characters).

`hello world`

## -- atoms

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
    │  │ ╭╴ \%           \\%\(\^\|\$\|#\|V\|\([><]\=\(\'M\|\([N.]\+[lcv]\+\)\)\)   │
    │  │ │                                                                         │
    │  │ │ before╶  ╭╴<╶╮ ╭╴N╶╮ ← Number  ╭╴c╶─ c̲olumn ⎫(bytes)  \%<22c     \%>.c  │
    │  │ │     in╶ ╭┼───┼╮┴╴.╶┤ ← cursor  ├─╴v╶─ v̲.col ⎪(chars)  \%<2v \%.l \%>3v  │
    │  │ │  after╶ │╰╴>╶╯│    ╰───────────┴──╴l╶─ l̲ine ⎪                           │
    │W │ │         │     ╰'M╶ mark M                   ⎬ not updated on change     │
    │W │ ╰─────────┴─────┬╴#╶ Cursor position          ⎭                           │
    │W │                 ├╴V╶ Visual area     (current, or previous)   \%Vfoo\%V   │
    │W │                 ├╴^╶ Beginning ⎫                                          │
    │W │                 ╰╴$╶ End       ⎭ of file/string                           │
    └──┴───────────────────────────────────────────────────────────────────────────┘


## -- multis

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

## -- preceding (zero width)

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
 

