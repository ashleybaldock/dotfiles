
" Remove oneline
" syn region cssURL contained
"       \ matchgroup=cssFunctionName
"       \ start="\<\(uri\|url\|local\|format\)\s*("
"       \ end=")"
"       \ contained
"       \ contains=cssStringQ,cssStringQQ

      " \ conceal cchar=╌
syn match cssVarDashes /--/ contained contains=NONE conceal transparent
syn match cssVarCustomProp contained "--\%([a-zA-Z0-9-_]\|[^\x00-\x7F]\)*\Z"
      \ contained contains=cssVarDashes
syn match cssCustomPropDashes /--/
      \ contained contains=NONE transparent
      \ conceal cchar=╌
      \ containedin=cssCustomProp
syn match cssCustomProp contained "--\%([a-zA-Z0-9-_]\|[^\x00-\x7F]\)*\Z"

syn keyword cssFunctionNameVar contained conceal cchar=𐐏 var
syn region cssFunctionVar
      \ matchgroup=cssVarParens
      \ start="\<var\s*("ms=s+3,hs=e
      \ end=")"me=e
      \ contained oneline
      \ containedin=cssDefinition,cssAttrRegion,cssAtRule,cssFunction
      \ contains=cssFunctionNameVar,cssVarCustomProp,cssFunctionVar,cssValue.*,cssFunction,cssColor,cssStringQ,cssStringQQ
      " \ contains=cssFunctionNameVar,cssVarParens
" syn region cssVarParens
"       \ start="("
"       \ end=")"me=e-1,he=e+2
"       \ contained oneline
"       \ contains=cssVarCustomProp,cssFunctionVar,cssValue.*,cssFunction,cssColor,cssStringQ,cssStringQQ

hi def link cssFunctionNameVar Conceal
hi def link cssVarCustomProp cssCustomProp
hi def link cssVarParens Conceal

syn match cssUrlSeps /[:;,]/ contained contains=NONE

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

