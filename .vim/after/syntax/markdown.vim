

"
" Additions to markdown formatting
"
" au BufWritePost <buffer> syn on
"
syn match markdownEscape "\\\~"

syn match markdownLineBreak " \{2,\}$" conceal cchar=⏎️


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


syn match mdConcealedEscape "\\" conceal

syn match mdQuotePrefix +^>+ contained contains=NONE conceal cchar=┃
syn match mdAlertConceal +\[\!+ cchar=◣ contained contains=NONE conceal
syn match mdAlertConceal +\]+ cchar=◢ contained contains=NONE conceal


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
