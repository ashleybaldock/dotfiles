if exists("g:mayhem_loaded_mouse")
  finish
endif
let g:mayhem_loaded_mouse = 1

"
" Mouse:
"
" Option Left Click On Focused Window:
"  i⁺₊﹢＋rts visual block selection from click location
"     (as if virtualedit=all)
"
nnoremap <expr> <M-LeftMouse> getmousepos().winid==win_getid() ? '<Cmd>StartVisualBlockToClick<CR>' : '<Cmd>StartVisualBlockFromClick<CR>'
" nnoremap <M-LeftMouse> :StartVisualBlockFromClick<CR>


" Disable right-click menu
noremap <RightMouse> <Nop>
