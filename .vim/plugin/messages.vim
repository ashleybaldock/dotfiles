if exists("g:mayhem_loaded_messages")
  finish
endif
let g:mayhem_loaded_messages = 1

"
" Highlighting:
"  $VIMHOME/syntax/vimmessages.vim
"  $VIMHOME/syntax/vimscriptnames.vim
"

command! MessagesPopup call messages#popupWithMessages()

command! MessagesSplit call messages#split()

command! MessagesClose call messages#closeMessages()

command! MessagesRefresh call messages#refreshMessages()

"
" :Mess(ages) [show/hide/toggle] reload [auto/no]
"
command! Messages call messages#split()

nnoremap <silent><script> <Plug>(mayhem_messages_toggle) <Cmd>call messages#visible() ? messages#hide() : messages#split()<CR>

nnoremap <silent><script> <Plug>(mayhem_messages_reload) <Cmd>call messages#visible() ? messages#reload() : messages#split()<CR>
