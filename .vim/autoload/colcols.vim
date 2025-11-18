if exists("g:mayhem_autoloaded_colcols") || &cp
  finish
endif
let g:mayhem_autoloaded_colcols = 1

"
" See: ../plugin/colcols.vim
"

" ╭── Column Guides ─────────────────────────────────────
"colcol#
" ├▻ add                      ┊+┊      Add guide at column (default: cursor)
" ├▻ alignLeftTo     A̲bc      ┃▒┃A̲bc     Align based on absolute column number, 
" ├▻ alignRightTo    A̲bc   A̲bc┃▒┃        or relative movement 
" ├▻ alignLeftOn     A̲bc      ┃A̲┃bc       ('+2', 'next', 'prev' etc.)
" ├▻ alignRightOn    A̲bc    A̲b┃c┃    
" ╰▻ delete                   ┊✕┊      Remove guide at column (default: cursor)


" TODO - use this with vartabstop/varsofttabstop



function colcols#list() abort
  return split(&l:colorcolumn, ',')->map({i, v -> str2nr(v)})
function

function! colcols#add(col = getcursorcharpos()[2]) abort
  exec 'setlocal colorcolumn+=' .. a:col
endfunc

function! colcols#delete(col = getcursorcharpos()[2]) abort
  exec 'setlocal colorcolumn-=' .. a:col
endfunc

" Return the column number of the color column to the right
" If no argument given, uses the column containing the cursor
" If there is no next color column, returns 0
function! colcols#next(col = getcursorcharpos()[2]) abort
  return s:GetColorColumnList()->filter({i, v -> v > a:col})->min()
endfunc

" Get the column of the previous color column within the same line
" If no argument given, uses the column containing the cursor
" If there is no previous color column, returns 0
function! colcols#prev(col = getcursorcharpos()[2]) abort
  return s:GetColorColumnList()->filter({i, v -> v < a:col})->max()
endfunc


function! colcols#cursorNext() abort
  call setcursorcharpos([getcursorcharpos()[1], colcols#next()])
endfunc

function! colcols#cursorPrev() abort
  call setcursorcharpos([getcursorcharpos()[1], colcols#prev()])
endfunc

" insert spaces to align position with column
" optional args:
"  from: column to pad from
"    to: column to align to
"
"⎟ 2  5     11        21
"⎟ Text     ░         ░
"⎟ ⁃1‐‐‐Text░         ░  to ⎧right
"⎟          ⁃2‐‐‐‐Text░     ⎧right
"⎟          ⁃2‐‐‐‐Text░     ⎧right
"⎟ ⁃‐‐‐‐‐‐‐‐Text      ░     ⎩left
"⎟ ⁃‐Text   ░‐‐Text‐‐‐░     ⎪center
"⎟          ░         ░
"
function! colcols#padOnColumn(from = getcursorcharpos()[2], to = colcols#next(a:from))
  if a:from >= a:to
    echo 'attempt to pad to left'
    " TODO - implement
  else
    let pad = a:to - a:from
    exec "normal! " .. (a:from >= a:to) ? 
          \ a:to .. "i \<Esc>" : '' .. pad .. "i \<Esc>"
  endif
endfunc

function! colcols#padToColumn(from = getcursorcharpos()[2], to = colcols#next(a:from))
  if a:from >= a:to
    echo 'attempt to pad to left'
    " TODO - implement
  else
    let a:pad = a:to - a:from + 1
    exec "normal! " .. a:pad .. "i \<Esc>"
  endif
endfunc


