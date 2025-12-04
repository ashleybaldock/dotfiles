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

syn match vimSlPer contained /%/ contains=NONE
syn match vimSlPerEscaped contained /%\@1<=%/ contains=NONE conceal
syn match vimSlPerEsc contained /%%/ containedin=vimString contains=vimSlPerEscaped

syn region vimSlSection contained containedin=NONE oneline
      \ matchgroup=vimSlSecEnds start=+(+
      \ end=+%\@1<=)+
      \ contains=vimSlItem

syn region vimSlSubExpr contained containedin=NONE oneline
      \ matchgroup=vimSlSubEnds start=+{+
      \ end=+}+
      \ contains=NONE

syn region vimSlSubReExpr contained containedin=NONE oneline
      \ matchgroup=vimSlSubReEnds start=+{%+
      \ skip=+[^%]}+
      \ end=+%}+
      \ contains=vimSlItem

syn region vimSlHlGroup contained containedin=NONE
      \ matchgroup=vimSlHlEnds start=+#+
      \ end=+#+
      \ contains=vimSlHlNCC,vimSlHlNCN

syn match vimSlHlNCC contained +C\ze#+ contains=NONE
syn match vimSlHlNCN contained +N\ze#+ contains=NONE

" syn match vimSlHlGroup /\%(%#\)\@2<=\w\+/ contained contains=NONE
syn match vimSlHlReset /%\@1<=\*/ contained contains=NONE
syn match vimSlHlSetUsr /%\@1<=\d\*/ contained contains=NONE
syn match vimSlTruncate /%\@1<=</ contained contains=NONE
syn match vimSlAlignSep /%\@1<==/ contained contains=NONE

syn cluster vimSlContent contains=vimSlHlGroup,vimSlHlReset,vimSlHlSetUsr,
      \vimSlTruncate,vimSlAlignSep,vimSlSetHlGroup,vimSlSubExpr,vimSlSubReExpr,
      \vimSlSection

hi def vimSlSubExpr    guifg=#dddd00
hi def vimSlSubEnds    guifg=#aaaa00

hi def vimSlSubReExpr  guifg=#ff8800
hi def vimSlSubReEnds  guifg=#aa6600

hi def vimSlItem       guifg=#000000   guibg=#000000

hi def vimSlSection    guifg=#ffccff
hi def vimSlSecEnds    guifg=#ee44ee

hi def vimSlHlGroup    guifg=#99ccee
hi def vimSlHlEnds     guifg=#4488cc
hi def vimSlHlNCC      guifg=#99eecc   gui=bold,italic
hi def vimSlHlNCN      guifg=#ee99cc   gui=bold,italic
hi def vimSlHlReset    guifg=#ff77cc
hi def vimSlHlSetUsr   guifg=#ffcc00

hi def vimSlTruncate   guifg=#5599aa
hi def vimSlAlignSep   guifg=#3377cc

hi def vimSlPer        guifg=#6666aa
hi def link vimSlPerEsc Special
hi def link vimSlPerEscaped Special
