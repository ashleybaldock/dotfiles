if exists("g:mayhem_loaded_css")
  finish
endif
let g:mayhem_loaded_css = 1

"
" CSS:
"
" See Also:
"                  ./csso.vim (CSS optimise)
"                  ./svgo.vim (SVG optimise)
"               ./dataurl.vim
"           ../syntax/css.vim
"     ../after/syntax/css.vim
"         ../ftplugin/css.vim
"   ../after/ftplugin/css.vim
"


" CSSO
"
" 
" command! -bar -range=% -nargs=? CssOptimise <line1>,<line2> <Nop>

"
" Layer Editing Tools:
"
" For properties made up of comma-separated layers, e.g. background
"
" Break Layers Into Lines:
"
" Convert Layers To CSS Variables:
"
" Expand All Layer Components:
" e.g.
"   background-image: <image1>, <image2>, <image3>, <image4>;
"   background-repeat: no-repeat, repeat-x;
" becomes:
"   background-image: <image1>, <image2>, <image3>, <image4>;
"   background-repeat: no-repeat, repeat-x, no-repeat, repeat-x;
"
" Move Layer Up Or Down:
"
" Reorder all layer components together
"   - Expands layer components as needed  
"   - Moving the top-most layer up or   ⎫ creates a duplicate 
"   - Moving the bottom-most layer down ⎭  layer above/below
"
" e.g. (cursor on 2nd layer of any layer property)
"   background-image: <image1>, <ima̲ge2>, <image3>, <image4>;
"   background-position: top, rig̲ht, bottom, left;
" (Move Up):              ╭───⇆⃝ ───╮  
"   background-image: <ima̲ge2>, <image1>, <image3>, <image4>;
"   background-position: rig̲ht, top, bottom, left;
" (Move Down):                      ╭───⇆⃝ ───╮ 
"   background-image: <image1>, <image3>, <ima̲ge2>, <image4>;
"   background-position: top, bottom, rig̲ht, left;
"
" e.g. for background-images
" <M-Up> / <M-Down>
" insert/normal:
"   move line, or layer, up/down
" visual:
" - move layer up/down (which may be left/right within line)
"

"
" Move Selectors:
"
" when adding/moving lines ending in {, adjust surroundings to make sense
"            ✘       ✔︎        ✘       ✔︎
" blah,    meh {   meh,     meh,    meh {}                         
" meh {    blah,   blah {                                          
" }        }       }        blah {  blah {                         
"                           }       }                              
" ditto for , and ;
"

"
" Extract A Selector From List:
"
" individual copy of rule for selector under cursor TODO
" e.g.
" .foo, .b̲ar, .baz {       .foo, .baz {
"   color: red;       ▬▶︎     color: red;...
"   ...                    .bar {
"                            color: red;...
"
" Extract All: Same but for all selectors in list                        TODO
"


"
" Common Prefix Search:
"  Find longest prefix shared by rules in selection/file 
function s:CommonPrefixes()
endfunc

"
" Prefix Rules: selection/file                    TODO
" e.g.
"  .foo {              #someid .foo {
"    color: red;  ▬▶︎      color: red;
"  }                   }
"
command! -bar -range=% -nargs=1 CssPrefix <line1>,<line2> <Nop>
"
" Prefix selected rules with a specificity increasing hack   TODO
command! -bar -range=% CssBoostSpecificity <line1>,<line2>CssPrefixRules ':not(#i#m#p#o#r#t#a#n#t)'

