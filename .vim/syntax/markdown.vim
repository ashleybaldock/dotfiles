"
" Markdown syntax++
"
" au BufWritePost <buffer> syn on
"
" See Also: 
"  $VIMRUNTIME/syntax/markdown.vim
"     ../after/syntax/markdown.vim
"     ../after/ftplugin/markdown.vim
" Test Doc:
"          ../demo/markdown.md
"

if exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'markdown'
endif

if has('folding')
  let s:foldmethod = &l:foldmethod
  let s:foldtext = &l:foldtext
endif
let s:iskeyword = &l:iskeyword

runtime! syntax/html.vim
unlet! b:current_syntax


if !exists('g:md_fenced_languages')
  let g:md_fenced_languages = []
endif
let s:included = {}
for s:type in mapnew(g:md_fenced_languages, 'matchstr(v:val,"[^=]*$")')
  if has_key(s:included, matchstr(s:type,'[^.]*'))
    continue
  endif
  if s:type =~ '\.'
    let b:{matchstr(s:type,'[^.]*')}_subtype = matchstr(s:type,'\.\zs.*')
  endif
  syn case match
  exec 'syn include @mdHighlight_' .. tr(s:type,'.','_') ..
        \ ' syntax/' .. matchstr(s:type,'[^.]*') .. '.vim'
  unlet! b:current_syntax
  let s:included[matchstr(s:type,'[^.]*')] = 1
endfor
unlet! s:type
unlet! s:included

syn spell toplevel
if exists('s:foldmethod') && s:foldmethod !=# &l:foldmethod
  let &l:foldmethod = s:foldmethod
  unlet s:foldmethod
endif
if exists('s:foldtext') && s:foldtext !=# &l:foldtext
  let &l:foldtext = s:foldtext
  unlet s:foldtext
endif
if s:iskeyword !=# &l:iskeyword
  let &l:iskeyword = s:iskeyword
endif
unlet s:iskeyword

if !exists('g:md_minlines')
  let g:md_minlines = 50
endif
exec 'syn sync minlines=' .. g:md_minlines
syn sync linebreaks=1
syn case ignore

syn match mdEscape "\\[][\\`*_{}()<>#+.!-]"

" Escaped H1-H6
syn match mdEscape /\\#\%(\\\?#\)\{,5}/ contains=NONE

syn match mdError "\w\@<=_\w\@="
syn match mdValid '[<>]\c[a-z/$!]\@!' transparent contains=NONE
syn match mdValid '&\%(#\=\w*;\)\@!' transparent contains=NONE

syn match mdLineStart "^[<@]\@!" nextgroup=@mdBlock,htmlSpecialChar

syn cluster mdBlock contains=mdH1,mdH2,mdH3,mdH4,mdH5,mdH6,mdBlockQuote,mdListMarker,mdOrderedListMarker,mdCodeBlock,mdRule,mdPara
syn cluster mdInline contains=mdLineBreak,mdLinkText,mdItalic,mdBold,mdCode,mdEscape,@htmlTop,mdError,mdValid

syn region mdPara contained keepend
      \ start=+^+ 
      \ skip=+<br\s*/\?>\n+
      \ end=+$+ contains=@mdInline

syn match mdH1 "^.\+\n=\+$" contained contains=@mdInline,mdHeadingRule,mdAutoLink
syn match mdH2 "^.\+\n-\+$" contained contains=@mdInline,mdHeadingRule,mdAutoLink

syn match mdHeadingRule "^[=-]\+$" contained

syn region mdH1 matchgroup=mdH1Delim start="^\s*#\s"      end="#*\s*$" keepend oneline contains=@mdInline,mdAutoLink contained concealends
syn region mdH2 matchgroup=mdH2Delim start="^\s*##\s"     end="#*\s*$" keepend oneline contains=@mdInline,mdAutoLink contained concealends
syn region mdH3 matchgroup=mdH3Delim start="^\s*###\s"    end="#*\s*$" keepend oneline contains=@mdInline,mdAutoLink contained concealends
syn region mdH4 matchgroup=mdH4Delim start="^\s*####\s"   end="#*\s*$" keepend oneline contains=@mdInline,mdAutoLink contained concealends
syn region mdH5 matchgroup=mdH5Delim start="^\s*#####\s"  end="#*\s*$" keepend oneline contains=@mdInline,mdAutoLink contained concealends
syn region mdH6 matchgroup=mdH6Delim start="^\s*######\s" end="#*\s*$" keepend oneline contains=@mdInline,mdAutoLink contained concealends


