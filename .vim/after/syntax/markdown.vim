"
" Additions to markdown formatting
"
" au BufWritePost <buffer> syn on
"
" See Also: 
"  $VIMRUNTIME/syntax/markdown.vim
" Test Doc:
"          ../../demo/markdown.md
"


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
  exe 'syn include @mdHighlight_' .. tr(s:type,'.','_') ..
        \ ' syntax/' .. matchstr(s:type,'[^.]*') ..'.vim'
  unlet! b:current_syntax
  let s:included[matchstr(s:type,'[^.]*')] = 1
endfor
unlet! s:type
unlet! s:included

" syn match markdownEscape "\\\~"

syn match markdownLineBreak " \{2,\}$" conceal cchar=⏎️

syn match mdNewPara "$"

syn region markdownH1 matchgroup=markdownH1Delimiter start=" \{,3}#\s"      end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained concealends
syn region markdownH2 matchgroup=markdownH2Delimiter start=" \{,3}##\s"     end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained concealends
syn region markdownH3 matchgroup=markdownH3Delimiter start=" \{,3}###\s"    end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained concealends
syn region markdownH4 matchgroup=markdownH4Delimiter start=" \{,3}####\s"   end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained concealends
syn region markdownH5 matchgroup=markdownH5Delimiter start=" \{,3}#####\s"  end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained concealends
syn region markdownH6 matchgroup=markdownH6Delimiter start=" \{,3}######\s" end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained concealends

syn region mdEscapedItalic
      \ start="\\\*\S\@="
      \ end="\%(\S\\\*\)\@3<=\ze\|^$"
      \ contains=mdEscapedItalicDelimiter,markdownLineStart,@Spell,mdEscapedBoldItalic,markdownBoldItalic
      " \ skip="\\\\\*"

syn match mdEscapedItalicDelimiter
      \ "\\\*\S\@=\|\S\@1<=\\\*"
      \ contained
      \ contains=mdConcealedEscape


syn region mdEscapedBold
      \ start="\\\*\\\*\S\@="
      \ end="\%(\S\\\*\\\*\)\@5<=\ze\|^$"
      \ skip="\*\|\\\\\*"
      \ contains=mdEscapedBoldDelimiter,markdownLineStart,@Spell,mdEscapedBoldItalic,markdownBoldItalic

syn match mdEscapedBoldDelimiter
      \ "\\\*\\\*\S\@=\|\S\@1<=\\\*\\\*"
      \ contained
      \ contains=mdConcealedEscape

syn region mdEscapedBoldItalic
      \ start="\\\*\\\*\\\*\S\@="
      \ end="\%(\S\\\*\\\*\\\*\)\@7<=\|^$"
      \ contains=mdEscapedBoldItalicDelimiter,markdownLineStart,@Spell

syn match mdEscapedBoldItalicDelimiter
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
      \ containedin=markdownBold,markdownItalic,markdownBoldItalic,mdEscaped

hi def mdHtmlComment guifg=#999999 gui=italic


syn match mdConcealedEscapedChar "\\\ze[*_~#>`-]" contains=NONE contained conceal

syn match mdEscapedChar "\\[*_~#>`-]" contains=NONE contained

" We heard you like escapes so we put escapes in your escapes
syn match mdConcealedEscape +\\+ contains=NONE contained conceal

syn match mdEscapedEscape +\\\ze\\+ contains=mdConcealedEscape contained
syn match mdDblEscapedChar "\\\\[*_~#>`-]" contains=mdEscapedEscape

" Escaped H1-H6
syn match mdEscapedChar /\\#\%(\\\?#\)\{,5}/ contains=NONE

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
      \ contains=mdAlertConceal,mdAlertTitleNote,mdAlertTitleTip,mdAlertTitleImp,mdAlertTitleWarn,mdAlertTitleCaution

syn keyword mdAlertTitleNote NOTE contained
syn keyword mdAlertTitleTip TIP contained
syn keyword mdAlertTitleImp IMPORTANT contained
syn keyword mdAlertTitleCaution CAUTION contained
syn keyword mdAlertTitleWarn WARNING contained

hi def mdAlertTitleNote guifg=#4444ff
hi def mdAlertTitleTip guifg=#9999ee
hi def mdAlertTitleImp guifg=#ee9999
hi def mdAlertTitleWarn guifg=#ee9944
hi def mdAlertTitleCaution guifg=#eeee44

" call matchadd('HlMkDnCode', '\(\(\\[*_~`]\)\2*\).\+\1')
" call matchadd('HlMkDnCode', '\\\zs[*_~(]\ze')
" call matchadd('Conceal', '\zs\\\ze[*_~(]')

" call matchadd('HlMkDnCode', '\(\(\\[`]\)\2*\).\+\1')
" echo matchadd('Conceal', '\(\(\\\)\@!\zs\(\`\)\ze\2*\).\+\1')
" call matchadd('Conceal', '\zs\\\ze[`]')
" call matchadd('Conceal', '`')

syn match mdCodeStart /\\\@1<!`/ conceal cchar=⎥ contains=NONE contained
syn match mdCodeEnd /\\\@1<!`/ conceal   cchar=⎢ contains=NONE contained
syn match mdCode2Start /\\\@1<!``/ conceal cchar=⎥ contains=NONE contained
syn match mdCode2End /\\\@1<!``/ conceal cchar=⎢ contains=NONE contained

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
      \ contains=mdEscapedCodeDelimiter,markdownLineStart,@Spell
syn match mdEscapedCodeDelimiter
      \ "\\`\S\@=\|\S\@1<=\\`"
      \ contained
      \ contains=mdConcealedEscape


syn region mdEscapedCode oneline keepend
      \ start="\\`\\`\S\@="
      \ end="\%(\S\\`\\`\)\@5<=\ze\|^$" end="\_$"
      \ skip="\\\\`"
      \ contains=mdEscapedCodeDelimiter,markdownLineStart,@Spell
syn match mdEscapedCodeDelimiter
      \ "\\`\\`\S\@=\|\S\@1<=\\`\\`"
      \ contained
      \ contains=mdConcealedEscape


syn match mdFootnote "\[^[^\]]\+\]"
syn match mdFootnoteDefinition "^\[^[^\]]\+\]:"

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
hi def mdEscapedCode guifg=#aaaa00 guibg=#222222
hi mdCode guifg=#cc88dd guibg=#391044
hi mdCodeStart guibg=#391044
hi def link mdCode2 mdCode
hi mdCodeBlock guifg=#cc6688 guibg=#222222
hi def mdCodeBlockType guifg=#99ff99
hi def mdEscapedItalic gui=italic
hi def mdEscapedItalicDelimiter guibg=#440022 gui=italic,underdotted
hi def mdEscapedBold gui=bold
hi def mdEscapedBoldDelimiter guibg=#220044 gui=bold,underdotted
hi def mdEscapedBoldItalic gui=bold,italic
hi def mdEscapedBoldItalicDelimiter guibg=#442200 gui=bold,italic,underdotted

hi def link mdCodeDelim Delimiter


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
