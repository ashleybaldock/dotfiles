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

command! -nargs=+ -complete=custom,session#complete Session call session#dispatch(<f-args>)


" function! s:SessionCompleteOld(ArgLead, CmdLine, CursorPos)
"   return map(globpath(g:mayhem_dir_session, a:ArgLead .. "*.session.vim", 0, 1),
"         \ {_, val -> fnamemodify(val, ":t:r:r") .. '	|etc'})
" endfunc

" function! SessionInfo()
"   if empty(v:this_session)
"     return '𝚗𝚘 𝚜𝚎𝚜𝚜𝚒𝚘𝚗'
"   else
"     if exists('g:loaded_obsession') && exists('g:this_obsession')
"       return 'Obsession: ' .. v:this_session
"     else
"       return 'Session: ' .. v:this_session
"     endif
"   endif
" endfunc


" " TODO
" " reasonable default name for sessions, e.g. for autosaved ones
" function! DefaultSessionName()
" endfunc

" " TODO - this could have a default for session name
" command! -nargs=1 -bang -complete=customlist,<SID>SessionCompleteOld
"       \  SessionCreate
"       \  mksession<bang> ~/.vim/session/<args>.session.vim
"       \| if exists('g:loaded_obsession')
"       \|   Obsession<bang> ~/.vim/session/<args>.session.vim
"       \| endif

" command! -nargs=1 -complete=customlist,<SID>SessionCompleteOld
" \ SessionLoad
"       \ so ~/.vim/session/<args>.session.vim
"       \| if exists('g:loaded_obsession') && !exists('g:this_obsession')
"       \|  Obsession
"       \|endif

" command!
"       \ SessionPause
"       \ if exists('g:loaded_obsession')
"         \ && exists('g:this_session')
"         \ && exists('g:this_obsession')
"       \|  Obsession
"       \|endif
"       \|doautocmd User Obsession

" command!
"       \ SessionResume
"       \ if exists('g:loaded_obsession')
"         \ && exists('g:this_session')
"         \ && !exists('g:this_obsession')
" \|  exec 'Obsession' g:this_session
"       \|endif
"       \|doautocmd User Obsession

" function! s:SessionDelete(session = get(g:, 'this_session', v:null))
"   if a:session != v:null
"   endif
" endfunc

" command! -nargs=1 -complete=customlist,<SID>SessionCompleteOld
"       \ SessionDelete
"       \ if exists('g:loaded_obsession')
"         \ && exists('g:this_obsession')
"         \ && g:this_obsession == '~/.vim/session/<args>.session.vim'
"       \|  Obsession
"       \|endif
"       \|!rm ~/.vim/session/<args>.session.vim

