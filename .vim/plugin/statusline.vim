if exists("g:mayhem_loaded_statusline")
  finish
endif
let g:mayhem_loaded_statusline = 1

scriptencoding utf-8

" TODO Statusline for narrow windows (<16)
"
" fi⠒me.vim
" fi⠤me.vim
" fi𝌀lme.vim
" fi𛲟me.vim
" fi⋅len.vim
"
" fil⋆en⋯.vim
" fil•en⋮.vim
" fil∶∶⋰⋫⋅⋱⋮⋯en‥.vim
" fi⁓le᛫᛫n•vim⫙⫘⫶⫶⫶⫾⫿⫻⫼⟐⦁⦂⧟⧫fil⧫*¨¨⠉⠒⠤⣀me
" fi•me.vim
" fi⸗me.vim
" fil«»en·vim
" Statusline for zero height windows

let g:mayhem = get(g:, 'mayhem', {})
let g:mayhem.sl = get(g:mayhem, 'sl', {})

let g:mayhem.symbols_S = get(g:mayhem, 'symbols_S', {})
let g:mayhem.symbols_8 = get(g:mayhem, 'symbols_8', {})
let g:mayhem.symbols_A = get(g:mayhem, 'symbols_A', {})

function FName()
  return expand('%:t:r')
endfunc
function FDotExt()
  let ext = expand('%:e')
  return ext == '' ? '' : '.'..ext
endfunc

function! WinType() abort
" (empty) = normal window, 'unknown' = not window
" autocmd command loclist popup preview quickfix
  let wintype = win_gettype()
endfunc

function! GetBestSymbols()
   return has("gui_macvim")
         \ ? get(g:mayhem, 'symbols_S',
         \     get(g:mayhem, 'symbols_8',
         \       get(g:mayhem, 'symbols_A', {})))
         \ : has("multi_byte_encoding") && &encoding == "utf-8"
         \   ? get(g:mayhem, 'symbols_8',
         \       get(g:mayhem, 'symbols_A', {}))
         \   : get(g:mayhem, 'symbols_A', {})
endfunc

let s:symbols = GetBestSymbols()

function ChDiag()
  return get(get(b:, 'mayhem', {}), 'sl_cache_diag', ['D?','DN'])[NC()]
endfunc

let g:mayhem.symbols_S.diag = {
      \ 'numbers': ['', '1⃝ ', '2⃝ ', '3⃝ ', '4⃝ ', '5⃝ ', '6⃝ ', '7⃝ ', '8⃝ ', '9⃝ ' ],
      \ 'error'  : '⚑⃝ ',
      \ 'warning': '!⃝ ',
      \ 'ok'     : '✓⃝ ',
      \ 'off'    : '?⃣ ',
      \ }
let g:mayhem.symbols_8.diag = {
      \ 'numbers': ['', '1⃝ ', '2⃝ ', '3⃝ ', '4⃝ ', '5⃝ ', '6⃝ ', '7⃝ ', '8⃝ ', '9⃝ ' ],
      \ 'error'  : '⚑⃝ ',
      \ 'warning': '!⃝ ',
      \ 'ok'     : '✓⃝ ',
      \ 'off'    : '?⃣ ',
      \ }
