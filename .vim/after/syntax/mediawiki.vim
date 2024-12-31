"
" au BufWritePost <buffer> syn on
"

syn keyword wikiInfBoxTagName contained title default format panel section label data image caption alt

syn keyword wikiInfBoxAttrs contained theme source
syn match wikiInfBoxAttrs +theme-source+ contained

syn region wikiInfBoxValue contained
      \ matchgroup=wikiInfBoxParens start=+=\s\+\z(['"]\)+ end=+\z1+

syn region wikiInfBoxTag contained
      \ matchgroup=wikiInfBoxTagParen start=+<\ze[^!/]+
      \ end=+>+
      \ contains=wikiInfBoxTagName,wikiInfBoxAttrs,htmlValue

syn region wikiInfBoxEndTag contained
      \ matchgroup=wikiInfBoxTagParen start=+<\/+
      \ end=+>+
      \ contains=wikiInfBoxTagName

syn region wikiInfBoxDefault contained
      \ start=+<default[^>]*>+
      \ end=+\ze<\/default>+
      \ contains=wikiInfBoxTag,wikiInfBoxEndTag,wikiText,wikiTempl,wikiParserFunc,wikiParam,htmlTag,htmlComment

syn region wikiInfBoxFormat contained
      \ start=+<format[^>]*>+
      \ end=+\ze<\/format>+
      \ contains=wikiInfBoxTag,wikiInfBoxEndTag,wikiText,wikiTempl,wikiParserFunc,wikiParam,htmlTag,htmlComment

syn region wikiInfBoxLabel contained
      \ start=+<label[^>]*>+
      \ end=+\ze<\/label>+
      \ contains=wikiInfBoxTag,wikiInfBoxEndTag,wikiText,wikiTempl,wikiParserFunc,wikiParam,htmlTag,htmlComment,wikiLink

syn region wikiInfBox start=+<infobox\>[^>]*>+ end=+<\/infobox>+ contains=wikiInfBoxTag,wikiInfBoxEndTag,wikiInfBoxDefault,wikiInfBoxLabel,wikiInfBoxFormat,htmlComment

hi def wikiInfBoxTagParen guifg=#339449
hi def wikiInfBoxTag guifg=#699911
hi def wikiInfBoxTagName guifg=#aaaa33
hi def wikiInfBoxAttrs guifg=#aa5920
hi def wikiInfBoxValue guifg=#99bb33
hi def wikiInfBoxParens guifg=#666666

syn region wikiTempl
      \ matchgroup=wikiTemplParens start="{{"
      \ end="}}" 
      \ contains=wikiNowiki,wikiNowikiEndTag,wikiTemplName,wikiTemplParam,wikiTempl,wikiParserFunc,wikiParam,wikiLink,htmlComment,wikiMagicVar

syn match wikiTemplName +[^:]<=+ contained
syn match wikiTemplParam +[^{|}]\++ contained

syn region wikiParserFunc
      \ containedin=wikiTemplate,wikiTableFormat,wikiTableNormalCell,wikiTableHeadingCell,wikiText
      \ matchgroup=wikiParFuncParens start=+{{\ze#+ end=+}}+
      \ contains=wikiParserFunc,wikiParFuncName,wikiParFuncParam,wikiParFuncDelim,wikiParam,wikiTempl,htmlComment,wikiMagicVar

syn match wikiParFuncName +#[^:{|}]\++ contained
syn match wikiParFuncParam +\([:|]\)\@1<=[^{|}]\++ contained
syn match wikiParFuncDelim +[:|]+ contained

syn region wikiParam
      \ matchgroup=wikiParamParens start="{{{"
      \ end="}}}" 
      \ contains=wikiParamName,wikiParamDefault,wikiParamDelim,wikiParam,wikiTempl,wikiParserFunc,htmlComment,wikiMagicVar

syn match wikiParamName +\%({{{\)\@3<=[^{|}]\++ contained
syn match wikiParamDefault +\%(|\)\@1<=[^{|}]\++ contained
syn match wikiParamDelim +|+ contained

hi def wikiParamParens guifg=#ffdd22
hi def wikiParamName guifg=#ffee22
hi def wikiParamDelim guifg=#ff8822

hi def wikiTemplParens guifg=#ee99aa
hi def wikiTemplName guifg=#ff0099
hi def wikiTemplParam guifg=#9900dd
hi def wikiTemplDelim guifg=#9900dd

hi def wikiParserFunc guifg=#0066aa
hi def wikiParFuncParens guifg=#9944ee
hi def wikiParFuncName guifg=#0099ff
hi def wikiParFuncParam guifg=#00ddee
hi def wikiParFuncDelim guifg=#22ff77


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


syn match wikiEscaped /{{[!=]}}/

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
hi def wikiEscaped guibg=#440000 guifg=#ee1111
hi def wikiMagicWord guibg=#440022 guifg=#ee0099


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
