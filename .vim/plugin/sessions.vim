if exists("g:mayhem_loaded_sessions")
  finish
endif
let g:mayhem_loaded_sessions = 1


function! s:SessionComplete(ArgLead, CmdLine, CursorPos)
  " return map(globpath('$HOME/.vim/session/', a:ArgLead .. "*.session.vim", 0, 1),
  return map(globpath(g:mayhem_dir_session, a:ArgLead .. "*.session.vim", 0, 1),
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

function! s:SessionInfo()
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

command! SessionInfo call <SID>SessionInfo()
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
      \| if exists('g:loaded_obsession')
      \|  Obsession
      \|endif

command!
      \ SessionPause
      \ if exists('g:loaded_obsession')
        \ && exists('g:this_session')
        \ && exists('g:this_obsession')
      \|  Obsession
      \|endif

command!
      \ SessionResume
      \ if exists('g:loaded_obsession')
        \ && exists('g:this_session')
        \ && !exists('g:this_obsession')
      \|  exec 'Obsession '..g:this_session
      \|endif

command! -nargs=1 -complete=customlist,<SID>SessionComplete
      \ SessionDelete
      \ if exists('g:loaded_obsession')
      \|  Obsession!
      \|else
      \|  !rm ~/.vim/session/<args>.session.vim
      \|endif

