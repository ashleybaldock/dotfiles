
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

                                                  
                                             line │ file/string │ word │ pattern
                                          ──┬─────│─────────────│──────│─────────
              Z = zero width      beginning │ BoL │    BoF/S    │ BoW  │ BoP
              B = not inside []         end │ EoL │    EoF/S    │ EoW  │ EoP
    ┌─────────┬───────────────┬───┬─────────────────────────────────────────────────┐
    │   atom  │    matches    │   │   notes                                         │
    ├─────────┼───────────────┼───┼─────────────────────────────────────────────────┤
    │   \_^   │  BoL          │Z B│                                                 │
    │    \^   │  literal      │  B│                                                 │
    │     ^   │  BoL/literal  │   │  (BoL: at BoP, after `\|`, `\(`, `\%(`, `\n`))  │
    │   \%^   │  BoF/S        │Z  │                                                 │
    │┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
    │   \_$   │  EoL          │Z B│                                                 │
    │    \$   │  literal      │  B│                                                 │
    │     $   │  EoL/literal  │   │  (EoL: at EoL, after `\|`, `\)`, `\n`)          │
    │   \%$   │  EoF/S        │Z  │                                                 │
    │┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
    │     .   │  Any N̲O̲T̲ EoL  │   │                                                 │
    │   \_.   │  Any          │   │  including EoL                                  │
    │┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
    │  \< \>  │  BoW / EoW    │Z  │  next / prev char is first / last of word       │
    │┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
    │ \zs \ze │  Any          │Z B│  sets start/end of match                        │
    │┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
    │   \%V   │  In Visual    │Z  │  or prev visual area (gv);  as pair: \%Vfoo\%V  │
    │┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
    │   \%#   │  Cursor       │Z  │ ⎫                                               │
    │   \%.l  │  Cursor Line  │   │ │                                               │
    │  \%<.l  │   Above       │   │ │                                               │
    │  \%>.l  │   Below       │   │ ⎬ not updated when cursor moved                 │
    │   \%.c  │  Cursor Col   │   │ │                                               │
    │  \%<.c  │   Before      │   │ │                                               │
    │  \%>.c  │   After       │   │ │                                               │
    │  \%.v   │  Virtual Col  │   │ │                                               │
    │  \%<.v  │   Before      │   │ │                                               │
    │  \%>.v  │   After       │   │ ⎭                                               │
    │┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
    │   \%23l │  In line      │   │                                                 │
    │  \%<23l │  Above line   │   │                                                 │
    │  \%>23l │  Below line   │   │                                                 │
    │┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
    │   \%'m  │     At ⎫ Mark │Z  │ ⎫                                               │
    │  \%>'m  │ Before ⎬ 'm'  │Z  │ ⎬ not updated if mark moved                     │
    │  \%<'m  │  After ⎭      │Z  │ ⎭                                               │
    │┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
    │ \%23c   │               │   │ ⎫ not updated when text changes                 │
    │ \%<23c  │               │   │ ⎬ byte number - not correct for multibyte chars │
    │ \%>23c  │               │   │ ⎭                                               │
    │┈┈┈┈┈┈┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│┈┈┈│┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈│
    │ \%23v   │               │   │ ⎫ not updated when text changes                 │
    │ \%<23v  │               │   │ ⎬                                               │
    │ \%>23v  │               │   │ ⎭                                               │
    └─────────┴───────────────┴───┴─────────────────────────────────────────────────┘


## -- multis

    ┌─────────────┬─────────┬──────────┐ 
    │   greedy    │  range  │   lazy   │  n,m = 0 or positive
    ├────┬────────┼─────────┼──────────┤                        
    │ \= │ \{,1}  │  0 → 1  │  \{-,1}  │  alternatively: \?
    │    │ \{,m}  │  0 → m  │  \{-,m}  │                        
    │  * │ \{}    │  0 → ∞  │  \{-}    │  nomagic: \*
    ├────┼────────┼─────────┼──────────┤                        
    │ \+ │ \(1,}  │  1 → ∞  │  \{-1,}  │   '\' ╭╴Optional 
    │    │ \{n,}  │  n → ∞  │  \{-n,}  │       ∇                
    │    │ \{n,m} │  n → m  │  \{-n,m} │  \{n,m\}               
    │    │ \{n}   │    n    │  \{-n}   │ 
    └────┴────────┴─────────┴──────────┘ 

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
 

