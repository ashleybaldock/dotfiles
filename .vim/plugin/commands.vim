
" copy full path
:command! CopyPath let @+ = expand("%:p")
" copy just filename
:command! CopyFilename let @+ = expand("%:t")
" copy branch
:command! CopyBranch let @+ = FugitiveHead()

function CursorOnComment()
  return join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')) =~? 'comment'
endfunc

command! CursorOnComment :echo CursorOnComment()

" Highlighting & Syntax debug
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo join(map(synstack(line('.'), col('.')), 'hlget(synIDattr(v:val, "name"))'), '▹')
endfunc
:command! SynStack :echo <SID>SynStack()
" nmap <leader>sp :call <SID>SynStack()<CR>
:command! MdNorm :hi markdownCodeBlock gui=bold
:command! MdBold :hi markdownCodeBlock gui=NONE

augroup misc_commands
  autocmd!
  " Set working directory to current file
  au BufEnter * silent! lcd %:p:h

  au FileType netrw setlocal nolist
  au FileType gitcommit setlocal nolist
  "au FileType netrw au BufEnter <buffer> set nolist
  "au FileType netrw au BufLeave <buffer> set list
  " Use <esc> to close quickfix window
  " au FileType qf if mapcheck('<esc>', 'n') ==# '' | nnoremap <buffer><silent> <esc> :cclose<bar>lclose<CR> | endif
augroup END


" Split if unsaved
function! s:SplitIfModified()
  if &modified
    split
  endif
endfunc

:command! SplitIfModified :exec <SID>SplitIfModified()

" === Ack / Search ===

:function! s:AckEscaped(search)
  " The ! avoids jumping to first result automatically
  execute printf('Ack! -Q -- "%s"', substitute(a:search, '\([%"\\]\)', '\\\1', 'g'))
:endfunc

:function! s:AckClipboard()
  call s:AckEscaped(@")
:endfunc

:function! s:AckCurrentWord()
  call s:AckEscaped(expand("<cword>"))
:endfunc

:function! s:AckLastSearch()
  call s:AckEscaped(expand("<cword>"))
:endfunc

:function! s:AckInput()
  call inputsave()
  let search = input("Ack! ")
  call inputrestore()
  call s:AckEscaped(search)
:endfunc

:command! AckInput :exec <SID>AckInput()
:command! AckClipboard :exec <SID>AckClipboard()
:command! AckCurrentWord :exec <SID>AckCurrentWord()



let topline = line("w0")
let botline = line("w$")
