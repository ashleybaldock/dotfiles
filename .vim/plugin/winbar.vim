if exists("g:mayhem_loaded_winbar")
  finish
endif
let g:mayhem_loaded_winbar = 1


" ═══╡ Dynamic WinBar menu ╞════════════════════════════════
"
" Related: CustomStatusline in ./statusline.vim
function! s:WinBarUpdate()
  if &diff
    nunmenu WinBar | nnoremenu 1.10 WinBar.S:Ξ⃝\ \ ・I:◳⃝\ \ ・-:⇠⃝\ \ ・<S-B>:⇅⃝\ \:<S-W>\ ・⌘⃝\ E⃝\ nter <nop>
  elseif &ft == 'netrw'
    nunmenu WinBar | nnoremenu 1.10 WinBar.S:Ξ⃝\ \ ・I:◳⃝\ \ ・-:⇠⃝\ \ ・<S-B>:⇅⃝\ \:<S-W>\ ・⌘⃝\ E⃝\ nter <nop>
  else
    nunmenu WinBar
  endif
endfunc

augroup winbar
  autocmd!

  au OptionSet diff call s:WinBarUpdate()
  au WinLeave,BufEnter,BufLeave,DiffUpdated,FileType * call s:WinBarUpdate()
augroup END