" syn match mdEscape "\\\~"

syn match mdLineBreak " \{2,\}$" conceal cchar=⏎️

syn match mdNewPara "$"

syn region mdEscapedItalic
      \ start="\\\*\ze\S"
      \ end="\%(\S\\\*\)\@3<=\ze\|^$"
      \ contains=mdEscapedItalicDelim,mdLineStart,@Spell,
      \mdItalic,mdBold,mdBoldItalic,mdEscapedBold,mdEscapedBoldItalic
      " \ skip="\\\\\*"

syn match mdEscapedItalicDelim
      \ "\\\*\S\@=\|\S\@1<=\\\*"
      \ contained
      \ contains=mdConcealedEscape

syn region mdItalic contained
      \ matchgroup=mdItalicDelim start="\z([*_]\)\ze\S"
      \ skip="\\\z1"
      \ end="\z1"
      \ concealends
      \ contains=@mdInline

syn region mdEscapedBold
      \ start="\\\*\\\*\S\@="
      \ end="\%(\S\\\*\\\*\)\@5<=\ze\|^$"
      \ skip="\*\|\\\\\*"
      \ contains=mdEscapedBoldDelimiter,mdLineStart,@Spell,mdEscapedBoldItalic,mdBoldItalic

syn match mdEscapedBoldDelim
      \ "\\\*\\\*\S\@=\|\S\@1<=\\\*\\\*"
      \ contained
      \ contains=mdConcealedEscape

syn region mdEscapedBoldItalic
      \ start="\\\*\\\*\\\*\S\@="
      \ end="\%(\S\\\*\\\*\\\*\)\@7<=\|^$"
      \ contains=mdEscapedBoldItalicDelim,mdLineStart,@Spell

syn match mdEscapedBoldItalicDelim
      \ "\\\*\\\*\\\*\S\@=\|\S\@1<=\\\*\\\*\\\*"
      \ contained
      \ contains=mdConcealedEscape


syn region mdQuoteMulti
      \ start=+^>+
      \ end=+\ze\n[^>]+
      \ contains=mdQuotePrefix,mdQuoteLine

syn region mdQuoteLine contained
      \ start=+\s\?>\ze\s+
      \ end=+\ze$+
      \ contains=mdQuotePrefix
      \ nextgroup=mdQuoteLine

syn match mdQuotePrefix  +\s*>+ contained contains=NONE conceal cchar=┃
syn match mdAlertConceal +\[\!+ contained contains=NONE conceal cchar=◣
syn match mdAlertConceal +\]+ contained contains=NONE conceal cchar=◢

syn region mdHtmlComment concealends
      \ matchgroup=Conceal start=+<!--\s\?+
      \ matchgroup=Conceal end=+\s\?-->+
      \ containedin=mdPara,@mdInline


syn match mdListMarker "\%(\t\| \{0,4\}\)[-*+]\%(\s\+\S\)\@=" contained
syn match mdOrderedListMarker "\%(\t\| \{0,4}\)\<\d\+\.\%(\s\+\S\)\@=" contained


syn match mdHozRule /^\%(---\|\*\*\*\|___\)$/ contains=NONE conceal cchar=⸻
" Escaped hozRule
syn match mdEscapedHozRule /^\%(\\_\\\?_\\\?_\|\\\*\\\?\*\\\?\*\|\\-\\\?-\\\?-\)\s*$/
      \ contains=mdConcealedEscape
syn match mdDblEscapedHozRule /\%(\\\\_\%(\\\\\)\?_\%(\\\\\)\?_\|\\\\\*\%(\\\\\)\?\*\%(\\\\\)\?\*\|\\\\-\%(\\\\\)\?-\%(\\\\\)\?-\)\s*/
      \ contains=mdEscapedEscape

hi def mdEscapedHozRule guibg=#222244
hi def link mdEscapedChar SpecialChar

syn region mdAlert
      \ start=+^>\s*\[!\%(NOTE\|TIP\|IMPORTANT\|WARNING\|CAUTION\)\]+
      \ end=+^[^>]\|^$+
      \ contains=mdQuotePrefix,mdAlertTitle
syn region mdAlertTip
      \ start=+^>\s*\ze\[!TIP\]+
      \ end=+^[^>]\|^$+
      \ contains=mdQuotePrefix,mdAlertTitle
