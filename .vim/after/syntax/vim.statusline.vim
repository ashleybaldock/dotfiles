"
" Add highlighting for statusline parts
"
" :au BufWritePost <buffer> syn on
"
" See Also: $VIMRUNTIME/syntax/vim.vim
"           ../syntax/vim.vim
"




" Statusline Items
" %[-][0][[{minwid}].[{maxwid}]]{item}    %% = %
syn match vimSlItem /%-\?0\?\%(50\|[1-4][0-9]\|[1-9]\)\?\.\?\%([1-9]\d*\)\?/
      \ contains=vimSlPer
      \ contained containedin=vimString,vimContinueString
      \ nextgroup=@vimSlContent

syn match vimSlPer contained /%/ contains=NONE
      \ nextgroup=vimSlLeft,vimSlZeros,vimSlMinW,vimSlSep
syn match vimSlPerEscaped contained /%\@1<=%/ contains=NONE conceal
syn match vimSlPerEsc contained /%%/ containedin=vimString contains=vimSlPerEscaped

syn match vimSlLeft /-/ contained contains=NONE nextgroup=vimSlZeros,vimSlMinW,vimSlSep conceal cchar=◂
syn match vimSlZeros /0/ contained contains=NONE nextgroup=vimSlMinW,vimSlSep conceal cchar=𝟢
syn match vimSlMinW /\%(50\|[1-4][0-9]\|[1-9]\)/ contained contains=NONE nextgroup=vimSlSep
syn match vimSlSep /\./ contained contains=NONE nextgroup=vimSlMaxW conceal cchar=⥂
syn match vimSlMaxW /[1-9]\d*/ contained contains=NONE

syn match vimSlItemCode /[fFtmMrRhHwWyYqknbBoONlLcvVpPSa]/ contained contains=NONE

syn region vimSlSection contained oneline transparent
      \ matchgroup=vimSlSecEnds start=/(/
      \ end=/%\@1<=)/
      \ contains=vimSlItem

syn region vimSlSubExpr contained oneline
      \ matchgroup=vimSlSubEnds start=/{/
      \ end=/}/
      \ contains=NONE

syn region vimSlSubReExpr contained oneline
      \ matchgroup=vimSlSubReEnds start=/{%/
      \ skip=/[^%]}/
      \ end=/%}/
      \ contains=vimSlItem

syn region vimSlHlGroup contained
      \ matchgroup=vimSlHlEnds start=/#/
      \ end=/#/
      \ contains=vimSlHlNC,vimSlHlNCC,vimSlHlNCN

syn match vimSlHlNC contained /⸮\ze#/ contains=NONE
syn match vimSlHlNCC contained /C\ze#/ contains=NONE
syn match vimSlHlNCN contained /N\ze#/ contains=NONE

" syn match vimSlHlGroup /\%(%#\)\@2<=\w\+/ contained contains=NONE
syn match vimSlHlReset /%\@1<=\*/ contained contains=NONE
syn match vimSlHlSetUsr /%\@1<=\d\*/ contained contains=NONE
syn match vimSlTruncate /%\@1<=</ contained contains=NONE
syn match vimSlAlignSep /%\@1<==/ contained contains=NONE

syn cluster vimSlContent contains=vimSlItemCode,
      \vimSlHlGroup,vimSlHlReset,vimSlHlSetUsr,
      \vimSlTruncate,vimSlAlignSep,
      \vimSlSubExpr,vimSlSubReExpr,
      \vimSlSection

hi def vimSlSubExpr    guifg=#dddd00
hi def vimSlSubEnds    guifg=#aaaa00

hi def vimSlSubReExpr  guifg=#ff8800
hi def vimSlSubReEnds  guifg=#aa6600

hi def vimSlItem       guifg=#000000   guibg=#000000
hi def vimSlMinW       guifg=#66dd66
hi def vimSlMaxW       guifg=#66dd66
hi def vimSlSecEnds    guifg=#ee44ee

hi def vimSlItemCode   guifg=#ffccff

hi def vimSlHlGroup    guifg=#99ccee   gui=italic
hi def vimSlHlEnds     guifg=#0088cc
hi def vimSlHlNC       guifg=#0088cc   gui=bold
hi def vimSlHlNCC      guifg=#99eecc   gui=bold,italic
hi def vimSlHlNCN      guifg=#ee99cc   gui=bold,italic
hi def vimSlHlReset    guifg=#ff77cc
hi def vimSlHlSetUsr   guifg=#ffcc00

hi def vimSlTruncate   guifg=#5599aa
hi def vimSlAlignSep   guifg=#3377cc

hi def vimSlPer        guifg=#6666aa
hi def link vimSlPerEsc Special
hi def link vimSlPerEscaped Special
