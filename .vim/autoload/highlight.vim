if exists("g:mayhem_autoloaded_highlight") || &cp
  finish
endif
let g:mayhem_autoloaded_highlight = 1

"
" Related:
"   $VIMHOME/plugin/highlight.vim
"

function! highlight#myNewFunction(...) abort

endfunc

" 
" Get expanded hl definition for word under cursor
" e.g.
" Constant   ->   Constant
"
function! highlight#expand(name = expand("<cword>")) abort
  let hinfo = ExecAndReturn('hi ' .. a:name)
  return a:name .. ' ' .. substitute(hinfo, '^\S\+\s\+\S\+\s\+', '', '') 
endfunc
"
" Open location where hl group was last set
"
" By default, uses the word under the cursor
"
function! highlight#lastdefined(hlname = expand("<cword>")) abort
  let file = ''
  let lnum = 0
  try
    let [path, line] = execute('verbose hi ' .. a:hlname)
          \->matchlist('Last set from \(.\+\) line \(\d\+\)')[1:2]
  catch
    echom 'Highlight group ''' .. a:hlname .. ''' does not exist'
    return
  endtry

  return [path, line]
endfunc

let s:none = echo#with('None')
let s:path = echo#with('None')
let s:sep = echo#with('None')
let s:lnum = echo#with('None')

function! highlight#formatLastDefinedForCommand(hlname = expand("<cword>")) abort
  let [path, line] = highlight#lastdefined(a:hlname)

  return ['echo'
        \ 'Hlgroup ''',
        \ a:hlname,
        \ ''' last defined @ ',
        \ path,
        \ ':',
        \ line,
        \]->join('')
endfunc

function! highlight#formatLastDefinedForCommandWithColor(hlname = expand("<cword>")) abort
  let [path, line] = highlight#lastdefined(a:hlname)

  return [
        \ s:none('Hlgroup '),
        \ echo#format(a:hlname, a:hlname),
        \ s:none(' last defined @ '),
        \ s:path(path),
        \ s:sep(':'),
        \ s:lnum(line),
        \]->flatten()->join(' | ')
endfunc

function! highlight#this(hlname = expand("<cword>")) abort
  exec 'hi' a:hlname
endfunc
