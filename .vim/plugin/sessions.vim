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
  echom 'session dir ''' .. g:mayhem_dir_session
        \ ..'''not found- creating it'
  call mkdir(g:mayhem_dir_session, "p", 0711)
endif

function! s:SessionNameToPath(name)
  return g:mayhem_dir_session .. '/' .. a:name .. '.session.vim'
endfunc

function! s:SessionCompleteOld(ArgLead, CmdLine, CursorPos)
  return map(globpath(g:mayhem_dir_session, a:ArgLead .. "*.session.vim", 0, 1),
        \ {_, val -> fnamemodify(val, ":t:r:r") .. '	|etc'})
endfunc

"
" :Session create [<new-session-id>]       (default to auto-generated name)
"          load <existing-session-id>
"          delete [<existing-session-id>]  (default to current session)
"          list                            (all sessions)
"          info 
"          pause
"          resume
"
"

" let s:subcommands = ['create', 'load', 'delete', 'list', 'info', 'pause', 'resume']

function s:Session(subcommand, ...)
  if a:subcommand == 'create'
    echo 'create!'
  elseif a:subcommand == 'load'
    echo 'load!'
  endif
endfunc

let s:subcommands = ['create', 'load', 'delete', 'list', 'info', 'pause', 'resume']

let s:match_command = '^Ses\%[sion]\s*'

" e.g. '\(c\%[reate]\|l\%[oad]\|l\%[ist]\|p\%[ause]\|r\%[esume]\|d\%[elete]\|i\%[nfo]\)'
let s:match_subcommand = '\(' .. 
      \mapnew(s:subcommands, {k, v -> v[0] .. '\%[' .. v[1:-1] .. ']'})->join('\|') ..
      \ '\)'
echom s:match_subcommand

let s:match_session = '\W\+'

" e.g. 'create^Minfo^MList^Mload^Mpause^Mresume^Mdelete^M'
let s:subcommand_completion = join(s:subcommands, "\n")
echom s:subcommand_completion

function! s:SessionComplete(ArgLead, CmdLine, CursorPos) abort
  echom 'a:ArgLead: ''' .. a:ArgLead ..
        \ ''', a:CmdLine: ''' .. a:CmdLine ..
        \ ''', a:CursorPos: ''' .. a:CursorPos .. ''''

  if a:CmdLine =~ s:match_command .. s:match_subcommand .. '\s*' .. s:match_session .. '\s*$'
    return 'a session...'
  elseif a:CmdLine =~ s:match_command .. s:match_subcommand .. '\s*$'
    return  'sessions...'
  elseif a:CmdLine =~ s:match_command .. s:match_subcommand
      return s:subcommand_completion
  else
      return s:subcommand_completion
  endif
endfunc

command! -nargs=+ -complete=custom,<SID>SessionComplete Session call s:Session(<f-args>)

function! s:SessionList()
  return expand('$HOME/.vim/session')
        \ ->readdirex({e -> e.name =~ '.session.vim$'})
        \ ->sort({a, b -> b.time - a.time})
        \ ->map({i, val -> [
          \ fnamemodify(val.name, ":t:r:r"),
          \ '     - updated within',
          \ format#timeSince(val.time),
          \ strftime("[%H:%M:%S %d-%m-%Y]", val.time),
          \ ]})
        \ ->join()
endfunc

function! SessionInfo()
  if empty(v:this_session)
    return '𝚗𝚘 𝚜𝚎𝚜𝚜𝚒𝚘𝚗'
  else
    if exists('g:loaded_obsession') && exists('g:this_obsession')
      return 'Obsession: ' .. v:this_session
    else
      return 'Session: ' .. v:this_session
    endif
  endif
endfunc


function! SessionNameForTitle() abort
  if empty(v:this_session)
    return '𝚗𝚘 𝚜𝚎𝚜𝚜𝚒𝚘𝚗'
  else
    return format#session(printf("%.14S", fnamemodify(v:this_session, ':t:r:r')))
  endif
endfunc

function! SessionName() abort
  if empty(v:this_session)
    return 'no session'
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
command! -nargs=1 -bang -complete=customlist,<SID>SessionCompleteOld
      \  SessionCreate
      \  mksession<bang> ~/.vim/session/<args>.session.vim
      \| if exists('g:loaded_obsession')
      \|   Obsession<bang> ~/.vim/session/<args>.session.vim
      \| endif

command! -nargs=1 -complete=customlist,<SID>SessionCompleteOld
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
\|  exec 'Obsession' g:this_session
      \|endif
      \|doautocmd User Obsession

function! s:SessionDelete(session = get(g:, 'this_session', v:null))
  if a:session != v:null
  endif
endfunc

command! -nargs=1 -complete=customlist,<SID>SessionCompleteOld
      \ SessionDelete
      \ if exists('g:loaded_obsession')
        \ && exists('g:this_obsession')
        \ && g:this_obsession == '~/.vim/session/<args>.session.vim'
      \|  Obsession
      \|endif
      \|!rm ~/.vim/session/<args>.session.vim

