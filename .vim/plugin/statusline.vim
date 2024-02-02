scriptencoding utf-8

  " buffer info - e.g. 1 300,82-85 99%
  " %(...%) - item group
  " %n - buffer number
  " %l - line number
  " %c - col number
  " %V - virtual col number
  " %P - percentage scrolled
  " set statusline+=%(%n\ %l,%c%V\ %P%)\ 
  " set statusline+=%(%P%)\ 

  " file info - e.g. .vimrc +
  " %t  - file name:so %
  " %Hh - help flag     ,HLP/[help]     𝓲⃝ 𝓲⃞ 𝒾⃟ 
  " %Ww - preview flag  ,PRV/[Preview]  ᴾ⃞ Ⓟ⃞ ᵖ⃞ Ⓟ⃞  
  " %Mm - modified flag ,+  /[+]        f
  " %Rr - readonly flag ,RO /[RO]       ʀ⃞ ᴿ͇̅ ʷ⃠ ᴿ̲̅ R⃞ ʀ⃞
  " set statusline+=%#StatusSynErr#
" set statusline+=%#IsModified#%{&mod?expand('%'):''}%*%#IsNotModified#%{&mod?'':expand('%')}%*
" set statusline+=%#IsModified#%{&mod?'+':''}%*
" set statusline+=%#IsNotModified#%{&mod?'':''}%*

  " set statusline+=%{%StatuslineMode()%}

  " set statusline+=%{%pathshorten(getbufinfo(bufnr())[0].name,3)%}
  " set statusline+=%*

  " Debug
  " set statusline+=%{%DebugWinNumber()%}
  " set statusline+=\ 
  " set statusline+=%{&mod?'+⃞':''}%*\ %-t%<\ %H%W%M%R\ 
" function! s:debugwinnumber()
  " g:statusline_winid is set for %!
  " let l:wininfo = getwininfo(g:statusline_winid)
  " let l:winactive = g:statusline_winid == win_getid()
  " return printf(' %%#Statement#%w%s:%s%%* ', win_getid(), g:actual_curwin)
" endfunc

        " \ .. '%#StatusBold#'
        " \ .. '{&modified?&modifiable?"-":"+":""}
        " \ .. '%{&modified?&modifiable?"+":"⨁":""}'


" TODO Statusline for narrow windows (<16)
" filen….vim
" filen⋯.vim
" filen⋮.vim
" filen…vim
" filen⋯vim
" filen⋮vim
" ຯ❋ ❊⬮⬬ ⬭ ⬯ ◌ 
" filen‥.vim
" filen·.vim
" filen•vim
" filen•.vim
" filen‥vim
" filen·vim
" Statusline for zero height windows

let g:mayhem = get(g:, 'mayhem', {})
let g:mayhem.sl = get(g:mayhem, 'sl', {})

function! WinType() abort
" (empty) = normal window, 'unknown' = not window
" autocmd command loclist popup preview quickfix
  let wintype = win_gettype()
endfunc

function! SLineIsCurwin()
  return g:actual_curwin == win_getid()
endfunc

function CachedDiag()
  return SLineIsCurwin()
        \ ? get(get(b:, 'mayhem', {}), 'sl_cache_diag', 'diag?')
        \ : get(get(b:, 'mayhem', {}), 'sl_cache_diagNC', 'diag?')
endfunc

function s:UpdateCachedDiagnostics()
  call s:SetStatusVars()
  let [b:mayhem.sl_cache_diag, b:mayhem.sl_cache_diagNC] =
        \ s:GetCurrentDiagnostics()
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
function s:GetCurrentDiagnostics()
  let symbols = has("multi_byte_encoding") && &encoding == "utf-8" ?
        \ g:mayhem.symbols_diag8 : g:mayhem.symbols_diagA

  if !exists('g:did_coc_loaded')
    return ['%#StatusSynOff#'   .. symbols.off .. '%*',
          \ '%#StatusSynOffNC#' .. symbols.off .. '%*']
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
    return ['%#StatusSynErr#'   .. symbol .. '%*',
          \ '%#StatusSynErrNC#' .. symbol .. '%*']
  endif

  if warningCount > 0
    let symbol = get(symbols.numbers, warningCount, symbols.warning)
    return ['%#StatusSynWarn#'   .. symbol .. '%*',
          \ '%#StatusSynWarnNC#' .. symbol .. '%*']
  endif

  return ['%#StatusSynOk#'   .. symbols.ok .. '%*',
        \ '%#StatusSynOkNC#' .. symbols.ok .. '%*']