"
" Prefix Conceal: hide long common prefix for readability
"
let s:prefix_matches = []
command! -bar CssPrefixConceal
      \ :call add(s:prefix_matches, matchadd('Conceal', 
      \   '#content\s\.mw-search-form-wrapper',
      \   10, -1, #{conceal:'𝓟'}))

command! -bar CssPrefixesReveal
      \ :for p in s:prefix_matches
      \ :call matchdelete(p)
      \ :endfor


"
" Unprefix Rules: selection/file
" e.g.
"  .b̲ar .foo {          .foo {
"    color: red;  ▬▶︎      color: red;
"  }                    }
"  .bar .baz {}         .baz {}
"
" ^\s\?\([.#]\S*\)\s
command! -bar -range=% -nargs=1 CssUnprefix <line1>,<line2> <Nop>


"                                       TODO
" Paste Into Existing Rules:
"
" Find matching selectors and add rules to those if possible
"

"
" Remove units from zero values where they are not needed
"  - Most properties don't need them, e.g. 0px, 0em, 0cqi all become 0
" Add units for zero values which require them (TODO):
"       <angle>  \(deg\|grad\|rad\|turn\)
"        <time>  \(s\|ms\)
"   <frequency>  \(Hz\|kHz\)
"  <resolution>  \(dpi\|dppx\|dpcm\)
"
command! -bar -range=% CssZeroUnits <line1>,<line2> s/\%(\s\|,\)\zs[-+]\?0\+\.\?\0*\(cap\|ch\|em\|ex\|ic\|lh\|rcap\|rch\|rem\|rex\|ric\|rlh\|vh\|vw\|vmax\|vmin\|vb\|vi\|cqw\|cqh\|cqi\|cqb\|cqmin\|cqmax\|px\|cm\|mm\|Q\|in\|pc\|pt\)\ze\%(\s\|;\)/0/ge


" These properties use <time>
" Ensure zero values have units (0 -> 0s)
"
" directly:
"  transition           ⎫
"   transition-delay    ├ any word in these starting
"   transition-duration ⎪  with  0 must be a <time>
"  animation            ⎪
"   animation-delay     ⎪
"   animation-duration  ⎭
"   
"
" These properties use <angle>
" Ensure zero values have units 
"
" directly:
"    image-orientation     any valid value starting
"                          with 0 must be an <angle>
"
" via: \%(linear-gradient\|repeating-linear-gradient\)(\s*0
"    background/background-image
"    mask/mask-image
"    border-image-source
"    shape-outside
" any valid linear-gradient def. if first property starts
"   with a 0, it must be an <angle>
"
" via: \%(skew\%(X\|Y\)([]0)\|rotate\%(3d\|X\|Y\|Z\)\?\)()
"    transform 
"
"    any valid value(s) in skew/rotate must be <angles>
"    any valid 4th value for rotate3d must be an <angle>     TODO
"

" 
" Add semicolon to end of last declaration in a rule
" (Anywhere else would be a syntax error)
" Useful for output from CSSO
"
command! -bar -range=% CssAddTrailingSemi <line1>,<line2>
      \ s/[^;{}]\zs\ze$\n\s*}/;/

"
" Important Comments:
"
" e.g.
" /*! comment */
"
command! -bar -range=% CssNoDevToolComments <line1>,<line2>
      \ s/\*\s\?\%(Inline\s#\d\+\|Element\)\s\?|.*$//


"
" CSS Grid Template Split:
"
" Formats grid-template-[columns/rows] into multiple lines
" 
command! -bar -range=% CssGridTemplateSplit <line1>,<line2>
      \ s/\%(^\(\s*\)grid-template-\%(rows\|columns\):.*\)\@<=\%(\[\zs\|\%(\[[^]]*\)\@<= \+\|\]\@>\)\ze.*[;}]/\1  /g



"
" Attribute Selectors: [data-attr='value']
"
" Replace " with '
" Add formatting
"  ║₁⎼⎼⎼⎼⎼⎼⎼₁⏐₂₂⏐₃⏐₄⎼⎼⎼₄⏐₃⏐₆₆⏐
" [║data-attr⏐$=⏐'⏐value⏐'⏐ i⏐]
"
" [data-attr$='value' i]
" ◥⎻⎻⎻⎻¹⎻⎻⎻⎻₂꛰︎₂꛰︎³꛰︎⎻⎻⁴⎻⎻⁵꛰︎₆͞︎₆͞︎⎻◤
"
command! -bar -range=% CssAttrSingleQuotes <line1>,<line2> s/\[\zs\([^|~$^=\]]*\)\([|~$^*]\?=\)\("\)\([^"']*\)\(\3\)\%(\s\([iIsS]\)\)\?\ze]/\1\2'\4'\6/cg


"
" CSS Variables:
"
"
" Extract Variable:                                                            TODO
" color: #556677;
"   ▼▼
" color: var(--color001);
" --color001: #556677;
"
"
" Extract Component Variables:                       TODO
"
" box-shadow: 1px 2px 0.1px 0 #449988 inset;
"   ▼
" box-shadow: var(--boxs01);
" --boxs01: 1px 2px 0.1px 0 #449988 inset;
"   ▼
" --boxs01-x: 1px;
" --boxs01-y: 2px;
" --boxs01-r: 0.1px;
" --boxs01-o: 0;
" --boxs01-c: #449988;
" --boxs01-i: inset;
" --boxs01: var(--boxs01-x) var(--boxs01-y) var(--boxs01-r) var(--boxs01-o) var(--boxs01-c) var(--boxs01-i); 
" box-shadow: var(--boxs01);
"
"
" color: #01020304;
" 
" color: var(--color02);
" --color02: #01020380;
"
" --c02r: 1;
" --c02g: 2;
" --c02b: 3;
" --c02a: 0.5;
" --color02: rgb(var(--c02r) var(--c02g) var(--c02b) / var(--c02a));



"
" command! CssDataURLSplitPathZ 
"
" If base64, wrap @ fixed length after preamble
" If svg, break up by:
"   attributes in root element
"     xmlns: hidden next to opening tag
"     width/height/viewBox: share a line, break if needed
"     style: own line
"       break into multiple lines if needed
"   child elements
"   svg path components inside d attribute
" e.g.
"
" url('data:image/svg+xml,<svg xmlns={SVG}\
"    width="1em" height="1em"\
"    viewBox="0 0 384 512"\
"    style="fill:#dd1111;"\
"    ><path d="\
"      M342.6 150.6\
"      c12.5-12.5 12.5-32.8 0-45.3\
"               s-32.8-12.5-45.3 0\
"      L(192, 210.7)(86.6, 105.4)\
"      c❲-12.5-12.5❳❲-32.8-12.5❳❲-45.3 0❳\
"      c←12.5↑12.5,←32.8↑12.5,←45.3 0)\
"      s{-45.3,   0  }(-12.5,  32.8)(  0,  45.3)\
"
"      M[10, 0]
"        a(10 10 0 1 0 10 10)
"        A(10 10 0 0 0 10 0)
"      ↘︎m→1↓16
"      ↘︎m1→16↓
"        H(⇢9)
"        v(-2↑)
"        h(2→)
"      z\
"      m‣2.71▴▫7.6a2.6 2.6 0 0 1-.33.74 3.2 3.2 0 0 1-.48.55\
"      l-.54.48c-.21.18-.41.35-.58.52a2.5 2.5 0 0 0-.47.56\
"      A2.3 2.3 0 0 0 11 12a3.8 3.8 0 0 0-.11 1H9.08\
"      a9 9 0 0 1 .07-1.25 3.3 3.3 0 0 1 .25-.9 2.8 2.8 0 0 1 .41-.67 4 4 0 0 1 .58-.58\
"      c.17-.16.34-.3.51-.44\
"      
"      L146.7 256 41.4 361.4\
"      c-12.5 12.5-12.5 32.8 0 45.3\
"      ⤷ s32.8 12.5 45.3 0\
"      L192 301.3 297.4 406.6\
"      c12.5 12.5 32.8 12.5 45.3 0\
"      ⤷ s12.5-32.8 0-45.3\
"      L237.3 256 342.6 150.6z\
"      "></path></svg>');
" Convert:
" TODO
"   s => c   (find previous curve endpoint and prepend)
"   t => q   (find previous curve endpoint and prepend)
"
"   abs => rel
"
" SVG Path Modification:
"
function! s:formatSVGcoord(n)
  return printf("%.3f", a:n)->substitute(
        \ '^\(-\?\)0*\([1-9]\d*\|0\)\%(\(\.\d*[1-9]\)\|\.\?\)0*$', '\1\2\3', 'g')
endfunc

let s:every1 = '\s*\(-\?\d*\(\d\|\.\d\)\d*\)'
let s:every2 = s:every1 .. s:every1
let s:every7 = s:every2 .. s:every1 .. '\s*\(0\|1\)\s*\(\0\|\1\)' .. s:every2

function! s:add(i, j)
  return a:i + a:j
endfunc
function! s:mul(i, j)
  return a:i * a:j
endfunc

function! s:do1(part, f, fargs)
  return substitute(a:part, every1,
        \     {n -> mapnew(n, str2float)->s:formatSVGcoord(a:f(str2float(n[1])))}, 'g' )
endfunc
function! s:do2(part, f)
  return substitute(a:part, every2,
        \     {n -> s:formatSVGcoord(a:f(str2float(n[1]) + a:x)) ..
        \           s:formatSVGcoord(a:f(str2float(n[2]) + a:y))}, 'g' )
endfunc
function! s:do7(part, f)
  return substitute(a:part, every7,
        \     {n -> s:formatSVGcoord(a:f(str2float(n[1]), a:x)) ..
        \           s:formatSVGcoord(a:f(str2float(n[2]), a:y)) ..
        \           s:formatSVGcoord(a:f(str2float(n[3]))) ..
        \           s:formatSVGcoord(a:f(str2float(n[4]) + a:y)) ..
        \           s:formatSVGcoord(a:f(str2float(n[5]) + a:y)) ..
        \           s:formatSVGcoord(a:f(str2float(n[6]) + a:y)) ..
        \           s:formatSVGcoord(a:f(str2float(n[7]) + a:y))}, 'g' )
endfunc
" Scale:
"
" TODO needs special case for A/a to avoid scaling flags/angle
"
" path: contents of a d="" attribute
" factor: scaling factor to multiply by
"
" Multiply all coordinates by a constant scaling factor
"
function! ScaleSVGPath(path, x = 1, y = x)
  let lookup = #{
        \ default: {s -> substitute(s, '\s*\zs\(-\?\d*\(\d\|\.\d\)\d*\)',
        \     {n -> printf("%.3f", str2float(n[1]) * a:x)->substitute(
        \ '^\(-\?\)0*\([1-9]\d*\|0\)\%(\(\.\d*[1-9]\)\|\.\?\)0*$', '\1\2\3', 'g')
        \ }, 'g' )},
        \}
  return substitute(a:path, '\([MLVCSQTAZmlhvcsqtaz]\)\([0-9. -]*\)', 
        \ {m -> m[1] .. (get(lookup, m[1], get(lookup, 'default')))(m[2])}, 'g')
