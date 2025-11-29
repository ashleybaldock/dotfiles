if exists("g:mayhem_autoloaded_colcol") || &cp
  finish
endif
let g:mayhem_autoloaded_colcol = 1

"
" See: ../plugin/colcol.vim
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



function! colcol#list() abort
  return split(&l:colorcolumn, ',')->map({i, v -> str2nr(v)})
endfunc

function! colcol#add(col = getcursorcharpos()[2]) abort
  exec 'setlocal colorcolumn+=' .. a:col
endfunc

function! colcol#clear() abort
  exec 'setlocal colorcolumn='
endfunc

function! colcol#delete(col = getcursorcharpos()[2]) abort
  exec 'setlocal colorcolumn-=' .. a:col
endfunc

" Return the column number of the color column to the right
" If no argument given, uses the column containing the cursor
" If there is no next color column, returns 0
function! colcol#next(col = getcursorcharpos()[2]) abort
  return s:GetColorColumnList()->filter({i, v -> v > a:col})->min()
endfunc

" Get the column of the previous color column within the same line
" If no argument given, uses the column containing the cursor
" If there is no previous color column, returns 0
function! colcol#prev(col = getcursorcharpos()[2]) abort
  return s:GetColorColumnList()->filter({i, v -> v < a:col})->max()
endfunc


function! colcol#cursorNext() abort
  call setcursorcharpos([getcursorcharpos()[1], colcol#next()])
endfunc

function! colcol#cursorPrev() abort
  call setcursorcharpos([getcursorcharpos()[1], colcol#prev()])
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
function! colcol#padOnColumn(from = getcursorcharpos()[2], to = colcol#next(a:from))
  if a:from >= a:to
    echo 'attempt to pad to left'
    " TODO - implement
  else
    let pad = a:to - a:from
    exec "normal! " .. (a:from >= a:to) ? 
          \ a:to .. "i \<Esc>" : '' .. pad .. "i \<Esc>"
  endif
endfunc

function! colcol#padToColumn(from = getcursorcharpos()[2], to = colcol#next(a:from))
  if a:from >= a:to
    echo 'attempt to pad to left'
    " TODO - implement
  else
    let a:pad = a:to - a:from + 1
    exec "normal! " .. a:pad .. "i \<Esc>"
  endif
endfunc


