if exists("g:mayhem_loaded_colorcolumn")
  finish
endif
let g:mayhem_loaded_colorcolumn = 1

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

command! AddColumnGuide :silent exec 'setlocal colorcolumn+='..virtcol('.')
command! RemoveColumnGuide :silent exec 'setlocal colorcolumn+='..virtcol('.')

" Return the column number of the color column to the right
" If no argument given, uses the cursor position
" If no color column exists to the right, returns input column
function! s:ColorColumnToRightOf(...)
  let colorcolumns = split(&l:colorcolumn, ',')
  let col = get(a:, 1, getcursorcharpos()[2])
  let nearestToRight = min(filter(colorcolumns, 'v:val > col'))
  return nearestToRight
endfunc

" Return the column number of the color column to the left
" If no argument given, uses the cursor position
" If no color column exists to the left, returns input column
function! s:ColorColumnToLeftOf(...)
  let colorcolumns = split(&l:colorcolumn, ',')
  let col = get(a:, 1, getcursorcharpos()[2])
  let nearestToLeft = max(filter(colorcolumns, 'v:val < col'))
  return nearestToLeft
endfunc

function! s:MoveToNextColorColumn()
  call setcursorcharpos([getcursorcharpos()[1], s:ColorColumnToRightOf()])
endfunc

function! s:MoveToPrevColorColumn()
  call setcursorcharpos([getcursorcharpos()[1], s:ColorColumnToLeftOf()])
endfunc
command! MoveToNextColorColumn :call <SID>MoveToNextColorColumn()
command! MoveToPrevColorColumn :call <SID>MoveToPrevColorColumn()

" insert spaces to align position with column
" optional args:
"  from: column to pad from
"    to: column to align to
function! s:PadOnColumn(...)
  let from = get(a:, 1, getcursorcharpos()[2])
  let to = get(a:, 2, s:ColorColumnToRightOf(from))
  if from >= to
    echo 'attempt to pad to left'
  else
    let pad = to - from
    exec "normal! "..pad.."i \<Esc>"
  endif
endfunc

function! s:PadToColumn(...)
  let from = get(a:, 1, getcursorcharpos()[2])
  let to = get(a:, 2, s:ColorColumnToRightOf(from))
  if from >= to
    echo 'attempt to pad to left'
  else
    let pad = to - from + 1
    exec "normal! "..pad.."i \<Esc>"
  endif
endfunc

" ColorColumn guides TODO
command! AlignRightToColorColumn :call <SID>PadToColumn()
command! AlignRightOnColorColumn :call <SID>PadOnColumn()
command! AlignLeftToColorColumn :
command! AlignLeftOnColorColumn :

command! AlignCenteredOn :
command! AlignCenteredBetween :

" nnoremap §\ 
" Add a horizontal row guide at cursor position
" TODO
" Clear guides at the cursor position (horizontal first, then vertical)
" TODO
" 
nnoremap §<S-\> :setlocal colorcolumn=<CR>
