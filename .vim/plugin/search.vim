if exists("g:mayhem_loaded_search")
  finish
endif
let g:mayhem_loaded_search = 1

" === Ack / Search ===
"
" Related:
"   $VIMHOME/autoload/search.vim
"   $VIMHOME/plugin/quickfix.vim
"   $VIMHOME/after/ftplugin/qf.vim
"   $VIMHOME/../.ignore
"   $VIMHOME/../.gitignore
"   $HOME/.agignore
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
  let sep = s:FindPatternSeperator(pat, rep)

  return 's' .. sep .. pat .. sep .. rep .. sep .. opt
endfunc


function s:AckEscaped(search, options = {}) abort
  let g:mayhem_last_ack_query = a:search
  let g:mayhem_last_ack_escaped = fnameescape(a:search)
  let g:mayhem_last_ack_case = get(options, 'case', 0)
  let g:mayhem_last_ack_root = get(options, 'root', 1)
  let g:mayhem_last_ack_literal = get(options, 'literal', 1)

  let g:mayhem_last_ack_dir = get(project#root(), 'path')

  " The ! avoids jumping to first result automatically
  let g:mayhem_last_ack_cmd = ([
        \ g:mayhem_last_ack_root ? 'CdProjectRoot' : '',
        \ [
        \  'Ack!',
        \  g:mayhem_last_ack_literal ? '-Q' : '',
        \  g:mayhem_last_ack_case ? '-s' : '',
        \  '--',
        \  '"' .. g:mayhem_last_ack_escaped .. '"',
        \ ]->join(' '),
        \])->join(' | ')

  exec g:mayhem_last_ack_cmd
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
  call s:AckEscaped(search, #{literal: 1, case: 0, root: 1})
endfunc

function s:AckVisual() range abort
  " TODO
endfunc

function s:AckArgs(args) abort
  " TODO
endfunc

function s:AckArg(search) abort
  call s:AckEscaped(a:search, #{literal: 1, case: 0, root: 1})
endfunc

command! -nargs=1 AckCmd call <SID>AckArg(<q-args>)
command! AckInput call <SID>AckInput()
command! AckClipboard call <SID>AckClipboard()
command! AckCurrentWord call <SID>AckCurrentWord()
command! AckLastSearch AckFromSearch

command! -range AckVisual <line1>,<line2>call <SID>AckVisual()
command! -nargs=1 AckArgs call <SID>AckArgs(<q-args>)


call autocmd_add([
      \#{
      \ event: ['CursorMoved','CursorMovedI'], pattern: '*',
      \ cmd: 'call search#requestcountupdate()',
      \ group: 'mayhem_search_countupdate', replace: v:true,
      \},
      \])

