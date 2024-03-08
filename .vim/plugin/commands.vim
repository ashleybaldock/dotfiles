
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
:command! HighlightThis :hi <c-r><c-w>
" nmap <leader>sp :call <SID>SynStack()<CR>

" Capture name of highlight
" '^:\?hi\w*\s\(link\|clear\)\@!\s*\zs\(\w\+\)\ze\s\+'
" Capture names in highlight link
" ^:\?hi\w*\s\+link\s\+\zs\(\w\+\)\s\+\(\w\+\)\ze\s\+

  " let matchid = matchadd(a:name, '^"\?:\?hi\w*\s\(link\|clear\)\@!\s*\zs' .. a:name .. '\ze\s\+', 10, -1)
  " %s/\(^\s*\||\s\+\)"\?:\?hi\w*\s\(\clear\)\@!\(link\)\?\s*\zs\(\w\+\)\ze\s\+/\=AddHighlightHighlight(submatch(0))/
  "echom a:name matchid

" :%s/^:\?hi\s\(link\|clear\)\@!\s*\zs\(\w\+\)\ze\s\+/\=AddHighlightHighlight(submatch(0))/
    "       '\(^\s*\||\s\+\)"\?:\?hi\w*\s\(\clear\)\@!\(link\)\?\s*\zs'

function s:AddHighlightHighlight(name)
  let matchid = matchadd(a:name, '\(^\s*\||\s\+\)"\?:\?hi\w*\s\(\clear\)\@!\(link\)\?\s*\zs' .. a:name .. '\ze\s\+', 10, -1)
  if exists('w:highlighthighlights') && type(w:highlighthighlights) == type([])
    call add(w:highlighthighlights, matchid)
  else
    let w:highlighthighlights = [ matchid ]
  endif
  return a:name
endfunc

function s:ToggleHighlightHighlight()
  if empty(get(w:, 'highlighthighlights', [])) 
    let w:highlighthighlights = map(filter(getline('1','$'),
          \ 'v:val =~ ''^:\?hi\w*\s\(link\|clear\)\@!\s*\zs\(\w\+\)\ze\s\+'''),
          \ 's:AddHighlightHighlight(submatch(0))')
  else
    for matchid in get(w:, 'highlighthighlights', [])
      call matchdelete(matchid)
    endfor
    let w:highlighthighlights = [ ]
  endif
endfunc

:command! HiHi :call <SID>ToggleHighlightHighlight()


augroup misc_commands
  autocmd!
  " Set working directory to current file
  au BufEnter * silent! lcd %:p:h

  au FileType netrw setlocal nolist
  au FileType gitcommit setlocal nolist
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
