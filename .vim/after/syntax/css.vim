"
" CSS Syntax Extensions
"
" :au BufWritePost <buffer> syn on
"
" See Also:
"          ../after/syntax/css.vim
"       ../../demo/css-regex-tests.cs
"          ../pack/default/start/vim-css3-syntax/after/syntax/css/
"       $VIMRUNTIME/syntax/css.vim
"

source <script>:p:h/common.vim

syn sync lines=200

" TODO
"
" make :hover etc. stand out more
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
"
"
" TODO - warning for missing '.'
"  (For things which probably aren't custom tag names)
" #search .mw-advancedSearch-namespacePresets,
" mw-advancedSearch-namespace-selection-header {
"   border-radius: 0;
"   border-top: 0;
"   border-bottom: 0;
" }

" TODO - don't flag 'float:unset;'
" #search .mw-advancedSearch-namespace-selection-header > .oo-ui-labelElement {
"   float: unset;
"   clear: unset;
"   display: contents;
" }
"
"
"
"
"
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
" descendant          ␣️     ancestor            :has(  )
" child               >     parent              :has(> )
" next sibling        +     previous sibling    :has(+ )
" subsequent sibling  ~     preceeding sibling  :has(~ )
"
" A B⃝       A⃝ :has(B)
"
"
" A > B⃝     A⃝ 
"
" A + B⃝     A⃝ :has(+ B)     A + B + C⃝    A + B⃝ :has(+ C)  A⃝ :has(+ B + C)
"
" BBAB̲BBAA  BBA̲BBBAA        ABBCCAABC̲C   ABBCCAAB̲CC       ABBCCAA̲BCC
"
"
" A ~ B⃝     A⃝ :has(~ B)     A ~ B ~ C⃝    A ~ B⃝ :has(~ C)  A⃝ :has(~ B ~ C)
"
" BBAB̲B̲B̲AA  BBA̲BBBAA        BBBCCAABC̲C̲   BBBCCAABC̲C̲       ABBCCAA̲BCC

syn match cssVarCustomProp contained "--\%([a-zA-Z0-9-_]\|[^\x00-\x7F]\)*\Z"
      \ contains=cssCustomPropDashes
syn match cssCustomPropDashes contained +--+
      \ conceal cchar=╸ contains=NONE transparent

" Math operators not made valid by being inside these functions
syn region cssFunctionRegion contained
      \ matchgroup=Conceal start="(" end=")"
      \ contains=
      \cssFunctionComma,cssFunctionNameVar,cssMathFunctionName,
      \cssError,
      \cssCustomPropRef,cssColor,cssValueAngle,cssValueInteger,cssValueNumber,cssValueLength

syn region cssSqrtRegion contained concealends
      \ matchgroup=Conceal start="(" end=")"
      \ contains=
      \cssFunctionComma,cssFunctionNameVar,cssMathFunctionName,
      \cssError,
      \cssCustomPropRef,cssColor,cssValueAngle,cssValueInteger,cssValueNumber,cssValueLength

syn keyword cssFunctionNameVar contained conceal cchar=𐐏 var
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssFunctionRegion

" Math operators are valid inside these
syn region cssMathFunctionRegion contained
      \ matchgroup=Conceal start="(" end=")"
      \ contains=cssMathFunctionRegion,cssCalcKeyword,CssMathOp,
      \cssFunctionComma,cssFunctionNameVar,cssMathFunctionName,
      \cssError,
      \cssCustomPropRef,cssColor,cssValueAngle,cssValueInteger,cssValueNumber,cssValueLength
" ⨠ ⎆ ⌾
syn keyword cssMathFunctionName calc 
      \ contained conceal cchar=c
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionRegion
syn keyword cssMathFunctionName min 
      \ contained conceal cchar=􂪔
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionRegion
syn keyword cssMathFunctionName max
      \ contained conceal cchar=􂪓
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionRegion
" 􂲯(30)  􂲯30
syn keyword cssMathFunctionName sqrt
      \ contained conceal cchar=√
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssSqrtRegion

syn match CssMathOp $[+*/-]$ contained contains=NONE

" syn keyword cssMathFunctionName pow
"       \ contained conceal cchar=
"       \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
"       \ nextgroup=cssPowSimple,cssPowRegion

" syn match cssPowSep contained +,+ conceal cchar=^ contains=NONE
"       \ nextgroup=cssPowExponentRegion

