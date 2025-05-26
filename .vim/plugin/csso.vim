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
command! -bar -range -nargs=? CssOptimise
      \ :'<,'>!node '.vim/js/csso.js' 2>~/log/csso-vim.log

