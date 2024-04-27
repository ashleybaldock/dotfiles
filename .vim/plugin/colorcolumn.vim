
" ╭── Column Guides ─────────────────────────────────────
" │ 
" ├─▻ AddColGuide                 ┊+┊      Add column guide at cursor
" ├─▻ LeftToColGuide  ⎛ A̲bc ▬▶︎ A̲bc┃▒┃    ⎞ Align selection To.. Left
" ├─▻ RightToColGuide ⎝ A̲bc ▬▶︎    ┃▒┃A̲bc ⎠                      Right 
" ├─▻ LeftOnColGuide  ⎛ A̲bc ▬▶︎  A̲b┃c┃    ⎞ Align selection On.. Left
" ├─▻ RightOnColGuide ⎝ A̲bc ▬▶︎    ┃A̲┃bc  ⎠                      Right
" ╰─▻ RemoveColGuide              ┊✕┊      Remove the column guide nearest to
"                                          the cursor, if two are equally close, 
"                                          remove the leftmost first.

command! AddColumnGuide :silent exec 'setlocal colorcolumn+='..virtcol('.')<CR>
command! RemoveColumnGuide :silent exec 'setlocal colorcolumn+='..virtcol('.')<CR>

" ColorColumn guides TODO
command! AlignRightToCC :
command! AlignRightOnCC :
command! AlignLeftToCC :
command! AlignLeftOnCC :

command! AlignCenteredOn :
command! AlignCenteredBetween :

" nnoremap §\ 
" Add a horizontal row guide at cursor position
" TODO
" Clear guides at the cursor position (horizontal first, then vertical)
" TODO
" 
nnoremap §<S-\> :setlocal colorcolumn=<CR>
