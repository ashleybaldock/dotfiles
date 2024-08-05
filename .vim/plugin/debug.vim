if exists("g:mayhem_loaded_debug")
  finish
endif
let g:mayhem_loaded_debug = 1


function! s:GetScriptnames()
    redir => l:scriptnames
        silent scriptnames
    redir end
    return split(l:scriptnames, '\n')
endfunc

function! s:SplitWithScriptnames()
  vsp
  enew
  call append('$', s:GetScriptnames())
  setlocal filetype=vimscriptnames nomodified nomodifiable
endfunc
command! ListPlugins call <SID>SplitWithScriptnames()



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
        \ '/*═*/ const winfo = { /*═══════════════════════╱ Window ╱═════*/',
        \]
  let winInfo = winInfo + [
        \ '/**/ winid: ' .. a:winid .. ', /**/'
        \ .. ' floating: ''' .. isFloat .. ''',/**/',
        \ '/**/  type: ''' .. winType .. ''',/**/'
        \ .. ' bufnr: ' .. bufnr .. ',/**/'
        \ .. ' tabnr: ' .. tabnr .. ',/**/'
        \ .. ' winnr: ' .. winnr .. ',/**/',
        \]
  let winInfo = winInfo + [
        \ '/*─*/ "getwininfo": /*─────────────────────────*/',
        \ wInfo->items()->copy()->filter(
        \   {idx, val -> type(val) != v:t_func}
        \ )->js_encode()
        \ ..',',
        \ '/*─*/ "w:": /*─────────────────────────────────*/',
        \ items(w:)->copy()->filter(
        \   {idx, val -> type(val) != v:t_func}
        \ )->js_encode()
        \ ..',',
        \ '/*─*/ "getwinvar&": /*─────────────────────────*/',
        \ getwinvar(winnr, '&')->copy()->filter(
        \   {idx, val -> type(val) != v:t_func}
        \ )->js_encode()
        \ ..',',
        \]
  let popInfo = []
  if float
    let popInfo = popInfo + [
        \ '/*───────────────────╱ popup_getoptions() ╱───*/',
        \ 'const popup_info = ',
        \ popOpts->copy()->filter(
        \   {idx, val -> type(val) != v:t_func}
        \ )->js_encode()
        \]
  endif
 
  let bufInfo = [
        \ '/*════════════════════════════════╱ Buffer ╱═══*/',
        \]
  let bufInfo = bufInfo + [
        \ '/**/ bufnr: ' .. bufnr .. ', /**/'
        \ .. ' buftype: ''' .. bufType .. ''',/**/',
        \ 'windows: ' .. win_findbuf(bufnr)->copy()->filter(
        \   {idx, val -> type(val) != v:t_func}
        \ )->js_encode(),
        \]
  let bufInfo = bufInfo + [
        \ '/*─*/ "getbufinfo": /*─────────────────────────*/',
        \ getbufinfo(bufnr)[0]->copy()->filter(  {idx, val -> type(val) != v:t_func} )->js_encode(),
        \]
  let bufInfo = bufInfo + [
        \ '/*─*/ "getbufvar&": /*─────────────────────────*/',
        \ getbufvar(bufnr, '&')->copy()->filter(
        \   {idx, val -> type(val) != v:t_func}
        \ )->js_encode(),
        \]
  let bufInfo = bufInfo + [
        \ '/*────────────────╱  fin  ╱───────────────────*/'
        \]
  vsp
  enew
  call append('$', winInfo)
  call append('$', popInfo)
  call append('$', bufInfo)
  call s:FormatInfo()
endfunc

" Print window and buffer info into a split
" By default, uses current window, argument is ID of window
" to us otherwise
" Optionally takes ID of a different window
command! -nargs=? Winfo call <SID>WindowInfo(<f-args>)

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

command! CursorInfo call <SID>CursorInfoOn()<CR>


