if exists("g:mayhem_autoloaded_messages") || &cp
  finish
endif
let g:mayhem_autoloaded_messages = 1

"
" Related:
"   $VIMHOME/plugin/messages.vim
"
"   $VIMHOME/syntax/vimmessages.vim
"   $VIMHOME/syntax/vimscriptnames.vim
"


function! messages#listRuntime() abort
  return split(&rtp, ',')[1:-1]
endfunc

function! messages#listScriptnames() abort
  return execute('silent scriptnames')->split('\s*\n\s*')
  " echo execute('silent scriptnames')->split('\s*\n\s*')->map({_,s -> split(s, '\s*:\s*')})
endfunc

function! messages#list() abort
  return execute('silent messages')->split("\n")[1:-1]
endfunc

function! messages#listToBuffer(bufnr, list) abort
  call setbufvar(a:bufnr, '&modifiable', 1)
  silent! call deletebufline(a:bufnr, 1, '$')
  call appendbufline(a:bufnr, 0, a:list)
  call setbufvar(a:bufnr, 'mayhem_lastupdated', localtime())
  call setbufvar(a:bufnr, '&modifiable', 0)
  call setbufvar(a:bufnr, '&modified', 0)
  call win_execute(winbufnr(a:bufnr), ['redraw', 'call cursor(''$'', 0)'])
endfunc

function! messages#listToSplit(list) abort
  exec min([20, max([4, len(a:list)])]) .. 'new'
  let bufnr = bufnr()
  call messages#listToBuffer(bufnr, a:list)
  call setbufvar(bufnr, '&buftype', 'nofile')
  call setbufvar(bufnr, '&bufhidden', 'wipe')
  call setbufvar(bufnr, '&buflisted', 0)
  return win_getid(winnr())
endfunc

function! messages#splitWithRuntime() abort
  let s:winid_runtime = extend(['Runtime'], messages#listRuntime())
        \->messages#listToSplit()
  call winbufnr(s:winid_runtime)
        \->setbufvar('&filetype', 'vimruntime')
endfunc

function! messages#splitWithScriptnames() abort
  let s:winid_scriptnames = extend(['Scriptnames'], messages#listScriptnames())
        \->messages#listToSplit()
  call winbufnr(s:winid_scriptnames)
        \->setbufvar('&filetype', 'vimscriptnames')
endfunc

"
" Expand <SNR> in messages output with real file names      TODO
"
function! messages#expandSNR(messages) abort
  return mapnew(a:messages,
        \{i, v -> substitute(v,
        \ '\%(\.\.\(function\|script\)\?\)\?<SNR>\(\d\+\)_\([^.[]\+\)\[\(\d*\)]',
        \   {m -> "  " .. m[3] .. "		" .. m[1] .. getscriptinfo(#{
        \ sid: str2nr(m[2], 10)})[0].name .. ':' .. m[4] .. "\n" }, 'g')->split("\n")})->flatten(1)
  "let replaceHome = map(replaceSNR,
  "     \ {_, p -> substitute(p, expand('$VIMHOME') .. '[]', 'g')
  return replaceSNR
endfunc

"
" Get number of buffer used to output messages to
"
" Return -1 if it doesn't exist, or creates it if create argument is set 
"
function! messages#bufnr(create = v:false) abort
  let s:bufnr_messages = get(s:, 'bufnr_messages', -1)

  if !bufexists(s:bufnr_messages) && a:create
    let s:bufnr_messages = bufadd('')

    call setbufvar(s:bufnr_messages, '&filetype', 'vimmessages')
    call setbufvar(s:bufnr_messages, '&buftype', 'nofile')
    call setbufvar(s:bufnr_messages, '&bufhidden', 'wipe')

    call autocmd_add([
          \#{
          \ event: 'ExitPre', replace: v:true,
          \ bufnr: s:bufnr_messages, group: 'mayhem_messages_quit',
          \ cmd: 'quit',
          \},
          \#{
          \ event: 'WinEnter', replace: v:true,
          \ bufnr: s:bufnr_messages, group: 'mayhem_messages_quit',
          \ cmd: 'if (winnr(''$'') == 1 | quit | endif',
          \},
          \])
  endif

  return s:bufnr_messages
endfunc

function! messages#refresh(msgbufnr = messages#bufnr(1)) abort
  let messages = messages#list()
  let messagesExpanded = messages#expandSNR(messages)

  call messages#listToBuffer(a:msgbufnr, messages)
endfunc

"
" Open a split with output of :messages
"
function! messages#split() abort

  let msgbufnr = messages#bufnr(1)

  exec 'vertical ' .. msgbufnr .. 'wincmd ^'

  call messages#refresh()

  nnoremap <buffer> <nowait> r <Cmd>call messages#refresh()<CR>
  nnoremap <buffer> <nowait> p <Cmd>call messages#splitWithScriptnames()<CR>
  nnoremap <buffer> <nowait> t <Cmd>call messages#splitWithRuntime()<CR>
  wincmd h

  return msgbufnr
endfunc

function! messages#close() abort
  call messages#bufnr()->winbufnr()->win_execute('close')
endfunc


"
" Messages popup
"

function! messages#popupClose() abort
  call get(s:, 'popid_messages', -1)->popup_close()
  unlet s:popid_messages
endfunc

"
" Key events intercepted by open popup
"
function! messages#popupFilter(winid, key) abort
  if a:key == 'x'
    call messages#popupClose()
    return 1
  endif
  return 0
endfunc

"
" Open a popup with recent output of :messages
"
function! messages#popup() abort
  let s:popid_messages = popup_create(messages#bufnr(1), #{
        \ title: 'Messages',
        \ pos: 'topleft',
        \ minwidth: 40,
        \ maxwidth: 80,
        \ minheight: 6,
        \ padding: [0,1,0,1],
        \ border: [1,1,1,1],
        \ highlight: 'HlPop01Bg',
        \ borderhighlight: ['HlPop01T','HlPop01R','HlPop01B','HlPop01L'],
        \ borderchars: [' ','⎥',' ','⎢', '⎛','⎞','⎠','⎝'],
        \ line: 'cursor',
        \ col: 'cursor',
        \ moved: 'any',
        \ filter: 's:MessagesPopupFilter',
        \ filtermode: 'n'
        \ })

  call messages#bufnr()->messages#refresh()
endfunc

