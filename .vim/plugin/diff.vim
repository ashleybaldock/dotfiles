if exists("g:mayhem_loaded_diff")
  finish
endif
let g:mayhem_loaded_diff = 1
 
let s:mayhem_diff_off = 'mayhem_diff_off'

" function! s:closeSavedVersionWindow(tempbuf)
"   for l:winId in win_findbuf(a:tempbuf)
"     call win_execute(l:winId, ":q")
"   endfor
" endfunc

" function s:delayDeleteBuffer(bufnr)
"   call timer_start(100, {_ -> execute('bdelete '.a:bufnr)})
" endfunction


" call setbufvar(bufnr('$'), 'filetype', &filetype)
" call setbufvar(bufnr('$'), 'mayhem_diff_saved', expand('%'))

"
" File Changed Since Reading:...
" For when a file has been changed externally and there are also changes to
" the buffer, open a split with the on-disk version and start a diff

" TODO - close temp window on diffoff
" TODO - closing temp window ends diff in both
" TODO - closing source window closes temp one

function! s:DiffWithOff(diffoff, tempbuf = 0)
  if a:diffoff > 0
    diffoff!
  endif

  if a:tempbuf > 0
    call timer_start(100, {_ -> execute('silent! bdelete ' .. a:tempbuf)})
  else
    nunmap <buffer> [[
    nunmap <buffer> ]]
    nunmap <buffer> “
    nunmap <buffer> ‘
    unlet b:mayhem_diff_left
  endif

  call autocmd_delete([#{ event: '*', group: s:mayhem_diff_off}])
endfunc

function! s:SetupDiffOffAutocmds()
  call autocmd_add([#{
        \ event: 'OptionSet', pattern: 'diff',
        \ cmd: 'if v:option_new == 0 | call s:DiffWithOff(0, ' .. bufnr('$') .. ') | endif',
        \ group: s:mayhem_diff_off, replace: v:true,
        \},
        \#{
        \ event: ['BufWinLeave','BufUnload'], bufnr: bufnr('$'),
        \ cmd: 'call s:DiffWithOff(1)',
        \ group: s:mayhem_diff_off, replace: v:true,
        \},
        \#{
        \ event: ['BufWinLeave','BufUnload'], bufnr: bufnr('.'),
        \ cmd: 'call s:DiffWithOff(1, ' .. bufnr('$') .. ')',
        \ group: s:mayhem_diff_off, replace: v:true,
        \}
        \])
endfunc

function! s:SetupLeftDiff()
  nnoremap <buffer> [[ [c
  nnoremap <buffer> ]] ]c
  nnoremap <buffer> { <Cmd>diffget<CR>
  nnoremap <buffer> } <Cmd>diffput<CR>
  let b:mayhem_diff_left = 1
  diffthis
endfunc

function! s:SetupRightDiff(execForContent)
  diffoff!
  let sourceft = &filetype
  vert new | setlocal bt=nofile modifiable
  exec a:execForContent
  exec 'nnoremap <buffer> §dx :diffoff!<CR>'
  nnoremap <buffer> [[ [c
  nnoremap <buffer> ]] ]c
  nnoremap <buffer> { <Cmd>diffput<CR>
  nnoremap <buffer> } <Cmd>diffget<CR>
  let b:mayhem_diff_right = 1
  diffthis
  wincmd p 
endfunc

function! s:DiffWithPaste()
  call s:SetupRightDiff("normal ggVG\"+p")
  call s:SetupLeftDiff()
  call s:SetupDiffOffAutocmds()
endfunc

function! s:DiffWithSaved()
  call s:SetupRightDiff("r ++edit # | normal 0d_")
  call s:SetupLeftDiff()
  call s:SetupDiffOffAutocmds()
endfunc

command! -bar -nargs=0 DiffWithPaste call <SID>DiffWithPaste()
command! -bar -nargs=0 DiffWithSaved call <SID>DiffWithSaved()
