if exists("g:mayhem_loaded_messages")
  finish
endif
let g:mayhem_loaded_messages = 1

"
" Highlighting For:
"  Messages:    ../syntax/vimmessages.vim
"  Scriptnames: ../syntax/vimscriptnames.vim
"

" let s:mayhem_winid_messages
" let s:mayhem_winid_popupmessages
" let s:mayhem_winid_scriptnames
" let s:mayhem_winid_runtime

function s:GetRuntimeList() abort
  return split(&rtp, ',')[1:-1]
endfunc

function s:GetScriptnamesList() abort
  return execute('silent scriptnames')->split("\n")[1:-1]
endfunc

function s:GetMessagesList() abort
  return execute('silent messages')->split("\n")[1:-1]
endfunc


function s:SplitWithRuntime() abort
  :8new
  let s:mayhem_winid_runtime = win_getid(winnr())
  call append('$', s:GetRuntimeList())
  setlocal filetype=vimmessages nomodified nomodifiable
endfunc

function s:SplitWithScriptnames() abort
  :9new
  let s:mayhem_winid_scriptnames = win_getid(winnr())
  call append('$', s:GetScriptnamesList())
  setlocal filetype=vimmessages nomodified nomodifiable
endfunc


command! ListPlugins call s:SplitWithScriptnames()
command! Runtime call s:SplitWithRuntime()

"
" Expand <SNR> in messages output with real file names      TODO
"
function s:ExpandMessages(messages) abort
  call mapnew(a:messages, {i, v -> v})

endfunc

function s:OnVimEnter(when) abort
  if !exists('s:startup_messages')
    let s:startup_messages = s:GetMessagesList()
  else

  call autocmd_add([#{
        \ event: 'QuitPre', replace: v:true,
        \ cmd: 'call s:CloseMessages()',
        \ group: 'mayhem_messages_exit',
          \}])
  endif 
endfunc

if v:vim_did_enter
  call s:OnVimEnter('direct')
                                                                             
  echom 'messages did enter auto'
  call autocmd_add([#{
        \ event: 'VimEnter', once: v:true,
        \ cmd: 'call s:OnVimEnter("auto")',
        \ group: 'mayhem_messages_init', replace: v:true,
        \}])
endif

function s:WriteMessagesToBufferInWindow(winid) abort
  let bufnr = winbufnr(a:winid)

  let messages = s:GetMessagesList()
  if win_gettype(a:winid) == 'popup'
    call appendbufline(bufnr, 0, messages)
  else
    silent call deletebufline(bufnr, 1, '$')
    call appendbufline(bufnr, '$', '-- Startup Messages --')
    call appendbufline(bufnr, '$', '')
    call appendbufline(bufnr, '$', get(s:, 'startup_messages', []))
    call appendbufline(bufnr, '$', '')
    call appendbufline(bufnr, '$', '-- Recent Messages --')
    call appendbufline(bufnr, '$', '')
    call appendbufline(bufnr, '$', messages)
    call appendbufline(bufnr, '$', '')
    call appendbufline(bufnr, '$', '⁓ Fin ⁓')
    call win_execute(a:winid, ['call cursor(''$'', 0)', 'redraw'])
  endif
endfunc

"
" Open a split with output of :messages
"
function s:SplitWithMessages() abort
  if !exists('s:mayhem_winid_messages')
    vnew
    let s:mayhem_winid_messages = win_getid(winnr())

    nnoremap <buffer> <nowait> r <ScriptCmd>call s:RefreshMessages()<CR>
    nnoremap <buffer> <nowait> p <ScriptCmd>call s:SplitWithScriptnames()<CR>
    nnoremap <buffer> <nowait> t <ScriptCmd>call s:SplitWithRuntime()<CR>
    wincmd h
  endif

  call s:RefreshMessages()
endfunc

function s:RefreshMessages() abort
  call setbufvar(winbufnr(s:mayhem_winid_messages), '&filetype', 'vimmessages')
  call setwinvar(s:mayhem_winid_messages, '&modifiable', 1)
  call s:WriteMessagesToBufferInWindow(s:mayhem_winid_messages)
  call setwinvar(s:mayhem_winid_messages, '&modifiable', 0)
  call setwinvar(s:mayhem_winid_messages, '&modified', 0)
  call win_execute(s:mayhem_winid_messages, ['call cursor(''$'', 0)', 'redraw'])
endfunc

function s:CloseMessages() abort
  call s:CloseMessagesPopup()
  
  if exists('s:mayhem_winid_messages')
    call win_execute(s:mayhem_winid_messages, 'close')
    unlet s:mayhem_winid_messages
  endif
endfunc


function s:CloseMessagesPopup() abort
  if exists('s:mayhem_winid_popupmessages')
    call popup_close(s:mayhem_winid_popupmessages)
    unlet s:mayhem_winid_popupmessages
  endif
endfunc

"
" Key events intercepted by open popup
"
function s:MessagesPopupFilter(winid, key) abort
  if a:key == 'x'
    call s:CloseMessagesPopup()
    return 1
  endif
  return 0
endfunc

"
" Open a popup with recent output of :messages
"
function s:PopupWithMessages() abort
  let s:mayhem_winid_popupmessages = popup_create('', #{
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

  call s:WriteMessagesToBufferInWindow(s:mayhem_winid_popupmessages)

  call setbufvar(winbufnr(s:mayhem_winid_popupmessages), '&filetype', 'vimmessages')
endfunc

" function s:Messages() abort
"   if exists('s:mayhem_winid_messages')
"   else
"   endif
" endfunc

command! MessagesPopup call s:PopupWithMessages()

command! MessagesSplit call s:SplitWithMessages()

command! MessagesClose call s:CloseMessages()

command! MessagesRefresh call s:RefreshMessages()

"
" :Mess(ages) [show/hide/toggle] reload [auto/no]
command! Messages call s:SplitWithMessages()
