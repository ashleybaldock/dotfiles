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

let s:mdIncludePrefix = 'mdHl_'

if !exists('g:md_fenced_languages')
  let g:md_fenced_languages = []
endif
let s:included = {}
for s:type in mapnew(g:md_fenced_languages, 'matchstr(v:val, "[^=]*$")')
  if has_key(s:included, matchstr(s:type,'[^.]*'))
    continue
  endif
  if s:type =~ '\.'
    let b:{matchstr(s:type, '[^.]*')}_subtype = matchstr(s:type, '\.\zs.*')
  endif
  syn case match
  exec 'syn include @' .. s:mdIncludePrefix .. tr(s:type, '.', '_') ..
        \ ' syntax/' .. matchstr(s:type, '[^.]*') .. '.vim'
  unlet! b:current_syntax
  let s:included[matchstr(s:type, '[^.]*')] = 1
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

syn region mdEscItalic
      \ start="\\\*\ze\S"
      \ end="\%(\S\\\*\)\@3<=\ze\|^$"
      \ contains=mdEscItalicDelim,mdLineStart,@Spell,
      \mdItalic,mdBold,mdBoldItalic,mdEscBold,mdEscBoldItalic
      " \ skip="\\\\\*"

syn match mdEscItalicDelim contained
      \ "\\\*\S\@=\|\S\@1<=\\\*"
      \ contains=mdConcealedEscape

syn region mdItalic contained
      \ matchgroup=mdItalicDelim start="\z([*_]\)\ze\S"
      \ skip="\\\z1"
      \ end="\z1"
      \ concealends
      \ contains=@mdInline

syn region mdEscBold
      \ start="\\\*\\\*\S\@="
      \ end="\%(\S\\\*\\\*\)\@5<=\ze\|^$"
      \ skip="\*\|\\\\\*"
      \ contains=mdEscBoldDelimiter,mdLineStart,@Spell,mdEscBoldItalic,mdBoldItalic

syn match mdEscBoldDelim contained
      \ "\\\*\\\*\S\@=\|\S\@1<=\\\*\\\*"
      \ contains=mdConcealedEscape

syn region mdEscBoldItalic
      \ start="\\\*\\\*\\\*\S\@="
      \ end="\%(\S\\\*\\\*\\\*\)\@7<=\|^$"
      \ contains=mdEscBoldItalicDelim,mdLineStart,@Spell

syn match mdEscBoldItalicDelim contained
      \ "\\\*\\\*\\\*\S\@=\|\S\@1<=\\\*\\\*\\\*"
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

syn match mdQuotePrefix  contained +\s*>+ contains=NONE conceal cchar=┃
syn match mdAlertConceal contained +\[\!+ contains=NONE conceal cchar=◣
syn match mdAlertConceal contained +\]+ contains=NONE conceal cchar=◢

syn region mdHtmlComment concealends
      \ matchgroup=Conceal start=+<!--\s\?+
      \ matchgroup=Conceal end=+\s\?-->+
      \ containedin=mdPara,@mdInline


syn match mdListMarker contained "\%(\t\| \{0,4\}\)[-*+]\%(\s\+\S\)\@="
syn match mdOrderedListMarker contained "\%(\t\| \{0,4}\)\<\d\+\.\%(\s\+\S\)\@="


syn match mdHozRule /^\%(---\|\*\*\*\|___\)$/ contains=NONE conceal cchar=⸻
" Escaped hozRule
syn match mdEscHozRule /^\%(\\_\\\?_\\\?_\|\\\*\\\?\*\\\?\*\|\\-\\\?-\\\?-\)\s*$/
      \ contains=mdConcealedEscape
syn match mdDblEscHozRule /\%(\\\\_\%(\\\\\)\?_\%(\\\\\)\?_\|\\\\\*\%(\\\\\)\?\*\%(\\\\\)\?\*\|\\\\-\%(\\\\\)\?-\%(\\\\\)\?-\)\s*/
      \ contains=mdEscEscape

