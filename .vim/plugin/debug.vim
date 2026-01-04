if exists("g:mayhem_loaded_debug")
  finish
endif
let g:mayhem_loaded_debug = 1

"
" Window & Buffer debug info
"
function s:FormatInfo()
  setlocal filetype=javascript buftype=nowrite nobuflisted
  file notarealfile.js
  setlocal nomodified
  Prettier
  " call CocAction('format')
  setlocal nomodified nomodifiable
  0file
endfunc
command! FormatInfo call <SID>FormatInfo()

function s:WindowInfo(winid = win_getid())
  let wInfo = getwininfo(a:winid)[0]
  let float = get(wInfo, 'variables', {})->get('float', 0)
  let isFloat = float ? 'Yes' : 'No'
  let bufnr = get(wInfo, 'bufnr', 0)
  let winType = win_gettype(a:winid)
  if winType == ''
    let winType = '<none>'
  endif
  let bufType = getbufvar(bufnr, '&buftype')
  if bufType == ''
    let bufType = '<none>'
  endif
  let tabnr = win_id2tabwin(a:winid)[0]
  let winnr = win_id2tabwin(a:winid)[1]
  let w = {'╺╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╱╱ Winfo ╱╱╍╍╍╍╍╸':
        \{ '╶───╴╱ window ╱╶──────────────────────────────────╴':
        \{ 'winid': a:winid
        \, 'popup': isFloat
        \, 'type': winType
        \, 'bufnr': bufnr
        \, 'tabnr': tabnr
        \, 'winnr': winnr
        \, 'getwininfo': wInfo->items()
        \, 'w:': items(w:)
        \, 'getwinvar&': getwinvar(winnr, '&')
        \ }
        \,'╶───╴╱ popup ╱╶───────────────────────────────────╴':
        \ float ? { 'popup_getoptions()': popup_getoptions(a:winid) } : {},
        \ '╶───╴╱ buffer ╱╶──────────────────────────────────╴':
        \{ ' bufnr': bufnr
        \, ' buftype': bufType
        \, ' windows': win_findbuf(bufnr)
        \, ' getbufinfo': getbufinfo(bufnr)[0]
        \, ' getbufvar&': getbufvar(bufnr, '&')
        \}
        \, '╺╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╱  fin  ╱╍╍╍╍╍╍╍╸': ""
        \}}
  vsp
  enew
  call append('$', format#dict2json(w))
  setlocal filetype=json
  setlocal nomodifiable nomodified 
endfunc

" Print window and buffer info into a split
" By default, uses current window, argument is ID of window
" to us otherwise
" Optionally takes ID of a different window
command! -bar -nargs=? Winfo call <SID>WindowInfo(<f-args>)

command! WinfoLastCocFloat call <SID>WindowInfo(g:coc_last_float_win)



function! s:CursorInfoUpdateFocusGained()
  let s:hasfocus = 1
  call s:CursorInfoUpdate()
endfunc

function! s:CursorInfoUpdateFocusLost()
  let s:hasfocus = 0
  call s:CursorInfoUpdate()
endfunc

function! s:CursorInfoUpdate()
  let mousepos = getmousepos()

endfunc

function! s:CursorInfoOff()
  augroup CursorInfo
    autocmd!
  augroup END
  
  " remove popup
endfunc

function! s:CursorInfoOn()
  augroup CursorInfo
    autocmd!

    au FocusGained * call s:CursorInfoUpdateFocusGained()
    au FocusLost * call s:CursorInfoUpdateFocusLost()
    au VimResized,FocusGained,FocusLost,CursorMoved,CursorMovedI * call s:CursorInfoUpdate()
  augroup END
endfunc

command! CursorInfo call <SID>CursorInfoOn()


