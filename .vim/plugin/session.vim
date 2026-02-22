if exists("g:mayhem_loaded_session")
  finish
endif
let g:mayhem_loaded_session = 1

"
" Related: ../autoload/session.vim
"
" TODO
" - auto-sessions that can be upgraded to a named session
" - reasonable default name for sessions, e.g. for autosaved ones
"

if !exists('g:mayhem_dir_session')
  echom 'Session directory not defined (g:mayhem_dir_session)'
  let g:mayhem_loaded_sessions = 2
  finish
endif

if !isdirectory(g:mayhem_dir_session)
  echom 'session dir ''' .. g:mayhem_dir_session
        \ ..'''not found- creating it'
  call mkdir(g:mayhem_dir_session, "p", 0711)
endif

command! -nargs=+ -complete=custom,session#complete Session call session#dispatch(<f-args>)

