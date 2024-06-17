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
  call append('$', s:GetMessages())
  setlocal filetype=vimscriptnames nomodified nomodifiable
endfunc
command! ListPlugins call <SID>SplitWithScriptnames()



" Window & Buffer debug info
"
function! s:FormatInfo()
  setlocal filetype=javascript
  call CocAction('format')
  setlocal filetype=mayhemwinfo
  setlocal nomodified nomodifiable
endfunc
command! FormatInfo call <SID>FormatInfo()

function! s:WindowInfo(winid = win_getid())
  let wInfo = getwininfo(a:winid)
  let float = get(get(wInfo, 'variables', {}), 'float', 0)
  let popOpts = float ? popup_getoptions(a:winid) : ''
  let bufnr = get(wInfo, 'bufnr', 0)

  let winInfo = [
        \ '// Window Info',
        \ wInfo,
        \ '// ------------------------------------'
        \]
  let popInfo = [
        \ '// popup options',
        \ popOpts,
        \ '// ------------------------------------'
        \]
 
  let bufinfo = [
        \ '// Buffer Info',
        \ getbufinfo(bufnr()),
        \ '// ------------------------------------'
        \]
  vsp
  enew
  call append('$', winInfo)
  call append('$', popInfo)
  call append('$', bufinfo)
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


