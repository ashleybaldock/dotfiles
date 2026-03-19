if exists("g:autoloaded_mayhem") || &cp
  finish
endif
let g:autoloaded_mayhem = 1

scriptencoding utf-8



" let acmd = #{
"       \bufnr:   '',
"       \cmd:     '',
"       \event:   '',
"       \group:   '',
"       \nested:  '',
"       \once:    '',
"       \pattern: '',
"       \replace: '', 
"       \}

"
" Do User Autocmd (but only if anything is listening)
"
" See: ../plugin/#mayhem.vim
"
function! mayhem#doUserAutocmd(name) abort
  if exists('#User#' .. a:name)
    exec 'doautocmd User ' .. a:name
  endif
endfunc

function! mayhem#paste() abort
  if exists('b:mayhem_home')
    exec 'enew'
  endif
  exec 'normal "+gP' 
endfunc

"
" Group dicts by value of a common key
"  i.e. [a{k:v1}, b{k:v2}, c{k:v1}] -> {v1:[a,c],v2:[b]}
"
function! mayhem#groupby(arrayOfDicts, key) abort
  let grouped = {}
  for item in a:arrayOfDicts
    let group = get(item, a:key, '_ungrouped')
    if !has_key(grouped, group)
      let grouped[group] = []
    endif
    call add(grouped[group], item)
  endfor
  return grouped
endfunc
"
" Group and subgroup dicts by value of common keys
"  i.e. [a{i:1,j:4}, b{i:2,j:4}, c{i:1,j:3}] -> {1:{4:[a],3:[c]},2:{4:[b]}}
"
function! mayhem#groupby2(arrayOfDicts, key1, key2) abort
  let grouped = {}
  for item in a:arrayOfDicts
    let group1 = get(item, a:key1, '_ungrouped')
    let group2 = get(item, a:key2, '_ungrouped')
    if !has_key(grouped, group1)
      let grouped[group1] = {}
    endif
    if !has_key(grouped[group1], group2)
      let grouped[group1][group2] = []
    endif
    call add(grouped[group1][group2], item)
  endfor
  return grouped
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
  return get(g:mayhem_path_hints, expand(a:path)->fnamemodify(':p:h'), {})
        \->get('hint', '')
endfunc

function! mayhem#getSubtypeForPath(path)
  return get(g:mayhem_path_hints, expand(a:path)->fnamemodify(':p:h'), {})
        \->get('subtype', '')
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



" function mayhem#visualChars() abort
"   let [_, y1, vcol_char, voff_char] = getcharpos('v')
"   let x1_char = vcol_char + voff_char
"   let [_, y2, ccol_char, coff_char, _] = getcursorcharpos()
"   let x2_char = ccol_char + coff_char
"   let dx_char = abs(x1_char - x2_char)
"   return #{from: min(x1_char, x2_char), to: max(x1_char, x2_char), count: dx_char}
" endfunc