endfunc


" ‡ ‡ † † ⁊ ⸗ ⁞ ⸬ ⸭ ⁜ ⸔ ꩜ 𒑲𒑳𒑱𒑰᰽᰾᰿☓⚡︎⍦ ♮ ♯ 𝄐𝄑 ⏒⏓⏑⏑⏘ ⏙ 
" ⌅⌄⌃⌵𐠐𐠅𐠦𐠣 𐠪𐠵𐠤𐠊𐠯𐠯𐠂 𐜝 𐝀 𐝁
" 𐰊𐱀 𐰒 𐱄𐰼 𐰋𐰲𐰱𐰮𐰯𐰄𐰀𐰚𐰇𐰭𐰃𐱈𐰚𐰇𐰩𐰳𐰏𐰀𐰞 𐰔𐰬𐱄𐱀𐰬𐰕 𐰔𐰑𐰔𐱄𐰚 𐰂𐰒𐰳𐰸𐰹𐱁𐰨𐰆𐰊 𐰋𐰌𐰞𐰃𐰐𐰢𐰤𐰞
" 𐙞 𐙟 𐰧𐰗 🁢🁣𐙦
" 𐰶𐰷𐰬 𐱄𐱀𐱃
" 𐰸𐰹𐰋𐰲𐰱𐱄𐱀𐰬𐰕 𐠤𐠯𐠮𐠵𐠙𐠠𐠃𐠳  ∎∣
" 𑀋𑀃𑀄𑀅𑀆𑀉𑀊𑀒𑀔𑀖𑀱𑀗𑀘𑀙𑀯𑀚𑀛𑀜𑁖𑁟 𑀷
" 𑀣𑀞 𑀟𑀠𑀢𑀦𑀖𑀬 𑀯𑀵𑀫
" 𑀩𑁇𑁈𑁉𑁋𑁊𑀓𑁋𑁌𑁜𑁣𑁜𑁋𑁊 𑁓𑁕𑁒𑁒𑁓𑁔𑁉𑁊𑁉𑁋𑁈 𑁍 
" 𑀛†‡※⁕⁑•◦ 𐠘 𝞒𝞧ʎ𑀛𐠨𑀕𑀰𑀏𐠫𐠃𐠠𐱃𐀿𐠊𐠒𐠑𐠙𐠸𐝕 𐠩
let g:mayhem.symbols_git8 = {
      \ 'isgit':  '𑀛',
      \ 'notgit': '⁑',
      \ 'gitoff': '𐝕',
      \ }
let g:mayhem.symbols_gitA = {
      \ 'isgit':  'y',
      \ 'notgit': 'n',
      \ 'gitoff': 'o',
      \ }

function CachedGit()
  return get(get(b:, 'mayhem', {}), 'sl_cache_git', ['G?','GN'])[NC() ? 1 : 0]
endfunc
function s:UpdateCachedGit()
  call s:SetStatusVars()
  " let [sl_git, sl_gitNC] =
  let b:mayhem.sl_cache_git = s:GetCurrentGit()
endfunc

" Fugitive
" TODO - add detailed git status info
function s:GetCurrentGit()
  let symbols = has("multi_byte_encoding") && &encoding == "utf-8" ?
        \ g:mayhem.symbols_git8 : g:mayhem.symbols_gitA

  if !exists('g:loaded_fugitive')
    return ['%#StatusGitOff#'   .. symbols.gitoff .. '%*',
          \ '%#StatusGitOffNC#' .. symbols.gitoff .. '%*']
  endif

  let head = FugitiveHead()
  if empty(head)
    return ['%#StatusNotGit#'   .. symbols.notgit .. '%*',
          \ '%#StatusNotGitNC#' .. symbols.notgit .. '%*']
  else
    return ['%#StatusGit#'   .. symbols.isgit .. '%*',
          \ '%#StatusGitNC#' .. symbols.isgit .. '%*']
  endif
