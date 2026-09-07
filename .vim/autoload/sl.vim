if exists("g:mayhem_autoloaded_sl") || &cp
  finish
endif
let g:mayhem_autoloaded_sl = 1

"
" Related
"    $VIMHOME/autoload/statusline.vim
"    $VIMHOME/plugin/statusline.vim
"

function! sl#CN() abort
  return g:actual_curwin == win_getid() ? 0 : 1
endfunc

function! sl#getCN(from, key, default = [a:key .. '_C', a:key .. '_N']) abort
  return get(a:from, 'mayhem', {})
        \->get(a:key, a:default)
        \->get(sl#CN())
endfunc


