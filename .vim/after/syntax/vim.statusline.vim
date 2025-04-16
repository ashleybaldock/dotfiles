"
" Add highlighting for statusline parts
"
" au BufWritePost <buffer> syn on
"
" See Also: $VIMRUNTIME/syntax/vim.vim
"           ../syntax/vim.vim
"




" Statusline Items
" %[-][0][[{minwid}].[{maxwid}]]{item}    %% = %
syn match vimSlItem /%-\?0\?\%([1-4][0-9]\|[1-9]\)\?\.\?\%([1-9]\d\*\)\?/
      \ contains=vimSlPer
      \ contained containedin=vimString
      \ nextgroup=@vimSlContent

syn match vimSlPer /%/ contained contains=NONE conceal
syn match vimSlPerEscaped /%\@1<=%/ contained contains=NONE conceal
syn match vimSlPerEsc /%%/ contained containedin=vimString contains=vimSlPerEscaped

syn region vimSlSection contained containedin=NONE oneline
      \ matchgroup=vimSlEnds start=+(+
      \ end=+\ze%)+
      \ contains=vimSlItem

syn region vimSlSubExpr contained containedin=NONE oneline
      \ matchgroup=vimSlEnds start=+{+
      \ end=+}+
      \ contains=NONE

syn region vimSlSubReExpr contained containedin=NONE oneline
      \ matchgroup=vimSlEnds start=+{%+
      \ skip=+[^%]}+
      \ end=+%\@1<=}+
      \ contains=vimSlItem

syn region vimSlHlGroup contained containedin=NONE
      \ matchgroup=vimSlHlEnds start=+#+
      \ end=+#+

" syn match vimSlHlGroup /\%(%#\)\@2<=\w\+/ contained contains=NONE
syn match vimSlHlReset /%\@1<=\*/ contained contains=NONE
syn match vimSlHlSetUsr /%\@1<=\d\*/ contained contains=NONE
syn match vimSlTruncate /%\@1<=</ contained contains=NONE
syn match vimSlAlignSep /%\@1<==/ contained contains=NONE

syn cluster vimSlContent contains=vimSlHlGroup,vimSlHlReset,vimSlHlSetUsr,
      \vimSlTruncate,vimSlAlignSep,vimSlSetHlGroup,vimSlSubExpr,vimSlSubReExpr,
      \vimSlSection

hi def link vimSlSubExpr String
hi def link vimSlSubReExpr Statement

hi def vimSlItem guibg=#000000 guifg=#000000
hi def link vimSlPerEsc Special
hi def link vimSlPerEscaped Special
hi def vimSlEnds guisp=#ffff00 gui=inverse

hi def vimSlHlEnds   guifg=#0055aa
hi def vimSlHlGroup  guifg=#2277cc
hi def vimSlHlReset  guifg=#ff77cc
hi def vimSlHlSetUsr guifg=#ffcc00
hi def vimSlTruncate guifg=#5599aa
hi def vimSlAlignSep guifg=#3377cc
