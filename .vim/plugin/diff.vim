if exists("g:mayhem_loaded_diff")
  finish
endif
let g:mayhem_loaded_diff = 1


"
" File Changed Since Reading:...
" For when a file has been changed externally and there are also changes to
" the buffer, open a split with the on-disk version and start a diff

" TODO - close temp window on diffoff
" TODO - closing temp window ends diff in both
" TODO - closing source window closes temp one
"
command! DiffWithSaved diffoff! | let sourceft = &filetype
      \ | vert new | set bt=nofile 
      \ | r ++edit #
      \ | 0d_ | let filetype = sourceft
      \ | exec 'nnoremap <buffer> §dx :diffoff!<CR>'
      \ | autocmd BufWinLeave,BufUnload <buffer> diffoff!
      \ | autocmd OptionSet diff <buffer> diffoff!
      \ | diffthis | wincmd p | diffthis 
      \ | augroup diffoff
      \   | autocmd BufWinLeave,BufUnload <buffer> diffoff!
      \ | augroup END
      \ | call setbufvar(bufnr('$'), 'filetype', &filetype)
      \ | call setbufvar(bufnr('$'), 'mayhem_diff_saved', expand('%'))

