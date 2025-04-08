"
" Additions to markdown formatting
"
" au BufWritePost <buffer> syn on
"
syn match markdownEscape "\\\~"

syn match markdownLineBreak " \{2,\}$" conceal cchar=⏎️

syn match mdNewPara "$"


" syn region mdEscapedItalicText start="\\\*\zs\S\@=" end="\S\ze\@<=\\\*\|^$" oneline contained contains=mdEscapedItalicDelimiter,markdownLineStart,@Spell

" syn region mdEscapedItalic start="\\_" end="\\_" oneline contains=mdEscapedItalicDelimiter

syn region mdEscapedItalic
      \ matchgroup=mdEscapedItalicDelimiter
      \ start="\\\*\S\@="
      \ end="\S\@<=\\\*\|^$"
      \ contains=mdEscapedItalicDelimiter,markdownLineStart,@Spell

syn match mdEscapedItalicDelimiter
      \ "\\\*"
      \ contained
      \ contains=mdConcealedEscape

" syn region mdEscapedBold start="\\\*\\\*\S\@=" end="\S\@<=\\\*\\\*" oneline contains=mdConcealedEscape,mdEscapedItalic

" syn region mdEscapedBold start="\\_\\_\S\@=" end="\S\@<=\\_\\_" oneline contains=mdConcealedEscape,mdEscapedItalic

" syn region mdEscapedCode matchgroup=mdEscapedDelimiter start="\(\(\\[*_~`]\)\2*\).\+\1" end="\\[*_~`]" oneline

hi def mdEscapedCode guifg=#aaaa00 guibg=#222222
hi def mdEscapedItalicText guifg=#dddddd guibg=#333333
hi def mdEscapedItalicDelimiter guifg=#dddd55 guibg=#288200
hi def mdEscapedBold guifg=#dddddd guibg=#333333
hi def mdEscapedBoldDelimiter guifg=#dd5555 guibg=#222222

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

syn match mdConcealedEscape "\\" conceal

syn region mdHtmlComment concealends
      \ matchgroup=Conceal start=+<!--\s\?+
      \ matchgroup=Conceal end=+\s\?-->+
      \ containedin=markdownBold,markdownItalic,markdownBoldItalic

hi def mdHtmlComment guifg=#999999 gui=italic

syn match mdHozRule +^\%(---\|\*\*\*\|___\)$+ contains=NONE

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





" echo matchadd('HlMkDnCode', '\\\([_*]\)\\\0\zs.\+\ze\\\0\\\0')
" echo matchadd('HlMkDnCode', '\\_\\_\zsBold\ze\\_\\_')
" echo matchadd('HlMkDnCode', '\\\zs_\ze')
" echo matchadd('Conceal', '\zs\\\ze_')



silent call prop_type_delete('p')
silent call prop_type_add('p', #{
      \ highlight: 'Delimiter',
      \ combine: v:true,
      \ })
call prop_add(21, 0, #{
      \ type: 'p',
      \ text: '¶',
      \ text_align: 'after',
      \ text_padding_left: 0,
      \ })

function s:onBufferChanged (bufnr, start, end, added, s)
  call prop_remove(#{type: 'p'}, a:start, a:end)

  " call prop_add_list()
endfunc
" call listener_add(s:onBufferChanged)
