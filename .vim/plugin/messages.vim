if exists("g:mayhem_loaded_messages")
  finish
endif
let g:mayhem_loaded_messages = 1

"
" Highlighting For:
"  Messages:    ../syntax/vimmessages.vim
"  Scriptnames: ../syntax/vimscriptnames.vim
"

command! MessagesPopup call messages#popupWithMessages()

command! MessagesSplit call messages#split()

command! MessagesClose call messages#closeMessages()

command! MessagesRefresh call messages#refreshMessages()

"
" :Mess(ages) [show/hide/toggle] reload [auto/no]
"
command! Messages call messages#split()