hi def mdEscHozRule guibg=#222244
hi def link mdEscChar SpecialChar

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
      \ contains=mdAlertConceal,mdAlTiNte,mdAlTiTip,mdAlTiImp,mdAlTiCtn,mdAlTiWrn
syn keyword mdAlTiNte NOTE contained
syn keyword mdAlTiTip TIP contained
syn keyword mdAlTiImp IMPORTANT contained
syn keyword mdAlTiCtn CAUTION contained
syn keyword mdAlTiWrn WARNING contained

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

syn region mdEscCode oneline keepend
      \ start="\\`\S\@="
      \ end="\%(\S\\`\)\@3<=\ze\|^$" end="\_$"
      \ skip="\\\\`"
      \ contains=mdEscCodeDelim,mdLineStart,@Spell
syn match mdEscCodeDelim
      \ "\\`\S\@=\|\S\@1<=\\`"
      \ contained
      \ contains=mdConcealedEscape


syn region mdEscCode oneline keepend
      \ start="\\`\\`\S\@="
      \ end="\%(\S\\`\\`\)\@5<=\ze\|^$" end="\_$"
      \ skip="\\\\`"
      \ contains=mdEscCodeDelim,mdLineStart,@Spell
syn match mdEscCodeDelim
      \ "\\`\\`\S\@=\|\S\@1<=\\`\\`"
      \ contained
      \ contains=mdConcealedEscape

syn region mdIdDecl matchgroup=mdLinkDelim start="^ \{0,3\}!\=\[" end="\]:" oneline keepend nextgroup=mdUrl skipwhite
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
syn match mdFootNote "\[^[^\]]\+\]"
syn match mdFtNteDef "^\[^[^\]]\+\]:"

"
" Escapes And Concealed:
"
syn match mdConcealedEscChar "\\\ze[*_~#>`-]" contains=NONE contained conceal

syn match mdEscChar "\\[*_~#>`-]" contains=NONE contained

" We heard you like escapes so we put escapes in your escapes
syn match mdConcealedEscape +\\+ contains=NONE contained conceal

syn match mdEscEscape +\\\ze\\+ contains=mdConcealedEscape contained
syn match mdDblEscChar "\\\\[*_~#>`-]" contains=mdEscEscape

"
" Code Block Syntax:
" Define languages to include automatically using:
"   let g:md_fenced_languages = ['js', 'bash']
"
let s:included = {}
for s:type in g:md_fenced_languages
  if has_key(s:included, matchstr(s:type, '[^.]*'))
    continue
  endif
  exe 'syn region'
        \ s:mdIncludePrefix .. substitute(matchstr(s:type, '[^=]*$'), '\..*', '', '')
        \ 'matchgroup=mdCodeDelim'
        \ 'start="^\s*\z(`\{3,\}\)\s*\%({.\{-}\.\)\=' .. matchstr(s:type, '[^=]*') ..
        \ '}\=\S\@!.*$"'
        \ 'end="^\s*\z1\ze\s*$" keepend'
        \ 'contains=@' .. s:mdIncludePrefix .. tr(matchstr(s:type, '[^=]*$'), '.', '_')
  exe 'syn region'
        \ s:mdIncludePrefix .. substitute(matchstr(s:type, '[^=]*$'), '\..*', '', '')
        \ 'matchgroup=mdCodeDelim'
        \ 'start="^\s*\z(\~\{3,\}\)\s*\%({.\{-}\.\)\=' .. matchstr(s:type, '[^=]*') ..
        \ '}\=\S\@!.*$"'
        \ 'end="^\s*\z1\ze\s*$" keepend'
        \ 'contains=@' .. s:mdIncludePrefix .. tr(matchstr(s:type, '[^=]*$'), '.', '_')
  let s:included[matchstr(s:type, '[^.]*')] = 1
endfor
unlet! s:type
unlet! s:included