" syn region cssPowExponentRegion contained 
"       \ start=",\@1<=" 
"       \ end="\ze)"
"       \ contains=cssPow,
"       \cssCustomPropRef,cssFunctionNameVar,cssMathFunctionName,cssColor,
"       \cssError,cssFunctionComma,cssValueAngle,cssValueInteger,cssValueNumber,cssValueLength
" syn region cssPowBaseRegion contained 
"       \ start="(\@1<="
"       \ end="\ze,"
"       \ nextgroup=cssPowSep 
"       \ contains=cssPow,
"       \cssCustomPropRef,cssFunctionNameVar,cssMathFunctionName,cssColor,
"       \cssError,cssFunctionComma,cssValueAngle,cssValueInteger,cssValueNumber,cssValueLength
" syn region cssPowRegion contained concealends
"       \ matchgroup=Conceal cchar=❮ start="(\ze\s*\d\+\s*,"
"       \ matchgroup=Conceal cchar=❯ end=",\@1<=\s*\d\+)"
"       \ contains=cssPowSep,
"       \cssCustomPropRef,cssFunctionNameVar,cssMathFunctionName,cssColor,
"       \cssError,cssValueAngle,cssValueInteger,cssValueNumber,cssValueLength

"{{{3 pow()
"  pow(a, n) -> aⁿ    (a  
" pow(a, -n) -> a⁻ⁿ  
"
syn match cssPowBase contained /-\?\d\+/ contains=NONE
      \ nextgroup=cssPowSep 
syn match cssPowSep contained /\s*,\s*/ contains=NONE conceal
      \ nextgroup=cssPowMinus,cssPow
syn match cssPowMinus contained /-/ contains=NONE conceal cchar=⁻ nextgroup=cssPow
syn match cssPow contained /0/ contains=NONE conceal cchar=⁰ nextgroup=cssPow
syn match cssPow contained /1/ contains=NONE conceal cchar=¹ nextgroup=cssPow
syn match cssPow contained /2/ contains=NONE conceal cchar=² nextgroup=cssPow
syn match cssPow contained /3/ contains=NONE conceal cchar=³ nextgroup=cssPow
syn match cssPow contained /4/ contains=NONE conceal cchar=⁴ nextgroup=cssPow
syn match cssPow contained /5/ contains=NONE conceal cchar=⁵ nextgroup=cssPow
syn match cssPow contained /6/ contains=NONE conceal cchar=⁶ nextgroup=cssPow
syn match cssPow contained /7/ contains=NONE conceal cchar=⁷ nextgroup=cssPow
syn match cssPow contained /8/ contains=NONE conceal cchar=⁸ nextgroup=cssPow
syn match cssPow contained /9/ contains=NONE conceal cchar=⁹ nextgroup=cssPow
syn region cssPowSimpleRegion contained concealends
      \ matchgroup=Conceal start="pow(\s*" end="\s*)"
      \ contains=cssPowBase
syn match cssPowSimple contained /pow(\s*\(-\?\d\+\)\s*,\s*\(-\?\d\+\)\s*)/
      \ contains=cssPowSimpleRegion
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup

hi link cssPowBase Number
hi link cssPowSep Number

"{{{3 Trig functions
syn match cssMathFunctionName /\%(a\@1<=\|\<\)sin\>/
      \ contained conceal cchar=𝙎 
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionRegion
syn match cssMathFunctionName /\%(a\@1<=\|\<\)cos\>/
      \ contained conceal cchar=𝘾 
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionRegion
syn keyword cssMathFunctionName tan
      \ contained conceal cchar=𝙏 
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionRegion
syn match cssMathFunctionName /\%(atan\)\@4<=2\>/
      \ contained conceal cchar=𝟮 
      \ containedin=NONE
      \ nextgroup=cssMathFunctionRegion
syn match cssMathFunctionName /\%(a\@1<=\|\<\)tan\ze2\?\>/
      \ contained conceal cchar=𝙏
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionName,cssMathFunctionRegion
syn match cssMathFunctionName /\<a\ze\%(sin\|cos\|tan2\?\)\>/
      \ contained conceal cchar=𝙖
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionName
"􁢏􀥄􁇝􁁀 􀐩 􂇏' 􀐪􀓗
"􀥖􀥗􀥘
" 􀼰􀼯􀼯 􀼯 􀼯 􀼯 􀼯 􀼯 􀼮
" 􁥞 􁥟
"
" 􀂘􀂙􀂸􀂹􀂺
"􀩈 􀩉 􀩊 􀩋 􀩌 􀩍􁆬
"􀍳􀍴 􀎗􀩈􀥖􀩉􀥗􀩊􀥘 􁆭􁅥
"
" hypot(a[, b[, c]… ]) /* sqrt(pow(a)[ + pow(b)[ + pow(c)]… ]) */
 " 􀫰 􀫱 􁹫' 􁹬' 􀍸 􀍹
" abs()  􀡿 􁢸􁢹􁢷
" sign()  􀛺􀅺  􀅻􀅼􀅾􀅿􀆀􂪯  􀜓
          
" pow(base, n)   2􀆇4 2^4 (2, 4)
"
" 5^var(--k)
"
" 􀆁􂪰 􀆂􂪱   􀆄️⃝ 􀆅️⃝ 􀃲️⃞ 􀃰️⃞ 􀃳️⃞ 
" exp(n)    eⁿⁿⁿ e¹ e² e³ e¹⁴e¹⁵e¹⁶e⁷e⁸e⁹  /* pow(e, n) */
" log()   

" mod()   27􀘾5   mod(27, 5) = 2
" rem()          rem(27, 5) = 2
" round()

" env()   􀆃
" var()

" calc-size()
" calc()      􀅮

" circle()         􀀀()
" ellipse()        􀲞()
" rect()           􀣮()
" polygon()        􀍵() 
" path()           􀜢()

" 􀋽 􀋾 􁘿 􁙀 􀋿 􀯭 􁸼' 􀯮 􀯯

" sepia()         􀜤()
" grayscale()   􀜚
" blur()
" brightness()    􀆮()
" contrast()      􁹭 ()
" 􂱢 􂱣 􁹭 􁹮  􁹤   
" drop-shadow()   􀨡() 􀯱() 􀯮() 􀯯()
" hue-rotate      􁑡()  􁘯() 􁘰()
" invert()        􀺊()
" opacity()       􁊕()
" saturate()

" 􀠑􀠒􁇊􀈀􁹡 􁤈 􁇋 􀈁 􁘯􁘰 􁚂 􁓀 􁚃􁓁􁿌 () 􀫸() 􀆿() 􁒏()

"
" 􀻄􂁀 􂁄 􂀂 􂁈 􂁌 􂁔 􀀂 􀀃 􀪗 􀪖  􁇋􁛋 􁹢 􁹥 􁹨 􁚌
" 􂁁 􂁅 􂀃 􂁉 􂁍 􂁕 􁹭 􁹮 􁹯 􁹰 􀝜􀍷􀠌
" 􀵋􀵌􀯠􀵏􀵐

" color-mix() 􀟗()
" color()     􀧹()
" linear-gradient() 􀘱􀅌() 􀊞􀘱     􀊞􁹣() 􁹤() 􁹥() 􁹦
" conic-gradient()  􀳈􀅌() 􀊞􀳈     􀜋􀅌() 􀊞􀜋() 􀊞􀑀 􀊞􀳇  􀊞􀳈􀊞􀟼􀟻􀕲􀕳
" radial-gradient() 􀢊􀅌() 􀊞􀢊     􀊞􀢊()    􀧺􀧻     
" repeating-linear-gradient() 􀘱􀅌􀧐􀬑􀄾􀑹􀅈􀅉 􁹣 􁹤 􁹥 􁹦
" repeating-conic-gradient() 􀳇􀳈
" repeating-radial-gradient()􀢊􁊕
" repeating-radial-gradient()


"{{{3 Image gradient functions
syn match cssMathFunctionName /linear-gradient\>/
      \ contained conceal cchar=▥
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionRegion
syn match cssMathFunctionName /conic-gradient\>/
      \ contained conceal cchar=◔
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionRegion
syn match cssMathFunctionName /radial-gradient\>/
      \ contained conceal cchar=⌾
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionRegion
syn match cssMathFunctionName /\<repeating-\ze\(linear\|conic\|radial\)-gradient/
      \ contained conceal cchar=∞
      \ containedin=cssAttrRegion,cssFunction,cssMathParens,cssMathGroup
      \ nextgroup=cssMathFunctionName
"
syn region cssFunction contained 
      \ start="\<\%(repeating-\|\)\%(linear-\|radial-\|conic-\)\=\gradient\s*("
      \ end=")\@1<="
      \ contains=cssMathFunctionName,cssColor,cssValueAngle,cssValueInteger,cssValueNumber,cssValueLength,
      \ cssFunction,cssGradientAttr,cssFunctionComma

" counter()􁂷􀅱
" counters()􀘽
" symbols()
" 􁙠 􀷾 􁙕 􀭞 􀋲 􀋱 􀢽 􀋳 􀋴 􀣩
" 􀋵 􀋶 􀝿 􀞀 􁖖      􀅸􀅷􀅹􀄢􀁜􀅍􁑣
"

" matrix()
" matrix3d()

" repeat()   􀊞()
" min()   􀅄()
" max()   􀅃()  􀣊 􀆥􀆦() 􂨨 􀆏􂦩 􀐷
" minmax()     􂪓􂪔() 􂨧  􂦪   􀐸
" clamp()  􀰬􀎕􀟀 􂭎  􀚌 􂮨'
              
" paint()   􀰗 􁐄
" palette-mix() Experimental  􀝥()
" cross-fade()
" device-cmyk()

" perspective() 􀒱()   􀡠 􀞐 􀡛 􀞑 􀞖 􀞏

" 􀎮 􀎯 􀎰 􀎱􀢇 􁱂' 􀢅 􀢆 􀑠
" " Easing
" linear()       􁘶()
" cubic-bezier() 􁘳() 􀑁() 􁂥() 
" steps()        􂆐(️)️  􀎌() 􀠕()
" ray()                􀕧 􀕨 􀸓 􀕬 􀕭 􀝦 􁙧 􁙨

syn match cssCustomPropRefDashes /--/ contained contains=NONE transparent conceal
syn match cssCustomPropRef contained "--\%([a-zA-Z0-9-_]\|[^\x00-\x7F]\)*\Z"
      \ contains=cssCustomPropRefDashes
" syn region cssFunctionVar
"       \ matchgroup=cssVarParens
"       \ start="\<var\s*("ms=s+3,hs=e
"       \ end=")"me=e
"       \ contained oneline
"       \ containedin=cssDefinition,cssAttrRegion,cssAtRule,cssFunction
"       \ contains=cssFunctionNameVar,cssVarCustomProp,cssFunctionVar,cssValue.*,cssFunction,cssColor,cssStringQ,cssStringQQ
"       " \ contains=cssFunctionNameVar,cssVarParens
"   syn region cssVarParens
"         \ start="("
"         \ end=")"me=e-1,he=e+2
"         \ contained oneline
"         \ contains=cssVarCustomProp,cssFunctionVar,cssValue.*,cssFunction,cssColor,cssStringQ,cssStringQQ


syn case ignore
syn keyword cssCalcKeyword contained e pi
syn match cssCalcKeyword +-\?infinity+ contained
syn case match
syn keyword cssCalcKeyword contained NaN
syn match cssError +\<\%(n[aA][nN]\|N\%(an\|A[nN]\)\)\>+ contained containedin=cssFunctionCalc
syn case ignore




syn match cssPseudoClassIdNoise contained +:+ contains=NONE
      \ containedin=cssPseudoClass,cssPseudoClassFn

syn region cssPseudoClassFn containedin=cssPseudoClass
      \ matchgroup=cssFunctionName start=":where("
      \ end=")"
      \ contains=cssNoise,cssSelectorOp,cssPseudoClassFn,cssPseudoClass,
      \cssStringQ,cssStringQQ,
      \cssTagName,cssAttributeSelector,cssClassName,cssIdentifier
syn region cssPseudoClassFn containedin=cssPseudoClass
      \ matchgroup=cssFunctionName start=":is("
      \ end=")"
      \ contains=cssNoise,cssSelectorOp,cssPseudoClassFn,cssPseudoClass,
      \cssStringQ,cssStringQQ,
      \cssTagName,cssAttributeSelector,cssClassName,cssIdentifier
syn region cssPseudoClassFn containedin=cssPseudoClass
      \ matchgroup=cssFunctionName start=":has("
      \ end=")"
      \ contains=cssNoise,cssSelectorOp,cssPseudoClassFn,cssPseudoClass,
      \cssStringQ,cssStringQQ,
      \cssTagName,cssAttributeSelector,cssClassName,cssIdentifier
syn region cssPseudoClassFn containedin=cssPseudoClass
      \ matchgroup=cssFunctionName start=":not("
      \ end=")"
      \ contains=cssNoise,cssSelectorOp,cssPseudoClassFn,cssPseudoClass,
      \cssStringQ,cssStringQQ,
      \cssTagName,cssAttributeSelector,cssClassName,cssIdentifier

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

syn match cssGridAttrProp contained "\<grid\>"
syn keyword cssGridAttrProp contained grid

syn match cssGridTemplateProp contained /\<grid-template-\%(columns\|rows\)\>/
      \ containedin=cssDefinition contains=cssGridProp
      \ nextgroup=cssGridTemplateRegion

syn region cssGridTemplateRegion contained
      \ start=+:\s\[+
      \ end=+\ze\%(;\|)\|}\|{\)+
      \ contains=cssGridTplLines,
      \cssImportant,cssValueNumber,cssValueLength,cssFunction,cssComment,cssError,cssNoise

syn region cssGridTplLines contained
      \ matchgroup=cssGridTplDelims start=+\[+
      \ end=+]+
      \ contains=cssGridTplLineStart,cssGridTplLineEnd,cssGridTplLine,cssGridTplForbidden
syn match cssGridTplLine contained +\<[A-Za-z_][A-Za-z0-9_-]\+\>+ contains=NONE
syn match cssGridTplLineStart contained +\<[A-Za-z_][A-Za-z0-9_-]\+-start\>+ contains=cssGridTplSuffix
syn match cssGridTplLineEnd contained +\<[A-Za-z_][A-Za-z0-9_-]\+-end\>+ contains=cssGridTplSuffix
syn match cssGridTplSuffix contained /-start\|-end/ contains=NONE
syn keyword cssGridTplForbidden contained span auto

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
      \ contains=cssPropertyProp,cssPropertyAttr,cssPropertySyntax,
      \cssComment,cssValue.*,cssColor,cssURL,cssCustomProp,cssError,
      \cssStringQ,cssStringQQ,cssFunction,cssUnicodeEscape,cssNoise
syn region cssPropertySyntax contained
      \ start=+\z("\|'\)+ end=+\z1+
      \ contains=cssSyntaxType

" @layer
syn region cssAtRule matchgroup=cssAtKeyword
      \ start=+@layer\>+ end=+\ze{+
      \ skipwhite skipnl
      \ contains=cssMediaProp,cssValueLength,cssAtRuleLogical,cssValueInteger,
      \cssMediaAttr,cssVendor,cssMediaType,
      \cssComment,cssCustomProp,cssFunctionName
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
      \ keepend containedin=cssAttrRegion,cssAtPropertyDef
      \ contains=cssUrlFunctionParens

syn region cssUrlFunctionParens contained
      \ matchgroup=cssUrlParen start=+(\ze\z("\|'\)+
      \ end=+\z1\zs)+
      \ contains=cssUrlFunctionString
syn region cssUrlFunctionString contained
      \ start=+\z("\|'\)+
      \ end=+\z1+
      \ contains=cssUrlPrefix,cssUrlMimeType,cssUrlSvgComment,cssUrlSvgTag,
      \cssUrlSvgEndTag,cssUrl64Data,cssUrlSeps,cssLineCont,cssPer0A
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
      \ contains=cssUrlSvgValue,cssUrlSvgTagN,cssUrlSvgPath,cssUrlSvgXmlns,
      \cssUrlSvgAttr,cssUrlSvgAttrSep,cssPerTag,
      \cssLineCont
syn region cssUrlSvgEndTag contained keepend
      \ start=+%3[cC]/+
      \ end=+%3[eE]+
      \ contains=cssUrlSvgTagN,cssPerTag,
      \cssLineCont

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
      \ pathEllipA,pathEllipR,
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

syn match pathM /M\s*/ contained
      \ contains=cssLineCont nextgroup=pathMExpl
syn match pathMExpl /\%(-\?\d*\.\?\d\+\s*\)\{2}/ contained
      \ contains=cssLineCont nextgroup=pathMImpl
syn match pathMImpl /\%(-\?\d*\.\?\d\+\s*\)\{2}/ contained
      \ contains=cssLineCont nextgroup=pathMImpl


syn match pathm /m\s*/ contained contains=cssLineCont nextgroup=pathMex
syn match pathmex /\%(-\?\d*\.\?\d\+\s*\)\{2}/ contained contains=cssLineCont

syn match pathClose +[zZ]+ contained

syn region pathMoveAbs  start=+M+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont
syn region pathMoveRel  start=+m+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont

syn region pathLineAbs  start=+L+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont
syn region pathLineRel  start=+l+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont

syn region pathHLineAbs start=+H+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont
syn region pathHLineRel start=+h+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont

syn region pathVLineAbs start=+V+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont
syn region pathVLineRel start=+v+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont

syn region pathCubicAbs start=+C+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont
syn region pathCubicRel start=+c+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont
syn region pathCubi2Abs start=+S+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont
syn region pathCubi2Rel start=+s+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont

syn region pathQuadAbs  start=+Q+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont
syn region pathQuadRel  start=+q+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont
syn region pathQuad2Abs start=+T+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont
syn region pathQuad2Rel start=+t+ end=+\ze[^0-9. \\-]+ contained contains=svgPathParam,cssLineCont

" syn region pathEllipAbs start=+A+ end=+\ze[MZVHLCSQTAmzvhlcsqta\\]+ oneline contained contains=svgPathParam
syn region pathEllipR start=+a+
      \ end=+\ze[^0-9. \\-]+
      \ contained contains=pathEllipRL,cssLineCont
syn match pathEllipRP2 /\%([^ -]\+\ze *[ -]\)\{7}/ contained
      \ contains=svgPathParam nextgroup=pathEllipRP1
syn match pathEllipRP1 /\%([^ -]\+\ze *[ -]\)\{7}/ contained
      \ contains=svgPathParam nextgroup=pathEllipRP2
syn match pathEllipRL /a/ contained contains=NONE
      \ nextgroup=pathEllipRP1

syn region pathEllipA start=+A+
      \ end=+\ze[^0-9. \\-]+
      \ contained contains=pathEllipAL,cssLineCont
syn match pathEllipAP2 /\%([^ -]\+\ze *[ -]\)\{7}/ contained
      \ contains=svgPathParam nextgroup=pathEllipAP1
syn match pathEllipAP1 /\%([^ -]\+\ze *[ -]\)\{7}/ contained
      \ contains=svgPathParam nextgroup=pathEllipAP2
syn match pathEllipAL /A/ contained contains=NONE
      \ nextgroup=pathEllipAP1

syn match svgPathParam +[0-9. -]\{1,}+ transparent contained contains=NONE

syn match svgPathCmdLetter /[MZVHLCSQTAmzvhlcsqta]/ contained contains=NONE


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

syn match cssImportant contained "!\ze\s*important\>" nextgroup=cssImportant
syn match cssImportant conceal contained "!\@1<=\s*important\>"


" Concealing - hacks
syn match specificity
      \ /:\zenot(\_s*\%[#u#n#i#m#p#o#r#t#a#n#t]\_s*)/
      \ conceal cchar=􀣴 contains=NONE
syn match specificity
      \ /:\@1<=not(\_s*\%[#u#n#i#m#p#o#r#t#a#n#t]\_s*)/
      \ conceal contains=NONE

hi def link specificity cssImportant

"
" Concealing - frivolous
"
call setcellwidths([[char2nr('﹐'),char2nr('﹫'),1]])
syn match cssUnitConc /%/ conceal cchar=﹪ transparent contained containedin=cssUnitDecorators contains=NONE
syn match cssUnitConc /deg/ conceal cchar=° transparent contained containedin=cssUnitDecorators contains=NONE
" syn match cssUnitConc /mm/ conceal cchar=㎜ transparent contained containedin=cssUnitDecorators contains=NONE
" syn match cssUnitConc /cm/ conceal cchar=㎝ transparent contained containedin=cssUnitDecorators contains=NONE
" syn match cssUnitConc /ms/ conceal cchar=㎳ transparent contained containedin=cssUnitDecorators contains=NONE
syn match cssUnitConc /p\zex/ conceal cchar=𝚙 transparent contains=NONE 
      \ contained containedin=cssUnitDecorators nextgroup=cssUnitConc
syn match cssUnitConc /p\@1<=x/ conceal cchar=𝚡 transparent contained contains=NONE

syn match cssUnitConc +p\ze\%(x\|c\|t\)+ conceal cchar=𝚙 transparent contained containedin=cssUnitDecorators contains=NONE nextgroup=cssUnitConc
syn match cssUnitConc /p\@1<=x/ conceal cchar=𝚡 transparent contained containedin=cssUnitDecorators contains=NONE nextgroup=cssUnitConc
syn match cssUnitConc /p\@1<=c/ conceal cchar=𝚌 transparent contained containedin=cssUnitDecorators contains=NONE nextgroup=cssUnitConc
syn match cssUnitConc /p\@1<=t/ conceal cchar=𝚝 transparent contained containedin=cssUnitDecorators contains=NONE nextgroup=cssUnitConc

syn match preProcComment +\zs/\*\s*prettier-ignore\s*\*/\ze+

syn match devtoolComment +\*\s\?\%(Inline\s#\d\+\|Element\)\s\?|.*$+


" Seps & noise
" syn match cssNoise contained +:+
syn match cssUrlSeps /[:;,]/ contained contains=NONE


"}}}1


"{{{1 Define colours
"


hi link cssUnitDecorators Conceal
"
hi cssIdHash         guifg=#ffaa00
hi cssSelectorOp     guifg=#22ffaa gui=bold
hi cssSelectorOp2    guifg=#0800ff gui=bold
hi cssAttrParens     guifg=#ff5500 gui=bold
hi cssAttrComma      guifg=#ffff00 gui=bold
hi cssAttrOp         guifg=#ff00ff

hi link cssAtRule Include
hi link cssAtKeyword PreProc

hi cssCustomProp  guifg=#bf53bc
hi cssNoise       guifg=#bbaf00

hi link cssIdentifier Function
hi link cssClassName Function

" Value types
hi link cssCalcKeyword Constant
hi link cssValueLength Number
hi link cssValueInteger Number
hi link cssValueNumber Number
hi link cssValueAngle Number
hi link cssValueTime Number
hi link cssValueFrequency Number
" unimplemented/vendor
hi cssVendor       guifg=#ffaa00 guibg=NONE gui=italic,strikethrough guisp=#ff0000
hi link cssHyerlinkProp cssVendor
hi link cssIEUIProp cssVendor
" no matches defined
hi link cssLineboxProp cssProp
hi link cssMarqueeProp cssProp
hi link cssPagedMediaProp cssProp
hi link cssPrintProp cssProp
hi link cssRubyProp cssProp
hi link cssSpeechProp cssProp
hi link cssRenderProp cssProp
" Generic/common
hi link cssCascadeProp cssProp
hi link cssCascadeAttr cssAttr
hi link cssCommonAttr cssAttr
" Language content & communication
hi cssCommsProp  guifg=#aabcc7 guibg=NONE    gui=none
hi link cssFontProp cssCommsProp
hi link cssTextProp cssCommsProp
hi link cssAuralProp cssCommsProp
hi link cssGeneratedContentProp cssCommsProp
hi link cssMobileTextProp cssCommsProp
" Color & appearance
hi cssPrettyProp guifg=#55aa77 guibg=NONE    gui=none
hi link cssAnimationProp cssPrettyProp
hi link cssTransitionProp cssPrettyProp
hi link cssBackgroundProp cssPrettyProp
hi link cssColorProp cssPrettyProp
hi link cssListProp cssPrettyProp
hi link cssObjectProp cssPrettyProp
" UI & behaviour
hi cssBehaveProp guifg=#cc6699 guibg=NONE    gui=none
hi link cssBorderProp cssBehaveProp
hi link cssTransformProp cssBehaveProp
hi link cssUIProp cssBehaveProp
hi link cssInteractProp cssBehaveProp
" Layout & structure
hi cssLayoutProp   guifg=#2288dd guibg=NONE  gui=none
hi cssFlexAttrProp guifg=#6688dd guibg=NONE  gui=none
hi cssGridAttrProp guifg=#8888dd guibg=NONE  gui=none

hi link cssBoxProp cssLayoutProp
hi link cssBoxAttr cssAttr

hi link cssPositioningProp cssLayoutProp
hi link cssPositioningAttr cssAttr

hi link cssDimensionProp cssLayoutProp
hi link cssDimensionAttr cssAttr

hi link cssFlexibleBoxProp cssFlexAttrProp
hi link cssFlexibleBoxAttr cssFlexAttrProp

hi link cssGridProp cssGridAttrProp
hi link cssMultiColumnProp cssLayoutProp
hi link cssTableProp cssLayoutProp
"
" Misc
"
hi cssImportant guifg=#ff22cc guibg=NONE gui=bold,italic
"
" [selector="attribute"]
"
hi link cssAttributeSelector Type
hi link cssClassNameDot Statement
hi def link cssAttrParens Statement
hi def link cssAttrOp cssSelectorOp2
hi def link cssIdHash Statement
"
" :pseudo
"
hi link cssPseudoClassIdNoise cssNoise
hi def cssPseudoClass      guifg=#ee0000 gui=italic
hi link cssPseudoClassId PreProc
hi link cssPseudoClassLang Constant

hi def cssPseudoClassFn    guifg=#ee0000 gui=italic
hi link cssFunctionName Function
hi def cssFunctionComma    guifg=#dddd22
hi def link cssFunctionNameVar Conceal

hi def cssMathFunctionName guifg=ycsealf gui=bold
hi def link CssMathOp Operator

hi def link cssVarCustomProp cssCustomProp
hi def link cssVarParens Conceal
hi def link cssCalcKeyword Constant

"
" @property
"
hi def link cssPropertySyntax String
hi def link cssSyntaxType Type
hi def link cssPropertyAttr Keyword
hi cssPropertyProp         guifg=#ccccff

"
" CSS extension for grid template
"
hi def cssGridTplSuffix    guifg=#666666
hi def cssGridTplLine      guifg=#6666aa
hi def cssGridTplLineStart guifg=#66aa66
hi def cssGridTplLineEnd   guifg=#aa6666
hi def cssGridTplDelims    guifg=#aaaaaa
hi def link cssGridTplForbidden Error
"
" CSS extension for dataurls
"
hi def link cssUrlFnName cssFunctionName
hi def link cssUrlParen  cssFunctionName
hi def cssUrlPrefix        guifg=#cc77ee
hi def cssUrlMimeType      guifg=#ff99ff
hi def cssUrlSeps          guifg=#ddcc44
hi def cssUrlSvgAttrSep    guifg=#ff00ff
hi def cssUrl64Token       guifg=#cc5533
hi def link cssUrl64Data Conceal
hi def link cssUrl64Invalid Error
hi def cssUrlSvgTag        guifg=#1199dd
hi def cssUrlSvgEndTag     guifg=#1199dd
hi def cssUrlSvgTagName    guifg=#999900

hi def link cssUrlSvgValue String 
hi def link cssUrlSvgAttr Type
hi def link cssUrlSvgTagError CommentError
hi def link cssUrlSvgComment CommentSubtle
hi def link cssUrlSvgXmlns CommentSubtle
hi def link preProcComment  CommentNoise

"
" CSS extension for SVG-in-dataurl
"
hi def pathClose           guifg=#ffaa00 guibg=NONE gui=bold
hi def pathMoveAbs         guifg=#009900 gui=bold guisp=#4444ee
hi def pathMoveRel         guifg=#009900
hi def pathLineAbs         guifg=#9900cc gui=bold guisp=#eeeeee
hi def pathLineRel         guifg=#9900cc
hi def pathHLineAbs        guifg=#0066aa gui=bold guisp=#eeeeee
hi def pathHLineRel        guifg=#0066aa
hi def pathVLineAbs        guifg=#bb0077 gui=bold guisp=#eeeeee
hi def pathVLineRel        guifg=#aa0066
hi def pathCubicAbs        guifg=#8800ff gui=bold guisp=#44eeee
hi def pathCubicRel        guifg=#8800ff
hi def pathCubi2Abs        guifg=#8855ff
hi def pathCubi2Rel        guifg=#8855ff
hi def pathQuadAbs         guifg=#664488 gui=bold guisp=#eeeeee
hi def pathQuadRel         guifg=#664488
hi def pathQuad2Abs        guifg=#665588 gui=bold guisp=#eeeeee
hi def pathQuad2Rel        guifg=#665588
hi def pathEllipA          guifg=#aa6666 guisp=#559999 gui=underdashed
hi def pathEllipAL         guifg=#559999 gui=bold,underline
hi def pathEllipAP1        guifg=#aa6666 guisp=#559999 gui=underline
hi def pathEllipAP2        guifg=#cc8888 guisp=#aa6666 gui=italic,underdashed
hi def pathEllipRP1        guifg=#aa6666 guisp=#559999 gui=underline
hi def pathEllipRP2        guifg=#cc8888 guisp=#aa6666 gui=italic,underdashed
hi def pathEllipRL         guifg=#559999 gui=underline
hi def svgPathParam        guifg=NONE

hi def svgPathCmdLetter    guisp=#ff0000 gui=underline,nocombine

hi def link cssLineCont Conceal
hi def link   cssPerEnc Conceal
hi def link  cssPer0A cssPerEnc
hi def link    cssPer cssPerEnc
hi def link  cssPer22 cssPerEnc
hi def link cssPerTag cssPerEnc

"}}}1


" silent call prop_type_delete('cssSvgPathDelim')
" silent call prop_type_add('cssSvgPathDelim', #{
"       \ highlight: 'Delimiter',
"       \ combine: v:true,
"       \ })
" call prop_add(21, 0, #{
"       \ type: 'p',
"       \ text: '¶',
"       \ text_align: 'after',
"       \ text_padding_left: 0,
"       \ })

" function! s:OnBufferChanged(bufnr, start, end, added, s)
"   call prop_remove(#{types: ['cssSvgPathDelim']}, a:start, a:end)

"   " call prop_add_list()
" endfunc

" call listener_add('s:OnBufferChanged', bufnr())

" vim: nowrap sw=2 sts=2 ts=8 et fdm=marker:

