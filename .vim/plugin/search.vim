if exists("g:mayhem_loaded_search")
  finish
endif
let g:mayhem_loaded_search = 1

" === Ack / Search ===
"
" Related:
"   $VIMHOME/autoload/search.vim
"   $VIMHOME/plugin/quickfix.vim
"   $VIMHOME/after/ftplugin/qf.vim
"   $VIMHOME/../.ignore
"   $VIMHOME/../.gitignore
"   $HOME/.agignore
"

command! -nargs=1 AckCmd call search#ackArg(<q-args>)
command! AckInput call search#ackInput()
command! AckClipboard call search#ackClipboard()
command! AckCurrentWord call search#ackCurrentWord()
command! AckLastSearch AckFromSearch

command! -range AckVisual <line1>,<line2>call search#ackVisual()
command! -nargs=1 AckArgs call search#ackArgs(<q-args>)


call autocmd_add([
      \#{
      \ event: ['CursorMoved','CursorMovedI'], pattern: '*',
      \ cmd: 'call search#requestcountupdate()',
      \ group: 'mayhem_search_countupdate', replace: v:true,
      \},
      \])

