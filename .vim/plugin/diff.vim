if exists("g:mayhem_loaded_diff")
  finish
endif
let g:mayhem_loaded_diff = 1
 
" function! s:closeSavedVersionWindow(tempbuf)
"   for l:winId in win_findbuf(a:tempbuf)
"     call win_execute(l:winId, ":q")
"   endfor
" endfunc

" function s:delayDeleteBuffer(bufnr)
"   call timer_start(100, {_ -> execute('bdelete '.a:bufnr)})
" endfunction



"
" File Changed Since Reading:...
" For when a file has been changed externally and there are also changes to
" the buffer, open a split with the on-disk version and start a diff

" TODO - close temp window on diffoff
" TODO - closing temp window ends diff in both
" TODO - closing source window closes temp one

function! s:DiffWithSavedOff(diffoff, tempbuf = 0)
  if a:diffoff > 0
    diffoff!
  endif

  if a:tempbuf > 0
    call timer_start(100, {_ -> execute('silent! bdelete '..a:tempbuf)})
  endif

  augroup diffoff
    au!
  augroup END
endfunc
 command! DiffWithSaved diffoff! | let sourceft = &filetype
      \ | vert new | set bt=nofile 
      \ | r ++edit #
      \ | 0d_ | let filetype = sourceft
      \ | exec 'nnoremap <buffer> §dx :diffoff!<CR>'
      \ | diffthis | wincmd p | diffthis 
      \ | exec 'augroup diffoff'
      \ |   exec 'au!'
      \ |   exec 'autocmd OptionSet diff if v:option_new == 0 | call s:DiffWithSavedOff(0, '..bufnr('$')..') | endif'
      \ |   exec 'autocmd BufWinLeave,BufUnload <buffer='..bufnr('$')..'> call s:DiffWithSavedOff(1)'
      \ |   exec 'autocmd BufWinLeave,BufUnload <buffer='..bufnr('.')..'> call s:DiffWithSavedOff(1, '..bufnr('$')..')'
      \ | exec 'augroup END'
      \ | call setbufvar(bufnr('$'), 'filetype', &filetype)
      \ | call setbufvar(bufnr('$'), 'mayhem_diff_saved', expand('%'))