" echo matchadd('HlMkDnCode', '\\_\\_\zsBold\ze\\_\\_')
" echo matchadd('HlMkDnCode', '\\\zs_\ze')
" echo matchadd('Conceal', '\zs\\\ze_')

"
" Highlight Definitions:
"
hi def mdAlTiNte            guifg=#4444ff
hi def mdAlTiTip            guifg=#9999ee
hi def mdAlTiImp            guifg=#ee9999
hi def mdAlTiCtn            guifg=#ee9944
hi def mdAlTiWrn            guifg=#eeee44

hi def mdH1                 guifg=#cc44cc guisp=#00cc11 gui=bold                
hi def mdH2                 guifg=#cc44cc guisp=#00cc11 gui=underline           
hi def mdH3                 guifg=#cc44cc guisp=#00cc11 gui=underdashed         
hi def mdH4                 guifg=#cc44cc guisp=#00aa11 gui=underdotted         
hi def mdH5                 guifg=#cc44cc guisp=#aa66aa gui=underdotted,italic  
hi def mdH6                 guifg=#cc44cc guisp=#aa66aa gui=italic              
hi def link mdHeadingRule mdRule
hi def link mdHeadDelim Delimiter
hi def link mdH1Delim mdHeadDelim
hi def mdH2Delim            guifg=#ff6600               gui=bold
hi def link mdH3Delim mdHeadDelim
hi def link mdH4Delim mdHeadDelim
hi def link mdH5Delim mdHeadDelim
hi def link mdH6Delim mdHeadDelim
hi def link mdListMarker htmlTagName
hi def link mdOrderedListMarker mdListMarker

hi def link mdBlockQuote Comment
hi def link mdHtmlComment CommentSubtle

hi def link mdRule PreProc

hi def link mdFootNote Typedef
hi def link mdFtNteDef Typedef

hi def link mdLinkText htmlLink
hi def mdIdDecl             guifg=#cc00ff guibg=#440000
hi def mdId                 guifg=#cc00ff guibg=#440000
hi def link mdUrl Float
hi def link mdAutoLink mdUrl
hi def link mdUrlTitle String
hi def link mdIdDelim mdLinkDelim
hi def link mdUrlDelim htmlTag
hi def link mdUrlTitleDelim Delimiter

hi def link mdItalic htmlItalic
hi def link mdItalicDelim mdItalic
hi def link mdBold htmlBold
hi def link mdBoldDelim mdBold
hi def link mdBoldItalic htmlBoldItalic
hi def link mdBoldItalicDelim mdBoldItalic
hi def link mdStrike htmlStrike
hi def link mdStrikeDelim mdStrike

hi def mdEscape             guifg=#33aa00 guibg=#061400    gui=none
hi def link mdError Error

hi def mdCodeDelim          guifg=#ffff00 guibg=NONE    gui=bold,strikethrough
hi def mdEscCode            guifg=#aaaa00 guibg=#222222
hi def mdCode               guifg=#cc88dd guibg=#391044
hi def mdCodeStart                        guibg=#391044
hi def link mdCode2 mdCode
hi def mdCodeBlock          guifg=#c9c9a3 guibg=#060606 gui=none
hi def mdCodeBlockType      guifg=#99ff99
hi def mdCodeBlockBg        guifg=NONE    guibg=#163646 gui=none
hi link mdHl_sh mdCodeBlockBg
hi link mdHl_javascript mdCodeBlockBg
hi link mdHl_typescript mdCodeBlockBg
hi link mdHl_json mdCodeBlockBg

hi def mdEscItalic                                      gui=italic
hi def mdEscItalicDelim     guibg=#440022               gui=italic,underdotted
hi def mdEscBold                                        gui=bold
hi def mdEscBoldDelim       guibg=#220044               gui=bold,underdotted
hi def mdEscBoldItalic                                  gui=bold,italic
hi def mdEscBoldItalicDelim guibg=#442200               gui=bold,italic,underdotted


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



" vim:colorcolumn=29,43,57:nolist:nowrap:
