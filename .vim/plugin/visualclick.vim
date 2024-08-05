if exists("g:mayhem_loaded_visualclick")
  finish
endif
let g:mayhem_loaded_visualclick = 1

"
" Visual Block Start From Click:
"
" Makes it so that if you option+click, visual block
" mode is entered with a selection between the cursor
" position and the actual click position (as if
" virtualedit was on).
"
" screenrow screen row         (All 1-based)
" screencol screen column
" winid     Window ID of the click
" winrow    row inside winid
" wincol    column inside winid
" line      text line inside winid
" column    text column inside winid
" coladd    offset (in screen columns) from the start of the clicked char
  " call winrestview({'curswant': pos.column + pos.coladd})
function s:StartVisualBlockFromClick()
  let pos = getmousepos()
  exec getwininfo(pos.winid)[0].winnr..'wincmd w'
call cursor([pos.line, pos.column, pos.coladd, pos.column + pos.coladd])
  execute "normal! \<C-v>"
endfunc

function s:StartVisualBlockToClick()
  let pos = getmousepos()
  execute "normal! \<C-v>"
  call cursor([pos.line, pos.column, pos.coladd, pos.column + pos.coladd])
endfunc

command! StartVisualBlockFromClick call <SID>StartVisualBlockFromClick()
command! StartVisualBlockToClick call <SID>StartVisualBlockToClick()


