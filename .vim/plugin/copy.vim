if exists("g:mayhem_loaded_copy")
  finish
endif
let g:mayhem_loaded_copy = 1

" ╭───────────────────────────────●
" │
" ╰─◯  Copy Things ◯───────────────╮
"                                  │
"    See Also:                     │
"     $y in ./shortcuts.vim        │
"           ./redir.vim            │
"                                  │
" ╭────────────────────────────────╯
" │
" ╰─╴filesystem
" ╎   ├─▶︎ full path
command! -bar CopyPath let @+ = expand("%:p")
" ╎   ╰─▶︎ full path
command! -bar CopyFilename let @+ = expand("%:t")
" ╎
" ╰─╴git
" ╎   ├─▶︎ branch
command! -bar CopyGitBranch let @+ = FugitiveHead()
" ╎   ╰─▶︎ diff
command! -bar CopyGitDiff let @+ = 'TODO'
" ╎
" ╰─╴current buffer
" ╎   ├─▶︎ info
command! -bar CopyWinfo silent call ExecToRegister('Winfo', '+')
" ╎   ├─▶︎ contents
command! -bar -nargs=? -range=% CopyBuffer let @+ = getbufline(bufname(<q-args>), <line1>, <line2>)->join("\n")
" ╎
" ╰─╴cursor
" ╎   ├─▶︎ unicode info from Characterize
" command! -bar -nargs=? CopyCharacterize redir @+>| Characterize <args> | redir END
command! -bar -nargs=? CopyCharacterize silent call ExecToRegister('Characterize '..<q-args>, '+')
" ╎   ├─▶︎ unicode info, character codepoint
command! -bar -nargs=? CopyCharCode redir @+>| GetCharCode <args> | redir END
" ╎   ╰─▶︎ unicode info, character codepoint
command! -bar -nargs=? CopyCharCodeMatch redir @+>| GetCharCodeMatch <args> | redir END
" ╎
" ╰─╴search
" ╎   ╰─▶︎ last
command! -bar CopyLastSearch let @+=@/
" ╎
" ╰─╴Coc
" ╎   ├─▶︎ Last diagnostic message
command! -bar CopyDiagnostic let @+ = CocAction('diagnosticInfo', 'echo')->join("\n").."\n"
" ╎   ├─▶︎ Last hover window message
command! -bar CopyHoverInfo let @+ = CocAction('getHover')->join("\n").."\n"
" ╎   ╰─▶︎ Last location jump list
command! -bar CopyLastJumpList let @+ = get(g:last_coc_jump_locations)
" ╎
" ╰─╴Vim/Debug
" ╎   ├─▶︎ Messages
command! -bar CopyMessages silent call ExecToRegister('silent messages', '+')

"
command! -complete=command -nargs=? CopyExec silent call ExecToRegister(<q-args>, '+')
