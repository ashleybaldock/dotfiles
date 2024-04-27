scriptencoding utf-8

" TODO indicator for virtualedit (+toolbar button)
" TODO indicator for delcombine (+toolbar button)

" TODO Statusline for narrow windows (<16)
" filen….vim
" filen⋯.vim
" filen⋮.vim
" filen…vim
" fi⋯me.vim
" ຯ❋ ❊⬮⬬ ⬭ ⬯ ◌ 
" filen‥.vim
" filen•vim
" fi•me.vim
" filen‥vim
" filen·vim
" Statusline for zero height windows

let g:mayhem = get(g:, 'mayhem', {})
let g:mayhem.sl = get(g:mayhem, 'sl', {})

function FName()
  return expand('%:t:r')
endfunc
function FDotExt()
  let ext = expand('%:e')
  return ext == '' ? '' : '.' .. ext
endfunc

function! WinType() abort
" (empty) = normal window, 'unknown' = not window
" autocmd command loclist popup preview quickfix
  let wintype = win_gettype()
endfunc

function ChDiag()
  return get(get(b:, 'mayhem', {}), 'sl_cache_diag', ['D?','DN'])[NC()]
endfunc

let g:mayhem.symbols_diag8 = {
      \ 'numbers': ['', '1⃝ ', '2⃝ ', '3⃝ ', '4⃝ ', '5⃝ ', '6⃝ ', '7⃝ ', '8⃝ ', '9⃝ ' ],
      \ 'error'  : '⚑⃝ ',
      \ 'warning': '!⃝ ',
      \ 'ok'     : '✓⃝ ',
      \ 'off'    : '?⃣ ',
      \ }
