if exists("g:mayhem_autoloaded_predicates") || &cp
  finish
endif
let g:mayhem_autoloaded_predicates = 1

"
" Get visibility status for the sign column in the given window
" returns:
"   v:false:   if adding a sign will not cause window content to move
"               (i.e. sign column is already visible, or never shown)
"               - signcolumn=yes
"               - signcolumn=no
"               - signcolumn=auto && sign count > 0
"               - signcolumn=number && number=
"   v:true:    if adding a sign would shift window contents
"                  i.e. sign column=no, or auto and no signs placed yet
"              signcolumn=yes,
"              signcolumn=auto && number of signs > 0
"              signcolumn=number && number
"              signcolumn=number && nonumber && number of signs > 0
"           1 if sign column is visible 
"
function! predicates#addingSignWillShiftSignColumn(winid = win_getid(winnr())) abort
  let signcolumn = getwinvar(a:winid, '&signcolumn')
  let signcount = sign_getplaced(winbufnr(winnr()), {'group':'*'})[0]['signs']->len()
  let number = getwinvar(a:winid, '&number')

  return ('auto' == signcolumn && 0 == signcount)
  \ || ('number' == signcolumn && 0 == number && 0 == signcount)
endfunction

