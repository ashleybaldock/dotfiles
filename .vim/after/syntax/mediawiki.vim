"
" Extensions To Mediawiki Syntax Highlighting:
"
" See Also:
"    ../../pack/default/start/mediawiki.vim/syntax/mediawiki.vim
"    ../../demo/syntax.test.mediawiki
"
" au BufWritePost <buffer> syn on
"


" TODO
"   - Highlighting for expr syntax (=, and, or etc.)
"   - Extra errorneous }'s
"   - Different HL group for HTML comments containing only whitespace and newlines
"   - Warning for missing | in template param

" Keyword Lists: {{{1 
syn keyword htmlTagN contained b big blockquote br
syn keyword htmlTagN contained caption center cite code
syn keyword htmlTagN contained dd del div dl dt em font
syn keyword htmlTagN contained hr h1 h2 h3 h4 h5 h6 i ins 
syn keyword htmlTagN contained li ol p pre rb rp rt ruby
syn keyword htmlTagN contained s small span strike strong sub sup
syn keyword htmlTagN contained table td th tr tt u ul var

syn keyword htmlArg contained align lang dir width height nowrap bgcolor clear
syn keyword htmlArg contained noshade cite datetime size face color type start
syn keyword htmlArg contained value compact summary border frame rules
syn keyword htmlArg contained cellspacing cellpadding valign char charoff
syn keyword htmlArg contained colgroup col span abbr axis headers scope rowspan
syn keyword htmlArg contained colspan id class name style title

syn keyword mwTagN contained math nowiki references source syntaxhighlight
syn keyword mwTagN contained includeonly onlyinclude noinclude
syn keyword mwTagN contained ref poem

syn keyword mwPiTagN contained infobox title default format panel 
syn keyword mwPiTagN contained section label data image caption alt navigation 

syn keyword mwPiAttrs contained class show collapse name layout type source span 
syn match mwPiAttrs /row-items/ contained
syn match mwPiAttrs /theme/ contained
syn match mwPiAttrs /theme-source/ contained
syn match mwPiAttrs /accent-color-source/ contained
syn match mwPiAttrs /accent-color-default/ contained
syn match mwPiAttrs /accent-color-text-source/ contained
syn match mwPiAttrs /accent-color-text-default/ contained
syn match mwPiAttrs /data\%(-\w*\)*/ contained


" Clusters: {{{1
syn cluster mwComment contains=mwHtmlNLCurComment,mwHtmlNLComment,htmlComment

syn cluster htmlTop contains=@Spell,
      \htmlTag,htmlEndTag,htmlSpecialChar,
      \htmlPreProc,@mwComment,
      \htmlLink,@htmlPreproc

syn cluster mwText contains=mwLink,mwTl,mwParam,mwParFunc,
      \mwNowiki,mwNowikiEndTag,
      \mwRef,mwSyntaxHL,mwSource,
      \mwItalic,mwBold,mwBoldAndItalic

syn cluster mwTop contains=@Spell,mwLink,
      \mwRef,mwSyntaxHL,mwSource,
      \mwNowiki,mwNowikiEndTag

syn cluster mwTableFormat contains=mwTl,
      \htmlString,htmlArg,htmlValue

syn cluster mwMagic add=mwMagicVar,mwMagicChar,mwMagicWord



" Infobox Ext Tags: <infobox></infobox> {{{1

" accent-color(-text|)-(source|default)
"       
" None
" infobox;                      name layout type theme
" title image header navigation data group panel
"
" <infobox>
"   │      ┌╴<section>
"   ┌──────┘─╴<group>
" <image>                       name source  
"   └╴<alt>╶──────┐                    source
"   └╴<caption>╶┐ │                   source
"   │           │ │
"   │           │ └─╴<default>(@wikiText:yes)
"   └───────────└vv
"   │ <title>   │ │─╴<format>(@wikiText:yes)
"   │           │ │
"   │ <data>    │ │
"   │           │ │

" image
" caption;              source
" default
" format

" infobox group section
" title;                source name
" default format

" infobox group section
" data;                 source name layout span 
" default label format

" data section
" label;
" None

" title data image alt caption
" default;
" None

" title data caption
" format;
" None

" infobox group section
" group;                        name layout show collapse row-items 
" data header image title group navigation panel

" infobox group panel section
" header;                       name
" None

" infobox group section
" navigation;                   name
" None

" infobox group
" panel;                        name
" header section
" 
" panel
" section;                      name
" title data label image group header navigation





