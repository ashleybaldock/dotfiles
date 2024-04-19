

" Dynamic winbar menu
" -> See also CustomStatusline in ./statusline.vim
function! s:WinBarUpdate()
  if &ft == 'netrw'
    nunmenu WinBar | nnoremenu 1.10 WinBar.S:Ξ⃝\ \ ・I:◳⃝\ \ ・-:⇠⃝\ \ ・<S-B>:⇅⃝\ \:<S-W>\ ・⌘⃝\ E⃝\ nter <nop>
  else
    nunmenu WinBar
  endif
endfunc

augroup winbar
  autocmd!

  au OptionSet diff call s:WinBarUpdate()
  au WinEnter,WinLeave,BufEnter,BufLeave,DiffUpdated * call s:WinBarUpdate()
augroup END
