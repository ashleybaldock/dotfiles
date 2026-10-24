if exists("g:mayhem_autoloaded_table") || &cp
  finish
endif
let g:mayhem_autoloaded_table = 1

"
" Related:
"   $VIMHOME/plugin/table.vim
"

"
" Transpose Rows And Columns: in range or visual selection
"
function! table#transpose(sep='	') range abort
  exec a:firstline .. ',' .. a:lastline .. '!rs -T -g1 -C' .. a:sep
  exec line("'[") .. ',' .. line("']") .. 's/^\zs\s*//g'

endfunc


" TODO
" sort table
" detect table under cursor
"  sort table / selected rows
"  - by column N / cursor position
"  - by regex
"
"
" move column
"  - left/right (by count N)
"  - to position N
" swap columns
"
"
" de-duplicate/normalise
"  - selected column to list of values
"     _
" 1 2 a      1 2 a,b,c
" 1 2 b      2 4 a,b
" 1 2 c  ->  2 5 b,c
" 2 4 a
" 2 4 b
" 2 5 b
" 2 5 c