endfunc

let s:splitPathParts = '\([MLVCSQTAZmlhvcsqtaz]\)\([0-9. -]*\)'
"
" Translate:
"
" Adds an offset to all absolute x and y coordinates
"
function! TranslateSVGPath(path, x = 0, y = 0)
  let lookup = #{
        \ default: {v -> v},
        \ H: {n -> s:do1(n, x, s:add)},
        \ V: {n -> s:do1(n, y, s:add)},
        \ M: {n -> s:do2(n, [x,y], s:add)},
        \ L: {n -> s:do2(n, [x,y], s:add)},
        \ Q: {n -> s:do2(n, [x,y], s:add)},
        \ T: {n -> s:do2(n, [x,y], s:add)},
        \ C: {n -> s:do2(n, [x,y], s:add)},
        \ S: {n -> s:do2(n, [x,y], s:add)},
        \ A: {n -> s:do7(n, [x,y,0,0,0,x,y], s:add)},
        \}
  return substitute(a:path, s:splitPathParts, 
        \ {m -> m[1] .. (get(lookup, m[1], get(lookup, 'default')))(m[2])}, 'g')
endfunc
"
" list of matches
" let list = []
" :%s/\<foo\(\a*\)\>/\=add(list, submatch(1))/gn
"
" '<,'>s//\\\1  \2/
"
" line break + continuation before base64
"     repeat to remove exisiting line continuation
" :%s/\%(\\$\n\s*\)base64,\%([^\\]*\zs\\$\n\s*\)//g
"
"     split base64, onto own line + define match area
"     \1 indentation    \2 
" %s/^\(\s\+\)[^;]\+;\zs\(base64,[a-zA-Z0-9/+ \\]\+\)\ze['");]/\\\1  \2/
"
"     get rid of existing line continuation and spaces
" '<,'>s/base64,\S*\zs //g
"
"     \1 indentation    \2 everything up to column 80
" s/^\(\s*\)\(.\+\)\%80c/\1\2\\\1/g
"
" s/^\(\s*\)base64,\&.*\%80c\zs\(.*\)\ze\%160c/\\\1\2/g
"
" %s/^\(\s\+\)[^;]\+;\zs\(base64,[a-zA-Z0-9/+ \\]\+\)\ze['");]/\\\1  \2/ | s/base64,\S*\zs //g | s/^\(\s*\)\(.\+\)\%80c/\1\2\\\1/g
"
"
"
" '<,'>s/^\(\s*\)[^;]\+;\zs\(base64,\_[a-zA-Z0-9/+ \\]\+\_[=]*\)\ze['");]

