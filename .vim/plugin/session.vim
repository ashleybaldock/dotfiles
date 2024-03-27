
function! s:SessionComplete(ArgLead, CmdLine, CursorPos)
  return map(globpath('$HOME/.vim/session/', a:ArgLead .. "*.session.vim", 0, 1),
        \ {_, val -> fnamemodify(val, ":t:r:r")})
endfunc

:command! -nargs=? -complete=customlist,<SID>SessionComplete
      \ NewSession
      \ :mksession ~/.vim/session/<args>.session.vim

:command! -nargs=? -complete=customlist,<SID>SessionComplete
      \ LoadSession
      \ :so ~/.vim/session/<args>.session.vim
