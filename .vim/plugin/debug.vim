if exists("g:mayhem_loaded_debug")
  finish
endif
let g:mayhem_loaded_debug = 1


"
" Turn a Vim dict into a JSON, taking care of any pesky Funcrefs
"
function! DictToJson(someDict)
  echom a:someDict->deepcopy()->map(
        \ {key, val -> (type(val) == v:t_func)
        \  ? '[FuncRef:'..string(val)..']'
        \  : val})->json_encode()
endfunc

" Window & Buffer debug info
"
function! s:FormatInfo()
  setlocal filetype=javascript buftype=nowrite nobuflisted
  file notarealfile.js
  setlocal nomodified
  Prettier
  " call CocAction('format')
  setlocal nomodified nomodifiable
  0file
endfunc
command! FormatInfo call <SID>FormatInfo()

function! s:WindowInfo(winid = win_getid())
  let wInfo = getwininfo(a:winid)[0]
  let float = get(get(wInfo, 'variables', {}), 'float', 0)
  let isFloat = float ? 'Yes' : 'No'
  let popOpts = float ? popup_getoptions(a:winid) : ''
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
  let winInfo = [
        \ '/*═*/ { /*═══════════════════════╱ Window ╱═════*/',
        \]
  let winInfo = winInfo + [
        \ '/**/ "winid": "' .. a:winid .. '", /**/'
        \ .. ' "floating": ' .. isFloat .. ',/**/',
        \ '/**/  "type": "' .. winType .. '",/**/'
        \ .. ' "bufnr": ' .. bufnr .. ',/**/'
        \ .. ' "tabnr": ' .. tabnr .. ',/**/'
        \ .. ' "winnr": ' .. winnr .. ',/**/',
        \]
  let winInfo = winInfo + [
        \ '/*─────────────────────────────*/ "getwininfo":',
        \ wInfo->items()->DictToJson() .. ',',
        \ '/*─────────────────────────────────────*/ "w:":',
        \ items(w:)->DictToJson() .. ',',
        \ '/*─────────────────────────────*/ "getwinvar&":',
        \ getwinvar(winnr, '&')-DictToJson() .. ',',
        \]
  let popInfo = []
  if float
    let popInfo = popInfo + [
        \ '/*───────────────────╱ popup_getoptions() ╱───*/',
        \ '"popup_info": ',
        \ popOpts->DictToJson() .. ',',
        \]
  endif
 
  let bufInfo = [
        \ '/*════════════════════════════════╱ Buffer ╱═══*/',
        \]
  let bufInfo = bufInfo + [
        \ '/**/ { "bufnr": "' .. bufnr .. '", /**/'
        \ .. ' "buftype": "' .. bufType .. '",/**/',
        \ '"windows": ' .. win_findbuf(bufnr)->DictToJson() .. ',',
        \]
  let bufInfo = bufInfo + [
        \ '/*─*/ ,"getbufinfo": /*─────────────────────────*/',
        \ getbufinfo(bufnr)[0]->DictToJson() .. ',',
        \ '/*'
        \]
  let bufInfo = bufInfo + [
        \ '/*─*/ ,"getbufvar&": /*─────────────────────────*/',
        \ getbufvar(bufnr, '&')->DictToJson() .. ',',
        \]
  let bufInfo = bufInfo + [
        \ '/*─*/ } /*────╱  fin  ╱───────────────────*/'
        \]
  vsp
  enew
  call append('$', FormatJSON(winInfo))
  call append('$', FormatJSON(popInfo))
  call append('$', FormatJSON(bufInfo))
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


