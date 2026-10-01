if exists("g:mayhem_loaded_messages")
  finish
endif
let g:mayhem_loaded_messages = 1

"
" Highlighting For:
"  Messages:    ../syntax/vimmessages.vim
"  Scriptnames: ../syntax/vimscriptnames.vim
"

" let s:bufnr_messages
" let s:popid_messages
" let s:winid_scriptnames
" let s:winid_runtime

command! Runtime call messages#splitWithRuntime()

command! Scriptnames call messages#splitWithScriptnames()

command! MessagesPopup call messages#popupWithMessages()

command! MessagesSplit call messages#splitWithMessages()

command! MessagesClose call messages#closeMessages()

command! MessagesRefresh call messages#refreshMessages()

function! s:CloseIfLastWindow() abort
  if (winnr('$') == 1 && get(b:, ''mayhem_messages'', 0) == 1)
    quit
  endif
endfunc

call autocmd_add([
      \#{
      \ event: 'User', replace: v:true,
      \ pattern: 'MayhemHomeClosed',
      \ cmd: 'call s:CloseMessages()',
      \ group: 'mayhem_messages_exit',
      \},
      \#{
      \ event: 'WinEnter', replace: v:true,
      \ cmd: 'call s:QuitIfLastWindow()',
      \ group: 'mayhem_quit_if_last_window',
      \},
      \])

"
" :Mess(ages) [show/hide/toggle] reload [auto/no]
"
command! Messages call messages#split()
