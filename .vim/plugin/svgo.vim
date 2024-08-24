if exists("g:mayhem_loaded_svgo")
  finish
endif
let g:mayhem_loaded_svgo = 1


" TODO
" - ignore leading comment chars
" - select SVG if cursor is inside one
" - convert dataurl containing SVG/b64 SVG and process that too


command! Svgo :'<,'>!svgo --input - 

" <svg xmlns="http://www.w3.org/2000/svg" viewBox="1 0 20 20"><path d="m4.3 2.9 12.8 12.8-1.4 1.4L2.9 4.3zM17.1 4.3 4.3 17.1l-1.4-1.4L15.7 2.9z"/></svg>



