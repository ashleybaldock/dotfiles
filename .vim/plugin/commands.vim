
" copy full path
:command! CopyPath let @+ = expand("%:p")
" copy just filename
:command! CopyFilename let @+ = expand("%:t")
" copy branch
:command! CopyBranch let @+ = FugitiveHead()
" copy buffer
:command! CopyBuffer let @+ = 'TODO'
" copy diff
:command! CopyDiff let @+ = 'TODO'

" find cursor
" highlight current cursor position by horizontal and vertical cursor
:command! PingCursor :


function CursorOnComment()
  return join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')) =~? 'comment'
endfunc

command! CursorOnComment :echo CursorOnComment()


" Information & Debug
"
:command! FormatInfo :setlocal filetype=javascript|call CocAction('format')|setlocal filetype=mh_winfo|setlocal nomodified nomodifiable
" getbufinfo(bufnr())
:command! BufferInfo :redir @">|silent echo '// Buffer Info'|silent echo getbufinfo(bufnr())|redir END|vsp|enew|put|FormatInfo
" getbufinfo()
:command! BuffersInfo :redir @">|silent echo '// All Buffers Info'|silent echo getbufinfo()|redir END|vsp|enew|put|FormatInfo
" getwininfo(winnr())
:command! WindowInfo :redir @">|silent echo '// Window Info'|silent echo getwininfo(win_getid())|redir END|vsp|enew|put|FormatInfo
" getwininfo()
:command! WindowsInfo :redir @">|silent echo '// All Windows Info'|silent echo getwininfo()|redir END|vsp|enew|put|FormatInfo

"[{'id': 491, 'name': 'vimFuncBody', 'cleared': v:true}]▹[{'id': 435, 'name': 'vimEcho', 'cleared': v:true}]▹[{'id': 417, 'linksto': 'Statement', 'name': 'vimCommand', 'default': v

" Highlighting & Syntax debug
"(ↀ ⋈ ⋯ ⨳ ♾ ⩆(◇▷ ⩈ ⩉⃞  ⫘  (⟠ ⧞  (○▫︎▫︎◎▹ ▻→'
augroup misc_commands
  autocmd!
  " Set working directory to current file
  au BufEnter * silent! lcd %:p:h
  au BufWinEnter * if (get(b:, 'linecount', 0) < get(g:, 'mayhem_sync_start_max_lines', 0)) | syn sync fromstart | endif

  " Use <esc> to close quickfix window
  " au FileType qf if mapcheck('<esc>', 'n') ==# '' | nnoremap <buffer><silent> <esc> :cclose<bar>lclose<CR> | endif
augroup END

" Create a split if current buffer has modifications
" Useful to run before a command that may open a new buffer
:command! SplitIfModified :if (&modified) | split | endif


  " !open '$VIMRUNTIME/../../../bin/mvim'
  "       \ --args -c 'delay 500m<CR>'
  "       \ -c 'echom testing<CR>'
  "       \ -c 'so /Users/ashley/tmp/vimpipe<CR>'
function s:ReopenSessionInNewPane()
  let pipe = shellescape(expand('$HOME/tmp/vimpipe'))
  exec '!rm '..pipe
  exec '!mkfifo '..pipe
  exec '!open --env VFR="'..shellescape(v:servername)..'" -a ''/Applications/MacVim.app/Contents/bin/mvim'' --args -c ''echom get(environ(), "VFR", "UNKNOWN")'' -c ''so '..pipe..''''
  exec 'mksession!'..pipe
endfunc
command! MoveToNewPane :call <SID>ReopenSessionInNewPane()

function! s:HighlightUnsavedWindows()
  if (&modified && &l:wincolor != 'WinUnsaved')
    s:WinColorOverride('WinUnsaved', 800)
  endif
endfunc
  
:command! Unsaved :windo call <SID>HighlightUnsavedWindows()


" ColorColumn guides TODO
command! AlignRightToCC :
command! AlignRightOnCC :
command! AlignLeftToCC :
command! AlignLeftOnCC :

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

