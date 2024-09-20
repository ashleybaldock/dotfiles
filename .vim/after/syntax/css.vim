
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

syn region cssUrlQ
      \ matchgroup=cssUrlFunctionName
      \ start="\<\(url\)\s*(\ze'data:"
      \ end="'\zs)"
      \ contained
      \ containedin=cssAttrRegion
      \ contains=cssUrlScheme,cssUrlMediaType,
      \  cssUrlSvgTag,cssUrlSvgEndTag,cssUrlSeps

syn region cssUrlQQ
      \ matchgroup=cssUrlFunctionName
      \ start=+\<\(url\)\s*(\ze"data:+
      \ end=+"\zs)+
      \ contained
      \ containedin=cssAttrRegion
      \ contains=cssUrlScheme,cssUrlMediaType,
      \  cssUrlSvgTag,cssUrlSvgEndTag,cssUrlSeps

syn match cssUrlScheme /data\ze:/
      \ contained contains=NONE
      \ nextgroup=cssUrlMediaType
syn match cssUrlMediaType /:\zs[^:(,]\+\(;[^,]\+\)*\ze,/
      \ contained contains=cssUrlBase64
syn match cssUrlBase64 /;\zsbase64\ze,/
      \ contained contains=NONE
syn match cssUrlSeps /[:;,]/
      \ contained contains=NONE display

syn region cssUrlSvgTag
      \ start=+%3[cC][^/]+
      \ end=+%3[eE]+
      \ contained
      \ contains=cssUrlSvgTagName,cssUrlSvgAttrName,cssUrlSeps,
      \  cssUrlSvgAttrValue,cssPer3C,cssPer3E

syn region cssUrlSvgEndTag
      \ start=+%3[cC]/+
      \ end=+%3[eE]+
      \ contained
      \ contains=cssUrlSvgTagName,cssPer3C,cssPer3E

syn match cssUrlSvgAttrName +\zs\<[a-zA-Z:_][-.0-9a-zA-Z:_]*\>\ze=+
      \ contains=NONE
      \ contained
      \ nextgroup=cssUrlSvgAttrValue

syn region cssUrlSvgAttrValue
      \ start=+=\zs\z\("\|'\|%22\)+
      \ end=+\z1+
      \ contained
" syn region cssUrlSvgAttrValueEQ
"       \ start=+=\zs%22+
"       \ end=+%22+
"       \ contained
" syn region cssUrlSvgAttrValueSQ
"       \ start=+='+
"       \ end=+'+
"       \ contained

syn match cssLineContinues /\\$/ conceal cchar=╲
      \ contained contains=NONE
      \ containedin=cssUrlQ,cssUrlQQ,cssDefinition,cssUrl,cssStringQ,cssStringQQ

syn match cssPer22 /%22/
      \ contained contains=NONE
      \ containedin=cssUrlQ,cssUrlQQ,cssUrl,cssStringQ,cssStringQQ
      \ conceal cchar="
syn match cssPer23 /%23/ conceal cchar=#
      \ contained contains=NONE
      \ containedin=cssUrlQ,cssUrlQQ,cssUrl,cssStringQ,cssStringQQ
syn match cssPer3C /%3[cC]/ conceal cchar=<
      \ contained contains=NONE
      \ containedin=cssUrlQ,cssUrlQQ,cssUrl,cssUrlSvgTag,cssUrlSvgEndTag,cssStringQ,cssStringQQ
syn match cssPer3E /%3[eE]/ conceal cchar=>
      \ contained contains=NONE
      \ containedin=cssUrlQ,cssUrlQQ,cssUrl,cssUrlSvgTag,cssUrlSvgEndTag,cssStringQ,cssStringQQ


hi def cssUrlFunctionName guifg=#004400 guibg=#ff00ff
hi def cssUrlScheme guifg=#0044cc
hi def cssUrlMediaType guifg=#0066aa
hi def cssUrlBase64 guifg=#aa0033
hi def cssUrlSeps guifg=#ddcc44

hi def cssLineContinues guifg=#0022aa
hi def cssUrlSvgTag guifg=#1199ff
hi def cssUrlSvgEndTag guifg=#1199ff
hi def cssUrlSvgTagName guifg=#999900

" hi def link cssUrlSvgTagName Function

hi def link cssUrlSvgAttrName Type
hi def link cssUrlSvgAttrValueDQ cssUrlSvgAttrValue
hi def link cssUrlSvgAttrValueEQ cssUrlSvgAttrValue
hi def link cssUrlSvgAttrValueSQ cssUrlSvgAttrValue
hi def link cssUrlSvgAttrValue String 

hi def link cssPer22 cssPerEnc
hi def link cssPer23 cssPerEnc
hi def link cssPer3C cssPerEnc
hi def link cssPer3E cssPerEnc
hi def link cssPerEnc Conceal


