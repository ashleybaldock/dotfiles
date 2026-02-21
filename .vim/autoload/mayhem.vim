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
" Turn an array of dicts into a dict of arrays of dicts
" that have the same value for the grouping key
"
function! mayhem#groupby(array, keyToGroupBy) abort
  let grouped = {}
  for item in array
    if has_key(item, keyToGroupBy)
      let group = get(a:array, a:keyToGroupBy, '')
      if has_key(grouped, group)
        call add(grouped[group], item)
      else
        let grouped[group] = [item]
      endif
    endif
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


