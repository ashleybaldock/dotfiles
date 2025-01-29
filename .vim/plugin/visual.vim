if exists("g:mayhem_loaded_visual")
  finish
endif
let g:mayhem_loaded_visual = 1



"
" Vertical (ColorColumn) for first and last column
" Horizontal (Sign w/ line highlight) for top and bottom row
"
vmap §o <ScriptCmd>call s:OutlineVisualBlock()<CR>
function! s:OutlineVisualBlock() abort
  let [_, y1, vcol, voff] = getpos('v')
  let x1 = vcol + voff
  let [_, y2, ccol, coff, _] = getcurpos()
  let x2 = ccol + coff
  let dx = abs(x1 - x2)
  let dy = abs(y1 - y2)

  echom 'visual area: ('..x1..','..y1..')->('..x2..','..y2..')'
  
  " sign_undefine('visualextentsign')
  let aSign = sign_define('signvisualtop', { 
        \ 'text': '􀅃',
        \ 'linehl': 'ColorColNormal', 
        \ 'numhl': 'ColorColNormal', 
        \ 'texthl': 'ColorColNormal',
        \ 'culhl': 'ColorColNormal',
        \})
  let aSign = sign_define('signvisualbot', { 
        \ 'text': '􀅄',
        \ 'linehl': 'ColorColNormal', 
        \ 'numhl': 'ColorColNormal', 
        \ 'texthl': 'ColorColNormal',
        \ 'culhl': 'ColorColNormal',
        \})
  let aSign = sign_define('signvisualsame', { 
        \ 'text': '􂭎',
        \ 'linehl': 'ColorColNormal', 
        \ 'numhl': 'ColorColNormal', 
        \ 'texthl': 'ColorColNormal',
        \ 'culhl': 'ColorColNormal',
        \})
  call sign_unplace('visualextentsigns')
  if y1 == y2
    call sign_place(0, 'visualextentsigns', 'signvisualsame',
          \ bufnr(), { 'lnum': y1, 'priority': 11 }) 
  else
    call sign_place(0, 'visualextentsigns', 'signvisualtop',
          \ bufnr(), { 'lnum': min([y1,y2]), 'priority': 11 }) 
    call sign_place(0, 'visualextentsigns', 'signvisualbot',
          \ bufnr(), { 'lnum': max([y1,y2]), 'priority': 101 }) 
  endif
endfunc


