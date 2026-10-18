if exists("g:mayhem_autoloaded_sl") || &cp
  finish
endif
let g:mayhem_autoloaded_sl = 1

"
" Related:
"  $VIMHOME/autoload/statusline.vim
"  $VIMHOME/plugin/statusline.vim
"

"
" Is the current window the current window
"
function! sl#CN() abort
  return g:actual_curwin == win_getid() ? 0 : 1
endfunc

"
" Retrieve either the current or not-current version of a cached statusline part
"
function! sl#getCN(from, key, default = [a:key .. '_C', a:key .. '_N']) abort
  return get(a:from, 'mayhem', {})
        \->get(a:key, a:default)
        \->get(sl#CN())
endfunc

function! sl#qfct() abort
  let count = getbufvar(bufnr(), 'mayhem_quickfix_count', -1)
  return count == -1 ? '?' : count == 0 ? '' : count
endfunc
function! sl#qfctp() abort
  let count = getbufvar(bufnr(), 'mayhem_quickfix_count', -1)
  return count == -1 ? '?' : count == 0 ? 'result' : 'results'
endfunc
function! sl#qffct() abor
  let count = getbufvar(bufnr(), 'mayhem_quickfix_filecount', -1)
  return count == -1 ? '?' : count == 0 ? '' : count
endfunc
function! sl#qffctp() abort
  let count = getbufvar(bufnr(), 'mayhem_quickfix_filecount', -1)
  return count == -1 ? '?' : count == 0 ? 'file' : 'files'
endfunc