syn region cssUrlFunction
      \ matchgroup=cssUrlFnName
      \ start=+\<\(url\)\ze(\z("\|'\)+
      \ end=+\z1)+
      \ keepend
      \ contained
      \ containedin=cssAttrRegion
      \ contains=cssUrlFunctionParens

syn region cssUrlFunctionParens
      \ matchgroup=cssUrlParen
      \ start=+(\ze\z("\|'\)+
      \ end=+\z1\zs)+
      \ contained
      \ contains=cssUrlFunctionString
syn region cssUrlFunctionString
      \ start=+\z("\|'\)+
      \ end=+\z1+
      \ contained
      \ contains=cssUrlPrefix,cssUrlMimeType,
      \ cssUrlSvgComment,
      \ cssUrlSvgTag,cssUrlSvgEndTag,
      \ cssUrl64Data,cssUrlSeps,
      \ cssLineCont,cssPer0A
" dataurl preamble
syn match cssUrlPrefix +data+
      \ contained
      \ contains=cssLineCont
      \ nextgroup=cssUrlMimeType
      \ skipwhite skipnl
" syn region cssUrlMimeType !:[A-Za-z/+]\+\ze[;,]!
syn region cssUrlMimeType
      \ start=+:+
      \ end=+,+
      \ end=+;+
      \ contained
      \ keepend
      \ contains=cssUrlSeps,cssLineCont
      \ nextgroup=cssUrl64Data,cssUrlSvgTag
      \ skipwhite skipnl

" Base64 encoded data
" syn match cssUrl64Token !base64,\zs[A-Za-z0-9/+]\+=!
syn region cssUrl64Data 
      \ matchgroup=cssUrl64Token
      \ start=+base64,+
      \ matchgroup=NONE
      \ end=!=\+!
      \ end=!\ze'!
      \ end=!\ze"!
      \ end=!\ze)!
      \ keepend
      \ fold
      \ cchar=*
      \ contained
      \ contains=cssUrlSeps,cssLineCont

syn region cssUrlSvgTag
      \ start=+%3[cC]+
      \ end=+%3[eE]+
      \ keepend
      \ contained
      \ contains=cssUrlSvgValue,cssUrlSvgTagN,
      \ cssUrlSvgPath,cssUrlSvgXmlns,cssUrlSvgAttr,
      \ cssUrlSvgAttrSep,cssPerTag,cssLineCont
syn region cssUrlSvgEndTag
      \ start=+%3[cC]/+
      \ end=+%3[eE]+
      \ keepend
      \ contained
      \ contains=cssUrlSvgTagN,cssPerTag,cssLineCont

syn region cssUrlSvgComment
      \ start=+%3[cC]!--[!]\?+
      \ end=+--[!]\?%3[eE]+
      \ keepend
      \ contained
      \ contains=@Spell,cssPerTag,cssLineCont

syn match cssUrlSvgAttr +\zs\<[a-zA-Z:_][-.0-9a-zA-Z:_]*\>\ze=+
      \ contained
      \ contains=cssUrlSvgAttrSep,cssLineCont,cssPer

syn region cssUrlSvgPath
      \ start=+d=%22+
      \ end=+%22+
      \ keepend
      \ contained
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

syn region cssUrlSvgXmlns
      \ start=+xmlns=%22+
      \ end=+%22+
      \ keepend
      \ contained
      \ contains=cssUrlSvgAttr,cssUrlSvgAttrSep,
      \ cssLineCont,cssPer22,cssPer

syn region cssUrlSvgValue
      \ start=+%22+
      \ end=+%22+
      \ keepend
      \ contained
      \ contains=cssPer22,cssPer

syn case match

syn match pathClose +[zZ]+ contained

syn region pathMoveAbs
      \ start=+M+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam
syn region pathMoveRel
      \ start=+m+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam

syn region pathLineAbs
      \ start=+L+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam
syn region pathLineRel
      \ start=+l+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam

syn region pathHLineAbs
      \ start=+H+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam
syn region pathHLineRel
      \ start=+h+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam

syn region pathVLineAbs
      \ start=+V+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam
syn region pathVLineRel
      \ start=+v+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam

syn region pathCubicAbs
      \ start=+C+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam
syn region pathCubicRel
      \ start=+c+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam
syn region pathCubi2Abs
      \ start=+S+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam
syn region pathCubi2Abs
      \ start=+s+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam

syn region pathQuadAbs
      \ start=+Q+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam
syn region pathQuadRel
      \ start=+q+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam
syn region pathQuad2Abs
      \ start=+T+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam
syn region pathQuad2Rel
      \ start=+t+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam

syn region pathEllipAbs
      \ start=+A+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam
syn region pathEllipRel
      \ start=+a+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+
      \ oneline contained contains=svgPathParam

syn match svgPathParam +[0-9. -]\{1,}+ transparent
      \ contained contains=NONE

syn case ignore

" syn match cssUrlSvgTagN +\/\?%3[cC]\zs[-a-zA-Z0-9]\++

syn match cssUrlSvgAttrSep /=/ contained contains=NONE

syn match cssLineCont /\\$/ conceal cchar=╲ contained contains=NONE
      \ containedin=cssDefinition,cssStringQ,cssStringQQ

syn match cssPer0A /%0[aA]/ conceal cchar=⮐  contained contains=NONE
      \ containedin=cssStringQ,cssStringQQ

syn match cssPer /%20/    conceal cchar=␣ contained contains=NONE
syn match cssPer /%21/    conceal cchar=! contained contains=NONE
syn match cssPer22 /%22/    conceal cchar=" contained contains=NONE
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


hi def link cssUrlFnName cssFunctionName
hi def link cssUrlParen  cssFunctionName
" hi def link cssUrlPre    PreProc
hi def cssUrlPrefix      guifg=#cc77ee
hi def cssUrlMimeType    guifg=#ff99ff
hi def cssUrlSeps        guifg=#ddcc44
hi def cssUrlSvgAttrSep  guifg=#ff00ff
hi def cssUrl64Token     guifg=#aa0033
hi def link cssUrl64Data Conceal
hi def cssUrlSvgTag      guifg=#1199dd
hi def cssUrlSvgEndTag   guifg=#1199dd
hi def cssUrlSvgTagName  guifg=#999900

hi def link cssUrlSvgValue String 
hi def link cssUrlSvgAttr Type
hi def link cssUrlSvgTagError htmlCommentError
hi def link cssUrlSvgComment htmlComment
hi def link cssUrlSvgXmlns htmlComment

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

