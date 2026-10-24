if exists("g:mayhem_loaded_table")
  finish
endif
let g:mayhem_loaded_table = 1


"
" Optional argument sets delimiter to insert between columns of output
" (defaults to <Tab>)
"
command! -nargs=? -range TransposeRowCol <line1>,<line2>call table#transpose(<f-args>)
