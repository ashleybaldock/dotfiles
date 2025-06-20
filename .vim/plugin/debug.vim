if exists("g:mayhem_loaded_debug")
  finish
endif
let g:mayhem_loaded_debug = 1


"
" Turn a Vim dict into a JSON, taking care of any pesky Funcrefs
"
let s:replace = {_, v -> '['..typename(v)..']'}
let s:identity = {_, v -> v}
function s:Lookup(key, val)
  return get(s:typemap, string(type(a:val)), s:replace)(a:key, a:val)
endfunc
let s:lookup = function('s:Lookup')
let s:typemap = {
      \  string(v:t_number): s:identity
      \, string(v:t_string): {_, v -> substitute(v, '\n', '\\n', 'g')}
      \, string(v:t_func): s:replace
      \, string(v:t_list): {_, v -> v->map(s:lookup)}
      \, string(v:t_dict): {_, v -> v->map(s:lookup)}
      \, string(v:t_float): s:identity
      \, string(v:t_bool): s:identity
      \, string(v:t_none): {_, v -> 'null'}
      \, string(v:t_job): s:replace
      \, string(v:t_channel): s:replace
      \, string(v:t_blob): s:replace
      \, string(v:t_class): s:replace
      \, string(v:t_object): s:replace
      \, string(v:t_typealias): s:replace
      \, string(v:t_enum): s:replace
      \, string(v:t_enumvalue): s:replace
      \ }
function s:DictToJson(someDict)
  let json = deepcopy(a:someDict)->map(s:lookup)
  echom json
  return json_encode(json)
endfunc

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
  let float = get(get(wInfo, 'variables', {}), 'float', 0)
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
  call append('$', FormatJSON(s:DictToJson(w)))
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


