if exists("g:mayhem_loaded_messages")
  finish
endif
let g:mayhem_loaded_messages = 1

"
" Highlighting For:
"  Messages:    ../syntax/vimmessages.vim
"  Scriptnames: ../syntax/vimscriptnames.vim
"

function s:GetScriptnames() abort
  return execute('silent scriptnames')->split("\n")[1:-1]
endfunc

function s:SplitWithScriptnames() abort
  :8new
  let s:mayhem_scriptnames_winid = win_getid(winnr())
  call append('$', s:GetScriptnames())
  setlocal filetype=vimscriptnames nomodified nomodifiable
endfunc

command! ListPlugins call s:SplitWithScriptnames()

function s:GetMessages() abort
  return execute('silent messages')->split("\n")[1:-1]
endfunc

"
" Expand <SNR> in messages output with real file names      TODO
"
function s:ExpandMessages(messages) abort
  call mapnew(a:messages, {i, v -> v})

endfunc

function s:OnVimEnter(when) abort
  echom 'messages ' .. a:when
  if !exists('s:startup_messages')
    let s:startup_messages = s:GetMessages()
  endif
  call autocmd_add([#{
        \ event: 'QuitPre', replace: v:true,
        \ cmd: 'call s:CloseMessages()',
        \ group: 'mayhem_messages_exit',
        \}])
endfunc

if v:vim_did_enter
  echom 'messages did enter direct'
  call s:OnVimEnter('direct')
else
  echom 'messages did enter auto'
  call autocmd_add([{
        \ 'event': 'VimEnter','once': v:true,
        \ 'cmd': 'call s:OnVimEnter("auto")',
        \ 'group': 'mayhem_messages_init','replace': v:true,
        \}])
endif

function s:WriteMessagesToBufferInWindow(winid) abort
  let bufnr = winbufnr(a:winid)

  let messages = s:GetMessages()
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
  endif
endfunc

"
" Open a split with output of :messages
"
function s:SplitWithMessages() abort
  if !exists('s:mayhem_messages_winid')
    vnew
    let s:mayhem_messages_winid = win_getid(winnr())

    nnoremap <buffer> <nowait> r <ScriptCmd>call s:RefreshMessages()<CR>
    nnoremap <buffer> <nowait> p <ScriptCmd>call s:SplitWithScriptnames()<CR>
    setlocal filetype=vimmessages 
    setlocal nomodified nomodifiable
    wincmd h
  endif

  call s:RefreshMessages()
endfunc

function s:RefreshMessages() abort
  call setbufvar(winbufnr(s:mayhem_messages_winid), '&filetype', 'vimmessages')
  call setwinvar(s:mayhem_messages_winid, '&modifiable', 1)
  call s:WriteMessagesToBufferInWindow(s:mayhem_messages_winid)
  call setwinvar(s:mayhem_messages_winid, '&modifiable', 0)
  call setwinvar(s:mayhem_messages_winid, '&modified', 0)
endfunc

function s:CloseMessages() abort
  if exists('s:mayhem_scriptnames_winid')
    call win_execute(s:mayhem_scriptnames_winid, 'close')
    unlet s:mayhem_scriptnames_winid
  endif
  if exists('s:mayhem_messages_winid')
    call win_execute(s:mayhem_messages_winid, 'close')
    unlet s:mayhem_messages_winid
  endif
endfunc


function s:CloseMessagesPopup() abort
  if exists('s:mayhem_messages_popupwinid')
    call popup_close(s:mayhem_messages_popupwinid)
    unlet s:mayhem_messages_popupwinid
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
  let s:mayhem_messages_popupwinid = popup_create('', #{
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

  call s:WriteMessagesToBufferInWindow(s:mayhem_messages_popupwinid)

  " setlocal filetype=vimmessages nomodified nomodifiable
  call setbufvar(winbufnr(s:mayhem_messages_popupwinid), '&filetype', 'vimmessages')
endfunc

command! MessagesPopup call s:PopupWithMessages()

command! MessagesSplit call s:SplitWithMessages()

command! MessagesClose call s:CloseMessages()

command! MessagesRefresh call s:RefreshMessages()