syn region mdAlertImport
      \ start=+^>\s*\ze\[!IMPORTANT\]+
      \ end=+^[^>]\|^$+
      \ contains=mdQuotePrefix,mdAlertTitle
syn region mdAlertWarning
      \ start=+^>\s*\ze\[!WARNING\]+
      \ end=+^[^>]\|^$+
      \ contains=mdQuotePrefix,mdAlertTitle
syn region mdAlertCaution
      \ start=+^>\s*\ze\[!CAUTION\]+
      \ end=+^[^>]\|^$+
      \ contains=mdQuotePrefix,mdAlertTitle

syn region mdAlertTitle contained keepend
      \ start=+\[\!+ 
      \ end=+\]+
      \ contains=mdAlertConceal,mdAlertTitleNote,mdAlertTitleTip,
      \mdAlertTitleImp,mdAlertTitleWarn,mdAlertTitleCaution

syn keyword mdAlertTitleNote NOTE contained
syn keyword mdAlertTitleTip TIP contained
syn keyword mdAlertTitleImp IMPORTANT contained
syn keyword mdAlertTitleCaution CAUTION contained
syn keyword mdAlertTitleWarn WARNING contained

" call matchadd('HlMkDnCode', '\(\(\\[*_~`]\)\2*\).\+\1')
" call matchadd('HlMkDnCode', '\\\zs[*_~(]\ze')
" call matchadd('Conceal', '\zs\\\ze[*_~(]')

" call matchadd('HlMkDnCode', '\(\(\\[`]\)\2*\).\+\1')
" echo matchadd('Conceal', '\(\(\\\)\@!\zs\(\`\)\ze\2*\).\+\1')
" call matchadd('Conceal', '\zs\\\ze[`]')
" call matchadd('Conceal', '`')

syn match mdCodeStart  /\\\@1<!`/  conceal cchar=⎥ contains=NONE contained
syn match mdCodeEnd    /\\\@1<!`/  conceal cchar=⎢ contains=NONE contained
syn match mdCode2Start /\\\@1<!``/ conceal cchar=⎥ contains=NONE contained
syn match mdCode2End   /\\\@1<!``/ conceal cchar=⎢ contains=NONE contained

syn region mdCode oneline keepend
      \ start="`"
      \ skip="\\`"
      \ end="\ze`" end="\_$"
      \ contains=mdCodeStart
      \ nextgroup=mdCodeEnd
syn region mdCode oneline keepend
      \ start="``"
      \ end="\ze``" end="\_$"
      \ contains=mdCode2Start
      \ nextgroup=mdCode2End

syn region mdCodeBlock
      \ start=+^\s*\z(\~\{3,\}\).*$+
      \ end=+^\s*\z1\ze\s*$+
syn region mdCodeBlock 
      \ start=+^\s*\ze\z(`\{3,\}\).*$+
      \ end=+^\s\(\z1\)\@3<=\ze\s*$+
syn region mdCodeBlock keepend
      \ matchgroup=mdCodeBlockDelim start="^\s*\z(`\{3,\}\)\ze[^`]*$"
      \ end="^\s*\z1\ze\s*$"
      \ contains=mdCodeBlockType
syn region mdCodeBlock keepend
      \ matchgroup=mdCodeBlockDelim start="^\s*\z(\~\{3,\}\)\ze[^~]*$"
      \ end="^\s*\z1\ze\s*$"
      \ contains=mdCodeBlockType

syn match mdCodeBlockType /\%(```\)\@3<=[^`]\+$/ contained contains=NONE
" syn match mdCodeBlockDelim /^````\?\ze[^`]/ contained conceal
"       \ containedin=mdCodeBlock contains=mdCodeBlockType 

syn region mdEscapedCode oneline keepend
      \ start="\\`\S\@="
      \ end="\%(\S\\`\)\@3<=\ze\|^$" end="\_$"
      \ skip="\\\\`"
      \ contains=mdEscapedCodeDelim,mdLineStart,@Spell
syn match mdEscapedCodeDelim
      \ "\\`\S\@=\|\S\@1<=\\`"
      \ contained
      \ contains=mdConcealedEscape


syn region mdEscapedCode oneline keepend
      \ start="\\`\\`\S\@="
      \ end="\%(\S\\`\\`\)\@5<=\ze\|^$" end="\_$"
      \ skip="\\\\`"
      \ contains=mdEscapedCodeDelim,mdLineStart,@Spell