syn region mwPiValue contained contains=NONE
      \ matchgroup=mwPiParens start=+=\s*\z(['"]\)+ end=+\z1+

syn region mwPiTag contained
      \ matchgroup=mwPiTagParen start=+<\ze[^!/]+
      \ end=+>+
      \ contains=mwPiTagN,mwPiAttrs,mwPiValue

syn region mwPiEndTag contained
      \ matchgroup=mwPiTagParen start=+<\/+
      \ end=+>+
      \ contains=mwPiTagN

syn region mwPiDefault contained
      \ start=+\ze<default\>[^>]*>+
      \ end=+\%(<\/default>\)\@10<=+
      \ contains=
      \mwPiTag,mwPiEndTag,@mwText,
      \@htmlTop,htmlEndTag,@mwComment

syn region mwPiFormat contained
      \ start=+\ze<format\>[^>]*>+
      \ end=+\%(<\/format>\)\@9<=+
      \ contains=
      \mwPiTag,mwPiEndTag,
      \@mwText,mwTl,mwParFunc,
      \mwParam,htmlTag,htmlEndTag,@mwComment

syn region mwPiLabel contained
      \ start=+\ze<label\>[^>]*>+
      \ end=+<\/label>+
      \ contains=
      \mwPiTag,mwPiEndTag,
      \@mwText,mwTl,mwParFunc,mwLink,mwParam,
      \htmlTag,htmlEndTag,@mwComment

syn region mwPiPanel contained
      \ start=+\ze<panel\>[^>]*>+
      \ end=+<\/panel>+
      \ nextgroup=mwPiTag
      \ contains=mwPiHeader,mwPiSection,
      \mwPiEndTag,
      \@mwText,@htmlTop

syn region mwPiGroup contained
      \ start=+\ze<\z(group\)\>[^>]*>+
      \ end=+<\/\z1>+
      \ nextgroup=mwPiTag
      \ contains=mwPiGroup,mwPiData,mwPiHeader,mwPiTitle,mwPiImage,
      \mwPiPanel,mwPiNavigation,
      \mwPiEndTag,
      \@mwText,
      \@htmlTop

syn region mwPiSection contained
      \ start=+<section\>[^>]*>+
      \ end=+<\/section>+
      \ nextgroup=mwPiTag
      \ contains=mwPiGroup,mwPiNavigation,
      \mwPiEndTag,
      \@mwText,mwTl,mwParFunc,mwLink,mwParam,
      \htmlTag,htmlEndTag,@mwComment

syn region mwPiNavigation contained
      \ start=+<navigation\>[^>]*>+
      \ end=+<\/navigation>+
      \ nextgroup=mwPiTag
      \ contains=
      \mwPiEndTag,
      \@mwText,mwTl,mwParFunc,mwLink,mwParam,
      \htmlTag,htmlEndTag,@mwComment

syn region mwPiTitle contained
      \ start=+<title\>[^>]*>+
      \ end=+<\/title>+
      \ nextgroup=mwPiTag
      \ contains=mwPiDefault,mwPiFormat,
      \mwPiEndTag,
      \@mwText,mwTl,mwParFunc,mwLink,mwParam,
      \@htmlTop

syn region mwPi
      \ start=+<infobox\>[^>]*>+
      \ end=+<\/infobox>+
      \ nextgroup=mwPiTag
      \ contains=mwPiTitle,mwPiImage,mwPiHeader,mwPiNavigation,
      \mwPiData,mwPiGroup,mwPiPanel,
      \mwPiEndTag,
      \@mwComment


"{{{1  Wiki Tags: <nowiki></nowiki>
syn region mwTag contained
      \ start=+<[^/]+
      \ end=+\%(\s*/\)\?>+
      \ contains=mwTagN,mwTagArg,mwTagSep,mwTagVal,htmlString
syn region mwEndTag contained
      \ start=+</+
      \ end=+>+
      \ contains=mwTagN
      \ containedin=mwSyntaxHLEndTag

syn match mwTagArg /\s\zs\w\+/ contained contains=NONE
      \ nextgroup=mwTagSep skipwhite skipempty
syn match mwTagSep /=/ contained contains=NONE
      \ nextgroup=mwTagVal skipwhite skipempty
syn region mwTagVal contained skipwhite skipempty
      \ matchgroup=mwTagValDelim start=+"+ end=+"+
      \ contains=@mwtext
      \ nextgroup=mwTagArg 

syn match mwMathTag +<math\%(\s*/\)\?>+ contained contains=mwTag
syn match mwMathEndTag +</math>+ contains=mwEndTag
syn region mwMath
      \ start=+<\z(math\)>+
      \ end=+\%(</\z1>\)\@7<=+
      \ contains=mwMathTag,mwMathEndTag

syn match mwNowikiTag +<nowiki\%(\s*/\)\?>+ contained contains=mwTag
syn match mwNowikiEndTag +</nowiki>+ contains=mwEndTag
syn region mwNowiki
      \ start=+<\z(nowiki\)>+
      \ end=+\%(</\z1>\)\@9<=+
      \ contains=mwNowikiTag,mwNowikiEndTag
syn match mwNowiki +<nowiki\s*/>+ contains=mwNowikiTag

syn match mwSourceTag +<source\%(\s[^>]*\)\?>+ contains=mwTag
syn match mwSourceEndTag +</source>+ contains=mwEndTag
syn region mwSource
      \ start=+\ze<\z(source\)\s*[^>]*>+
      \ end=+\%(</\z1>\)\@9<=+
      \ contains=mwSourceTag,mwSourceEndTag

syn match mwSyntaxHLTag +<syntaxhighlight\%(\s[^>]*\)\?>+ contains=mwTag
syn match mwSyntaxHLEndTag +</syntaxhighlight>+ contains=mwTag
syn region mwSyntaxHL
      \ start=+\ze<\z(syntaxhighlight\)\s*[^>]*>+
      \ end=+\%(</\z1>\)\@18<=+
      \ contains=mwSyntaxHLTag,mwSyntaxHLEndTag

syn match mwRefTag +<ref\%(\s[^>]*\)\?>+ contains=mwTag
syn match mwRefEndTag +</ref>+ contains=mwEndTag
syn region mwRef
      \ start=+\ze<\z(ref\)\s*[^>]*>+
      \ end=+\%(</\z1>\)\@6<=+
      \ contains=mwRefTag,mwRefEndTag

syn match mwOnlyInc /<onlyinclude>/ contains=mwTag
syn match mwOnlyIncEndTag +</onlyinclude>+ contains=mwEndTag nextgroup=mwWhitespaceErr
syn match mwNoInc /<noinclude>/ contains=mwTag
syn match mwNoIncEndTag +</noinclude>+ contains=mwEndTag nextgroup=mwWhitespaceErr
syn match mwIncOnly /<includeonly>/ contains=mwTag
syn match mwIncOnlyEndTag +</includeonly>+ contains=mwEndTag nextgroup=mwWhitespaceErr
" syn region mwIncOnly
"       \ start="<\z(includeonly\)>"
"       \ end=+\%(</\z1>\)\@11<=+
"       \ contains=mwIncOnlyTag,mwIncOnlyEndTag
syn match mwWhitespaceErr contained
      \ ".\+\ze\%(<\%(noinclude\|includeonly\|onlyinclude\)>\|\%$\)"
syn match mwWhitespaceErr "\%^\zs.\+\ze<\%(noinclude\|includeonly\|onlyinclude\)>"
" syn match mwWhitespaceWarn contained ""

"
"{{{1  Comments:

syn match mwHtmlNLComment /<!--\_s*-->/ contains=NONE
syn match mwHtmlNLCommentEnd contained /-->/ contains=NONE
" syn match mwHtmlNLComment /\%([<>! \n-]*\%#[<>! \n-]*\)\@!\&<!--\_s*-->/
" syn match mwHtmlNLCurComment /\%(\_.*\%#\)\@=\%(<!--\_s\{-}-->\)\@>\%(\%#\_.*\)\@<=/
syn match mwHtmlNLCurComment /<!--\_s*-->\&[<>!\n -]*\%#[<>!\n -]*/
" syn match mwHtmlNLCurComment /\%(.*\%#.*$\)\@<=\&<!--\_s*-->\|<!--\_s*-->\&\%(.*\%#.*$\)\@=/
" syn match mwHtmlNLCurComment /<!--\%(.*\%#.*$\)\@=\_s*-->/
" syn match mwHtmlNLCurComment /\%(.*\%#.*\)\@>\_^\s*-->/

" syn match mwHtmlNLCurComment /<!--\_s*\_^-->\ze.\{-}\%#.*/
" syn match mwHtmlNLCurComment /<!--\_s*\_^\zs\s*-->\ze.\{-}\%#.*/
syn match mwHtmlNLCurComment /\%(.*\%#.*\)\@<=\zs<!--$/ skipempty skipwhite
      \ nextgroup=mwHtmlNLCommentEnd


"{{{1  Templates: {{Flex/Row

syn region mwTl
      \ matchgroup=mwTlParens start="{{"
      \ end="}}" 
      \ contains=mwTlName,mwTlPVal,mwTlPDelim,
      \mwParFunc,mwTl,mwParam,
      \@mwComment
      \ containedin=wikiTable

syn match mwTlName /[^{|]\+\ze\%($\||\|}}\)/ 
      \ contained skipwhite skipempty
      \ contains=mwTl,mwParFunc,mwParam,mwTlPathSep,@mwComment
      \ nextgroup=mwTlPDelim
syn match mwTlPathSep +/+ contained contains=NONE

syn region mwTlPVal contained skipwhite skipempty
      \ start="\%(=\)\@1<="
      \ end="\ze\%(|\|}}\)"
      \ skip="\%({{[!=]\)\@3<=}}"
      \ contains=@htmlTop,@mwText,@mwMagic,@mwComment
      \ nextgroup=mwTlPDelim

syn region mwTlPStyleVal contained skipwhite skipempty
      \ start="\%(style\)\@5<="
      \ end="\ze\%(|\|}}\)"
      \ skip="\%({{[!=]\)\@3<=}}"
      \ contains=@htmlTop,@mwText,@mwMagic,@mwComment
      \ nextgroup=mwTlPDelim

" syn match mwTlAnonPVal /\%(|\)\@1<=\zs[^=|]\+\ze\%(|\|}}\)/
syn match mwTlAnonPVal /[^=|}]\+\ze\s*[|}]/
      \ contained skipwhite skipempty
      \ contains=@htmlTop,@mwText,@mwMagic
      \ nextgroup=mwTlPDelim

