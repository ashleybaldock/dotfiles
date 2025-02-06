"
" au BufWritePost <buffer> syn on
"


"
" Infobox Ext Tags: <infobox></infobox>
"

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
"   │           │ └─╴<default>(wikiText:yes)
"   └───────────└vv
"   │ <title>   │ │─╴<format>(wikiText:yes)
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







syn keyword wikiInfBoxTagName contained title default format panel section label data image caption alt

syn keyword wikiInfBoxAttrs contained layout name type class 
syn match wikiInfBoxAttrs /theme\%(-source\)\?/ contained
syn match wikiInfBoxAttrs /\(accent-color\%(-text\)\?\)-\(source\)\?/ contained


syn region wikiInfBoxValue contained
      \ matchgroup=wikiInfBoxParens start=+=\s\+\z(['"]\)+ end=+\z1+

syn region wikiInfBoxTag contained
      \ matchgroup=wikiInfBoxTagParen start=+<\ze[^!/]+
      \ end=+>+
      \ contains=wikiInfBoxTagName,wikiInfBoxAttrs

syn region wikiInfBoxEndTag contained
      \ matchgroup=wikiInfBoxTagParen start=+<\/+
      \ end=+>+
      \ contains=wikiInfBoxTagName

syn region wikiInfBoxDefault contained
      \ start=+<default[^>]*>+
      \ end=+\ze<\/default>+
      \ contains=wikiInfBoxTag,wikiInfBoxEndTag,wikiText,wikiTl,wikiParserFunc,wikiParam,htmlTag,htmlEndTag,htmlComment

syn region wikiInfBoxFormat contained
      \ start=+<format[^>]*>+
      \ end=+\ze<\/format>+
      \ contains=wikiInfBoxTag,wikiInfBoxEndTag,wikiText,wikiTl,wikiParserFunc,wikiParam,htmlTag,htmlEndTag,htmlComment

syn region wikiInfBoxLabel contained
      \ start=+<label[^>]*>+
      \ end=+\ze<\/label>+
      \ contains=wikiInfBoxTag,wikiInfBoxEndTag,wikiText,wikiTl,wikiParserFunc,wikiParam,htmlTag,htmlEndTag,htmlComment,wikiLink

syn region wikiInfBox start=+<infobox\>[^>]*>+ end=+<\/infobox>+ contains=wikiInfBoxTag,wikiInfBoxEndTag,wikiInfBoxDefault,wikiInfBoxLabel,wikiInfBoxFormat,htmlComment

hi def wikiInfBoxTagParen guifg=#339449
hi def wikiInfBoxTagName guifg=#aaaa33
hi def wikiInfBoxAttrs guifg=#aa5920
hi def wikiInfBoxValue guifg=#99bb33
hi def wikiInfBoxParens guifg=#666666


"
" Templates: {{Flex/Row}}
"

syn region wikiTl
      \ matchgroup=wikiTlParens start="{{"
      \ end="}}" 
      \ contains=wikiTlName,wikiTlParams,wikiTlPDelim,wikiParserFunc,wikiTl,wikiParam
      \ containedin=wikiTable

syn match wikiTlParams +[^{|}]\++ contained contains=wikiTlPVal,wikiTlPDelim

syn match wikiTlName +\%({{\)\@2<=[^|]\+\ze\%(|\|}}\)+ contained contains=wikiTlPathSep

syn region wikiTlPVal contained
      \ start="\%(|\)\@1<=\zs"
      \ end="\ze\%(|\|}}\)" contains=wikiTlPName,wikiTlPSep,wikiTl,wikiParserFunc,wikiParam,@htmlTop,@wikiText,@Magic

syn match wikiTlPName "\%(|\)\@1<=\s*\zs[^=|}]\{-1,}\ze\s*=" contained

syn match wikiTlPathSep +/+ contained
syn match wikiTlPSep +=+ contained
syn match wikiTlPDelim +|+ contained

syn cluster wikiText add=wikiTl remove=wikiTemplate

hi def wikiTlParens  guifg=#ef0099
hi def wikiTlName    guifg=#cc55ff
hi def wikiTlPDelim  guifg=#ff0099
hi def wikiTlPName   guifg=#cc88ff
hi def wikiTlPVal    guifg=#eeeeff
hi def wikiTlPSep    guifg=#aa44aa
hi def wikiTlPathSep guifg=#ef0099


"
" Parser Functions: {{#Do|Something}}
"

syn region wikiParserFunc
      \ containedin=wikiTl,wikiTableFormat,wikiTableNormalCell,wikiTableHeadingCell,wikiText
      \ matchgroup=wikiParFuncParens start=+{{\ze#+ end=+}}+
      \ contains=wikiParserFunc,wikiParFuncName,wikiParFuncParam,wikiParFuncDelim,wikiParam,wikiTl,htmlComment,@Magic

syn match wikiParFuncName +#[^:{|}]\++ contained
syn match wikiParFuncParam +\([:|]\)\@1<=[^{|}]\++ contained
syn match wikiParFuncDelim +[:|]+ contained

syn cluster wikiText add=wikiParserFunc

hi def wikiParserFunc guifg=#0066aa
hi def wikiParFuncParens guifg=#9944ee
hi def wikiParFuncName guifg=#0099ff
hi def wikiParFuncParam guifg=#00ddee
hi def wikiParFuncDelim guifg=#22ff77


"
" Parameters: {{{param}}}
"

syn region wikiParam
      \ matchgroup=wikiParamParens start="{{{"
      \ end="}}}" 
      \ contains=wikiParamName,wikiParamDefault,wikiParamDelim,wikiParam,wikiTl,wikiParserFunc,htmlComment,wikiMagicVar

syn match wikiParamName +\%({{{\)\@3<=[^{|}]\++ contained
syn match wikiParamDefault +\%(|\)\@1<=[^{|}]\++ contained
syn match wikiParamDelim +|+ contained

syn cluster wikiText add=wikiTl remove=wikiTemplateParam

hi def wikiParamParens guifg=#dd9922
hi def wikiParamDelim guifg=#dd9922
hi def wikiParamName guifg=#ffee22


syn match wikiTableNormalCell /\(^|\|||\)\([^|]*|\)\?.*/ contains=wikiTableSeparator,@wikiText,wikiTableNormalFormat,@htmlTop

"
" Magic Words: __TOC__
"

syn match wikiMagicWord /__\%(NO\|FORCE\|\)TOC__/

syn match wikiMagicWord /__\%(NO\)\?\%(NEWSECTIONLINK\|INDEX\)__/

syn match wikiMagicWord /__NO\%(EDITSECTION\|GALLERY\|CONTENTCONVERT\|CC\|TITLECONVERT\|TC\)__/

syn match wikiMagicWord /__\%(HIDDENCAT\|START\|END\|STATICREDIRECT\)__/
syn match wikiMagicWord /__EXPECTUNUSED\%(CATEGORY\|EXPECTUNUSEDTEMPLATE\)__/

" syn match wikiMagicWordExt /__TOC__/
" __NOGLOBAL__
" __DISAMBIG__
" __EXPECTED_UNCONNECTED_PAGE__
" __ARCHIVEDTALK__
" __NOTALK__
" __EXPECTWITHOUTSCANS__
" {{NOEXTERNALLANGLINKS}} 


"
" Magic Variables: {{{PAGENAME}}}
"

syn match wikiMagicChar /{{[!=]}}/

syn match wikiMagicVar /{{CURRENT\%(YEAR\|MONTH\%(2\|1\|NAME\%(GEN\|\)\|ABBREV\|\)\|DAY\%(2\|NAME\|\)\|DOW\|TIME\%(STAMP\|\)\|HOUR\|WEEK\|VERSION\)}}/
syn match wikiMagicVar /{{LOCAL\%(YEAR\|MONTH\|MONTH1\|MONTH2\|MONTHNAME\|MONTHNAMEGEN\|MONTHABBREV\|DAY\|DAY2\|DOW\|DAYNAME\|TIME\|HOUR\|WEEK\|TIMESTAMP\)}}/
syn match wikiMagicVar /{{\%(SITENAME\|SERVER\%(NAME\|\)\|DIR\%(ECTION\)\?MARK\|\%(ARTICLE\|SCRIPT\|STYLE\)PATH\)}}/
syn match wikiMagicVar /{{\%(USERLANGUAGE\|CONTENTLANG\%(UAGE\|\)\|PAGE\%(ID\|LANGUAGE\)\|TRANSLAT\%(ABLEPAGE\|IONLANGUAGE\)\)}}/
syn match wikiMagicVar /{{REVISION\%(ID\|DAY\|DAY2\|MONTH\|MONTH1\|YEAR\|TIMESTAMP\|USER\|SIZE\)}}/
syn match wikiMagicVar /{{NUMBEROF\%(PAGES\|ARTICLES\|FILES\|EDITS\|VIEWS\|USERS\|ADMINS\|ACTIVEUSERS\)}}/
syn match wikiMagicVar /{{\%(FULL\|BASE\|SUB\|SUBJECT\|ARTICLE\|TALK\|ROOT\|\)PAGENAMEE\?}}/
syn match wikiMagicVar /{{\%(NAME\|SUBJECT\|ARTICLE\|TALK\)SPACEE\?}}/
syn match wikiMagicVar /{{NAMESPACENUMBER}}/

hi def wikiMagicVar guibg=#440022 guifg=#dd4499
hi def wikiMagicChar guibg=#440000 guifg=#ee1111
hi def wikiMagicWord guibg=#440022 guifg=#ee0099

syn cluster Magic add=wikiMagicVar,wikiMagicChar,wikiMagicWord


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
