if exists("g:mayhem_loaded_csso")
  finish
endif
let g:mayhem_loaded_csso = 1

"
" CSS Optimise:
"
" See Also:
"                   ./css.vim
"                  ./svgo.vim (SVG optimise)
"           ../syntax/css.vim
"     ../after/syntax/css.vim
"         ../ftplugin/css.vim
"   ../after/ftplugin/css.vim
"


" CSSO
"
" 
command! -bar -range=% -nargs=0 CssOptimise <line1>,<line2> <Nop>


