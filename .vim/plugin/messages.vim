if exists("g:mayhem_loaded_messages")
  finish
endif
let g:mayhem_loaded_messages = 1


function! s:GetMessages()
    redir => l:messages
        silent messages
    redir end
    return split(l:messages, '\n')[1:-1]
endfunc

function! s:WriteMessagesToBufferInWindow(winid)
  let bufnr = winbufnr(a:winid)

  let messages = s:GetMessages()
  if win_gettype(a:winid) == 'popup'
    call appendbufline(bufnr, 0, s:GetMessages())
  else
    call setbufline(bufnr, 1, '-- Startup Messages --')
    call setbufline(bufnr, 2, '<SNR>XX->file? - :ListPlugins')
    call setbufline(bufnr, 3, '')
    call appendbufline(bufnr, 3, s:GetMessages())
  endif
endfunc

function! s:SplitWithMessages()
  vsp
  enew
  let s:mayhem_messages_winid = win_getid(winnr())

  au QuitPre <buffer> call s:CloseMessagesWindow()

  call s:WriteMessagesToBufferInWindow(s:mayhem_messages_winid)
  setlocal filetype=vimmessages nomodified nomodifiable
  wincmd h
endfunc

function s:MessagesPopupFilter(winid, key)
  if a:key == 'x'
    call popup_close(a:winid)
    return 1
  endif
  return 0
endfunc

function! s:PopupWithMessages()
  " au QuitPre <buffer> call s:CloseMessagesWindow()

  " setlocal filetype=vimmessages nomodified nomodifiable
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

  call setbufvar(winbufnr(s:mayhem_messages_popupwinid), '&filetype', 'vimmessages')
endfunc

function! s:CloseMessagesWindow()
  if exists('s:mayhem_messages_winid')
    call win_execute(s:mayhem_messages_winid, 'close')
    unlet s:mayhem_messages_winid
  endif
endfunc

function! s:CloseMessagesPopup()
  if exists('s:mayhem_messages_popupwinid')
    call popup_close(s:mayhem_messages_popupwinid)
    unlet s:mayhem_messages_popupwinid
  endif
endfunc

command! MessagesPopup call <SID>PopupWithMessages()
command! MessagesSplit call <SID>SplitWithMessages()

command! CloseMessages call <SID>CloseMessagesWindow()