let g:mayhem.symbols_diagA = {
      \ 'numbers': ['', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
      \ 'error'  : 'E',
      \ 'warning': 'W',
      \ 'ok'     : 'Ø',
      \ 'off'    : '¿',
      \ }

" TODO - Add gutter display of errors elsewhere in file
function s:Update_Diag()
  let symbols = has("multi_byte_encoding") && &encoding == "utf-8" ?
        \ g:mayhem.symbols_diag8 : g:mayhem.symbols_diagA

  if !exists('g:did_coc_loaded')
    let b:mayhem.sl_cache_diag = [
        \ '%#SlSynOffC#' .. symbols.off .. '%*',
        \ '%#SlSynOffN#' .. symbols.off .. '%*']
    return
  endif

  let diaginfo     = get(b:, 'coc_diagnostic_info', {})
  "lnums": [90, 6, 0, 6],
  let lnums        = get(diaginfo, 'lnums',       0)
  let infoCount    = get(diaginfo, 'information', 0)
  let hintCount    = get(diaginfo, 'hint',        0)
  let warningCount = get(diaginfo, 'warning',     0)
  let errorCount   = get(diaginfo, 'error',       0)

  if errorCount > 0
    let symbol = get(symbols.numbers, errorCount, symbols.error)
    let b:mayhem.sl_cache_diag = [
        \ '%#SlSynErrC#' .. symbol .. '%*',
        \ '%#SlSynErrN#' .. symbol .. '%*']
    return
  endif

  if warningCount > 0
    let symbol = get(symbols.numbers, warningCount, symbols.warning)
    let b:mayhem.sl_cache_diag = [
        \ '%#SlSynWarnC#' .. symbol .. '%*',
        \ '%#SlSynWarnN#' .. symbol .. '%*']
    return
  endif

  let b:mayhem.sl_cache_diag = [
        \ '%#SlSynOkC#' .. symbols.ok .. '%*',
        \ '%#SlSynOkN#' .. symbols.ok .. '%*']
  return
endfunc


" ‡ ‡ † † ⁊ ⸗ ⁞ ⸬ ⸭ ⁜ ⸔ ꩜ 𒑲𒑳 𒑱𒑰᰽᰾᰿☓⚡︎⍦ ♮ ♯ 𝄐𝄑 ⏒⏓⏑⏑⏘ ⏙ 
" ⌅⌄⌃⌵𐠐𐠅𐠦𐠣 𐠪𐠵𐠤𐠊𐠯𐠯𐠂 𐜝 𐝀 𐝁
" 𐰊 𐱀 𐱄𐰼 𐰋𐰲𐰱𐰮𐰯𐰄𐰀 𐰚𐰇𐰭𐰃𐱈 𐰚𐰇𐰩𐰳𐰏𐰀𐰞 𐰔𐰬𐱄𐱀𐰬𐰕 𐰔𐰑𐰔𐱄𐰚 𐰂𐰒𐰳𐰸𐰹𐱁𐰨𐰆𐰊 𐰋𐰌𐰞𐰃𐰐𐰢𐰤𐰞
" 𐙞 𐙟 𐰧𐰗 🁢🁣𐙦
" 𐰶𐰷𐰬 𐱄 𐱀 𐱃
" 𝍖 ⚌ ䷖
" 𐠴 𐠔 𐠲 𐠫 𐠒𐠞𐠙𐠍𐘁𐘂𐘃𐘥 𐠘
" 𐰸𐰹𐰋𐰲𐰱𐱄 𐱀 𐰬 𐰕 𐠤 𐠯 𐠮 𐠵 𐠙 𐠠 𐠃 𐠳  ∎∣
" 𑀋𑀃𑀄𑀅𑀆𑀉𑀊𑀒𑀔𑀖𑀱𑀗𑀘𑀙𑀯𑀚𑀛𑀜𑁖𑁟 𑀷
" 𐚳 𐚶 𐚷 𐝀𐀞𐁖𐀝𐀷𐂧𐂬𐂞𐂲𐃏𐃘  𐀮𐀳 𐝁𐝎 𐝍 𐝏𐝐𐝑 𐝒 𐝓𐝕
" 𐀿𐁘  𐌄𐌅𐌆𐌎𐌏𐩩𐩪𐩫𐩰𐩺𐩻𐩼𐩲𐩥𐩤
" 𐰎
" 𑀣𑀞 𑀟𑀠𑀢𑀦𑀖𑀬 𑀯𑀵𑀫
" 𑀩𑁇𑁈𑁉𑁋𑁊𑀓𑁋𑁌𑁜𑁣𑁜𑁋𑁊 𑁓𑁕𑁒𑁒𑁓𑁔𑁉𑁊𑁉𑁋𑁈 𑁍 
" 𑀛†‡※⁕⁑•◦ 𐠘 𝞒𝞧ʎ𑀛𐠨𑀕𑀰𑀏𐠫𐠃𐠠𐱃𐀿𐠊𐠒𐠑𐠙𐠸𐝕 𐠩
" 𐘨𐘥
let g:mayhem.symbols_git8 = {
      \ 'isgit': '𑀛',
      \ 'notgit': '⁑',
      \ 'gitoff': '𐝕' 
      \}
let g:mayhem.symbols_gitA = { 'isgit': 'y', 'notgit': 'n', 'gitoff': 'o' }
" local, has
"  *   unstaged changes
"  +   staged changes
"  $   stashes
"  %   untracked files
"
"      has changes
" ⨁⃫ ⨁⃦ ⨤⨈⃦ ⨇⃦ ⨆⃦ 
" ◇⃓◆⃓ ▲⃓ ▽⃓△⃓  ◦⃓ ●⃫ ○⃫ □⃫ ✱⃓⃗ ✱⃓⃡ ✱⃓⃖ ✱⃓ ✱⃓⃖ ✲⃫ ⚙︎⃩ ‣▵▴◎
" ▞͢ ▙͎  ◐⃡ ◑⃖ ◒̴⃟ ◓⃘ ◪⃥  ◨⃑ ◩⃐ ◊⃨ ⟠̤⧫͎∆͍ ∇  
"
" ⍰ ⎕̶⎕̵⎕̴⎕⃓⎕⃦ ⎕⃥⎕̸⎕̷⎕⃟⎕⃠ ⎕⃞  ⎕̶⃞ ⎕⃓⃞ ⎕⃝  ⎕⃪⃝ ⎕⃓⃟  ⎕⃞̷ ⎕⃞⃦ ⎕⃞̸ ⎕⃞⃫ ⎕̶⃘ ⎕ ∧∨<>
"⊕⊛
" >͛ >⃖ >⃗ >⃓ >⃔ >⃦ >⃕ >⃨ >̶ >⃞ >̈ >̇ >͘ >݃ >̍ >̎⃞ >̏ >̋ >̂⃞ > >͐
" ≷ ≷⃖ ≷⃗ ≷⃡ ≷⃔ ≷ ≷⃕ ≷⃨ ≷ ≷⃞ ≷̈ ≷̇ ≷͘ ≷݃ ≷̍ ≷̎ ≷̏ ≷ ≷̂ ≷⃑⃞ ≷⃐ ≷̊ ≷⃩ ≷⃥
" < <⃖ <⃗ < <⃔ < <⃕ <⃨ < <⃞ <⃦ <⃒ <⃫ <⃓ <̷ <⃥ <͛̾ <⃔ <̵ ⃖<⃑ <⃐ <⃖ < <
" = =⃖ =⃗ = =⃔ = =⃕ =⃨ = =⃞ = = = =𑀸= = = = = = = = =
">⃞ ≷⃞ <⃞ =⃞ 
"
" ≺ ≻ ∗͐ ∗͔ ∗͕ ∗⃖ ∗⃗ ∗⃡ ∗̿ ∗̅  ∗̽ ∗ͣ ∗ͨ ∗ͤͥ ∗ͯ ∗͍ ∗͇ ʢǂʘʕ↑ɤ ∘∙∫
" ∗ ∗̟̟ ∗̊ ∗⃔ ∗͞ ∗⃕ ∗͛ ̃∗̃ ∗⃒ ∗⃦ ∗⃓ ∗̸ ∗⃫ ∗̷ ∗⃟ ∗⃘ ∗⃠ ∗⃝ ∗ ∗
"
" branch, relative to upstream
" ⍃   <   behind
" ⍄   >   ahead
" ⌺   <>  diverged
" ⌸   =   in sync
" ✮✮✭✬✫✪⭐︎★☆⭐︎✡︎✩✯✥✤✣✢✧❊✽✻❉✱✲✾✾❃❋✴︎✴︎❇︎⚙︎❄︎❆❅※❈﹅✘✗✖︎✕❍❥❍❤︎✰❡►❖◼︎⁍☑︎☒☐★
" ⭐︎♕♔⚀✍︎☻♙☕︎✦✟    ✠ ⚙︎⚑⚐☯︎⚘☘︎⚘⚛︎⚈⚆⚇⁕＊⁂⁗

" ᰽᰾᰿᛭᛬⸕ ⸖⸋⁙⁘⁏ ⁏⸰%‰‱
" ⌵⎀⌵⌄⌃⌤ ⏏︎ ⎊⎌⎀⌅⌆⌂⌒⌓⌔⌤

function ChGit()
  return get(get(b:, 'mayhem', {}), 'sl_cache_git', ['G?','GN'])[NC()]
endfunc

" Fugitive
" TODO - add detailed git status info
function s:Update_Git()
  let symbols = has("multi_byte_encoding") && &encoding == "utf-8" ?
        \ g:mayhem.symbols_git8 : g:mayhem.symbols_gitA

  if !exists('g:loaded_fugitive')
    let b:mayhem.sl_cache_git = [
          \ '%#SlGitOffC#' .. symbols.gitoff .. '%*',
          \ '%#SlGitOffN#' .. symbols.gitoff .. '%*']
    return
  endif

  let head = FugitiveHead()
  if empty(head)
    let b:mayhem.sl_cache_git =  [
          \ '%#SlNotGitC#' .. symbols.notgit .. '%*',
          \ '%#SlNotGitN#' .. symbols.notgit .. '%*']
    return
  else
    let b:mayhem.sl_cache_git =  [
          \ '%#SlGitC#' .. symbols.isgit .. '%*',
          \ '%#SlGitN#' .. symbols.isgit .. '%*']
    return
  endif
endfunc

function CheckRO()
  return &readonly ? "ᴿ" : ""
endfunc
function CheckUtf8()
  return &fenc !~ "^$\\|utf-8" || &bomb ? "∪⃞⃥ " : ""
endfunc
function CheckUnix()
  return &fileformat == "unix" ? "" : "␌⃞ "
endfunc


function ChFName()
  return get(get(b:, 'mayhem', {}), 'sl_cached_filename',
        \ [expand('%'),expand('%')])[NC()]
endfunc
function ChFInfo()
  return get(get(b:, 'mayhem', {}), 'sl_cached_fileinfo',
        \ ['',''])[NC()]
endfunc
let g:mayhem.type_ext_map = {
      \ 'javascriptreact': ['jsx'],
      \ 'javascript': ['js'],
      \ 'typescriptreact': ['tsx'],
      \ 'typescript': ['ts'],
      \ 'markdown': ['md'],
      \ }
function s:Update_FileInfo()
  call s:SetStatusVars()
  let ext = expand('%:e')
  let name = expand('%:r')
  let tail = expand('%:t')
  let type = getbufvar(bufnr(), '&filetype')

  if name == ''
    let b:mayhem.sl_cached_filename = [
      \ '%#SlFNoNameC#nameless%* ' ..
      \ '%{&modified?&modifiable?"+":"⨁":""}',
      \ '%#SlFNoNameN#nameless%* ' ..
      \ '%{&modified?&modifiable?"+":"⨁":""}']
    let b:mayhem.sl_cached_fileinfo = [
      \ '%#SlFTyp2C#' .. type .. '%*',
      \ '%#SlFTyp2N#' .. type .. '%*']
    return
  endif
    "'%=%{&modifiable?&readonly?"R":"":"r"}' 
    "'%{&readonly?"ʀ⃞":""}'
"  Ⓡ ⓡ  🅡 🆁 🄡  
  if type == ext || index(get(g:mayhem.type_ext_map, type, []), ext) >= 0
    let b:mayhem.sl_cached_filename = [
      \ '%{%CheckRO()%}%#SlFNameC#' .. name .. '.%#SlFTypExtC#' .. ext .. '%* ' ..
      \ '%{&modified?&modifiable?"+":"⨁":""}',
      \ '%{%CheckRO()%}%#SlFNameN#' .. name .. '.%#SlFTypExtN#' .. ext .. '%* ' ..
      \ '%{&modified?&modifiable?"+":"⨁":""}']
    let b:mayhem.sl_cached_fileinfo = [
      \ '%#SlFTyp2C#' .. type .. '%*',
      \ '%#SlFTyp2N#' .. type .. '%*']
  else
    let b:mayhem.sl_cached_filename = [
      \ '%{%CheckRO()%}%#SlFNameC#' .. tail .. '%*',
      \ '%{%CheckRO()%}%#SlFNameN#' .. tail .. '%*']
    let b:mayhem.sl_cached_fileinfo = [
      \ '%#SlFTyp2C#' .. type .. '%*',
      \ '%#SlFTyp2N#' .. type .. '%*']
  endif

endfunc

function! s:StatuslineMode() abort
  " ^V/^S need to be real, i.e. entered using ctrl+v,ctrl+v/ctrl+s
  return {'n': 'n', 'i': 'ɪ',
        \ 'v': 'v', 'V': 'v̅', '': 'v̺͆',
        \ 's': 's', 'S': 's̅', '': 's̺͆',
        \ 'R': 'ʀ', 'r': 'ᴚ',
        \ 't': 'ʇ', 'c': 'ɔ',\
        \ '!': 'S', }[mode()]
endfunc

"ꘖǀǀǁǂ|‖꜏ꖔ꜊   ꜏̲̅ ꜊̲̅
let g:mayhem.symbols_scroll8L = {
      \ 'steps': ['꜒','꜍','꜓','꜎','꜔','꜐','꜕','꜑','꜖'],
      \ 'top':    '꜒̅',
      \ 'full':   'ǁ',
      \ 'bot':    '꜖̲',
      \ }
let g:mayhem.symbols_scroll8R = {
      \ 'steps': ['˥','꜈','˦','꜉','˧','꜋','˨','꜌','˩'],
      \ 'top':    '˥̅',
      \ 'full':   'ǁ',
      \ 'bot':    '˩̲',
      \ }
let g:mayhem.symbols_scroll8 = g:mayhem.symbols_scroll8R
let g:mayhem.symbols_scrollA = {
      \ 'steps': ['1','2','3','4','5','6','7','8','9'],
      \ 'top':    '¯',
      \ 'full':   ']',
      \ 'bot':    '_',
      \ }
function ScrollHint() abort
  if !exists('g:mayhem.symbols_scroll8')
    return
  endif
  let symbols = has("multi_byte_encoding") && &encoding == "utf-8" ?
        \ g:mayhem.symbols_scroll8 : g:mayhem.symbols_scrollA

  let line_cursor = line('.')
  let line_wintop = line('w0')
  let line_winbot = line('w$')
  let line_count  = line('$')

  if line_wintop == 1
    if line_winbot == line_count
      return symbols.full
    endif
    return symbols.top
  endif
  if line_winbot == line_count
    return symbols.bot
  endif

  let position = (line_cursor * len(symbols.steps) - 1) / line_count

  let top    = line('w0')
  let height = line('w$') - top + 1

  " echo printf('%i, %i, %i, %s',
  "\ line_cursor, line_count, position, symbols.steps[position])
  return symbols.steps[position]
endfunc

function s:SetStatusVars()
  let b:mayhem = get(b:, 'mayhem', {})
  let b:mayhem.sl_normC = get(b:mayhem, 'sl_normC', '')
  let b:mayhem.sl_normN = get(b:mayhem, 'sl_normN', '')

  let b:mayhem.f_projroot = ProjectRoot()
  " let b:mayhem.f_full = expand('%')
  let b:mayhem.f_tail = expand('%:t')
  let b:mayhem.f_head = expand('%:p:h')
  let b:mayhem.f_ext = expand('%:e')
  let b:mayhem.projname = fnamemodify(b:mayhem.f_projroot,':p:h:t')
  let b:mayhem.f_name = expand('%:p:h')
  let b:mayhem.f_type = getbufvar(bufnr(), '&filetype')
endfunc
" sp|enew|pu=execute('echo getbufvar(bufnr(), "name")')

function s:UpdateStatuslines() abort
  call s:SetStatusVars()
  call s:Update_FileInfo()
  call s:Update_Git()
  call s:Update_Diag()

  " let obsessionStatus = exists("*ObsessionStatus")
  "       \ ? '%{ObsessionStatus("𐱃","𐠂")}' : '𑀠'

  let g:mayhem['sl_norm'] = [
    \ '%{%ChGit()%} %{%ChFName()%} %#SlSepC#%<%=%*' ..
    \ '%( %#SlFlagC#%{%CheckUtf8()%}%{%CheckUnix()%}%* %)' ..
    \ '%{%ChFInfo()%} %{%ScrollHint()%}' ..
    \ ' %{%ChDiag()%}',
    \
    \ '%{%ChGit()%} %{%ChFName()%} %#SlSepN#%<%=%*' ..
    \ '%( %#SlFlagN#%{%CheckUtf8()%}%{%CheckUnix()%}%* %)' ..
    \ '%{%ChFInfo()%} %{%ScrollHint()%}' ..
    \ ' %{%ChDiag()%}']


  let g:mayhem['sl_prev'] = [
    \ '%#SlInfoC#ᴘ⃞  %-f%*%<%=%(%n %l,%c%V %P%) ',
    \ '%#SlInfoN#ᴘ⃞  %-f%*%<%=%(%n %l,%c%V %P%) ']
  let g:mayhem['sl_help'] = [
        \ '%#SlInfoC#𝓲⃝  %{%FName()%}%*%#SlHintC#%{%FDotExt()%}%<%=%(ln%l %*%P%) ',
        \ '%#SlInfoN#𝓲⃝  %{%FName()%}%*%#SlHintN#%{%FDotExt()%}%<%=%(ln%l %*%P%) ']

  " ' ℺⃞ 🅀 𝒬⃞  ⍰ \ %%*'
  let g:mayhem['sl_qfix'] = [
        \ '%#SlInfoC#ℚ⃞ %*',
        \ '%#SlInfoN#𝒬⃞ %*']
  let g:mayhem['sl_dir'] = [
        \ '%#SlDirC#DIR %-F:h%*',
        \ '%#SlDirN#DIR %-F:h%*']
endfunc

function NC()
  return g:actual_curwin == win_getid() ? 0 : 1
endfunc

" Related: WinColorUpdate in ./wincolor.vim
function CustomStatusline()
  if &buftype == 'help'
    return get(get(g:, 'mayhem', {}), 'sl_help', ['sl_helpC', 'sl_helpN'])[NC()]
  elseif &buftype == 'quickfix'
    return get(get(g:, 'mayhem', {}), 'sl_qfix', ['sl_qfixC', 'sl_qfixN'])[NC()]
  elseif &buftype == 'preview'
    return get(get(g:, 'mayhem', {}), 'sl_prev', ['sl_prevC', 'sl_prevN'])[NC()]
  endif
  if &ft == 'netrw'
    return get(get(g:, 'mayhem', {}), 'sl_dir', ['sl_dirC', 'sl_dirN'])[NC()]
  endif
  return get(get(g:, 'mayhem', {}), 'sl_norm', ['sl_normC', 'sl_normN'])[NC()]
endfunc


augroup statusline
  autocmd! * <buffer>
  " autocmd BufEnter    <buffer> match ExtraWhitespace /\s\+$/
  " autocmd InsertEnter <buffer> match ExtraWhitespace /\s\+\%#\@<!$/
  " autocmd InsertLeave <buffer> match ExtraWhitespace /\s\+$/

  " au EncodingChanged * call s:UpdateCustomStatuslines()
  " au BufWinEnter,BufFilePost,EncodingChanged <buffer> call s:UpdateStatuslines()

  autocmd CursorHold,BufWinEnter,BufFilePost,EncodingChanged * call s:UpdateStatuslines()
augroup END

" This is called via an autocmd - see commands.coc.vim
:command! UpdateSlCachedDiagnostics :call <SID>Update_Diag()

:command! UpdateCustomStatusline :call <SID>UpdateStatuslines()

set statusline=%{%CustomStatusline()%}

UpdateCustomStatusline

" vim:signcolumn=auto:foldcolumn=1:foldmethod=marker:nolist:nowrap