endfunc

let g:mayhem.type_ext_map = {
      \ 'typescriptreact': ['tsx'],
      \ 'typescript': ['ts'],
      \ }
function CachedFileInfo()
  return get(get(b:, 'mayhem', {}), 'sl_cache_fileinfo',
        \ [expand('%'),expand('%')])[NC() ? 1 : 0]
endfunc
function s:UpdateCachedFileInfo()
  call s:SetStatusVars()
  let b:mayhem.sl_cache_fileinfo = s:GetCurrentFileInfo()
endfunc
function s:GetCurrentFileInfo()
  let ext = expand('%:e')
  let name = expand('%:r')
  let tail =  expand('%:t')
  let type = getbufvar(bufnr(), '&filetype')

  if type == ext || index(get(g:mayhem.type_ext_map, type, []), ext) >= 0
    return ['%#SlFName#' .. name .. '.%#SlFTypExt#' .. ext .. '%*' ..
          \ ' %#SlFTyp2#' .. type .. '%*',
          \ '%#SlFNameNC#' .. name .. '.%#SlFTypExtNC#' .. ext .. '%*' ..
          \ ' %#SlFTyp2NC#' .. type .. '%*']
  else
    return ['%#SlFName#' .. tail .. '%#SlFTyp#[' .. type .. ']%*' ,
          \ '%#SlFNameNC#' .. tail .. '%#SlFTypNC#[' .. type .. ']%*']
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

"ꘖǀǀǁǂ|‖꜏꜊ ꖔ
let g:mayhem.symbols_scroll8L = {
      \ 'steps': ['꜒','꜍','꜓','꜎','꜔','꜐','꜕','꜑','꜖'],
      \ 'top':    '꜒̅',
      \ 'full':   '꜏̲̅',
      \ 'bot':    '꜖̲',
      \ }
