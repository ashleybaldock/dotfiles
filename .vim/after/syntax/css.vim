
"{{{
" syn region cssUrlSvg  start=+%3[cC]svg+  end=+%3[cC]/svg%3[eE]+  contains=@htmlXml transparent keepend

" syn region cssUrlSvgTag
"       \ start=+%3[cC][^/]+
"       \ end=+%3[eE]+
"       \ contains=cssUrlSvgTagName,cssUrlSvgAttrName,cssUrlSeps,
"       \  cssUrlSvgAttrValue,cssPer3C,cssPer3E

" syn region cssUrlSvgEndTag
"       \ start=+%3[cC]/+
"       \ end=+%3[eE]+
"       \ contains=cssUrlSvgTagName,cssPer3C,cssPer3E

" syn region cssUrlSvgAttrValueEQ
"       \ start=+=\zs%22+
"       \ end=+%22+
"       \ contained
" syn region cssUrlSvgAttrValueSQ
"       \ start=+='+
"       \ end=+'+
"       \ contained
      " \ contains=cssUrlHeader,cssPerEnc,cssUrlSvgTag,cssUrlSvgTagBracket,cssUrlSvgEndTag
" syn region cssUrlHeader
"       \ start="\zedata:"
"       \ end=+,+
"       \ contained
"       \ contains=NONE
      " \ contains=cssUrlScheme,cssUrlMediaType,cssUrlBase64,cssUrlSeps
" syn region cssUrlSvgPQ
"       \ start=^\zs%22\zedata:image/svg+xml\(;[^,]\*\)\*,^
"       \ end=+%22+
"       \ contained
"       \ extend
"       \ containedin=cssUrl
"       \ contains=cssUrlHeader,cssPerEnc,cssUrlSvgTag,cssUrlSvgTagBracket,cssUrlSvgEndTag
" syn match cssUrlSvgTagName
"     \ /\(%3[cC]\/\|%3[cC]\)\zs[a-zA-Z:_][-.0-9a-zA-Z:_]*\ze\(\s\|%3[eE]\)/
"     \ contains=NONE
"     \ contained

" syn region cssUrlSvgDQ
"       \ start=^\zs"\zedata:image/svg+xml\(;[^,]\*\)\*,^
"       \ end=+"+
"       \ contained
"       \ extend
" syn region cssUrlSvgSQ
"       \ start=^\zs'\zedata:image/svg+xml\(;\_[^,]\*\)\*,^
"       \ end=+'+
"       \ contained
"       \ extend
"       \ contains=cssUrlScheme,cssUrlMediaType,cssUrlBase64,cssUrlSvgTag,cssUrlSvgEndTag,cssUrlSeps

" syn region cssUrlQ
"       \ matchgroup=cssUrlFunctionName
"       \ start=+\zs\<\(url\)\s*\ze('\ze+
"       \ end=+'\zs)+
"       \ contained
"       \ containedin=cssAttrRegion
"       \ contains=cssUrlScheme,cssUrlMediaType,
"       \  cssUrlSvgTag,cssUrlSvgEndTag,cssUrlSeps

