
" TODO
"
" highlight invalid base64 characters
" distinctive colour for counter-set etc.
" @property highlighting
" :has() / :is() etc. highlighting contents
" warning for slow :has()
" [attr="" [i|s]]    = ^= $= ~= |= *=  
" [data-attr=""] color data- differently
"
" global selector * , *|*
" namespace separator 
"
" more obvious where boundary between text-shadow (etc.) layers are
"
" Combinators:
" The descendant combinator is technically one or more <whitespace characters>
" between two selectors in the absence of another combinator.
" Additionally, the white space characters of which the combinator
" is comprised may contain any number of CSS comments.
"
" CSS White Space Characters:          /[\x09\x0A\x0C\x0D\20]\+/
" * tab             TAB ^I 	  \x09
" * new line        LF            \x0A
" * form feed       FF  ^L \    \x0C
" * carriage return CR  ^M      \x0D
" * space character ' '           \x20
"
"   [^+~>}]\zs[\x09\x0A\x0C\x0D\x20]\+\ze[^{+~>]/
"
" Other Combinators:
" list                ,
"               :has( , )
" forgiving ⎧    :is( , )
"           ⎩ :where( , )
" child               >     parent              :has(> )
" next sibling        +     previous sibling    :has(+ )
" subsequent sibling  ~     preceeding sibling  :has(~ )
"


" exec 'source '..expand("<script>:h")..'"/common.vim"'

source <script>:p:h/common.vim

syn match cssVarCustomProp contained "--\%([a-zA-Z0-9-_]\|[^\x00-\x7F]\)*\Z"
      \ contains=cssCustomPropDashes
syn match cssCustomPropDashes contained +--+
      \ conceal cchar=╸ contains=NONE transparent

" Math operators not made valid by being inside these functions
syn region cssFunctionRegion contained
      \ matchgroup=Conceal start="(" end=")"
      \ contains=cssCustomPropRef,cssFunctionNameVar,cssMathFunctionName,cssFunctionComma,cssColor,cssValueAngle,cssValueInteger,cssValueNumber,cssValueLength

" Math operators valid inside these and nested children
syn region cssMathFunctionRegion contained
      \ matchgroup=Conceal start="(" end=")"
      \ contains=cssCalcKeyword,cssError,cssMathFunctionRegion,cssCustomPropRef,cssFunctionNameVar,cssMathFunctionName,cssFunctionComma,cssColor,cssValueAngle,cssValueInteger,cssValueNumber,cssValueLength

syn keyword cssFunctionNameVar contained conceal cchar=𐐏 var
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssFunctionRegion

syn keyword cssMathFunctionName contained conceal cchar=c calc
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionRegion
syn keyword cssMathFunctionName contained conceal cchar=⬇ min
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionRegion
syn keyword cssMathFunctionName contained conceal cchar=⬆ max
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionRegion

syn match cssCustomPropRefDashes /--/ contained contains=NONE transparent conceal
syn match cssCustomPropRef contained "--\%([a-zA-Z0-9-_]\|[^\x00-\x7F]\)*\Z"
      \ contains=cssCustomPropRefDashes
hi def cssFunctionComma guifg=#dddd22
hi def link cssCustomPropRef cssCustomProp
" syn region cssFunctionVar
"       \ matchgroup=cssVarParens
"       \ start="\<var\s*("ms=s+3,hs=e
"       \ end=")"me=e
"       \ contained oneline
"       \ containedin=cssDefinition,cssAttrRegion,cssAtRule,cssFunction
"       \ contains=cssFunctionNameVar,cssVarCustomProp,cssFunctionVar,cssValue.*,cssFunction,cssColor,cssStringQ,cssStringQQ
"       " \ contains=cssFunctionNameVar,cssVarParens
" " syn region cssVarParens
" "       \ start="("
" "       \ end=")"me=e-1,he=e+2
" "       \ contained oneline
" "       \ contains=cssVarCustomProp,cssFunctionVar,cssValue.*,cssFunction,cssColor,cssStringQ,cssStringQQ
syn region cssFunction contained 
      \ matchgroup=cssFunctionName start="\<\%(repeating-\|\)\%(linear-\|radial-\|conic-\)\=\gradient\s*("
      \ end=")"
      \ contains=cssColor,cssValueAngle,cssValueInteger,cssValueNumber,cssValueLength,
      \ cssFunction,cssGradientAttr,cssFunctionComma