let g:mayhem.symbols_scroll8R = {
      \ 'steps': ['˥','꜈','˦','꜉','˧','꜋','˨','꜌','˩'],
      \ 'top':    '˥̅',
      \ 'full':   '꜊̲̅',
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

function s:StatuslineEncoding() abort
  if &fileencoding && &fileencoding != 'utf-8'
    set statusline+= 
  endif
endfunc

function s:SetStatusVars()
  let b:mayhem = get(b:, 'mayhem', {})
  let b:mayhem.sl_norm = get(b:mayhem, 'sl_norm', '')

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
  call s:UpdateCachedFileInfo()
  call s:UpdateCachedGit()
  call s:UpdateCachedDiagnostics()

  let g:mayhem['sl_norm'] = ''
        \ .. '%{%CachedGit()%} ' .. '%{&previewwindow?"ᴘ⃞":""}'
        \ .. '%{%CachedFileInfo()%} %<'
        \ .. '%{&modified?&modifiable?"+":"⨁":""}'
        \ .. '%=%{&modifiable?&readonly?"R":"":"r"}' 
        \ .. '%{&modifiable?&readonly?"ʀ⃞":"":"ᴚ⃞"}'
        \ .. '%( %#StatusSynErr#'
        \ .. '%{&fileencoding=="utf-8"?"":"∪⃞⃥ "}'
        \ .. '%{&fileformat=="unix"?"":"␌⃞ "}'
        \ .. '%* %)'
        \ .. '%{%ScrollHint()%}'
        \ .. ' %{%CachedDiag()%}'

  let g:mayhem['sl_normNC'] = g:mayhem['sl_norm']

  let g:mayhem['sl_help'] = ''
        \ .. '%#StatusInfo#𝓲⃝ %*'
        \ .. '%*' .. '\ '
        \ .. '%-f'
        \ .. '%<' .. '%='
        \ .. '%(%n\ %l,%c%V\ %P%)\ '
  let g:mayhem['sl_helpNC'] = ''
        \ .. '%#StatusInfoNC#𝓲⃝ %*'
        \ .. '%*' .. '\ '
        \ .. '%-f'
        \ .. '%<' .. '%='
        \ .. '%(%n\ %l,%c%V\ %P%)\ '

    " ' ℺⃞ 🅀 𝒬⃞  ⍰ \ %%*'
  let g:mayhem['sl_qfix'] = ''
        \ .. '%#StatusInfo#ℚ⃞\ %*'
  let g:mayhem['sl_qfixNC'] = ''
        \ .. '%#StatusInfoNC#𝒬⃞\ %*'
endfunc

function NC()
  return g:actual_curwin != win_getid()
endfunc

function CustomStatusline()
  if &buftype == 'help'
    return get(get(g:, 'mayhem', {}), NC() ? 'sl_help' : 'sl_helpNC', 'help-statusline-not-found') 
  elseif &buftype == 'quickfix'
    return get(get(g:, 'mayhem', {}), NC() ? 'sl_qfix' : 'sl_qfixNC', 'qfix-statusline-not-found') 
  endif
  return get(get(g:, 'mayhem', {}), NC() ? 'sl_norm' : 'sl_normNC', 'norm-statusline-not-found')  
endfunc


augroup statusline
  autocmd! * <buffer>
  " autocmd BufEfter    <buffer> match ExtraWhitespace /\s\+$/
  " autocmd InsertEnter <buffer> match ExtraWhitespace /\s\+\%#\@<!$/
  " autocmd InsertLeave <buffer> match ExtraWhitespace /\s\+$/

  " au EncodingChanged * call s:UpdateCustomStatuslines()
  " au BufWinEnter,BufFilePost,EncodingChanged <buffer> call s:UpdateStatuslines()
  " au BufWinEnter,BufFilePost * call UpdateCustomStatusline()
  " au BufWinEnter,BufFilePost * silent! call UpdateCustomStatusline()

  au BufWinEnter,BufFilePost,EncodingChanged * call s:UpdateStatuslines()
  au User CocDiagnosticChange call s:UpdateCachedDiagnostics()
 
  " autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
augroup END

:command! UpdateCachedDiagnostics :call <SID>UpdateCachedDiagnostics()

:command! UpdateCustomStatusline :call <SID>UpdateStatuslines()

set statusline=%{%CustomStatusline()%}



  " ⨕⃞ ⨧⃞ ⨳⃞ ⩆⃞ ➔⃞  ⫸⃞ 
  " ∓± ⋉ ⋊ ⨁ +⃞ +⃝   +⃓⃟
  " return printf('%%#StatusScroll%s#𝓲⃝ %%*', l:hisuffix)
" ⌷⌶⌴⌴⌑⌸⍓⍐ ꜎̲̅⍗⍊⍑⍦꜎̲̅⎕˩̲̅𐠐
" Top ☐̲̅˩̲̅◇̲̅▯̲̅🁣̲̅ ̲̅ ⠿̲̅ ⍇̲̅𐠳̲̅␣̲̅Ξ̲̅Ε̲̅˩̲̅𐅞̲̅𐅝̲̅˩̲̅⠿̲̅ ▔▁▂▃▄▅▆▇██ ˥𐰿̲̅ c𐱀⎕


" Top ☐̲̅◇̲̅▯̲⃗̅⠿̲̅𐠳̲̅˥̲̅⫿̲̅⦂̲̅≡̲̅ ⟐̲̅˩̲̅⧇̲̅ ⧦̲̅ ≣̲̅˩̲̅≡̳̿≣̲̿˩̲̅≡̲̅⧧̲̅ 

" ⊠̲̅˥̲̅≣̲̅␣̲̅˥̲̅Ξ̲̅Ε̲̅˥̲̅𐅞̲̅𐅝̲̅˥̲̅⠿̲̅⧉̲̅˥̲̅⨳̲̅⧈̲̅ ˥̲̅⟤̲̅  ▁▂▃▄▅▆▇█▔̲̅╠̲̅╔̲̅˥̲̅╚̲̅ ̲̅𐰿̲̅𐱀̲̅⎕

  " ̲̅◧̲̅◖̲̅◗̲̅▼̲̅▲̲̅▽̲̅△̲̅˩̲̅▿̲̅▵̲̅▾̲̅▴̲̅⧨̲̅⧩̲̅⧪̲̅⧫̲̅◊̲̅˩̲̅⧰̲̅⧱̲̅ ̲̅⧒̲̅˩̲̅ ̲̅⧓̲̅ ̲̅⧔̲̅ ̲̅⧕̲̅ ̲̅⧖̲̅ ̲̅⧗̲̅ 

" ↱   ⌷≣⫿⃞⫿⃪⫿⃟⫿̷⫿̸⫿⃫⫿⃓⫿⃒⃒ ⫿⃦ ⫿⃥⫿̶⫿̵⫿̴⫿̄⫿͞⫿͛⫿⃔⫿⃖⫿⃡⫿⃗⫿⃕⫿︢⫿̃⫿͠

"   ⫿̿⫿̅⫿⃩⫿⃜⫿⃛⫿̈⫿̇⫿͘͘⫿݃⫿⫿⫿ˈ⫿⫿⫿̎⫿̏⫿̋⫿̀⫿́̒⫿̒⫿⃑⫿⃐⫿̂⫿́⫿͐͐⫿͐⫿͌⫿͊⫿͋⫿̽⫿ͣ⫿ͨ⫿ͩ
"   ⫿ͤ⫿ͪ⫿ͥ⫿ᷜ⫿ͫ⫿ͦ⫿ͬ⫿ͭ⫿ͧ⫿ͮ⫿ͯ⫿̚⫿̌⫿͂⫿̑⫿̑⫿͡ ⫿̆⫿͝⫿︠⫿︡⫿͑⫿̊⫿͒⫿̐⫿̉
"   ⫿҅⫿゚⫿҄⫿҆⫿͍⫿̱⫿⫿⫿⫿⫿⫿⫿⫿⫿̲̅⫿̲̅⫿̲̅˩̲̅⫿̲̅⫿⫿⫿⫿⫿⫿⫿§⫿
"   ⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿⫿
"  ⏐⥑⥮̲̅⇅̲̅⇵̲̅⊏̲̅⊐̲̅⊔̲̅⊓̲̅⊞̲̅⊤̲̅   ꜈ 1%-24%
" 25% ̲̅˦⃨̲̅]̲̲̅∗̲̅ ̲̅∟̲̅ ̲̅∥̲̅∃̲̅∆̲̅∇̲̅  
"     ꜉̲ 26%-49%
" 50% ˧̲̃ 
"     ꜋̺⃩ 
" 75% ˨⸣⸥⸠⸡
"     ꜌
" Bot ˩
" ꜛ̲̅ꜜ̲̅ꜝ̲̅ꜞ̲̅ꜟ̲̅ ↓̲̅↑̲̅ ꖋ̲̅ꖌ̲̅ꖍ̲̅ꖎ̲̅ꖔ̲̅ ̳̿꜈̲̅꜉̲̅꜊̲̅꜋̲̅꜌̲̅ ̲̅˥̲̅˦̲̅˧̲̅˨̲̅˩̲̅⟧☓⚇¦|~⌶⎔⎼⎻⎺⎽
  "◻︎☐◇□◌❙❘❚◇▫︎▮▯] ːǀǁǂ˪˫↓↑↘↗ˑʘʭ|]ꜗꜝᶲ⸡⸠⎶ ⁐ ⸢ 

" ꜛ̲̅ꜜ̲̅ꜝ̲̅ꜞ̲̅ꜟ̲̅ ↓̲̅↑̲̅ ꖋ̲̅ꖌ̲̅ꖍ̲̅ꖎ̲̅ꖔ̲̅ ̳̿꜈̲̅꜉̲̅꜊̲̅꜋̲̅꜌̲̅ ̲̅˥̲̅˦̲̅˧̲̅˨̲̅˩̲̲̅̅~̲̅⌶̲̅⎔̲̅⎼̲̅⎻̲̅⎺̲̅⎽̲̅◻︎̲̅☐̲̅

  " ◇̲̅□̲̅◌̲̅❙̲̅❘̲̅❚̲̅◇̲̅▫︎̲̅▮̲̅▯̲̅]̲̅ ̲̅ː̲̅ǀ̲̅ǁ̲̅ǂ̲̅˪̲̅˫̲̅↓̲̅↑̲̅↘̲̅↗̲̅ˑ̲̅ʘ̲̅ʭ̲̅|̲̅]̲̅ꜗ̲̅ꜝ̲̅ᶲ̲̅⸡̲̅⸠̲̅⎶̲̅ 

 "⁐̲̅˥̲̅


" ꜛ̲̅ꜜ̲̅ꜝ̲̅ꜞ̲̅ꜟ̲̅ ↓̲̅↑̲̅ꖋ̲̅ꖌ̲̅ꖍ̲̅ꖎ̲̅ꖔ̲̅꜍̲̅꜈̲̅꜎̲̅꜉̲̅꜏̲̅꜊̲̅꜐꜋̲̅꜑̲̅꜌̲̅ ̲̅꜒̲̅˥̲̅꜓̲̅˦̲̅꜔̲̅˧̲̅꜕̲̅˨̲̅꜖̲̅˩̲̅ 
" ꜛꜜꜝꜞꜟ ↓↑ꖋ ꖌ ꖍ ꖎ ꖔ ꜍⃩꜈꜎⃛꜉⃛꜏⃛꜊⃛꜐⃛꜋⃛꜑⃛꜌⃛ ꜒⃛˥⃛꜓⃛˦⃛꜔̈˧⃛꜕⃛˨⃛꜖⃛˩⃛
" ꜛꜜꜝꜞꜟ ↓↑ꖋ ꖌ ꖍ ꖎ ꖔ ꜍꜈꜎꜉꜏꜊꜐꜋꜑꜌ ꜒˥꜓˦꜔˧꜕˨꜖˩
" ꜛꜜꜝꜞꜟ ↓↑ꖋ ꖌ ꖍ ꖎ ꖔ ꜍꜈꜎꜉꜏꜊꜐꜋꜑꜌ ꜒˥꜓˦꜔˧꜕˨꜖˩
" ꜛꜜꜝꜞꜟ ↓↑ꖋ ꖌ̲̅ ꖍ ꖎ ꖔ ꜍꜈꜎꜉꜏꜊꜐꜋꜑꜌ ꜒˥꜓˦꜔˧꜕˨꜖˩
" ꜛꜜꜝꜞꜟ ↓↑  ꜈꜍꜉꜎꜊꜏꜋꜐꜌꜑ ꜒˥꜓˦꜔˧꜕˨꜖˩
" ꜛꜜꜝꜞꜟ ↓↑  ꜍̲̿꜎꜏꜐꜑̲̅꜈꜉꜊꜋꜌ ꜒̅꜓꜔꜕꜖̲˥̅˦˧˨˩̲
" ꜛꜜꜝꜞꜟ ↓↑  ꜍꜎꜏꜐꜑꜈꜉꜊꜋꜌ ꜒꜓꜔꜕꜖˥˦˧˨˩
" ꜛꜜꜝꜞꜟ ↓↑  ꜍̳̿꜎̲̅꜏꜐꜑꜈꜉꜊꜋꜌ ꜒꜓꜔꜕꜖˥˦˧˨˩
" ᵦᵧᵨᵩᵪ₀₁₂₃₄₅₆₇₈₉
" ⣏⢽⣎⣝⣟⢟⢛⢻⢼⢫⢣⡯⡱⢷̲̅꜍̳̿
"  ̲̲̅̅⟦̲̅⦀̲̅꜎̲̅⫼̲̅⫻̲̅⁽̲̅⧫̲̅█̲̅ 