"
" Data URLs:
" See Also: ./dataurl.vim
"
" /url(\("\|'\|\)data:\([A-Za-z/]\+\);\(base64\)\?,\([A-Za-z0-9/+=]\+\)\1)/
"
" Split: across multiple lines                              TODO
" TODO
" Split SVG URLs at tag boundaries …%3E\⏎️ %3C… (…>\⏎️ <…)
"
command! CssDataURLSplit3E3C :s/%3E\zs\s*\ze%3C/\\    /g

"
" Add spaces before and after the child combinator ( > )
"
" \%d173 used in place of } to avoid syntax bug
"
command! -bar -range=% CssSpaceChildCombi 
      \ <line1>,<line2>s/\%(}\|\%^\)\_.\{-}\S\zs\s*>\s*\ze\S\_.\{-}\(\%d173\|\%$\)/ > /gc

"
" Data URLs:
"
" TODO
command! -bar -range=% CssDataURLFit <line1>,<line2> <Nop>

" Quotes: add if missing, change to ''
" (Assumes no syntax errors to start with)
" 
command! -bar -range=% CssDataURLQuotesNone
      \ <line1>,<line2> s/url(\zs\("\|\'\|\)\(data:\_.\{-}\)\1\ze)/\2/
command! -bar -range=% CssDataURLQuotesSingle
      \ <line1>,<line2> s/url(\zs\("\|\'\|\)\(data:\_.\{-}\)\1\ze)/\'\2\'/
command! -bar -range=% CssDataURLQuotesDouble
      \ <line1>,<line2> s/url(\zs\("\|\'\|\)\(data:\_.\{-}\)\1\ze)/\"\2\"/


"
" Hex Codes:
"
" Change hex color codes to uppercase
command! -bar -range=% CssUppercaseHex
      \ <line1>,<line2> s/\<\(#\x\{8}\|#\x\{6}\|#\x\{4}\|#\x\{3}\)\>/\U&/g

" Change hex color codes to lowercase
command! -bar -range=% CssLowercaseHex
      \ <line1>,<line2> s/\<\(#\x\{8}\|#\x\{6}\|#\x\{4}\|#\x\{3}\)\>/\L&/g

" Expand short hex codes (#F0E ▬▶︎ #FF00EE, #FB3A ▬▶︎ #FFBB33AA)
command! -bar -range=% CssExpandHex
      \ <line1>,<line2> s/\<#\(\x\)\(\x\)\(\x\)\(\x\)\?\>/#\1\1\2\2\3\3\4\4/g

" Compact long hex codes (#FF00EE ▬▶︎ #FOE, #FFBB33AA ▬️▶︎ #FB3A, #112233ff #123)
command! -bar -range=% CssCompactHex
      \ <line1>,<line2> s/\%(\<#\|#\<\)\(\x\)\1\(\x\)\2\(\x\)\3\%(\([0-9a-eA-E]\)\4\|[fF]\{2}\)\?\>/#\1\2\3\4/g


"
" Parse Hex Codes:
"
" Returns a Color<{p, s, r, g, b, a}>
" (p: parsed-from, s: parser status, r, g, b, a: obvious)
"
" Defaults to #0000 if parsing fails
"
function CssParseHex(hex)
  let result = {'p': a:hex, 's': 'fail', 'r': 0, 'g': 0, 'b': 0, 'a': 0 }
  let match8 = matchlist(a:hex, '\(\x\x\)\(\x\x\)\(\x\x\)\(\x\x\)')
  if len(match8) > 0
    let result['s'] = 'ok:hex8'
    let result['r'] = str2nr(match8[1], 16)
    let result['g'] = str2nr(match8[2], 16)
    let result['b'] = str2nr(match8[3], 16)
    let result['a'] = str2nr(match8[4], 16) / 255.0
  else
    let match6 = matchlist(a:hex, '\(\x\x\)\(\x\x\)\(\x\x\)')
    if len(match6) > 0
      let result['s'] = 'ok:hex6'
      let result['r'] = str2nr(match6[1], 16)
      let result['g'] = str2nr(match6[2], 16)
      let result['b'] = str2nr(match6[3], 16)
      let result['a'] = 1
    else
      let match4 = matchlist(a:hex, '\(\x\)\(\x\)\(\x\)\(\x\)')
      if len(match4) > 0
        let result['s'] = 'ok:hex4'
        let result['r'] = str2nr(match4[1] .. match4[1], 16)
        let result['g'] = str2nr(match4[2] .. match4[2], 16)
        let result['b'] = str2nr(match4[3] .. match4[3], 16)
        let result['a'] = str2nr(match4[4] .. match4[4], 16) / 255.0
      else
        let match3 = matchlist(a:hex, '\(\x\)\(\x\)\(\x\)')
        if len(match3) > 0
          let result['s'] = 'ok:hex3'
          let result['r'] = str2nr(match3[1] .. match3[1], 16)
          let result['g'] = str2nr(match3[2] .. match3[2], 16)
          let result['b'] = str2nr(match3[3] .. match3[3], 16)
          let result['a'] = 1
        endif
      endif
    endif
  endif
  return result
endfunc

"
" Color Functions:
"
" Format a color in modern form [rgb(rr gg bb / aa)]
"
function CssFormatRGB(colour) abort
  let r = get(a:colour, 'r', 0)
  let g = get(a:colour, 'g', 0)
  let b = get(a:colour, 'b', 0)
  let a = get(a:colour, 'a', 1)
  return a == 0.0
        \ ? printf('rgb(%d %d %d / 0)', r, g, b)
        \ : a == 1
        \ ? printf('rgb(%d %d %d)', r, g, b)
        \ : printf('rgb(%d %d %d / %.1f%%)', r, g, b, a * 100)
endfunc

"                                                           TODO
" #rrggbb[aa] ▬▶︎ rgb(r g b [/ aa])
command! -bar -range=% CssHexToRgb
      \ <line1>,<line2> s/\<\(#\x\{8}\|#\x\{6}\|#\x\{4}\|#\x\{3}\)\>/\=
      \CssFormatRGB(CssParseHex(submatch(0)))/


" s/\<#\%(
"       \ \(\x\x\)\(\x\x\)\(\x\x\)\(\x\x\)\|
"       \ \(\x\x\)\(\x\x\)\(\x\x\)\|
"       \ \(\x\)\(\x\)\(\x\)\(\x\)\|
"       \ \(\x\)\(\x\)\(\x\)\)\>/\=FormatRGB({
"       \ 'r':parseInt(submatch(1), 16),
"       \ 'g':parseInt(submatch(2), 16),
"       \ 'b':parseInt(submatch(3), 16),
"       \ 'a':parseInt(submatch(4), 16)
"       \})/

"                                                           TODO
" %s+rgba\?(\s*\(\d\+\)[ ,]\s*\(\d\+\)[, ]\s*\(\d\+\)\s*[,/ ]\s*\(\d*\.\?\d\+\)\s*)+r:\1,g:\2,b:\3,a:\4+
" rgb(r g b [/ a]) ▬▶︎ #rrggbb[aa] 
command! CssRgbToHex <Nop>
"                                                           TODO
" #rrggbb[aa] ▬▶︎ hsl(h s l [/ a])
command! CssHexToHsl <Nop>
"                                                           TODO
" hsl(h s l [/ a]) ▬▶︎ #rrggbb[aa] 
command! CssHslToHex <Nop>

"                                                           TODO
command! CssRgbToHsl <Nop>
"                                                           TODO
command! CssHslToRgb <Nop>
"             \1 H                \2 S                \3 L                    \4 A
"          ╭─────────╮      ╭─────────────╮      ╭─────────────╮           ╭────────────╮
"/\<hsla\?(\(\d\{1,}\)[^ ]* \(100\|\d\d\?\)[^ ]* \(100\|\d\d\?\)[^ )]*\(\/ \(100\|\d\d?\)%\?\)\?)/

"
" Get color's complement (h+180deg)
"                                                           TODO
" Returns result in same format as supplied, hex->hex, rgb->rgb, hsl->hsl
"
command! CssColorComplement <Nop>

" Get inverse of a colour
"                                                           TODO
" Returns result in same format as supplied, hex->hex, rgb->rgb, hsl->hsl
"
command! CssColorInverse <Nop>


" Edge cases and formats etc.
"           #xyz[f] | #xxyyzz[ff]  ▬▶︎  rgb(r g b)
"      #xyz[0-e] | #xxyyzz[00-ef]  ▬▶︎  rgb(r g b / a)
"
"   (legacy) rgb(R,G,B) | (legacy) rgba(R,G,B,1) |
" rgb(R G B) | rgb(R G B / 1) | rgb(R G B / 100%)  ▬▶︎ #xxyyzz
"
"   (legacy) rgba(R,G,B,A) |
" rgb(R G B / [0-0.999])| rgb(R G B / [0-99.99%])  ▬▶︎ #xxyyzzaa

" Absolute value syntax
" rgb(R G B[ / A])  R,G,B = 0-255 or 0%-100% or none
" let rgb = "\<rgb(\(\d\{1,3}\|0\?\d\?\d%\|100%\|none\)\s\+\(\d\{1,3}\|0\?\d\?\d%\|100%\|none\)\s\+\(\d\{1,3}\|0\?\d\?\d%\|100%\|none\)\(\s\+\/\s\+\(0\?\.\d\+\|1\(\.0*\)\?\|0\?\|none\))\|)\)"

let s:none = 'none'
" fast (false positives / non-validating)
"
" <number[0(000)-255(999)]>
let s:nF_0_255 = '\d{1,3}'
" <percentage[0%(00%)-100%]>      (…but also 000%,00% etc.)
let s:pF_0_100 = '100%\|\d{1,2}%'
" <number[0.0-1.0(1.999)]>        (…but also 1.0-1.9 etc.)
let s:dF_00_10 = '1\.0\|0\.0\+\|0\?\.\d\+'

let s:rgb_F = '\('..s:nF_0_255..'\|'..s:pF_0_100..'\|'..s:dF_00_10..'\|'..s:none..'\)'
let s:alpha_F = '\('..s:pF_0_100..'\|'..s:dF_00_10..'\)'

let s:rgbFast = '\<rgba\?('..s:rgb_F..'[^ ] '..s:rgb_F..'[^ ] '..s:rgb_F..'[^)/]\%()\| '..s:alpha_F..'[^)])\)'

"let byte = 
"      \ "\d{1,3}"
"      \ .."\d{1,3}"

" :%s/\<rgb(\s*\(\d{1,3}\|100%\|\d{1,2}%\|none\)\s\+\(\d{1,3}\|100%\|\d{1,2}%\|none\)\s\+\(\d{1,3}\|100%\|\d{1,2}%\|none\)\(\s+\/\s+[01]\?\.\?\d\+\|none\)\?)/

"
" strict (false negatives possible, but no false positives)
"
" <number[0-255]>
let s:nS_0_255 = '\([0-9]\|[1-9][0-9]\|1[0-9]\{2}\|2[0-4][0-9]\|25[0-5]\)'
" 
" <percentage[0%-100%]>
let s:pS_0_100 = '\(100%\|[1-9]\?[0-9]%\)'
"
" <number[0.0-1.0]>
let s:dS_00_10 = '\([01]\(\.0*\)\|0\.\d*\)'

"/\<rgb(\([01][0-9][0-9]\d\{1,3}\|0\?\d\?\d%\|100%\|none\)\s\+\(\d\{1,3}\|0\?\d\?\d%\|100%\|none\)\s\+\(\d\{1,3}\|0\?\d\?\d%\|100%\|none\)\(\s\+\/\s\+\(0\?\.\d\+\|1\(\.0*\)\?\|0\?\|none\))\|)\)/

      
" /\ze\(\s\|;\|,\)/




"                 TODO
" Macros:
"
"
" Background Image Skeleton:
"
"
" Linear Gradient:
"
" Radial Gradient:
"
" Conical Gradient:
"
"
" Box Shadow With Variables:
"
"
" Text Shadow Outline:
"
"
"
" Filter Drop Shadow Outline:
"


" Text outline, 8 sides, identical
"
"  --┏️ --┓️ --▙️  --▛️  --▜️  --▟️  --▌⃞ --▐⃞ --▄⃞ --▀⃞ --▖⃞  --▗▗️--▘️--▝️
"  --┏️ --┓️ --▙⃣  --▛⃣  --▜⃣  --▟⃣  --▌⃞ --▐⃞ --▄⃞ --▀⃞ --▖⃞  --▗▗️--▘️--▝️
"
"  --┏⃞  --▙⃞  --▛⃞  --▜⃞  --▟⃞  --▌⃞ --▐⃞ --▄⃞ --▀⃞ --▖⃞  --▗▗️--▘️--▝️
"
"  ┏⃞ ┓⃞ ┛⃞ ┗⃞ ┳⃞ ┫⃞ ┻⃞ ┣⃞ ╋⃞ ━⃞ ┃⃞   ╭️⃞  ╮️⃞ ╰️⃞  ╯️⃞    k
"  ┏︎⃞ ┓︎⃞  ┛⃞️︎ ┗⃞ ┳⃞ ┫⃞ ┻⃞ ┣⃞ ╋⃞ ━⃞ ┃⃞  ┼⃝   ┼⃞  ┼⃣  ┼⃝️   
"  ┏️⃞ ┓️⃞   ┛⃞ ┗⃞ ┳⃞ ┫⃞ ┻⃞ ┣⃞ ╋⃞ ━⃞ ┃⃞ 
"
"  --◢⃞   --◣⃞  --◤⃞  --◥⃞      --▶⃞    --◀︎⃞  --▼⃞  --▲⃞   
"
"  --◩ --◪ --⬕ --⬔ --⬒ --⬓ --◧ --◨
"
"  --◩⃑   --◪⃪ --⬕⃜꛱ --⬔꛱ --⬒ --⬓ --◧ --◨️  
"
"  --◩⃝  --◪⃝  --⬕⃝  --⬔⃝  --⬒⃝  --⬓⃝  --◧⃝  --◨⃝ 
"
"  --◩⃞  --◪⃞  --⬕⃞  --⬔⃞  --⬒⃞  --⬓⃞  --◧⃞  --◨⃞ 
"  --◩️ --◪️ --⬕️ --⬔️ --⬒️ --⬓️ --◧️ --◨️
"  --◰ --◲ --◱ --◳ --⊟ --⊞ --◫ --⊠ ⊏ ⊐ ⊓ ⊔⊿⟔ ⌜
"
"  ⧄ ⧅ ⧆ ⧇ ⧈ ⟤ ⟥
"
"  --⿰⃟  --⿱⃞⃓ --⿲⃞⃦ ⿳⃞⃦ ⿴⃞⃣ ⿵⃟ ⿶⃘ ⿷⃞ ⿸⃞ ⿹⃞̶ ⿺⃞⃪ ⿻⃞ ⿼⃞ ⿽⃞ ⿾⃞ ⿿⃞ 
"
"  --⿰⃞⃓ --⿱⃞⃓ --⿲⃞⃦ ⿳⃞⃦ ⿴⃞⃣ ⿵⃟ ⿶⃘ ⿷⃞ ⿸⃞ ⿹⃞̶ ⿺⃞⃪ ⿻⃞ ⿼⃞ ⿽⃞ ⿾⃞ ⿿⃞ 
"  --〃--々--〆--〤--〥--〦--〧--〨
"  --〇--ⴷ--ⴸ--ⴹ--ⴺ--ⴱ--ⴲ--ⵀ--ⵁ--ⵔ--ⵕ--ⵙ--ⵚ
"  --ⵌ --ⴳ--ⴴ--ⴵ --ⵖ --ⵄ
"  --「」--〓--〡--〢--〣 --〱--〳--〵--〻--〼
"  --く--し--ひ--へ--ト
"  --ㄇ--ㄈ--ㄩ--・--ー
"  --⼌--⼕--⼐
"  --㐃㗊 --ꔷ ▐ 🮁🮆🭸𜺏
"  --⼯--⼠⼟
"  --⼮--⼈--
"  ⼀⼁--⼃--⼍
"  --ヿ --𠃊--𠃍--𠃌--𠆢--𦉫--𦣝
"  --ㄥ--ㄏ--ㄟ--ㄨ--ㄫ--ㄝ
" --＾:; --＄:;
" --＠:; --［:; --］:;
"        --｛:; --｝:;
"        --（:; --）:;
" --＼:; --｜:; --／:; --＿:; --￣:; --￤:; 
" --？:; --꩜ :;
" --～:; --！:; --‼:;
" --￢:; --＆:; 
" --＞:;
" --＜:;
" --＊:;
" --％:;
" --＝:;
" --＋: 1px;
" --－: calc(var(--＋) * -1);
" --０: 0;
" ０１２３４５６７８９ＡＢＣＤＥＦ
" --＃: 0 #000f;
" --＃0000: #0000;
" text-shadow:
"   var(--＋) var(--０) var(--＃),
"   var(--＋) var(--＋) var(--＃),
"   var(--０) var(--＋) var(--＃),
"   var(--－) var(--＋) var(--＃),
"   var(--－) var(--０) var(--＃),
"   var(--－) var(--－) var(--＃),
"   var(--０) var(--－) var(--＃),
"   var(--＋) var(--－) var(--＃);
"
" text-shadow:
" --textoutline1px: 1px 0 0 #000f, 1px 1px 0 #000f, 0 1px 0 #000f, -1px 1px 0 #000f, -1px 0 0 #000f, -1px -1px 0 #000f, 0 -1px 0 #000f, 1px -1px 0 #000f;
" --textoutline1px: 1px 0 0.6px #ffff, 1px 1px 0.6px #ffff, 0 1px 0.6px #ffff, -1px 1px 0.6px #ffff, -1px 0 0.6px #ffff, -1px -1px 0.6px #ffff, 0 -1px 0.6px #ffff, 1px -1px 0.6px #ffff;
"
"  1px   0     0 #000f,
"  1px   1px   0 #000f,
"  0     1px   0 #000f,
"  -1px  1px   0 #000f,
"  -1px  0     0 #000f,
"  -1px  -1px  0 #000f,
"  0     -1px  0 #000f,
"  1px   -1px  0 #000f;

" Text border, 4 sides

"   --bcolor: rgb(0 0 0);
"   --bblur: 0;
"   --bthick: 0.01em;
"   --bct:var(--bcolor);--bcr:var(--bcolor);--bcb:var(--bcolor);--bcl:var(--bcolor);
"   --blt:var(--bblur);--blr:var(--bblur);--blb:var(--bblur);--bll:var(--bblur);
"   --bw: var(--bthick); --bh: var(--bthick);
"   --bxt: calc(var(--bw) * -1); --bxb: var(--bw); --bxr: 0; --bxl: 0;
"   --byl: calc(var(--bh) * -1); --byr: var(--bh); --byt: 0; --byb: 0;
"   text-shadow:
"     var(--bxt) var(--byt) var(--blt) var(--bct),
"     var(--bxr) var(--byr) var(--blr) var(--bcr),
"     var(--bxb) var(--byb) var(--blb) var(--bcb),
"     var(--bxl) var(--byl) var(--bll) var(--bcl),
"     0 0 #0000;

" Text border, 4 corners

"   --bcolor: rgb(0 0 0);
"   --bblur: 0;
"   --bthick: 0.01em;
"   --bctr:var(--bcolor);--bcbr:var(--bcolor);--bcbl:var(--bcolor);--bctl:var(--bcolor);
"   --bltr:var(--bblur);--blbr:var(--bblur);--blbl:var(--bblur);--bltl:var(--bblur);
"   --bw: var(--bthick); --bh: var(--bthick);
"   --bxtl: calc(var(--bw) * -1); --bxbl: var(--bxtl); --bxbr: var(--bw); --bxtr: var(--bxbr);
"   --bytl: calc(var(--bh) * -1); --bytr: var(--bytl); --bybr: var(--bh); --bybl: var(--bybr); 
"   text-shadow:
"     var(--bxtr) var(--bytr) var(--bltr) var(--bctr),
"     var(--bxbr) var(--bybr) var(--blbr) var(--bcbr),
"     var(--bxbl) var(--bybl) var(--blbl) var(--bcbl),
"     var(--bxtl) var(--bytl) var(--bltl) var(--bctl),
"     0 0 #0000;

" Text border, 4 sides & 4 corners

"   --bcolor: rgb(0 0 0);
"   --bblur: 0;
"   --bthick: 0.01em;
"   --bct:var(--bcolor);--bcr:var(--bcolor);--bcb:var(--bcolor);--bcl:var(--bcolor);
"   --bctr:var(--bcolor);--bcbr:var(--bcolor);--bcbl:var(--bcolor);--bctl:var(--bcolor);
"   --blt:var(--bblur);--blr:var(--bblur);--blb:var(--bblur);--bll:var(--bblur);
"   --bltr:var(--bblur);--blbr:var(--bblur);--blbl:var(--bblur);--bltl:var(--bblur);
"   --bw: var(--bthick); --bh: var(--bthick);
"   --bxt: calc(var(--bw) * -1); --bxb: var(--bw); --bxr: 0; --bxl: 0;
"   --byl: calc(var(--bh) * -1); --byr: var(--bh); --byt: 0; --byb: 0;
"   --bxtl: calc(var(--bw) * -1); --bxbl: var(--bxtl); --bxbr: var(--bw); --bxtr: var(--bxbr);
"   --bytl: calc(var(--bh) * -1); --bytr: var(--bytl); --bybr: var(--bh); --bybl: var(--bybr); 
"   text-shadow:
"     var(--bxt) var(--byt) var(--blt) var(--bct),
"     var(--bxr) var(--byr) var(--blr) var(--bcr),
"     var(--bxb) var(--byb) var(--blb) var(--bcb),
"     var(--bxl) var(--byl) var(--bll) var(--bcl),
"     var(--bxtr) var(--bytr) var(--bltr) var(--bctr),
"     var(--bxbr) var(--bybr) var(--blbr) var(--bcbr),
"     var(--bxbl) var(--bybl) var(--blbl) var(--bcbl),
"     var(--bxtl) var(--bytl) var(--bltl) var(--bctl),
"     0 0 #0000;





" function! s:OpenCSSFile()
"  if filereadable(expand('%:r')..'.scss')
"    exec 'vsp '..expand('%:r')..'.scss'
"  elseif filereadable(expand('%:r')..'.module.scss')
"    exec 'vsp '..expand('%:r')..'.module.scss'
"  elseif filereadable(expand('%:r')..'.module.css')
"    exec 'vsp '..expand('%:r')..'.module.css'
"  else
"    echo 'No matching CSS file found'
"  endif
" endfunc
" command! OpenCSSFile call <SID>OpenCSSFile()