let g:mayhem.symbols_A.diag = {
      \ 'numbers': ['', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
      \ 'error'  : 'E',
      \ 'warning': 'W',
      \ 'ok'     : 'Ø',
      \ 'off'    : '¿',
      \ }

" TODO - Add gutter display of errors elsewhere in file
function s:Update_Diag()
  " let symbols = has("multi_byte_encoding") && &encoding == "utf-8" ?
  "       \ g:mayhem.symbols_diag8 : g:mayhem.symbols_diagA
  " let symbols = get(s:symbols, 'diag', {})

  if !exists('g:did_coc_loaded')
    let symbol = get(s:symbols.diag, 'off', 'X')
    let b:mayhem.sl_cache_diag = [
          \ '%#SlSynOffC#'..symbol..'%*',
          \ '%#SlSynOffN#'..symbol..'%*']
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
    let symbol = get(s:symbols.diag.numbers, errorCount, s:symbols.error)
    let b:mayhem.sl_cache_diag = [
        \ '%#SlSynErrC#'..symbol..'%*',
        \ '%#SlSynErrN#'..symbol..'%*']
    return
  endif

  if warningCount > 0
    let symbol = get(s:symbols.diag.numbers, warningCount, s:symbols.warning)
    let b:mayhem.sl_cache_diag = [
        \ '%#SlSynWarnC#'..symbol..'%*',
        \ '%#SlSynWarnN#'..symbol..'%*']
    return
  endif

  let symbol = get(s:symbols.diag, 'ok', 'X')
  let b:mayhem.sl_cache_diag = [
        \ '%#SlSynOkC#'..symbol..'%*',
        \ '%#SlSynOkN#'..symbol..'%*']
  return
endfunc


" SF symbols, only works on OSX
let g:mayhem.symbols_S.git = {
      \ 'isgit':    '􀐅',
      \ 'notgit':   '􁊓',
      \ 'gitoff':   '􀃮',
      \ 'problem':  '􀃮',
      \ 'norepo':   '􁊓',
      \ 'behind':   '􁄻',
      \ 'ahead':    '􀯇',
      \ 'diverged': '􀐉',
      \ 'unstaged': '􁚍',
      \ 'staged':   '􀐇'
      \}
" Unicode
let g:mayhem.symbols_8.git = {
      \ 'isgit':    '𑀛',
      \ 'notgit':   '⁑',
      \ 'gitoff':   '𐝕',
      \ 'problem':  '𐝕',
      \ 'norepo':   'n',
      \ 'behind':   '❮',
      \ 'ahead':    '❯', 
      \ 'diverged': '◇',
      \ 'unstaged': '*',
      \ 'staged':   '+'
      \}
" ASCII fallback
let g:mayhem.symbols_A.git = {
      \ 'isgit':    '=',
      \ 'notgit':   'n',
      \ 'gitoff':   '!',
      \ 'problem':  '!',
      \ 'norepo':   'n',
      \ 'behind':   '<',
      \ 'ahead':    '>',
      \ 'diverged': '~',
      \ 'unstaged': '*',
      \ 'staged':   '+'
      \}
"   $   stashes          􀐆 􀫝 􀠧 􀓔 􁊓  􀴨􀖄􀖅 􀙡􀙠
"   %   untracked files
" 􀙡branch, relative to upstream
"               no changes     with changes
"     !       􀃮  problem
"     n       􁊓  not a repo
" <   <   ❮   􁄻  behind       􁚍 unstaged (*)
" >   >   ❯   􀯇  ahead        􀐇 staged   (+)
" <>  ~   ◇   􀐉  diverged   
" =   =       􀐅  in sync

function ChGit()
  return get(get(b:, 'mayhem', {}), 'sl_cache_git', ['G?','GN'])[NC()]
endfunc

" Fugitive
" TODO - add detailed git status info
function s:Update_Git()
  let gitsymbols = get(s:symbols, 'git', {})

  if !exists('g:loaded_fugitive')
    let b:mayhem.sl_cache_git = [
          \ '%#SlGitOffC#'..gitsymbols.gitoff..'%*',
          \ '%#SlGitOffN#'..gitsymbols.gitoff..'%*']
    return
  endif

  let head = FugitiveHead()
  if empty(head)
    let b:mayhem.sl_cache_git =  [
          \ '%#SlNotGitC#'..gitsymbols.notgit..'%r',
          \ '%#SlNo1tGitN#'..gitsymbols.notgit..'%*']
    return
  else
    let b:mayhem.sl_cache_git =  [
          \ '%#SlGitC#'..gitsymbols.isgit..'%*',
          \ '%#SlGitN#'..gitsymbols.isgit..'%*']
    return
  endif
endfunc

let g:mayhem.symbols_S.status = {
      \ 'readonly': '⚑⃝ ',
      \ 'fencnot8': '∪⃞⃥ ',
      \ 'ffnotnix': '␌⃞ ',
      \ 'diffing' : '􀉆􀄭􀕹',
      \ }
let g:mayhem.symbols_8.status = {
      \ 'readonly': 'ᴿ',
      \ 'fencnot8': '∪⃞⃥ ',
      \ 'ffnotnix': '␌⃞ ',
      \ 'diffing' : 'DIFF',
      \ }
let g:mayhem.symbols_A.status = {
      \ 'readonly': 'R',
      \ 'fencnot8': '!8',
      \ 'ffnotnix': '!F',
      \ 'diffing' : 'DIFF',
      \ }
function CheckRO()
  return &readonly ? s:symbols.status.readonly : ""
endfunc
function CheckUtf8()
  return &fenc !~ "^$\\|utf-8" || &bomb ? s:symbols.status.fencnot8 : ""
endfunc
function CheckUnix()
  return &fileformat == "unix" ? "" : s:symbols.status.ffnotnix
endfunc
function Diffing()
  return &diff ? s:symbols.status.diffing : ""
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
      \ 'dosbatch': ['bat'],
      \ }