hi def link cssFunctionNameVar Conceal
hi def link cssVarCustomProp cssCustomProp
hi def link cssVarParens Conceal

syn case ignore
syn keyword cssCalcKeyword contained e pi
syn match cssCalcKeyword +-\?infinity+ contained
syn case match
syn keyword cssCalcKeyword contained NaN
syn match cssError +\<\%(n[aA][nN]\|N\%(an\|A[nN]\)\)\>+ contained containedin=cssFunctionCalc
syn case ignore

hi def link cssCalcKeyword Constant



syn match cssPseudoClassId contained +:+ containedin=cssPseudoClass

syn region cssPseudoClassFn containedin=cssPseudoClass
      \ matchgroup=cssFunctionName start=":where("
      \ end=")"
      \ contains=cssSelectorOp,cssPseudoClass,cssStringQ,cssStringQQ,cssTagName,cssAttributeSelector,cssClassName,cssIdentifier
syn region cssPseudoClassFn containedin=cssPseudoClass
      \ matchgroup=cssFunctionName start=":is("
      \ end=")"
      \ contains=cssSelectorOp,cssPseudoClass,cssStringQ,cssStringQQ,cssTagName,cssAttributeSelector,cssClassName,cssIdentifier
syn region cssPseudoClassFn containedin=cssPseudoClass
      \ matchgroup=cssFunctionName start=":has("
      \ end=")"
      \ contains=cssSelectorOp,cssPseudoClass,cssStringQ,cssStringQQ,cssTagName,cssAttributeSelector,cssClassName,cssIdentifier
syn region cssPseudoClassFn containedin=cssPseudoClass
      \ matchgroup=cssFunctionName start=":not("
      \ end=")"
      \ contains=cssSelectorOp,cssPseudoClass,cssStringQ,cssStringQQ,cssTagName,cssAttributeSelector,cssClassName,cssIdentifier

"                           
"   absolute                         …use…
" ────────────────────────────────────────────
"    cm   mm    Q   in   pc   pt     print
"            px                      screen
"            𝗉𝗑
" ────────────────────────────────────────────
"
"   font-relative                     …to…
" ─────── ⭤ ╶────────── ⭤ ╶───────────────────
"   A⭥    0⭥    ⭥   x⭥  水⭥    ̲̅⭥︎
" ────────────────────────────────────────────
"   𝚌𝚊𝚙   𝚌𝚑   𝚎𝚖   𝚎𝚡   𝚒𝚌   𝚕𝚑   
"   cap   ch   em   ex   ic   lh    (local)
"  rcap  rch  rem  rex  ric  rlh    (root)
"  𝚛𝚌𝚊𝚙  𝚛𝚌𝚑  𝚛𝚎𝚖  𝚛𝚎𝚡  𝚛𝚒𝚌  𝚛𝚕𝚑  
" ────────────────────────────────────────────
"
"   viewport-percentage
" ────────────────────────────────────────────
"         larger…╷…smaller side
" block╷inline   │    width…╷…height  …of…
" ─────│─────────│──────────│─────────────────
"    vb│vi   vmax│vmin   vw │ vh    v̲iewport
"      │         │      dvw │ dvh   d̲ynamic
"      │         │      lvw │ lvh   l̲arge
"      │         │      svw │ svh   s̲mall
"   cqb│cqi cqmax│cqmin cqw │ cqh   c̲ontainer
" ────────────────────────────────────────────
"

syn match cssAttrOp "[~|^$*]\?=" contained
syn region cssAttributeSelector
      \ matchgroup=cssAttrParens start="\["
      \ end="]"
      \ contains=cssUnicodeEscape,cssAttrOp,cssStringQ,cssStringQQ

syn match cssIdHash '#' contained containedin=cssIdentifier contains=NONE

" Seps & noise
syn match cssUrlSeps /[:;,]/ contained contains=NONE

" Combinators
" syn match cssCombinator

" More @rules
syn match cssAtKeyword /@\(property\|layer\)/

