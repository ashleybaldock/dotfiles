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

function! sl#qftitle() abort
  return get(w:, 'quickfix_title', 'quickfix list')
endfunc
function! sl#qfsearch() abort
  return get(g:, 'mayhem_last_ack_query', 'search')
endfunc
function! sl#qfesc() abort
  return getbufvar(bufnr(), 'mayhem_last_ack_escaped', 'escaped')
endfunc
function! sl#qfcase() abort
  return getbufvar(bufnr(), 'mayhem_last_ack_case', 0)
endfunc
function! sl#qfroot() abort
  return getbufvar(bufnr(), 'mayhem_last_ack_root', 1)
endfunc
function! sl#qfliteral() abort
  return getbufvar(bufnr(), 'mayhem_last_ack_literal', 1)
endfunc
function! sl#qfdir() abort
  return getbufvar(bufnr(), 'mayhem_last_ack_dir', '?/')
endfunc
function! sl#qfcmd() abort
  return getbufvar(bufnr(), 'mayhem_last_ack_cmd', ' :?? ')
endfunc

function! sl#qfct() abort
  let qfct = getbufvar(bufnr(), 'mayhem_quickfix_count', -1)
  return qfct == -1 ? '?' : qfct == 0 ? '' : qfct
endfunc
function! sl#qfctp() abort
  let qfct = getbufvar(bufnr(), 'mayhem_quickfix_count', -1)
  return qfct == -1 ? '?' : qfct == 0 ? '' : qfct == 1 ? 'result' : 'results'
endfunc
function! sl#qfin() abort
  let qfct = getbufvar(bufnr(), 'mayhem_quickfix_count', -1)
  return qfct == -1 ? 'in' : qfct == 0 ? '' : 'in'
endfunc
function! sl#qffct() abor
  let qffct = getbufvar(bufnr(), 'mayhem_quickfix_filecount', -1)
  return qffct == -1 ? '?' : qffct == 0 ? '' : qffct
endfunc
function! sl#qffctp() abort
  let qffct = getbufvar(bufnr(), 'mayhem_quickfix_filecount', -1)
  return qffct == -1 ? '?' : qffct == 0 ? '' : qffct == 1 ? 'file' : 'files'
endfunc

function! sl#qfcounts() abort
  let results = getbufvar(bufnr(), 'mayhem_quickfix_count', 0)
  let files = getbufvar(bufnr(), 'mayhem_quickfix_filecount', 0)

  return results == 0 ? 'no results' : format#CN([
        \ '%{',
        \ '%(',
        \ ' %#SlQfCt⸮#%{%sl#qfct()%}%#SlQf⸮# %{%sl#qfctp()%}',
        \ ' %{%sl#qfin()%} ',
        \ '%#SlQfCt⸮#%{%sl#qffct()%}%#SlQf⸮# %{%sl#qffctp()%}',
        \ ' %)',
        \ '%* ',
        \ '%}'])
endfunc
