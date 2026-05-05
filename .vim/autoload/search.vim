if exists("g:mayhem_autoloaded_search") || &cp
  finish
endif
let g:mayhem_autoloaded_search = 1

"
" See: ../plugin/search.vim
"

let s:countupdate_timer = 0

function! search#requestcountupdate() abort
  let s:countupdate_timer = timer_start(200, 'search#countupdate')
endfunc

function! search#countupdate(timer) abort
  if a:timer == get(s:, 'searchcount_timer', 0)
    call searchcount(#{recompute: 1, maxcount: 0, timeout: 100})
    DoUserAutocmd MayhemSearchCountUpdated
  endif
endfunc


