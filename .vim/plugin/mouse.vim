if exists("g:mayhem_loaded_mouse")
  finish
endif
let g:mayhem_loaded_mouse = 1

"
" Mouse Mappings: 􀺤􁝸 􀇰 
"
" Option Left Click On Focused Window:
"  See: ./visualclick.vim
"  i⁺₊﹢＋rts visual block selection from click location
"     (as if virtualedit=all)
"
nnoremap <expr> <M-LeftMouse> getmousepos().winid==win_getid() ? '<Cmd>StartVisualBlockToClick<CR>' : '<Cmd>StartVisualBlockFromClick<CR>'
" nnoremap <M-LeftMouse> :StartVisualBlockFromClick<CR>


" Disable right-click menu
noremap <RightMouse> <Nop>

" <LeftMouse>
" <RightMouse>
"

"
"i-r:beam,s:updown,sd:udsizing,vs:leftright,vd:lrsizing,m:no,ml:up-arrow,v:rightup-arrow,v:beam,

"􁝸  􀮐 􀭈 􀯪 􁑢 􀇰􀭆􀭇􀫌􁷁􀣠􀭅􁚀 
" n   Normal
" v   Visual
" o   Operator-pending
" i   Insert
" r   Replace
"
"     command-line
" c	  appending
" ci	inserting
" cr	replacing
" m	  'Hit ENTER' / 'More' prompt
" ml	idem, but cursor in the last line
"     any mode
" e	  pointer below last window     
"     status line
" s	  over
" sd	dragging
"     vertical separator
" vs	over 
" vd	dragging
" a   everywhere                              
