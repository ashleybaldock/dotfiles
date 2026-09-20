if exists("g:mayhem_autoloaded_echo") || &cp
  finish
endif
let g:mayhem_autoloaded_echo = 1

"
" Related:
"     $VIMHOME/plugin/echo.vim
"

function! echo#format(group = 'EchoText', ...) abort
  return [
        \ 'echoh ' .. a:group,
        \ 'echon ''' .. flattennew(a:000)->join(' ') .. '''',
        \ 'echoh None',
        \ ]->join(' | ')
endfunc

"
" Returns a function that formats echo commands with the given highlight group
"
function! echo#with(group = 'EchoText') abort
  return function('echo#format', [a:group])
endfunc