" syn region cssUrlQQ
"       \ matchgroup=cssUrlFunctionName
"       \ start=+\<\(url\)\s*(\ze"data:+
"       \ end=+"\zs)+
"       \ keepend
"       \ contained
"       \ containedin=cssAttrRegion
"       \ contains=cssUrlFunctionName,cssUrlScheme,cssUrlMediaType,
"       \  cssUrlSvgTag,cssUrlSvgEndTag,cssUrlSeps
"       }}}



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
      \ matchgroup=cssUrlFunctionStart
      \ start=+\<\(url\)(\z("\|'\|%22\)+
      \ matchgroup=cssUrlFunctionEnd
      \ end=+\z1)+
      \ keepend
      \ contained
      \ containedin=cssAttrRegion
      \ contains=cssUrlPreamble,cssUrlFunctionName,cssUrlScheme,cssUrlMediaType,
      \  cssUrlSvgTag,cssUrlSvgEndTag,cssUrlSeps,cssLineContinues

syn region cssUrlPreamble
      \ matchGroup=cssUrlPreamble
      \ start=+data:+
      \ end=+,+
      \ contained
      \ contains=cssUrlScheme,cssUrlMediaType,cssUrlSeps,cssLineContinues
syn match cssUrlScheme +data\ze:+
      \ contained
      \ contains=NONE
syn match cssUrlMediaType /:\zs[^:(,]\+\(;[^,]\+\)*\ze,/
      \ contained
      \ contains=cssUrlBase64,cssUrlSeps,cssLineContinues
syn match cssUrlBase64 /;\zsbase64\ze,/
      \ contained
      \ contains=NONE
syn match cssUrlSeps /[:;,]/
      \ contained contains=NONE display

syn match cssUrlFunctionName +\<\(url\)\ze\s*(['"]\?data:+
      \ contained

syn region cssUrlSvgString
      \ start=+%23+
      \ end=+%23+
      \ contained
      \ contains=cssUrlSvgSpecialChar

syn match cssUrlSvgAttr +\zs\<[a-zA-Z:_][-.0-9a-zA-Z:_]*\>\ze=+
      \ contained
      \ contains=NONE

" syn match cssUrlSvgValue contained "=[\t ]*[^'" \t>][^ \t>]*"hs=s+1 contains=@cssUrlSvgPreproc
syn region cssUrlSvgValue
      \ start=+=\zs\z\("\|'\|%22\)+
      \ end=+\z1+
      \ contained
      \ keepend
      \ contains=cssUrlSvgPath

syn region cssUrlSvgEndTag
      \ start=+%3[cC]/+
      \ end=+%3[eE]+
      \ keepend
      \ contained
      \ contains=cssUrlSvgTagN,cssUrlSvgTagError,cssPer3C,cssPer3E

syn region cssUrlSvgTag
      \ start=+%3[cC][^/]+
      \ end=+%3[eE]+
      \ keepend
      \ contained
      \ contains=cssUrlSvgTagN,cssUrlSvgString,cssUrlSvgAttr,
      \ cssUrlSvgValue,cssUrlSvgTagError,cssPer3C,cssPer3E

syn match cssUrlSvgTagN +%3[cC]\s*[-a-zA-Z0-9]\++hs=s+1
      \ contained
      \ contains=cssUrlSvgTagName

syn match cssUrlSvgTagN +%3[cC]/\s*[-a-zA-Z0-9]\++hs=s+2
      \ contained
      \ contains=cssUrlSvgTagName

syn match cssUrlSvgTagError +\%(%3[eE]\)\@3<!%3[cC]+ms=s+1
      \ contained 


syn region cssUrlSvgPath
      \ start=+path=\zs\z\("\|'\|%22\)+
      \ end=+\z1+
      \ keepend
      \ contained
      \ contains=pathAbsMove,pathRelMove,pathClose,
      \ pathLineAbs,pathLineRel,pathHLineAbs,pathHLineRel,
      \ pathVLineAbs,pathVLineRel,
      \ pathCubicAbs,pathCubicRel,pathCubic2Abs,pathCubic2Rel,
      \ pathQuadAbs,pathQuadRel,pathQuad2Abs,pathQuad2Rel,
      \ pathEllipticalAbs,pathEllipticalRel,
      \ cssLineContinues

syn region svgPathCmdM
      \ matchGroup=svgPathCmdM
      \ start=+M+
      \ end=+\ze[MZVHLCSQTAmzvhlcsqta]+
      \ contained
      \ contains=svgPathCmdParam,cssLineContinues

syn match svgPathCmdParam +[0-9. -]\{1,}+

" syn match pathAbsMove /M\d*\.\?\d\+ \d


syn match cssLineContinues /\\$/ conceal cchar=╲
      \ contained
      \ contains=NONE
      \ containedin=cssUrlSvg,cssUrlSvgTag,cssUrlSvgEndTag,cssDefinition,cssStringQ,cssStringQQ

syn region cssUrlSvgComment start=+%3[cC]!--+	end=+--[!]\?%3[eE]+	contains=@Spell

syn match cssUrlSvgSpecialChar "&#\=[0-9A-Za-z]\{1,8};"
syn match cssPer0A /%0A/ conceal cchar=⮐ 
      \ contained contains=NONE
      \ containedin=cssUrlSvg,cssUrlSvgTag,cssUrlSvgEndTag,cssStringQ,cssStringQQ

syn match cssPer22 /%22/ conceal cchar="
      \ contained contains=NONE
      \ containedin=cssUrlSvg,cssUrlSvgTag,cssUrlSvgEndTag,cssStringQ,cssStringQQ

syn match cssPer23 /%23/ conceal cchar=#
      \ contained contains=NONE
      \ containedin=cssUrlSvg,cssUrlSvgTag,cssUrlSvgEndTag,cssStringQ,cssStringQQ

syn match cssPer3C /%3[cC]/ conceal cchar=<
      \ contained contains=NONE
      \ containedin=cssUrlSvg,cssUrlSvgTag,cssUrlSvgEndTag,cssStringQ,cssStringQQ

syn match cssPer3E /%3[eE]/ conceal cchar=>
      \ contained contains=NONE
      \ containedin=cssUrlSvg,cssUrlSvgTag,cssUrlSvgEndTag,cssStringQ,cssStringQQ


hi def link cssUrlFunction Statement
hi def cssUrlFunctionName guifg=#0544ff
hi def link cssUrlPreamble PreProc
hi def cssUrlScheme guifg=#0044cc
hi def cssUrlMediaType guifg=#0066aa
hi def cssUrlBase64 guifg=#aa0033
hi def cssUrlSeps guifg=#ddcc44
hi def link cssUrlSvgValue String 
hi def link cssUrlSvgAttr Type
hi def link cssUrlSvgString String
hi def cssUrlSvgTag guifg=#1199dd
hi def cssUrlSvgEndTag guifg=#1199ff
hi def cssUrlSvgTagName guifg=#999900
hi def link cssUrlSvgTagN cssUrlSvgTagName
hi def link cssUrlSvgTagError htmlCommentError
hi def link cssUrlSvgSpecialChar Special
hi def link cssUrlSvgComment htmlComment


hi def cssLineContinues guifg=#0022aa
hi def link cssPer0A cssPerEnc
hi def link cssPer22 cssPerEnc
hi def link cssPer23 cssPerEnc
hi def link cssPer3C cssPerEnc
hi def link cssPer3E cssPerEnc
hi def link cssPerEnc Conceal

" vim: nowrap sw=2 sts=2 ts=8 et fdm=marker:
