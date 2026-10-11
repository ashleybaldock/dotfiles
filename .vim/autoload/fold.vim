if exists("g:mayhem_autoloaded_fold") || &cp
  finish
endif
let g:mayhem_autoloaded_fold = 1

"
" Related:
"   $VIMHOME/plugin/fold.vim
"

function! fold#linecount() abort
  return str2nr(v:foldend) - str2nr(v:foldstart)
endfunc

function! fold#startline() abort
  return getline(v:foldstart)
        \->substitute('<!--\|-->\|/\*\|\*/\|{{{\d\=', '', 'g')
endfunc

function! fold#endline() abort
  return getline(v:foldend)
        \->substitute('<!--\|-->\|/\*\|\*/\|{{{\|}}}\d\=', '', 'g')
endfunc

function! fold#marker() abort
  let startline = getline(v:foldstart)
  return [
        \ '╴',
        \  substitute(v:folddashes, '-', '❰', 'g'),
        \ ' ',
        \ fold#startline()->trim(),
        \ ' ❱╶ ─ ╴❰ ',
        \ fold#linecount(),
        \ ' lines folded ❱'
        \]->join('')
endfunc

" gitgutter#fold#is_changed()

function! fold#indent() abort
  return [
        \ fold#startline()[:30],
        \ ' //════════❰ ',
        \ fold#linecount(),
        \ ' lines folded ❱',
        \]->join('')
endfunc

"
" Get a list of fold locations to make signs for
"
function! fold#signs() abort
endfunc

"
" Custom folding
"
function! fold#level() abort
endfunc


