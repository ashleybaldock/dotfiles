if exists("g:mayhem_autoloaded_toggle") || &cp
  finish
endif
let g:mayhem_autoloaded_toggle = 1

"
" See: ../plugin/toggle.vim
"

"
" Generate predictable values from toggle variable name
"
function! toggle#parse(togglename) abort
  let [name, scope; rest] = split('g:' .. a:togglename, ':\zs')->reverse()
  let aupat = 'Toggle_' .. scope .. name
  let augroup = 'mayhem_update_' .. aupat
  return #{name: name, scope: scope, aupat: aupat, augroup: augroup}
endfunc

"
" Toggles a boolean variable's state, e.g. for config flags
"  + Sends a User autocmd notificaton to listeners, generated from
"    the variable name in the form: #User#Toggle_<scope>:<name>
" e.g.
"   g:mayhem_sl_show_winsize -> #User#Toggle_g:mayhem_sl_show_winsize
"
"   - If no scope is specified in the variable name, g: is used.
"   - In which case, the notification needs to contain g: as well.
"
"   mayhem_no_scope -> #User#Toggle_g:mayhem_no_scope
"
function! toggle#toggle(togglename) abort
  let tgl = toggle#parse(a:togglename)
  exec 'let' tgl.scope .. tgl.name '= !(get(' .. tgl.scope .. ',''' .. tgl.name .. ''', 1))'
  call mayhem#doUserAutocmd(tgl.aupat)
endfunc

"
" Returns the current state of a toggle
"
function! toggle#get(togglename) abort
  let tgl = toggle#parse(a:togglename)
  exec 'let result = get(' .. tgl.scope .. ',''' .. tgl.name .. ''', 0)'
  return result
endfunc


function! toggle#observe(togglename, callback) abort
  let tgl = toggle#parse(a:togglename)
  call autocmd_add([
        \#{
        \ event: 'User', pattern: tgl.aupat,
        \ cmd: a:togglecmd,
        \ group: tgl.augroup, replace: v:true,
        \},
        \])
endfunc