syn match mwTlPName "\%(|\)\@1<=\s*\zs[^=|}]\{-1,}\ze\s*="
      \ contained skipwhite skipempty
      \ contains=@mwComment
      \ nextgroup=mwTlPSep

" syn match mwTlPStyle "\%(|\)\@1<=\s*\zsstyle\ze\s*="
"       \ contained skipwhite skipempty
"       \ nextgroup=mwTlPSep

" syn match mwTlPNum "\%(|\)\@1<=\s*\zs\d\+\ze\s*="
syn match mwTlPNum "\d\+\ze\s*="
      \ contained skipwhite skipempty
      \ contains=@mwComment
      \ nextgroup=mwTlPSep

syn match mwTlPSep +=+ contained skipwhite skipempty
      \ nextgroup=mwTlPVal
syn match mwTlPDelim /|/ contained skipwhite skipempty
      \ nextgroup=mwTlAnonPVal,mwTlPNum,mwTlPName



"
"{{{1 Parser Functions: {{#Do|Something}}  
"

syn region mwParFunc
      \ matchgroup=mwParFuncParens start=+{{#+
      \ end="}}"me=s+2
      \ contains=mwParFuncName,mwParFuncDelim,
      \@mwText,@htmlTop,@mwComment

syn match mwParFuncName +#\@1<=[^:{|}]\+\ze:+ 
      \ contained skipwhite skipempty contains=NONE
      \ nextgroup=mwParFuncParam,mwParFuncDelim

      " \ skip=+\%({{[!=]\)\@3<=}}+
" syn region mwParFuncParam contained skipwhite skipempty 
"       \ start=+:\@1<=\||\@1<=+
"       \ end=+\ze\(|\|}}\)+
syn match mwParFuncParam /\(\_[^|}]\|\s\)*\s*/
      \ contained
      \ nextgroup=mwParFuncDelim
      \ contains=@htmlTop,@mwText,@mwMagic,@mwComment
syn match mwParFuncDelim /:\||/
      \ contained
      \ contains=NONE
      \ nextgroup=mwParFuncParam,mwParFuncDelim



"
"{{{1  Tables: {|  
"
syn match mwTableNormalCell /\(^|\|||\)\([^|]*|\)\?.*/
      \ contains=mwTableSeparator,mwTableNormalFormat,
      \mwParFunc,
      \@htmlTop,@mwText

"
"{{{1  Magic Words: __TOC__  
"

syn match mwMagicWord /__\%(NO\|FORCE\|\)TOC__/

syn match mwMagicWord /__\%(NO\)\?\%(NEWSECTIONLINK\|INDEX\)__/

syn match mwMagicWord /__NO\%(EDITSECTION\|GALLERY\|CONTENTCONVERT\|CC\|TITLECONVERT\|TC\)__/

syn match mwMagicWord /__\%(HIDDENCAT\|START\|END\|STATICREDIRECT\)__/
syn match mwMagicWord /__EXPECTUNUSED\%(CATEGORY\|EXPECTUNUSEDTEMPLATE\)__/

" syn match mwMagicWordExt /__TOC__/
" __NOGLOBAL__
" __DISAMBIG__
" __EXPECTED_UNCONNECTED_PAGE__
" __ARCHIVEDTALK__
" __NOTALK__
" __EXPECTWITHOUTSCANS__
" {{NOEXTERNALLANGLINKS}} 


"
"{{{1 Magic Variables: {{PAGENAME}}
"

syn match mwMagicChar /{{[!=]}}/

syn match mwMagicVar /{{CURRENT\%(YEAR\|MONTH\%(2\|1\|NAME\%(GEN\|\)\|ABBREV\|\)\|DAY\%(2\|NAME\|\)\|DOW\|TIME\%(STAMP\|\)\|HOUR\|WEEK\|VERSION\)}}/
syn match mwMagicVar /{{LOCAL\%(YEAR\|MONTH\|MONTH1\|MONTH2\|MONTHNAME\|MONTHNAMEGEN\|MONTHABBREV\|DAY\|DAY2\|DOW\|DAYNAME\|TIME\|HOUR\|WEEK\|TIMESTAMP\)}}/
syn match mwMagicVar /{{\%(SITENAME\|SERVER\%(NAME\|\)\|DIR\%(ECTION\)\?MARK\|\%(ARTICLE\|SCRIPT\|STYLE\)PATH\)}}/
syn match mwMagicVar /{{\%(USERLANGUAGE\|CONTENTLANG\%(UAGE\|\)\|PAGE\%(ID\|LANGUAGE\)\|TRANSLAT\%(ABLEPAGE\|IONLANGUAGE\)\)}}/
syn match mwMagicVar /{{REVISION\%(ID\|DAY\|DAY2\|MONTH\|MONTH1\|YEAR\|TIMESTAMP\|USER\|SIZE\)}}/
syn match mwMagicVar /{{NUMBEROF\%(PAGES\|ARTICLES\|FILES\|EDITS\|VIEWS\|USERS\|ADMINS\|ACTIVEUSERS\)}}/
syn match mwMagicVar /{{\%(FULL\|BASE\|SUB\|SUBJECT\|ARTICLE\|TALK\|ROOT\|\)PAGENAMEE\?}}/
syn match mwMagicVar /{{\%(NAME\|SUBJECT\|ARTICLE\|TALK\)SPACEE\?}}/
syn match mwMagicVar /{{NAMESPACENUMBER}}/


"
"{{{1 Template Parameters: ❴❴❴param❵❵❵


syn region mwParam
      \ matchgroup=mwParamParens start="{\{3}"
      \ end="}\{3}" 
      \ nextgroup=mwParamName
      \ contains=mwParamName,mwParamDefault,mwParamDelim,
      \@mwText,@mwComment,mwMagicVar

syn match mwParamName +\%({\{3}\)\@3<=[^{|}]\++ contained
syn match mwParamDefault /\%(|\)\@1<=[^{|}]\+/ contained
syn match mwParamDelim /|/ contained




" {{CASCADINGSOURCES}} expensive

" parser functions without #
" {{PROTECTIONLEVEL:action}}
" {{PROTECTIONEXPIRY:action}}

" {{DISPLAYTITLE:title}}
" {{DEFAULTSORT:sortkey}}
" {{DEFAULTSORTKEY:sortkey}}
" {{DEFAULTCATEGORYSORT:sortkey}}

" {{NUMBERINGROUP:groupname}}
" {{NUMINGROUP:groupname}}

" {{PAGESINCATEGORY:categoryname}} expensive
" {{PAGESINCAT:categoryname}} expensive
" {{PAGESINCATEGORY:categoryname|all}} expensive
" {{PAGESINCATEGORY:categoryname|pages}} expensive
" {{PAGESINCATEGORY:categoryname|subcats}} expensive
" {{PAGESINCATEGORY:categoryname|files}} expensive
" {{PAGESINNS:index}} expensive
" {{PAGESINNAMESPACE:index}}  expensive

" {{PAGEID: page name }} expensive
" {{PAGESIZE:page name}} expensive
" {{PROTECTIONLEVEL:action | page name}} expensive
" {{PROTECTIONEXPIRY: action | page name}} expensive
" {{CASCADINGSOURCES: page name}} expensive
" {{REVISIONID: page name }} expensive
" {{REVISIONDAY: page name }} expensive
" {{REVISIONDAY2: page name }} expensive
" {{REVISIONMONTH: page name }} expensive
" {{REVISIONMONTH1: page name }} expensive
" {{REVISIONYEAR: page name }} expensive
" {{REVISIONTIMESTAMP: page name }} expensive
" {{REVISIONUSER: page name }}  expensive


" {{localurl:page name}}
" {{fullurl:page name}}
" {{canonicalurl:page name}}
" {{filepath:file name}}
" {{urlencode:string}} or
" {{anchorencode:string}} 


"     {{localurle:page name}}

"     {{fullurle:page name}}

"     {{canonicalurle:page name}}



"     {{ns:2}} / {{ns:User}}








" {{formatnum:...}}

" {{#dateformat:date}}
" {{#formatdate:date}}
" {{#dateformat:date|format}}
" {{#formatdate:date|format}}

" {{lc:string}}

" {{lcfirst:string}}

" {{uc:string}}

" {{ucfirst:string}}

" {{padleft:xyz|stringlength}}
" {{padleft:xyz|strlen|char}}
" {{padleft:xyz|strlen|string}}

" {{padright:xyz|stringlength}}
" {{padright:xyz|strlen|char}}
" {{padright:xyz|strlen|string}}

" {{bidi:string}}



" {{PLURAL:...}}
" {{GRAMMAR:...}}
" {{GENDER:...}}
" {{int:...}}

" {{#language}}
" {{#language:language code}}
" {{#bcp47}}
" {{#bcp47:language code}}
" {{#dir}}
" {{#dir:language code}}


" Transclusion modifiers

" {{:xyz}}
" {{int:xyz}}
" {{msg:xyz}}
" {{raw:xyz}}
" {{raw:xyz}}
" {{msgnw:xyz}}
" {{subst:xyz}}
" {{safesubst:xyz}} 



" Misc

" {{#interwikilink:link prefix|page title|link text}}
" {{#interlanguagelink:link prefix|page title}}
" {{#special:special page name}}
" {{#speciale:special page name}}
" {{#tag:tagname |content |attribute1=value1 |attribute2=value2 }} 
"

"
" Cheerful defaults for the highlighting groups
"

hi def link mwHtmlNLComment CommentNoise
hi def link mwHtmlNLCurComment CommentHidden
hi def link mwHtmlNLCommentEnd CommentNoise


hi def mwWhitespaceErru              guibg=#551100 guisp=#ff0000 gui=undercurl

hi def mwTag           guifg=#ff4400
hi def link mwEndTag mwTag
hi def mwTagN          guifg=#ffaa44
hi def mwTagArg        guifg=#ff7777
hi def link mwTagSep mwTag
hi def link mwTagVal String
hi def link mwTagValDelim Special

hi def mwMagicVar      guifg=#dd4499 guibg=#440022 
hi def mwMagicChar     guifg=#ee1111 guibg=#440000 
hi def mwMagicWord     guifg=#ee0099 guibg=#440022 

hi def mwTlParens      guifg=#ef0099
hi def mwTlName        guifg=#cc55ff
hi def mwTlPathSep     guifg=#ef0099
hi def mwTlPDelim      guifg=#ff0099
hi def mwTlAnonPVal    guifg=#cceeff
hi def mwTlPName       guifg=#cc88ff
hi def mwTlPNum        guifg=#cc88ff
hi def mwTlPSep        guifg=#ee66cc
hi def mwTlPVal        guifg=#eeeeff

hi def mwParFunc       guifg=#0066aa
hi def mwParFuncParens guifg=#9944ee
hi def mwParFuncName   guifg=#0099ff
hi def mwParFuncParam  guifg=#00ddee
hi def mwParFuncDelim  guifg=#22ff77

hi def mwParamParens   guifg=#dd9922
hi def mwParamDelim    guifg=#dd9922
hi def mwParamName     guifg=#ffee22

hi def mwPiTagParen    guifg=#339449
hi def mwPiTagN        guifg=#aaaa33
hi def mwPiAttrs       guifg=#aa5920
hi def mwPiValue       guifg=#99bb33
hi def mwPiParens      guifg=#666666

" vim: nowrap sw=2 sts=2 ts=8 et fdm=marker:
