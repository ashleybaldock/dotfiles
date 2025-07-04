"
" Add 'wysiwyg' highlight groups for highlight attributes
"
" Also make undercurl etc. not show as errors
"
" au BufWritePost <buffer> syn on
"
" See Also: $VIMRUNTIME/syntax/vim.vim
"           ../syntax/vim.statusline.vim
"

if expand('%:p') == expand('$VIMHOME/plugin/statusline.vim')
  exec 'so ' .. expand('$VIMHOME/after/syntax/vim.statusline.vim')
endif

syn keyword	vimHiAttrib	contained	undercurl underdotted underdouble
syn keyword	vimHiAttrib	contained	underdashed strikethrough

syn match	vimHiAttribList	contained	"\i\+"
      \ contains=vimHiAttrib,vimHiAttrBold,
      \   vimHiAttrUnLine,vimHiAttrUnCurl,
      \   vimHiAttrUnDbl,vimHiAttrUnDot,vimHiAttrUnDash,
      \   vimHiAttrStrike,vimHiAttrItalic,
      \   vimHiAttrInv,vimHiAttrRev,vimHiAttrStand,
      \   vimHiAttrNoCom,vimHiAttrNONE
syn match	vimHiAttribList	contained	"\i\+,"he=e-1
      \	nextgroup=vimHiAttribList
      \ contains=vimHiAttrib,
      \   vimHiAttrBold,vimHiAttrItalic,
      \   vimHiAttrStrike,vimHiAttrUnLine,vimHiAttrUnCurl,
      \   vimHiAttrUnDbl,vimHiAttrUnDot,vimHiAttrUnDash,
      \   vimHiAttrInv,vimHiAttrRev,vimHiAttrStand,
      \   vimHiAttrNoCom,vimHiAttrNONE

" syn keyword vimHiAttrBold   contained bold conceal cchar=􀅓
" syn keyword vimHiAttrUline  contained underline conceal cchar=􀅕
" syn keyword vimHiAttrUcurl  contained undercurl conceal cchar=􁆭
" syn keyword vimHiAttrUdble  contained underdouble conceal cchar=􀃤
" syn keyword vimHiAttrUdot   contained underdotted conceal cchar=􁊓􀍠􁢏
" syn keyword vimHiAttrUdash  contained underdashed conceal cchar=􀓔
" syn keyword vimHiAttrStrike contained strikethrough conceal cchar=􀅖
" syn keyword vimHiAttrItalic contained italic conceal cchar=􀅔
syn keyword vimHiAttrBold   contained bold
syn keyword vimHiAttrUnLine contained underline
syn keyword vimHiAttrUnCurl contained undercurl
syn keyword vimHiAttrUnDbl  contained underdouble
syn keyword vimHiAttrUnDot  contained underdotted
syn keyword vimHiAttrUnDash contained underdashed
syn keyword vimHiAttrStrike contained strikethrough
syn keyword vimHiAttrItalic contained italic
syn keyword vimHiAttrInv    contained inverse
syn keyword vimHiAttrRev    contained reverse
syn keyword vimHiAttrStand  contained standout
syn keyword vimHiAttrNoCom  contained nocombine
syn keyword vimHiAttrNONE   contained NONE

hi def vimHiAttrBold   guifg=ywnormf gui=bold
hi def vimHiAttrUnLine guifg=#009999 gui=underline     guisp=ywnormf
hi def vimHiAttrUnCurl guifg=#009999 gui=undercurl     guisp=ywnormf
hi def vimHiAttrUnDbl  guifg=#009999 gui=underdouble   guisp=ywnormf
hi def vimHiAttrUnDot  guifg=#009999 gui=underdotted   guisp=ywnormf
hi def vimHiAttrUnDash guifg=#009999 gui=underdashed   guisp=ywnormf
hi def vimHiAttrStrike guifg=#009999 gui=strikethrough guisp=ywnormf
hi def vimHiAttrItalic guifg=ywnormf gui=italic
hi def vimHiAttrInv    guifg=ywnormf gui=inverse
hi def vimHiAttrRev    guifg=ywnormf gui=reverse
hi def vimHiAttrStand  guifg=ywnormf gui=standout
hi def vimHiAttrNoCom  guifg=ywnormf gui=nocombine
hi def vimHiAttrNONE   guifg=#009999 gui=none

syn keyword vimCommand macm[enu] skipwhite nextgroup=@vimMenuList

syn keyword vimCommand maca[ction]

" Comment items
syn region KeyCombo contained containedin=vimLineComment oneline
      \ matchgroup=KeyComboStart start="▌️"
      \ matchgroup=KeyComboEnd end="▐️"
syn region KeyCombo contained containedin=vimLineComment oneline
      \ matchgroup=KeyComboStart start="┇️"
      \ matchgroup=KeyComboEnd end="┇️"
syn region KeyCombo contained containedin=vimLineComment oneline
      \ matchgroup=KeyComboStart start="︙"
      \ matchgroup=KeyComboEnd end="︙"

syn region DemoCursorRange contained containedin=vimLineComment
      \ concealends
      \ matchgroup=Conceal start="󠀨"
      \ end="󠀩"

syn region DemoCursor contained containedin=DemoCursorRange
      \ concealends
      \ matchgroup=Conceal start="󠁛"
      \ end="󠁝"

hi def KeyCombo guifg=#f9f9f9 guibg=#2255cc guisp=bg gui=bold
hi def KeyComboEnd guibg=#2255cc guifg=bg gui=bold
hi def KeyComboStart guibg=#2255cc guifg=bg gui=bold
hi def DemoCursorRange guifg=#cc22dd guibg=#333333 guisp=#cc22dd gui=underline
" hi def link DemoCursor Cursor
hi def DemoCursor guifg=#000000 guibg=#cc22dd