function s:TypeMatchesFilename(type, filename)
  let ext = fnamemodify(a:filename, ':e')
  let name = fnamemodify(a:filename, ':r')
  let tail = fnamemodify(a:filename, ':t')
  let typemapping = get(g:mayhem.type_ext_map, a:type, [])

  return a:type == ext || index(typemapping, ext) >= 0
        \ || name == tail && index(typemapping, name) >= 0
endfunc

function s:Update_FileInfo()
  call s:SetStatusVars()
  let ext = expand('%:e')
  let name = expand('%:r')
  let diffname = getbufvar(bufnr(), 'mayhem_diff_saved', '')
  let tail = expand('%:t')
  let type = getbufvar(bufnr(), '&filetype')

  if name == ''
    if &diff && diffname != ''
      " let b:mayhem.sl_cached_filename = [
      "   \ '%#SlFDfSvNmC#Saved('..diffname..')%* '..
      "   \ '%{&modified?&modifiable?"+":"⨁":""}',
      "   \ '%#SlFDfSvNmN#Saved('..diffname..')%* '..
      "   \ '%{&modified?&modifiable?"+":"⨁":""}']
      let b:mayhem.sl_cached_filename = [
        \ '%#SlFDfSvNmC#Saved('..diffname..')%* '..
        \ '%{&modified?&modifiable?"􀑍":"􀴥􀍼":""}',
        \ '%#SlFDfSvNmN#Saved('..diffname..')%* '..
        \ '%{&modified?&modifiable?"􀑍":"􀴥􀍼":""}']
    else
      let b:mayhem.sl_cached_filename = [
        \ '%#SlFNoNameC#nameless%* '..
        \ '%{&modified?&modifiable?"􀑍":"􀴥":""}',
        \ '%#SlFNoNameN#nameless%* '..
        \ '%{&modified?&modifiable?"􀑍":"􀴥":""}']
    endif
    let b:mayhem.sl_cached_fileinfo = [
      \ '%#SlFTyp2C#'..type..'%*',
      \ '%#SlFTyp2N#'..type..'%*']
    return
  endif

  if s:TypeMatchesFilename(type, expand('%'))
    let b:mayhem.sl_cached_filename = [
      \ '%{%CheckRO()%}%#SlFNameC#'..name..
      \ '.%#SlFTypExtC#'..ext..'%* '..
      \ '%{&modified?&modifiable?"+":"⨁":""}',
      \ '%{%CheckRO()%}%#SlFNameN#'..name..
      \ '.%#SlFTypExtN#'..ext..'%* '..
      \ '%{&modified?&modifiable?"+":"⨁":""}']
    let b:mayhem.sl_cached_fileinfo = [
      \ '%#SlFTyp2C#'..type..'%*',
      \ '%#SlFTyp2N#'..type..'%*']
  else
    let b:mayhem.sl_cached_filename = [
      \ '%{%CheckRO()%}%#SlFNameC#'..tail..'%* '..
      \ '%{&modified?&modifiable?"+":"⨁":""}',
      \ '%{%CheckRO()%}%#SlFNameN#'..tail..'%* '..
      \ '%{&modified?&modifiable?"+":"⨁":""}']
    let b:mayhem.sl_cached_fileinfo = [
      \ '%#SlFTyp2C#'..type..'%*',
      \ '%#SlFTyp2N#'..type..'%*']
  endif
endfunc

" ^V/^S need to be real, i.e. entered using ctrl+v,ctrl+v/ctrl+s
" Single letter mode() - Ascii
function! SimpleModeA() abort
  return {
        \ 'n': 'n',
        \ 'i': 'i',
        \ 'v': 'v', 'V': 'V', '': '^V',
        \ 's': 's', 'S': 'S', '': '^S',
        \ 'R': 'R',
        \ 'r': 'r',
        \ 't': 't',
        \ 'c': 'c',
        \ '!': 'S',
        \ }[mode()]
endfunc

" Single letter mode() - Unicode
function! SimpleMode8() abort
  return {
        \ 'n': 'n',
        \ 'i': 'ɪ',
        \ 'v': 'v', 'V': 'v̅', '': 'v̺͆',
        \ 's': 's', 'S': 's̅', '': 's̺͆',
        \ 'R': 'ʀ',
        \ 'r': 'ᴚ',
        \ 't': 'ʇ',
        \ 'c': 'ɔ',
        \ '!': 'S',
        \ }[mode()]
