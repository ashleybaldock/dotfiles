
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
function! DiffToggle()
  if &diff
    setlocal wincolor=WinDiff
  endif
endfunc
augroup misc_commands
  autocmd!
  " Set working directory to current file
  au BufEnter * silent! lcd %:p:h

  au DiffUpdated * setlocal wincolor=WinDiff
  au OptionSet diff call SetUpDiffMappings()
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

" Overide current window background color temporarily
function! s:WinColorOverride(tempwincolor)
  let w:mayhem_saved_wincolor = &l:wincolor
  let &l:wincolor = a:tempwincolor
endfunc
function! s:WinColorReset()
  echom 'WinColorReset'..&l:wincolor..&wincolor
  let &l:wincolor = get(w:, 'mayhem_saved_wincolor', 'WinNormal')
endfunc

function! s:HighlightUnsavedWindows()
  if &modified && &l:wincolor != 'WinUnsaved'
    let w:mayhem_saved_wincolor = &l:wincolor
    let &l:wincolor = 'WinUnsaved'
    call timer_start(get(g:, 'mayhem_show_unsaved_duration', 800), {_ -> s:WinColorReset()})
  endif
endfunc
  
:command! WinColorReset :call <SID>WinColorReset()
:command! Unsaved :windo call <SID>HighlightUnsavedWindows()


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

