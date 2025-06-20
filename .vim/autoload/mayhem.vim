if exists("g:autoloaded_mayhem") || &cp
  finish
endif
let g:autoloaded_mayhem = 1

scriptencoding utf-8


"
" Do User Autocmd (but only if anything is listening)
"
function! mayhem#doUserAutocmd(name)
  if exists('#User#' .. a:name)
    exec 'doautocmd User ' .. a:name
  endif
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
function! mayhem#Toggle(togglename) 
  let [name, scope; rest] = split('g:' .. a:togglename, ':\zs')->reverse()
  exec 'let' scope .. name '= !(get(' .. scope .. ',''' .. name .. ''', 1))'
  call mayhem#doUserAutocmd('#User#Toggle_' .. scope .. name)
endfunc

function! mayhem#Toggled(togglename) abort
  let [name, scope; rest] = split('g:' .. a:togglename, ':\zs')->reverse()
  exec 'let result = get(' .. scope .. ',''' .. name .. ''', 0)'
  return result
endfunc


" show hint for files in these folders
" most specific is used
if !exists('g:mayhem_path_hints')
  let g:mayhem_path_hints = {}
endif
if !exists('g:mayhem_type_ext_map')
  let g:mayhem_type_ext_map = {}
endif

function! mayhem#getHintForPath(path)
  return get(g:mayhem_path_hints, fnamemodify(expand(a:path), ':p:h'), {})->get('hint', '')
endfunc
function! mayhem#getSubtypeForPath(path)
  return get(g:mayhem_path_hints, fnamemodify(expand(a:path), ':p:h'), {})->get('subtype', '')
endfunc

function mayhem#fileTypeMatchesExt(type, filename)
  let ext = fnamemodify(a:filename, ':e')
  let name = fnamemodify(a:filename, ':r')
  let tail = fnamemodify(a:filename, ':t')
  let typemapping = get(g:mayhem_type_ext_map, a:type, [])

  return a:type != '' && a:type == ext
        \ || index(typemapping, ext) >= 0
        \ || name == tail && index(typemapping, name) >= 0
endfunc

" TODO
" function s:PathDifference(path1, path2)
"   echo fnamemodify(expand(a), ':p:h')
" endfunc

