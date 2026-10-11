if exists("g:mayhem_autoloaded_search") || &cp
  finish
endif
let g:mayhem_autoloaded_search = 1

" === Ack / Search ===
"
" Related:
"   $VIMHOME/plugin/search.vim
"   $VIMHOME/plugin/quickfix.vim
"   $VIMHOME/after/ftplugin/qf.vim
"   $VIMHOME/../.ignore
"   $VIMHOME/../.gitignore
"   $HOME/.agignore
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


function! search#toSubstitute() abort
  if getcmdtype() =~ '[/?]'
    let search = '%s/' .. getcmdline() .. '/'
    return "\<C-c>:" .. search
  endif
  return ''
endfunc

function! search#expandLastSubstitute() abort
  if getcmdtype() =~ '[:]' && getcmdline() =~ '\%(%\|'<,'>\)\?s\%[ubstitute]\z([/|+!@£$%^&:]\)+'
    return "\<C-c>:" 
  endif
  return ''
endfunc


"
" For multi-line searches, make leading/trailing whitespace not matter
" TODO
"
" Prepend: ^\_s*
" Append: \_s*$
" Replace: \s*\n\+\s* \_s*\_$\_s*
"
" '<,'>s/\s*\n\+\s*/\\\_s*\\\_\$\\\_s\*/
"
function! search#fuzz(text) abort
  if stridx(a:pattern, '\n') < 0
    return '^\_s*' .. text .. '\_s*\_$'   
  else
    return '^\_s*' .. text .. '\_s*$\_s*'
  endif
endfunc


"
" Not: [0-9A-Za-z\"|#] (# only in vim9script)
" Used by preference in order specified
"
let s:separatorCandidates = split("/+!?$&@^~_-,.:;<=`'()[]{}", '.\zs')

"
" Find best separator that isn't in either pattern or replacement
"
function! search#separator(pattern, replacement) abort
  for c in s:separatorCandidates
    if stridx(a:pattern, c) < 0 && stridx(a:replacement, c) < 0
      return c
    endif
  endfor
endfunc

function! search#tosubstitute(text, replacement, options = {}) abort
  let trim = get(a:options, 'trim', v:true)
  let fuzzws = get(a:options, 'fuzzws', v:true)
  let flags = get(a:options, 'flags', 'cg')
  let pat = a:text
  let rep = a:replacement
  let opt = a:flags
  let sep = search#separator(pat, rep)

  return 's' .. sep .. pat .. sep .. rep .. sep .. opt
endfunc

function! search#ackEscaped(search, options = {}) abort
  let g:mayhem_last_ack_query = a:search
  let g:mayhem_last_ack_escaped = fnameescape(a:search)
  let g:mayhem_last_ack_case = get(a:options, 'case', 0)
  let g:mayhem_last_ack_root = get(a:options, 'root', 1)
  let g:mayhem_last_ack_literal = get(a:options, 'literal', 1)

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

function! search#ackClipboard() abort
  call search#ackEscaped(@")
endfunc

function! search#ackCurrentWord() abort
  call search#ackEscaped(expand("<cword>"))
endfunc

" function! search#ackLast() abort
"   call search#ackEscaped(@/)
" endfunc

function! search#ackInput() abort
  call inputsave()
  let search = input("Ack! ")
  call inputrestore()
  call search#ackEscaped(search, #{literal: 1, case: 0, root: 1})
endfunc

function! search#ackVisual() range abort
  " TODO
endfunc

function! search#ackArgs(args) abort
  " TODO
endfunc

function! search#ackArg(search) abort
  call search#ackEscaped(a:search, #{literal: 1, case: 0, root: 1})
endfunc