syn match mdEscapedCodeDelim
      \ "\\`\\`\S\@=\|\S\@1<=\\`\\`"
      \ contained
      \ contains=mdConcealedEscape

syn region mdIdDeclaration matchgroup=mdLinkDelim start="^ \{0,3\}!\=\[" end="\]:" oneline keepend nextgroup=mdUrl skipwhite
syn match mdUrl "\S\+" nextgroup=mdUrlTitle skipwhite contained
syn region mdUrl matchgroup=mdUrlDelim start="<" end=">" oneline keepend nextgroup=mdUrlTitle skipwhite contained
syn region mdUrlTitle matchgroup=mdUrlTitleDelim start=+"+ end=+"+ keepend contained
syn region mdUrlTitle matchgroup=mdUrlTitleDelim start=+'+ end=+'+ keepend contained
syn region mdUrlTitle matchgroup=mdUrlTitleDelim start=+(+ end=+)+ keepend contained

syn region mdLinkText matchgroup=mdLinkTextDelim start="!\=\[\%(\_[^][]*\%(\[\_[^][]*\]\_[^][]*\)*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" nextgroup=mdLink,mdId skipwhite contains=@mdInline,mdLineStart
syn region mdLink matchgroup=mdLinkDelim start="(" end=")" contains=mdUrl keepend contained
syn region mdId matchgroup=mdIdDelim start="\[" end="\]" keepend contained
syn region mdAutoLink matchgroup=mdUrlDelim start="<\%(\w\+:\|[[:alnum:]_+-]\+@\)\@=" end=">" keepend oneline




" Footnotes:
syn match mdFootnote "\[^[^\]]\+\]"
syn match mdFootnoteDefinition "^\[^[^\]]\+\]:"

"
" Escapes And Concealed:
"
syn match mdConcealedEscapedChar "\\\ze[*_~#>`-]" contains=NONE contained conceal

syn match mdEscapedChar "\\[*_~#>`-]" contains=NONE contained

" We heard you like escapes so we put escapes in your escapes
syn match mdConcealedEscape +\\+ contains=NONE contained conceal

syn match mdEscapedEscape +\\\ze\\+ contains=mdConcealedEscape contained
syn match mdDblEscapedChar "\\\\[*_~#>`-]" contains=mdEscapedEscape

"
" Code Block Syntax:
" Define languages to include automatically using:
"   let g:md_fenced_languages = ['js', 'bash']
"
let s:included = {}
for s:type in g:md_fenced_languages
  if has_key(s:included, matchstr(s:type,'[^.]*'))
    continue
  endif
  exe 'syn region mdHighlight_' ..
        \ substitute(matchstr(s:type,'[^=]*$'),'\..*','','') ..
        \ ' matchgroup=mdCodeDelim start="^\s*\z(`\{3,\}\)\s*\%({.\{-}\.\)\=' ..
        \ matchstr(s:type,'[^=]*') ..
        \ '}\=\S\@!.*$" end="^\s*\z1\ze\s*$" keepend contains=@mdHighlight_' ..
        \ tr(matchstr(s:type,'[^=]*$'),'.','_')
  exe 'syn region mdHighlight_' ..
        \ substitute(matchstr(s:type,'[^=]*$'),'\..*','','') ..
        \ ' matchgroup=mdCodeDelim start="^\s*\z(\~\{3,\}\)\s*\%({.\{-}\.\)\=' ..
        \ matchstr(s:type,'[^=]*') ..
        \ '}\=\S\@!.*$" end="^\s*\z1\ze\s*$" keepend contains=@mdHighlight_' ..
        \ tr(matchstr(s:type,'[^=]*$'),'.','_')
  let s:included[matchstr(s:type,'[^.]*')] = 1
endfor
unlet! s:type
unlet! s:included


" echo matchadd('HlMkDnCode', '\\_\\_\zsBold\ze\\_\\_')
" echo matchadd('HlMkDnCode', '\\\zs_\ze')
" echo matchadd('Conceal', '\zs\\\ze_')

"
" Highlight Definitions:
"
hi def mdAlertTitleNote    guifg=#4444ff
hi def mdAlertTitleTip     guifg=#9999ee
hi def mdAlertTitleImp     guifg=#ee9999
hi def mdAlertTitleWarn    guifg=#ee9944
hi def mdAlertTitleCaution guifg=#eeee44

