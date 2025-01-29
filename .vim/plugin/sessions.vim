if exists("g:mayhem_loaded_sessions")
  finish
endif
let g:mayhem_loaded_sessions = 1

if !exists('g:mayhem_dir_session')
  echom 'Session directory not defined (g:mayhem_dir_session)'
  let g:mayhem_loaded_sessions = 2
  finish
endif

if !isdirectory(g:mayhem_dir_session)
  echom 'session dir '''..g:mayhem_dir_session
        \ ..'''not found- creating it'
  call mkdir(g:mayhem_dir_session, "p", 0711)
endif

function! s:SessionNameToPath(name)
  return g:mayhem_dir_session..'/'..a:name..'.session.vim'
endfunc

function! s:SessionComplete(ArgLead, CmdLine, CursorPos)
  return map(globpath(g:mayhem_dir_session, a:ArgLead.."*.session.vim", 0, 1),
        \ {_, val -> fnamemodify(val, ":t:r:r")})
endfunc

function! s:RoughTimeSince(eventtime)
  let diffseconds = localtime() - a:eventtime
  if diffseconds < 1
    return 'the future'
  endif
  if diffseconds < 60
    return 'the last minute'
  endif
  if diffseconds < 3600
    return 'the last hour'
  endif
  if diffseconds < 86400
    return 'the last day'
  endif
  if diffseconds < 604800
    return 'the last week'
  endif
  if diffseconds < 2629743
    return 'the last month'
  endif
  if diffseconds < 31556926
    return 'the last year'
  endif
  return 'over a year ago'
endfunc

function! s:SessionList()
  return expand('$HOME/.vim/session')
        \ ->readdirex({e -> e.name =~ '.session.vim$'})
        \ ->sort({a, b -> b.time - a.time})
        \ ->map({i, val -> [
          \ fnamemodify(val.name, ":t:r:r"),
          \ '     - updated within',
          \ s:RoughTimeSince(val.time),
          \ strftime("[%H:%M:%S %d-%m-%Y]", val.time),
          \ ]})
        \ ->join()
endfunc

function! SessionInfo()
  if empty(v:this_session)
    return 'No Session'
  else
    if exists('g:loaded_obsession') && exists('g:this_obsession')
      return 'Obsession: '..v:this_session
    else
      return 'Session: '..v:this_session
    endif
  endif
endfunc


function s:ToFixedWidthFont(text)
  " '<,'>s/\u/\=nr2char(char2nr(submatch(0)) + 0x1D62F)/g
  " '<,'>s/\l/\=nr2char(char2nr(submatch(0)) + 0x1D629)/g
  return substitute(a:text, '\u',
        \ '\=nr2char(char2nr(submatch(0)) + 0x1D62F)',
        \ 'g')->substitute('\l',
        \ '\=nr2char(char2nr(submatch(0)) + 0x1D629)',
        \ 'g')
endfunc

function! SessionFixedWidthName()
  if empty(v:this_session)
    return '[𝙽𝚘 𝚂𝚎𝚜𝚜𝚒𝚘𝚗]'
  else
    return s:ToFixedWidthFont(fnamemodify(v:this_session, ':t:r:r'))
  endif
endfunc

function! SessionName()
  if empty(v:this_session)
    return '[No Session]'
  else
    return fnamemodify(v:this_session, ':t:r:r')
  endif
endfunc

" TODO
" reasonable default name for sessions, e.g. for autosaved ones
function! DefaultSessionName()
endfunc

command! SessionInfo echo SessionInfo()
command! SessionList echo <SID>SessionList()

" TODO - this could have a default for session name
command! -nargs=1 -bang -complete=customlist,<SID>SessionComplete
      \  SessionCreate
      \  mksession<bang> ~/.vim/session/<args>.session.vim
      \| if exists('g:loaded_obsession')
      \|   Obsession<bang> ~/.vim/session/<args>.session.vim
      \| endif

command! -nargs=1 -complete=customlist,<SID>SessionComplete
      \ SessionLoad
      \ so ~/.vim/session/<args>.session.vim
      \| if exists('g:loaded_obsession') && !exists('g:this_obsession')
      \|  Obsession
      \|endif

command!
      \ SessionPause
      \ if exists('g:loaded_obsession')
        \ && exists('g:this_session')
        \ && exists('g:this_obsession')
      \|  Obsession
      \|endif
      \|doautocmd User Obsession

command!
      \ SessionResume
      \ if exists('g:loaded_obsession')
        \ && exists('g:this_session')
        \ && !exists('g:this_obsession')
      \|  exec 'Obsession '..g:this_session
      \|endif
      \|doautocmd User Obsession

function! s:SessionDelete(session = get(g:, 'this_session', v:null))
  if a:session != v:null
  endif
endfunc

command! -nargs=1 -complete=customlist,<SID>SessionComplete
      \ SessionDelete
      \ if exists('g:loaded_obsession')
        \ && exists('g:this_obsession')
        \ && g:this_obsession == ~/.vim/session/<args>.session.vim
      \|  Obsession
      \|endif
      \|!rm ~/.vim/session/<args>.session.vim