" @property
syn match cssSyntaxType contained +\%(<angle>\|<color>\|<custom-ident>\|<image>\|<integer>\|<length>\|<length-percentage>\|<number>\|<percentage>\|<resolution>\|<string>\|<time>\|<transform-function>\|<transform-list>\|<url>\)+
syn keyword cssPropertyProp contained syntax inherits initial-value
syn keyword cssPropertyAttr contained true false
syn match cssPropertyAttr contained /\<\>/
syn region cssAtRule
      \ matchgroup=cssAtKeyword 
      \ start=+@property\>+
      \ end=+\ze{+
      \ skipwhite skipnl nextgroup=cssAtPropertyDef
      \ contains=cssVarCustomProp,cssCustomProp,cssComment
syn region cssAtPropertyDef transparent fold contained
      \ matchgroup=cssBraces start=+{+ end=+}+
      \ contains=cssPropertyProp,cssPropertyAttr,cssPropertySyntax,cssComment,cssValue.*,cssColor,cssURL,cssCustomProp,cssError,cssStringQ,cssStringQQ,cssFunction,cssUnicodeEscape,cssNoise
syn region cssPropertySyntax contained
      \ start=+\z("\|'\)+ end=+\z1+
      \ contains=cssSyntaxType

hi def link cssPropertySyntax String
hi def link cssSyntaxType Type
hi def link cssPropertyAttr Keyword
hi def link cssPropertyProp PreProc

" @layer
syn region cssAtRule matchgroup=cssAtKeyword
      \ start=+@layer\>+ end=+\ze{+
      \ skipwhite skipnl
      \ contains=cssMediaProp,cssValueLength,cssAtRuleLogical,cssValueInteger,cssMediaAttr,cssVendor,cssMediaType,cssComment,cssCustomProp,cssFunctionName
      \ nextgroup=cssDefinition

"{{{1 SVG in CSS url()
"
syn match cssUrlSvgTagN !\(%3[cC]/\?\)\@3<=[-a-zA-Z0-9]\+!
      \ contained transparent
      \ contains=cssUrlSvgTagName

syn keyword cssUrlSvgTagName contained a altGlyph altGlyphDef altGlyphItem animate 
syn keyword cssUrlSvgTagName contained animateColor animateMotion animateTransform animation
syn keyword cssUrlSvgTagName contained audio canvas circle clipPath color-profile cursor
syn keyword cssUrlSvgTagName contained defs desc discard ellipse
syn keyword cssUrlSvgTagName contained feBlend feColorMatrix feComponentTransfer feComposite
syn keyword cssUrlSvgTagName contained feConvolveMatrix feDiffuseLighting feDisplacementMap
syn keyword cssUrlSvgTagName contained feDistantLight feDropShadow feFlood feFuncA feFuncB
syn keyword cssUrlSvgTagName contained feFuncG feFuncR feGaussianBlur feImage feMerge
syn keyword cssUrlSvgTagName contained feMergeNode feMorphology feOffset fePointLight
syn keyword cssUrlSvgTagName contained feSpecularLighting feSpotLight feTile feTurbulence
syn keyword cssUrlSvgTagName contained filter font font-face font-face-format font-face-name
syn keyword cssUrlSvgTagName contained font-face-src font-face-uri foreignObject g
syn keyword cssUrlSvgTagName contained glyph glyphRef handler hkern iframe image line
syn keyword cssUrlSvgTagName contained linearGradient listener marker mask metadata
syn keyword cssUrlSvgTagName contained missing-glyph mpath path pattern polygon polyline
syn keyword cssUrlSvgTagName contained prefetch radialGradient rect script set solidColor
syn keyword cssUrlSvgTagName contained stop style svg switch symbol text textArea textPath
syn keyword cssUrlSvgTagName contained title tref tspan unknown use video view vkern

syn region cssUrlFunction contained 
      \ matchgroup=cssUrlFnName start=+\<\(url\)\ze(\z("\|'\)+
      \ end=+\z1)+
      \ keepend containedin=cssAttrRegion
      \ contains=cssUrlFunctionParens

syn region cssUrlFunctionParens contained
      \ matchgroup=cssUrlParen start=+(\ze\z("\|'\)+
      \ end=+\z1\zs)+
      \ contains=cssUrlFunctionString
syn region cssUrlFunctionString contained
      \ start=+\z("\|'\)+
      \ end=+\z1+
      \ contains=cssUrlPrefix,cssUrlMimeType,cssUrlSvgComment,cssUrlSvgTag,cssUrlSvgEndTag,cssUrl64Data,cssUrlSeps,cssLineCont,cssPer0A
" dataurl preamble
" url('data:image/svg+xml,
syn match cssUrlPrefix +data+ contained
      \ contains=cssLineCont
      \ skipwhite skipnl nextgroup=cssUrlMimeType
syn region cssUrlMimeType contained keepend
      \ start=+:+
      \ end=+,+
      \ end=+;+
      \ contains=cssUrlSeps,cssLineCont
      \ skipwhite skipnl nextgroup=cssUrl64Data,cssUrlSvgTag

" Base64 encoded data
" syn match cssUrl64Token !base64,\zs[A-Za-z0-9/+]\+=!
syn region cssUrl64Data contained keepend
      \ matchgroup=cssUrl64Token start=+base64,+
      \ matchgroup=NONE end=!=\+! end=!\ze'! end=!\ze"! end=!\ze)!
      \ fold
      \ cchar=*
      \ contains=cssUrl64Invalid,cssUrlSeps,cssLineCont

syn match cssUrl64Invalid contained !^\s*\zs[^A-Za-z0-9/+=]\+!


syn region cssUrlSvgTag contained keepend
      \ start=+%3[cC]+
      \ end=+%3[eE]+
      \ contains=cssUrlSvgValue,cssUrlSvgTagN,cssUrlSvgPath,cssUrlSvgXmlns,cssUrlSvgAttr,cssUrlSvgAttrSep,cssPerTag,cssLineCont
syn region cssUrlSvgEndTag contained keepend
      \ start=+%3[cC]/+
      \ end=+%3[eE]+
      \ contains=cssUrlSvgTagN,cssPerTag,cssLineCont

syn region cssUrlSvgComment contained keepend
      \ start=+%3[cC]!--[!]\?+
      \ end=+--[!]\?%3[eE]+
      \ contains=@Spell,cssPerTag,cssLineCont

syn match cssUrlSvgAttr +\zs\<[a-zA-Z:_][-.0-9a-zA-Z:_]*\>\ze=+ contained
      \ contains=cssUrlSvgAttrSep,cssLineCont,cssPer

syn region cssUrlSvgPath contained keepend
      \ start=+d=%22+
      \ end=+%22+
      \ contains=cssUrlSvgAttr,pathClose,
      \ pathMoveAbs,pathMoveRel,
      \ pathLineAbs,pathLineRel,
      \ pathHLineAbs,pathHLineRel,
      \ pathVLineAbs,pathVLineRel,
      \ pathCubicAbs,pathCubicRel,
      \ pathCubi2Abs,pathCubi2Rel,
      \ pathQuadAbs,pathQuadRel,
      \ pathQuad2Abs,pathQuad2Rel,
      \ pathEllipAbs,pathEllipRel,
      \ cssUrlSeps,cssPer22,cssLineCont,cssPer

syn region cssUrlSvgXmlns contained keepend
      \ start=+xmlns=%22+
      \ end=+%22+
      \ contains=cssUrlSvgAttr,cssUrlSvgAttrSep,cssLineCont,cssPer22,cssPer

syn region cssUrlSvgValue contained keepend
      \ start=+%22+
      \ end=+%22+
      \ contains=cssPer22,cssPer

syn case match

syn match pathClose +[zZ]+ contained

syn region pathMoveAbs  start=+M+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam
syn region pathMoveRel  start=+m+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam

syn region pathLineAbs  start=+L+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam
syn region pathLineRel  start=+l+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam

syn region pathHLineAbs start=+H+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam
syn region pathHLineRel start=+h+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam

syn region pathVLineAbs start=+V+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam
syn region pathVLineRel start=+v+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam

syn region pathCubicAbs start=+C+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam
syn region pathCubicRel start=+c+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam
syn region pathCubi2Abs start=+S+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam
syn region pathCubi2Rel start=+s+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam

syn region pathQuadAbs  start=+Q+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam
syn region pathQuadRel  start=+q+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam
syn region pathQuad2Abs start=+T+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam
syn region pathQuad2Rel start=+t+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam

syn region pathEllipAbs start=+A+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam
syn region pathEllipRel start=+a+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam

syn match svgPathParam +[0-9. -]\{1,}+ transparent contained contains=NONE

syn case ignore

syn match cssUrlSvgAttrSep /=/ contained contains=NONE
"}}}1

"{{{1 Concealing
"
syn match cssLineCont /\\$/ conceal cchar=╲ contained contains=NONE
      \ containedin=cssDefinition,cssStringQ,cssStringQQ

" Concealing - percent encoded chars
"
syn match cssPer0A /%0[aA]/ conceal cchar=⮐  contained contains=NONE containedin=cssStringQ,cssStringQQ
syn match cssPer /%20/    conceal cchar=␣ contained contains=NONE
syn match cssPer /%21/    conceal cchar=! contained contains=NONE
syn match cssPer22 /%22/  conceal cchar=" contained contains=NONE
syn match cssPer /%23/    conceal cchar=# contained contains=NONE
syn match cssPer /%24/    conceal cchar=$ contained contains=NONE
syn match cssPer /%25/    conceal cchar=% contained contains=NONE
syn match cssPer /%26/    conceal cchar=& contained contains=NONE
syn match cssPer /%27/    conceal cchar=' contained contains=NONE
syn match cssPer /%28/    conceal cchar=( contained contains=NONE
syn match cssPer /%29/    conceal cchar=) contained contains=NONE
syn match cssPer /%2[aA]/ conceal cchar=* contained contains=NONE
syn match cssPer /%2[bB]/ conceal cchar=+ contained contains=NONE
syn match cssPer /%2[cC]/ conceal cchar=, contained contains=NONE
syn match cssPer /%2[dD]/ conceal cchar=- contained contains=NONE
syn match cssPer /%2[eE]/ conceal cchar=. contained contains=NONE
syn match cssPer /%2[fF]/ conceal cchar=/ contained contains=NONE
syn match cssPer /%3[aA]/ conceal cchar=: contained contains=NONE
syn match cssPer /%3[bB]/ conceal cchar=; contained contains=NONE
syn match cssPerTag /%3[cC]/ conceal cchar=< contained contains=NONE
syn match cssPer /%3[dD]/ conceal cchar== contained contains=NONE
syn match cssPerTag /%3[eE]/ conceal cchar=> contained contains=NONE
syn match cssPer /%3[fF]/ conceal cchar=? contained contains=NONE
syn match cssPer /%40/    conceal cchar=@ contained contains=NONE
syn match cssPer /%5[bB]/ conceal cchar=[ contained contains=NONE
syn match cssPer /%5[cC]/ conceal cchar=\ contained contains=NONE
syn match cssPer /%5[dD]/ conceal cchar=] contained contains=NONE
syn match cssPer /%5[eE]/ conceal cchar=^ contained contains=NONE
syn match cssPer /%5[fF]/ conceal cchar=_ contained contains=NONE

" Concealing - frivolous
"𖭰 𖭱 𖢈𖦝𖦡𐙘 𐙫 𐙪 𐊁 ﾛﾖﾘ ﾧﾡﾤ
"
" 𖫓 𖫙 𖫛 𖫬 𖫢 𖫡 𖫠 𖫑 𖫧 𖨬 𖨕  𑜀 𐭱 𐭡 𐭢𐭧 𐤒 𐤂𐤋𐤋 𐣢𐣼𐣽𐣿 𐣴 𐤿 
" ＤＤＥＦｅｉｊ｝ｦｕｕｅｅｅｅ｀;ﾪ   ∅ ⦰ ⦳ 
call setcellwidths([[char2nr('﹐'),char2nr('﹫'),1]])
syn match cssUnitConc /%/ conceal cchar=﹪ transparent contained containedin=cssUnitDecorators contains=NONE
syn match cssUnitConc /deg/ conceal cchar=° transparent contained containedin=cssUnitDecorators contains=NONE
syn match cssUnitConc /mm/ conceal cchar=㎜ transparent contained containedin=cssUnitDecorators contains=NONE
syn match cssUnitConc /cm/ conceal cchar=㎝ transparent contained containedin=cssUnitDecorators contains=NONE
syn match cssUnitConc /ms/ conceal cchar=㎳ transparent contained containedin=cssUnitDecorators contains=NONE
syn match cssUnitConc /p\zex/ conceal cchar=𝚙 transparent contained containedin=cssUnitDecorators contains=NONE nextgroup=cssUnitPx1
syn match cssUnitConc /p\@1<=x/ conceal cchar=𝚡 transparent contained containedin=cssUnitDecorators contains=NONE

syn match cssUnitConc +p\ze\%(x\|c\|t\)+ conceal cchar=𝚙 transparent contained containedin=cssUnitDecorators contains=NONE nextgroup=cssUnitConc
syn match cssUnitConc /p\@1<=x/ conceal cchar=𝚡 transparent contained containedin=cssUnitDecorators contains=NONE nextgroup=cssUnitConc
syn match cssUnitConc /p\@1<=c/ conceal cchar=𝚌 transparent contained containedin=cssUnitDecorators contains=NONE nextgroup=cssUnitConc
syn match cssUnitConc /p\@1<=t/ conceal cchar=𝚝 transparent contained containedin=cssUnitDecorators contains=NONE nextgroup=cssUnitConc

syn match preProcComment +\zs/\*\s*prettier-ignore\s*\*/\ze+

"}}}1


"{{{1 Define colours
"
hi link cssAttributeSelector Type
hi link cssClassNameDot Statement
hi def link cssAttrParens Statement
hi def link cssAttrOp cssSelectorOp2
hi def link cssIdHash Statement
"
hi def link cssUrlFnName cssFunctionName
hi def link cssUrlParen  cssFunctionName
hi def cssUrlPrefix      guifg=#cc77ee
hi def cssUrlMimeType    guifg=#ff99ff
hi def cssUrlSeps        guifg=#ddcc44
hi def cssUrlSvgAttrSep  guifg=#ff00ff
hi def cssUrl64Token     guifg=#cc5533
hi def link cssUrl64Data Conceal
hi def cssUrl64Invalid   guibg=#ff0000
hi def cssUrlSvgTag      guifg=#1199dd
hi def cssUrlSvgEndTag   guifg=#1199dd
hi def cssUrlSvgTagName  guifg=#999900


hi def link cssUrlSvgValue String 
hi def link cssUrlSvgAttr Type
hi def link cssUrlSvgTagError htmlCommentError
hi def link cssUrlSvgComment htmlComment
hi def link cssUrlSvgXmlns htmlComment
hi def preProcComment guifg=#212121

hi def pathClose    guifg=#ffaa00 guibg=NONE gui=bold
hi def pathMoveAbs  guifg=#009900 gui=bold guisp=#4444ee
hi def pathMoveRel  guifg=#009900
hi def pathLineAbs  guifg=#9900cc gui=bold guisp=#eeeeee
hi def pathLineRel  guifg=#9900cc
hi def pathHLineAbs guifg=#0066aa gui=bold guisp=#eeeeee
hi def pathHLineRel guifg=#0066aa
hi def pathVLineAbs guifg=#bb0077 gui=bold guisp=#eeeeee
hi def pathVLineRel guifg=#aa0066
hi def pathCubicAbs guifg=#8800ff gui=bold guisp=#44eeee
hi def pathCubicRel guifg=#8800ff
hi def pathCubi2Abs guifg=#8855ff
hi def pathCubi2Rel guifg=#8855ff
hi def pathQuadAbs  guifg=#664488 gui=bold guisp=#eeeeee
hi def pathQuadRel  guifg=#664488
hi def pathQuad2Abs guifg=#665588 gui=bold guisp=#eeeeee
hi def pathQuad2Rel guifg=#665588
hi def pathEllipAbs guifg=#aa6666 gui=bold guisp=#eeeeee
hi def pathEllipRel guifg=#aa6666
hi def svgPathParam guifg=NONE


hi def link cssLineCont Conceal
hi def link cssPer0A cssPerEnc
hi def link cssPer cssPerEnc
hi def link cssPer22 cssPerEnc
hi def link cssPerTag cssPerEnc
hi def link cssPerEnc Conceal

" vim: nowrap sw=2 sts=2 ts=8 et fdm=marker:

