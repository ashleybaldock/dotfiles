
" copy full path
:command! CopyPath let @+ = expand("%:p")
" copy just filename
:command! CopyFilename let @+ = expand("%:t")
" copy branch
:command! CopyBranch let @+ = FugitiveHead()


" Highlighting & Syntax debug
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '▹')
endfunc
:command! SynStack :echo <SID>SynStack()
" nmap <leader>sp :call <SID>SynStack()<CR>
:command! MdNorm :hi markdownCodeBlock gui=bold
:command! MdBold :hi markdownCodeBlock gui=NONE

augroup misc_commands
  autocmd!
  " Set working directory to current file
  au BufEnter * silent! lcd %:p:h

  au FileType netrw set nolist
  au FileType gitcommit set nolist
  "au FileType netrw au BufEnter <buffer> set nolist
  "au FileType netrw au BufLeave <buffer> set list
  " Use <esc> to close quickfix window
  au FileType qf if mapcheck('<esc>', 'n') ==# '' | nnoremap <buffer><silent> <esc> :cclose<bar>lclose<CR> | endif
augroup END
