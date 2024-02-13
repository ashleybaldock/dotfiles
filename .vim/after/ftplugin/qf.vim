" Only do this when not done yet for this buffer
" if exists("b:did_ftplugin")
"   finish
" endif
" b:did_ftplugin = 1

" wincmd K
" resize 8
" setlocal winfixheight
"
" pclose
" rightbelow vsplit pedit 
" resize 8
" setlocal winfixheight

" nnoremap <buffer><silent> p :rightbelow vsplit pedit<bar>.cc<bar>resize 8<bar>setlocal winfixheight<bar>setlocal nomodifiable<bar>wincmd h<CR>

" if mapcheck('<esc>', 'n') ==# ''
  " nnoremap <buffer><silent> <esc> <plug>(quickr_preview_qf_close)

  " nnoremap <leader>p <plug>(quickr_preview)
  " nnoremap <leader>q <plug>(quickr_preview_qf_close)
" endif

" open entry and come back
" nnoremap <silent> <buffer> o <CR><C-w>p

" open entry and close the location/quickfix window.
" let b:qf_isLoc = get(get(getwininfo(win_getid()), 0, {}), 'loclist', 0)
" if b:qf_isLoc == 1
"   nnoremap <silent> <buffer> O <CR>:lclose<CR>
" else
"   nnoremap <silent> <buffer> O <CR>:cclose<CR>
" endif

" do something on each line in the location/quickfix list
" usage:
"   :Doline s/^/---
" command! -buffer -nargs=1 Doline call qf#do#DoList(1, <q-args>)

" do something on each file in the location/quickfix list
" usage:
"   :Dofile %s/^/---
" command! -buffer -nargs=1 Dofile call qf#do#DoList(0, <q-args>)

" Move forward and backward in list history (in a quickfix or location window)
" nnoremap <silent> <buffer> <Plug>(qf_older)         :<C-u>call qf#history#Older()<CR>
" nnoremap <silent> <buffer> <Plug>(qf_newer)         :<C-u>call qf#history#Newer()<CR>
" Jump to previous and next file grouping (in a quickfix or location window)
" nnoremap <silent> <buffer> <Plug>(qf_previous_file) :<C-u>call qf#filegroup#PreviousFile()<CR>
" nnoremap <silent> <buffer> <Plug>(qf_next_file)     :<C-u>call qf#filegroup#NextFile()<CR>
