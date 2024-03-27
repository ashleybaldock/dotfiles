
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
function <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo join(map(synstack(line('.'), col('.')), 'hlget(synIDattr(v:val, "name"))'), '▹')
endfunc

:command! SynStack :echo <SID>SynStack()

:command! HighlightThis :hi <c-r><c-w>


augroup misc_commands
  autocmd!
  " Set working directory to current file
  au BufEnter * silent! lcd %:p:h

  " Use <esc> to close quickfix window
  " au FileType qf if mapcheck('<esc>', 'n') ==# '' | nnoremap <buffer><silent> <esc> :cclose<bar>lclose<CR> | endif
augroup END

" Create a split if current buffer has modifications
" Useful to run before a command that may open a new buffer
function s:SplitIfModified()
  if &modified
    split
  endif
endfunc

:command! SplitIfModified :exec <SID>SplitIfModified()


" === Ack / Search ===

function s:AckEscaped(search)
  " The ! avoids jumping to first result automatically
  execute printf('Ack! -Q -- "%s"', substitute(a:search, '\([%"\\]\)', '\\\1', 'g'))
endfunc

function s:AckClipboard()
  call s:AckEscaped(@")
endfunc

function s:AckCurrentWord()
  call s:AckEscaped(expand("<cword>"))
endfunc

function s:AckLastSearch()
  call s:AckEscaped(@/)
endfunc

function! s:AckInput()
  call inputsave()
  let search = input("Ack! ")
  call inputrestore()
  call s:AckEscaped(search)
endfunc

:command! AckInput :exec <SID>AckInput()
:command! AckClipboard :exec <SID>AckClipboard()
:command! AckCurrentWord :exec <SID>AckCurrentWord()
:command! AckLastSearch :exec <SID>AckLastSearch()

:command! CopyLastSearch :let @+=@/

