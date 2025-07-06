if exists("g:mayhem_loaded_search")
  finish
endif
let g:mayhem_loaded_search = 1

" === Ack / Search ===
"
" See: ../../../.agignore
"         ../../.ignore
"         ../../.gitignore
"


" For multi-line searches, make leading/trailing whitespace not matter
" TODO
"
" Prepend: ^\_s*
" Append: \_s*$
" Replace: \s*\n\+\s* \_s*\_$\_s*
"
" '<,'>s/\s*\n\+\s*/\\\_s*\\\_\$\\\_s\*/
function! s:FuzzWhitespace(text)
  if stridx(a:pattern, '\n') < 0
    return '^\_s*' .. text .. '\_s*\_$'   
  else
    return '^\_s*' .. text .. '\_s*$\_s*'
  endif
endfunc


" Not: [0-9A-Za-z\"|#] (# only in vim9script)
" Used by preference in order specified
let s:separatorCandidates = split("/+!?$&@^~_-,.:;<=`'()[]{}", '.\zs')

" Find best separator that isn't in either pattern or replacement
function! s:FindPatternSeperator(pattern, replacement)
  for c in s:separatorCandidates
    if stridx(a:pattern, c) < 0 && stridx(a:replacement, c) < 0
      return c
    endif
  endfor
endfunc

function MakeSubstitute(text, replacement, options = {})
  let trim = get(a:options, 'trim', v:true)
  let fuzzws = get(a:options, 'fuzzws', v:true)
  let flags = get(a:options, 'flags', 'cg')
  let pat = a:text
  let rep = a:replacement
  let opt = a:options
  let sep = s:FindPatternSeperator(pattern, replacement)

  return 's'..sep..pat..sep..rep..sep..opt
endfunc


function s:AckEscaped(search) abort
  " The ! avoids jumping to first result automatically
  execute printf('Ack! -Q -- "%s"', substitute(a:search, '\([%"\\]\)', '\\\1', 'g'))
endfunc

function s:AckClipboard() abort
  call s:AckEscaped(@")
endfunc

function s:AckCurrentWord() abort
  call s:AckEscaped(expand("<cword>"))
endfunc

" function s:AckLastSearch() abort
"   call s:AckEscaped(@/)
" endfunc

function! s:AckInput() abort
  call inputsave()
  let search = input("Ack! ")
  call inputrestore()
  call s:AckEscaped(search)
endfunc

function s:AckVisual() range abort
  " TODO
endfunc

function s:AckArgs(args) abort
  " TODO
endfunc

command! AckInput exec <SID>AckInput()
command! AckClipboard exec <SID>AckClipboard()
command! AckCurrentWord exec <SID>AckCurrentWord()
command! AckLastSearch AckFromSearch

command! -range AckVisual <line1>,<line2>call <SID>AckVisual()
command! -nargs=1 AckArgs exec <SID>AckArgs(<q-args>)