hi def mdH1                guifg=#cc44cc guisp=#00cc11 gui=bold                
hi def mdH2                guifg=#cc44cc guisp=#00cc11 gui=underline           
hi def mdH3                guifg=#cc44cc guisp=#00cc11 gui=underdashed         
hi def mdH4                guifg=#cc44cc guisp=#00aa11 gui=underdotted         
hi def mdH5                guifg=#cc44cc guisp=#aa66aa gui=underdotted,italic  
hi def mdH6                guifg=#cc44cc guisp=#aa66aa gui=italic              
hi def link mdHeadingRule mdRule
hi def link mdHeadDelim Delimiter
hi def link mdH1Delim mdHeadDelim
hi def mdH2Delim           guifg=#ff6600               gui=bold
hi def link mdH3Delim mdHeadDelim
hi def link mdH4Delim mdHeadDelim
hi def link mdH5Delim mdHeadDelim
hi def link mdH6Delim mdHeadDelim
hi def link mdListMarker htmlTagName
hi def link mdOrderedListMarker mdListMarker

hi def link mdBlockQuote Comment
hi def link mdHtmlComment CommentSubtle

hi def link mdRule                  PreProc

hi def link mdFootnote              Typedef
hi def link mdFootnoteDefinition    Typedef

hi def link mdLinkText              htmlLink
hi def mdIdDeclaration  guifg=#cc00ff guibg=#440000
hi def mdId             guifg=#cc00ff guibg=#440000
hi def link mdAutoLink              mdUrl
hi def link mdUrl                   Float
hi def link mdUrlTitle              String
hi def link mdIdDelim               mdLinkDelim
hi def link mdUrlDelim              htmlTag
hi def link mdUrlTitleDelim         Delimiter

hi def link mdItalic                htmlItalic
hi def link mdItalicDelim           mdItalic
hi def link mdBold                  htmlBold
hi def link mdBoldDelim             mdBold
hi def link mdBoldItalic            htmlBoldItalic
hi def link mdBoldItalicDelim       mdBoldItalic
hi def link mdStrike                htmlStrike
hi def link mdStrikeDelim           mdStrike

hi def link mdEscape                Special
hi def link mdError                 Error

hi def mdCodeDelim      guifg=#ffff00 guibg=NONE    gui=bold,strikethrough
hi def mdEscapedCode    guifg=#aaaa00 guibg=#222222
hi mdCode               guifg=#cc88dd guibg=#391044
hi mdCodeStart                        guibg=#391044
hi def link mdCode2 mdCode
hi def mdCodeBlock      guifg=#c9c9a3 guibg=#060606 gui=none
hi def mdCodeBlockType  guifg=#99ff99
hi def mdEscapedItalic                              gui=italic
hi def mdEscapedItalicDelim           guibg=#440022 gui=italic,underdotted
hi def mdEscapedBold                                gui=bold
hi def mdEscapedBoldDelim             guibg=#220044 gui=bold,underdotted
hi def mdEscapedBoldItalic                          gui=bold,italic
hi def mdEscapedBoldItalicDelim       guibg=#442200 gui=bold,italic,underdotted


silent call prop_type_delete('p')
silent call prop_type_add('p', #{
      \ highlight: 'Delimiter',
      \ combine: v:true,
      \ })
silent call prop_type_delete('hr')
silent call prop_type_add('hr', #{
      \ highlight: 'Delimiter',
      \ combine: v:false,
      \ })
call prop_add(21, 0, #{
      \ type: 'p',
      \ text: '¶',
      \ text_align: 'after',
      \ text_padding_left: 0,
      \ })
call prop_add(5, 0, #{
      \ type: 'p',
      \ text: '╺━━━━━━━━━━━━━━━━━━━━━━━╸',
      \ text_align: 'after',
      \ text_padding_left: 0,
      \ })
call prop_add(17, 0, #{
      \ type: 'p',
      \ text: '╺━━━━━━━━━━━━━━━━━━━━━━━╸',
      \ text_align: 'after',
      \ text_padding_left: 0,
      \ })

function! s:OnBufferChanged(bufnr, start, end, added, s)
  call prop_remove(#{types: ['p', 'hr']}, a:start, a:end)

  " call prop_add_list()
endfunc

call listener_add('s:OnBufferChanged', bufnr())


let b:current_syntax = "markdown"
if main_syntax ==# 'markdown'
  unlet main_syntax
endif