endfunc

" Single letter mode() - SF Symbols
function! SimpleModeSF() abort
  return {
        \ 'n': 'n',
        \ 'i': 'ɪ',
        \ 'v': 'v', 'V': 'v̅', '': 'v̺͆',
        \ 's': 's', 'S': 's̅', '': 's̺͆',
        \ 'R': 'ʀ',
        \ 'r': 'ᴚ',
        \ 't': 'ʇ',
        \ 'c': 'ɔ',
        \ '!': 'S',
        \ }[mode()]
endfunc

" Multi letter mode(true) - Ascii
function! ModeA() abort
endfunc
" Multi letter mode(true) - Unicode
function! Mode8() abort
endfunc
" Multi letter mode(true) - SF Symbols
function! ModeSF() abort
  return {'n':    '􀂮',
        \ 'no':   '􀂮􀍡',
        \ 'nov':  '􀂮􀍡',
        \ 'noV':  '􀂮􀍡',
        \ 'no': '􀂮􀍡',
        \ 'niI':  '􀈎',
        \ 'niR':  '􀈎',
        \ 'niV':  '􀈎',
        \ 'nt':   '􀂮􀩼',
        \ 'v':    '􀍳',
        \ 'V':    'v̅',
        \ '':   'v̺͆ v⃞',
        \ 'vs':   '',
        \ 'Vs':   '',
        \ 's':  '',
        \ 's':    's',
        \ 'S':    's̅',
        \ '':   's̺͆ s⃞',
        \ 'i':    '􀈎',
        \ 'ic':   '􀈎',
        \ 'ix':   '􀈎',
        \ 'R':    'ʀ',
        \ 'Rc':   'ʀ',
        \ 'Rx':   'ʀ',
        \ 'Rv':   'ʀ',
        \ 'Rvc':  'ʀ',
        \ 'Rvx':  'ʀ',
        \ 'c':    '􀂘',
        \ 'ct':   '􀂘􀩼􀄄',
        \ 'cr':   '􀂘',
        \ 'cv':   '􀕲',
        \ 'cvr':  '􀕲',
        \ 'ce':   '􀕲',
        \ 'r':    '􀅇',
        \ 'rm':   '􀋷',
        \ 'r?':   '􀢰',
        \ 't':    '􀃼􀩼',
        \ '!':    '􀖇',
        \ }[mode(v:true)]
endfunc

"ꘖǀǀǁǂ|‖꜏ꖔ꜊   ꜏̲̅ ꜊̲̅
let g:mayhem.symbols_8.scrollL = {
      \ 'steps': ['꜒','꜍','꜓','꜎','꜔','꜐','꜕','꜑','꜖'],
      \ 'top':'꜒̅', 'full':'ǁ', 'bot':'꜖̲',
      \ }
let g:mayhem.symbols_8.scrollR = {
      \ 'steps': ['˥','꜈','˦','꜉','˧','꜋','˨','꜌','˩'],
      \ 'top':'˥̅', 'full':'ǁ', 'bot':'˩̲',
      \ }
let g:mayhem.symbols_S.scroll = g:mayhem.symbols_8.scrollR
let g:mayhem.symbols_8.scroll = g:mayhem.symbols_8.scrollR
let g:mayhem.symbols_A.scroll = {
      \ 'steps': ['1','2','3','4','5','6','7','8','9'],
      \ 'top':'¯', 'full':']', 'bot':'_',
      \ }
