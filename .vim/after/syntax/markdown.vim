
syn match markdownEscape "\\\~"

syn match markdownLineBreak " \{2,\}$" conceal cchar=⏎⃞


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
