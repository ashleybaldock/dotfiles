if exists("g:mayhem_loaded_copy")
  finish
endif
let g:mayhem_loaded_copy = 1

" ╭──────────────────╮
" ╰─◯  Copy things   │
" ╭──────────────────╯
" │
" ╰─╴filesystem
" ╎   ├─▶︎ full path
command! CopyPath let @+ = expand("%:p")
" ╎   ╰─▶︎ full path
command! CopyFilename let @+ = expand("%:t")
" ╎
" ╰─╴git
" ╎   ├─▶︎ branch
command! CopyGitBranch let @+ = FugitiveHead()
" ╎   ╰─▶︎ diff                                      TODO
command! CopyGitDiff let @+ = 'TODO'
" ╎
" ╰─╴current buffer
" ╎   ├─▶︎ info                                      TODO
command! CopyBufferInfo let @+ = 'TODO'
" ╎   ├─▶︎ contents                                  TODO
command! CopyBuffer let @+ = 'TODO'
" ╎
" ╰─╴cursor
" ╎   ├─▶︎ unicode info from Characterize
command!  -nargs=? CopyCharacterize redir @+>| Characterize <args> | redir END
" ╎   ├─▶︎ unicode char name                         TODO
" :command!  -nargs=? CopyCharacterize redir @+>| Characterize <args> | redir END
" ╎   ╰─▶︎ unicode info, character codepoint         TODO
command! CopyCharCode let @+ = 'TODO'
" ╎
" ╰─╴search
" ╎   ╰─▶︎ last
command! CopyLastSearch let @+=@/
" ╎
" ╰─╴Coc
" ╎   ├─▶︎ Last diagnostic message
command! CopyDiagnostic redir @+>| silent echo CocAction('diagnosticInfo', 'echo') | redir END
" ╎   ├─▶︎ Last hover window message
command! CopyHoverInfo redir @+>| silent echo CocAction('getHover') | redir END
" ╎   ╰─▶︎ Last location jump list
command! CopyLastJumpList let @+ = get(g:last_coc_jump_locations)
" ╎
" ╰─╴Vim/Debug
" ╎   ├─▶︎ Messages
command! CopyMessages redir @+>| silent messages | redir END