function ScrollHint() abort
  let scrollsymbols = get(s:symbols, 'scroll', {})
  let line_cursor = line('.')
  let line_wintop = line('w0')
  let line_winbot = line('w$')
  let line_count  = line('$')

  if line_wintop == 1
    if line_winbot == line_count
      return scrollsymbols.full
    endif
    return scrollsymbols.top
  endif
  if line_winbot == line_count
    return scrollsymbols.bot
  endif

  let position = (line_cursor * len(scrollsymbols.steps) - 1) / line_count

  let top    = line('w0')
  let height = line('w$') - top + 1

  " echo printf('%i, %i, %i, %s',
  "\ line_cursor, line_count, position, scrollsymbols.steps[position])
  return scrollsymbols.steps[position]
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
  "

  "     Size:  left╺╮  ╭╸zeros
  "               %{-}{0}{minwid}.{maxwid}
  " Truncate: %< ║ %-f %< %f ┃ abcdefghi.vim < efghi.vim ┃
  " Separate: %= ║ L%=Mid%=R ┃ L          Mid          R ┃

  let g:mayhem['sl_norm'] = [
        \ '%{%ChGit()%} %{%ChFName()%} %#SlSepC#%<%=%*'..
        \ '%{%Diffing()%}'..
        \ '%( %#SlFlagC#%{%CheckUtf8()%}%{%CheckUnix()%}%* %)'..
        \ '%{%ChFInfo()%} %{%ScrollHint()%}'..
        \ ' %{%ChDiag()%}',
        \
        \ '%{%ChGit()%} %{%ChFName()%} %#SlSepN#%<%=%*'..
        \ '%{%Diffing()%}'..
        \ '%( %#SlFlagN#%{%CheckUtf8()%}%{%CheckUnix()%}%* %)'..
        \ '%{%ChFInfo()%} %{%ScrollHint()%}'..
        \ ' %{%ChDiag()%}']


  " let g:mayhem['sl_prev'] = [
  "   \ '%#SlInfoC#ᴘ⃞  %-f%*%<%=%(%n %l,%c%V %P%) ',
  "   \ '%#SlInfoN#ᴘ⃞  %-f%*%<%=%(%n %l,%c%V %P%) ']
  let g:mayhem['sl_prev'] = [
    \ '%#SlInfoC#􀬸 %-f%*%<%=%(%n %l,%c%V %P%) ',
    \ '%#SlInfoN#􀬸 %-f%*%<%=%(%n %l,%c%V %P%) ']
  " let g:mayhem['sl_help'] = [
  "       \ '%#SlInfoC#𝓲⃝  %{%FName()%}%*%#SlHintC#%{%FDotExt()%}%<%=%(ln%l %*%P%) ',
  "       \ '%#SlInfoN#𝓲⃝  %{%FName()%}%*%#SlHintN#%{%FDotExt()%}%<%=%(ln%l %*%P%) ']
  let g:mayhem['sl_help'] = [
        \ '%#SlInfoC#􀉚  %{%FName()%}%*%#SlHintC#%{%FDotExt()%}%<%=%(ln%l %*%P%) ',
        \ '%#SlInfoN#􀉚  %{%FName()%}%*%#SlHintN#%{%FDotExt()%}%<%=%(ln%l %*%P%) ']

  let g:mayhem['sl_messages'] = [
        \ '  􀤏  %=%#SlMessC#􁈏 Messages 􁈐%*%=  􀤏  ',
        \ '  􀤏  %=%#SlMessN#􁈏 Messages 􁈐%*%=  􀤏  ']

  let g:mayhem['sl_terminal'] = [
        \ '%#SlTermC#􀩼 %*',
        \ '%#SlTermN#􀩼 %*']

  " ' ℺⃞ 🅀 𝒬⃞  ⍰ \ %%*'
  let g:mayhem['sl_qfix'] = [
        \ '%#SlQfixC#􀩳 %*',
        \ '%#SlQfixN#􀩳 %*']
  " let g:mayhem['sl_dir_todo'] = [
  "       \ '%#SlDirC#DIR %-F:h%*',
  "       \ '%#SlDirN#DIR %-F:h%*']
  let g:mayhem['sl_dir'] = [
        \ '%#SlDirC#􀈕 %-F:h%*%<%=%#SlDirInvC#netrw%*',
        \ '%#SlDirN#􀈕 %-F:h%*%<%=%#SlDirInvN#netrw%*']

  " let g:mayhem['sl_home_todo'] = [
  "       \ '%#SlHomeC#HOME Vim Mayhem%*%<%=%#SlHmRtC#%*',
  "       \ '%#SlHomeN#HOME Vim Mayhem%*%<%=%#SlHmRtN#%*']
  let g:mayhem['sl_home'] = [
        \ '%#SlHomeLC#􁘭  %*%<%=%#SlHomeMC#Vim Mayhem%*%=%#SlHomeRC#􁘭 %*',
        \ '%#SlHomeLN#􁘭  %*%<%=%#SlHomeMN#Vim Mayhem%*%=%#SlHomeRN#􁘭 %*']
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
  elseif &ft == 'vimmessages'
    return get(get(g:, 'mayhem', {}), 'sl_messages', ['sl_messagesC', 'sl_messagesN'])[NC()]
  elseif &ft == 'mayhemhome'
    return get(get(g:, 'mayhem', {}), 'sl_home', ['sl_homeC', 'sl_homeN'])[NC()]
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
