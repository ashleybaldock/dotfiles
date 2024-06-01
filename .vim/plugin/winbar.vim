if exists("g:mayhem_loaded_winbar")
  finish
endif
let g:mayhem_loaded_winbar = 1

" let s:loaded = 'g:mayhem_loaded_'..substitute(expand('%:t:r'), '[^A-Za-z0-9-_]', '', 'g')
" if exists(s:loaded) | finish | else | exec 'let '..s:loaded..' = 1' | endif


" ═══╡ Dynamic WinBar menu ╞════════════════════════════════
"
" Related: CustomStatusline in ./statusline.vim
function! s:WinBarUpdate()
  if &diff
    nunmenu WinBar | nnoremenu 1.10 WinBar.Diff・⌘⃣\ D⃣\ :toggle\ diff・?:get・?:put・?:prev・?:next・ <nop>
  elseif &ft == 'netrw'
    nunmenu WinBar | nnoremenu 1.10 WinBar.Netrw・S:sort・I:layout・-:back・<S-B>:up・<S-W>:down・ <nop>
  else
    nunmenu WinBar
  endif
endfunc

command! WinBarUpdate call <SID>WinBarUpdate()

augroup winbar
  autocmd!

  au OptionSet diff call s:WinBarUpdate()
  au WinLeave,BufEnter,BufLeave,DiffUpdated,FileType * call s:WinBarUpdate()
augroup END
