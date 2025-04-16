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

" TODO extend this to allow symbol lookup with list index e.g. for numbers
function! GetSymbol(symbolpath, fallback = 'X!')
  let lookup = split(a:symbolpath, '\.')->reduce(
        \{ acc, val -> get(acc, val, {})}, s:symbols)
  return empty(lookup) ? a:fallback : l:lookup
endfunc

function ChDiag()
  return get(get(b:, 'mayhem', {}), 'sl_cache_diag', ['D?','DN'])[NC()]
endfunc

" AddSymbols('diag.numbers.S', ['', '1⃝ ', '2⃝ ', '3⃝ ', '4⃝ ', '5⃝ ', '6⃝ ', '7⃝ ', '8⃝ ', '9⃝ ' ])
" AddSymbols('diag.error.S'  , '⚑⃝ ')
" AddSymbols('diag.warning.S', '!⃝ ')
" AddSymbols('diag.ok.S'     , '✓⃝ ')
" AddSymbols('diag.off.S'    , '?⃣ ')

" AddSymbols('diag.numbers.8', ['', '1⃝ ', '2⃝ ', '3⃝ ', '4⃝ ', '5⃝ ', '6⃝ ', '7⃝ ', '8⃝ ', '9⃝ ' ])
" AddSymbols('diag.error.8'  , '⚑⃝ ')
" AddSymbols('diag.warning.8', '!⃝ ')
" AddSymbols('diag.ok.8'     , '✓⃝ ')
" AddSymbols('diag.off.8'    , '?⃣ ')

" Sym range def 'numbers.double'
"       \ sf=􀔩􀔪􀔫􀔬􀔭􀔮􀔯􀔰􀔱􀔲􀔳􀔴􀔵􀔶􀔷􀔸􀔹􀔺􀔻􀔼􀔽􀔾􀔿􀕀􀕁􀕂􀕃􀕄􀕅􀕆􀕇􀘢􀚽􀚿􀛁􀛃􀛅􀛇􀛉􀛋􀛍􀛏􀛑􀛓􀛕􀛗􀛙􀛛􀛝􀛟􀛡
"       \ u8=
"       \ as=
" Sym range def 'numbers.wide'
"       \ sf=􀃈􀃊􀃌􀃎􀃐􀃒􀑵􀃖􀃘􀑷􀔳􀔴􀔵􀔶􀔷􀔸􀔹􀔺􀔻􀔼􀔽􀔾􀔿􀕀􀕁􀕂􀕃􀕄􀕅􀕆􀕇􀘢􀚽􀚿􀛁􀛃􀛅􀛇􀛉􀛋􀛍􀛏􀛑􀛓􀛕􀛗􀛙􀛛􀛝􀛟􀛡
"       \ u8=0⃝ 1⃝ 2⃝ 3⃝ 4⃝ 5⃝ 6⃝ 7⃝ 8⃝ 9⃝ ⑩ ⑪ ⑫ ⑬ ⑭ ⑮ ⑯ ⑰ ⑱ ⑲ ⑳
"       \ u8=⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ ⑪ ⑫ ⑬ ⑭ ⑮ ⑯ ⑰ ⑱ ⑲ ⑳
"       \ u8=０⒈ ⒉ ⒊ ⒋ ⒌ ⒍ ⒎ ⒏ ⒐ ⒑ ⒒ ⒓ ⒔ ⒕ ⒖ ⒗ ⒘ ⒙ ⒚ ⒛
"       \ u8=〇⑴ ⑵ ⑶ ⑷ ⑸ ⑹ ⑺ ⑻ ⑼ ⑽ ⑾ ⑿ ⒀ ⒁ ⒂ ⒃ ⒄ ⒅ ⒆ ⒇
"       \ as=０１２３４５６７８９
" ['', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
" Sym def diag.error   sf=􀋊️⃝ u8=⚑⃝  as=E   􀋉️⃝  􀋊️⃝ 􀋉⃝   
" Sym def diag.warning sf=􀢒️⃝ u8=!⃝  as=W  􀋍️⃝  􀋎️⃝  􀋍 􀋎⃤︎
" Sym def diag.ok      sf=􀆅️⃝ u8=✓⃝  as=O  􀤔􀤔⃝ 􀤔️⃝ 􀤔︎⃝  􀤕􀤕⃝ 􀤕️⃝ 􀤕︎⃝  
" Sym def diag.off     sf=􀅍️⃝ u8=?⃣  as=X
"
" 􀆅️⃝  􀁢️⃝ 􀋙️⃝ 􀋝️⃝ 􀋚️⃝ 􀋞️⃝
"
" 􁑣️⃝  􀅍️⃝  􀢒️⃝
"
" AddSymbols('warning' '',
" AddSymbols('ok'      'Ø',
" AddSymbols('off'     '¿',
"
" 􀋙⃞︎   􀋝⃞︎  􀋙️⃝ 􀋝️⃝ 􁄤️⃝
"   
" 􀋚︎􀋞︎ 􀋚️⃝ 􀋞️⃝ 􁄠️⃝
" 􀃮􀃯􀃬􀃭􀃰 􀃱􀃲􀃳􀤘⃞︎ 􀤙 
" 
" 􀀹️⃝􀀻️⃝􀀽️⃝􀀿️⃝􀁁️⃝􀘘️⃝􀁃️⃝􀁅️⃝􀔊️⃝􀔋️⃝􀔌️⃝􀔍️⃝􀔎️⃝􀔏️⃝􀔐️⃝􀔑️⃝􀔒️⃝􀔓️⃝􀔔️⃝
" 􀀸️⃝􀀺️⃝􀀼️⃝􀀾️⃝􀁀️⃝􀘗️⃝􀁂️⃝􀁄️⃝􀓫️⃝􀓬️⃝􀓭️⃝􀓮️⃝􀓯️⃝􀓰️⃝􀓱️⃝􀓲️⃝􀓳️⃝􀓴️⃝􀓵️⃝
" 􀃈️⃝􀃊️⃝􀃌️⃝􀃎️⃝􀃐️⃝􀘙️⃝􀃒️⃝􀃔️⃝􀔩️⃝􀔪️⃝􀔫️⃝􀔬️⃝􀔭️⃝􀔮️⃝􀔯️⃝􀔰️⃝􀔱️⃝􀔲️⃝􀔳️⃝
" 􀃋️⃝􀃍️⃝􀃏️⃝􀃑️⃝􀘚️⃝􀃓️⃝􀃕️⃝􀕈️⃝􀕉️⃝􀕊️⃝􀕋️⃝􀕌️⃝􀕍️⃝􀕎️⃝􀕏️⃝􀕐️⃝􀕑️⃝􀕒️⃝

"  􀓄️⃝  􀄦️⃝  􀖄️⃝  􀅈️⃝      􀧐️⃝ 􀄪️⃝ 􀅎️⃝ 􀅍️⃝ 􀒆️⃝ 􀅼️⃝ 􀅽️⃝ 􀅬️⃝ 
"    􀓅️⃝  􀄧️⃝  􀖅️⃝     􀅉️⃝ 􀬑️⃝        􀢒️⃝  􀅳️⃝     􀥋⃝ 
"           􀙠️⃝ 􀅊️⃝ 􀄾️⃝     􀄫️⃝     􀣴️⃝   􀅷️⃝     􀘽⃝ 
"  􀓂️⃝  􀄤️⃝ 􀙡️⃝ 􀱶️⃝     􀑹️⃝                􀘾️⃝  
"  􀓃️⃝  􀄥️⃝   􂄝️⃝ 􀄿️⃝        􀄨️⃝           􀅮️⃝  
"                􀅃️⃝        􀄩️⃝ 􀆐️⃝ 
"         􀅋️⃝   􀅀️⃝        􀄮️⃝     􀆑️⃝ 􀛺️⃝   􀆃️⃝   
"                􀅄️⃝           􀆒️⃝          􀆄️⃝ 􀅺️⃝ 􀆂️⃝  
"         􂄧️⃝  􀅁️⃝         􀄯️⃝     􀆓️⃝     􀅻️⃝         􂪱️⃝
"   􀅓️⃝            􀅅️⃝            􂉏️⃝   􀅾️⃝         􀙚️⃝  
"     􀅔️⃝                     􀄰️⃝     􂉐️⃝   􀅿️⃝ 
"       􀅕️⃝   􀅙️⃝   􀅂️⃝              􂦫️⃝       􀆀️⃝ 
"    􀅖️⃝     􀅪️⃝    􀅆️⃝           􀄱️⃝     􂦬️⃝   􂪯️⃝ 
"      􀨡️⃝    􀅫️⃝   􁂎️⃝                   􀆁️⃝ 
"                                    􂪰️⃝ 
"   􀓶️⃝  􀔕️⃝  􀔴️⃝  􀕓️⃝                         􀛨️⃝         
" 􀓷️⃝  􀔖️⃝  􀔵️⃝  􀕔️⃝                           􀺸️⃝          
"   􀓸️⃝  􀔗️⃝  􀔶️⃝  􀕕️⃝   􀆉️⃝  􀁲️⃝  􀁳️⃝  􀄂️⃝  􀄃️⃝    􀺶️⃝         
" 􀓹️⃝  􀔘️⃝  􀔷️⃝  􀕖️⃝   􀆊️⃝  􀁴️⃝  􀁵️⃝  􀄄️⃝  􀄅️⃝      􀛩️⃝           􀸏️⃝ 
"   􀓺️⃝  􀔙️⃝  􀔸️⃝  􀕗️⃝   􀆇️⃝  􀁮️⃝  􀁯️⃝  􀃾️⃝  􀃿️⃝    􀛪️⃝         􀡅️⃝ 
" 􀓻️⃝  􀔚️⃝  􀔹️⃝  􀕘️⃝   􀆈️⃝  􀁰️⃝  􀁱️⃝  􀄀️⃝  􀄁️⃝      􀢋️⃝           􁇵️⃝ 
"   􀓼️⃝  􀔛️⃝  􀔺️⃝  􀕙️⃝                               
" 􀓽️⃝  􀔜️⃝  􀔻️⃝  􀕚️⃝                                 
"   􀓾️⃝  􀔝️⃝  􀔼️⃝  􀕛️⃝ 
" 􀓿️⃝  􀔞️⃝  􀔽️⃝  􀕜️⃝ 
"
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
    let b:mayhem.sl_cache_diag = [
          \ '%#SlSynOffC#'..GetSymbol('diag.off')..'%*',
          \ '%#SlSynOffN#'..GetSymbol('diag.off')..'%*']
    return
  endif

  let diaginfo   = get(b:, 'coc_diagnostic_info', {})
  "lnums": [90, 6, 0, 6],
  let lnums      = get(diaginfo, 'lnums',       0)
  let infoCount  = get(diaginfo, 'information', 0)
  let hintCount  = get(diaginfo, 'hint',        0)
  let warnCount  = get(diaginfo, 'warning',     0)
  let errorCount = get(diaginfo, 'error',       0)

  if errorCount > 0
    " TODO symbol lookup with list index
    let symbol = get(s:symbols.diag.numbers, errorCount, get(s:symbols.diag, 'error', 'X!'))
    let b:mayhem.sl_cache_diag = [
        \ ['%#SlSynErrC#',symbol,'%*']->join(''),
        \ ['%#SlSynErrN#',symbol,'%*']->join(''),
        \]
    return
  endif

  if warnCount > 0
    let symbol = get(s:symbols.diag.numbers, warnCount, get(s:symbols.diag, 'warning', 'X!'))
    let b:mayhem.sl_cache_diag = [
        \ ['%#SlSynWarnC#',symbol,'%*']->join(''),
        \ ['%#SlSynWarnN#',symbol,'%*']->join(''),
        \]
    return
  endif

  let b:mayhem.sl_cache_diag = [
        \ ['%#SlSynOkC#', GetSymbol('diag.ok'), '%*']->join(''),
        \ ['%#SlSynOkN#', GetSymbol('diag.ok'), '%*']->join(''),
        \]
  return
endfunc


" SF symbols, only works on OSX
let g:mayhem.symbols_S.git = {
      \ 'isgit':    '􀐅',
      \ 'notgit':   '􀓔',
      \ 'gitoff':   '􀃮',
      \ 'problem':  '􀃮',
      \ 'norepo':   '􀓔',
      \ 'insync':   '􀐅',
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
      \ 'insync':   '=',
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
      \ 'modified': '+',
      \ 'gitoff':   '!',
      \ 'problem':  '!',
      \ 'norepo':   'n',
      \ 'insync':   '=',
      \ 'behind':   '<',
      \ 'ahead':    '>',
      \ 'diverged': '~',
      \ 'unstaged': '*',
      \ 'staged':   '+'
      \}
"   $   stashes          􀐆️⃞   􀫝️⃞   􀠧︎⃝  􀓔⃞️  􁊓⃞︎  􀼳 􀴨 
"                                             􀖄️⃞ 􀖄️⃝ 􀖄️⃤ 
"                                             􀖅️⃞ 􀖅️⃝ 􀖅️⃤ 
"                                             􀙡️⃞ 􀙡️⃝ 􀙡️⃤
"                                             􀙠️⃞ 􀙠️⃝ 􀙠️⃤
"
"                                             
"                                             􀖄⃤ 􀖅⃤  􀙡⃤ 􀙠⃤
"                                             􀖄⃟ 􀖅⃟ 􀙡⃟ 􀙠⃟️
"                                             􀖄⃤︎ 􀖅⃤︎  􀙡⃤︎ 􀙠⃤︎
"                                             􀖄⃠️ 􀖅⃠️  􀙡⃠️ 􀙠⃠️
"   %   untracked files
" 􀙡branch, relative to upstream
"     !       􀃮  problem
"               no changes     with changes
"     n       􀓔  not a repo   􀃜 modified (+)   􁝊 nomodifiable
" <   <   ❮   􁄻  behind       􁚍 unstaged (*)
" >   >   ❯   􀯇  ahead        􀐇 staged   (+)
" z   ~   ◇   􀐉  diverged   
" =   =       􀐅  in sync

" Get latest cached git status
function ChGit()
  return get(get(b:, 'mayhem', {}), 'sl_cache_git', ['G?','GN'])[NC()]
endfunc

" Update cached git status
" TODO - add detailed git status info
function s:Update_Git()
  if !exists('g:loaded_fugitive')
    let b:mayhem.sl_cache_git = [
          \ '%#SlGitOffC#'..GetSymbol('git.gitoff')..'%*',
          \ '%#SlGitOffN#'..GetSymbol('git.gitoff')..'%*']
    return
  endif

  let head = FugitiveHead()
  if empty(head)
    let b:mayhem.sl_cache_git =  [
          \ '%#SlNotGitC#'..GetSymbol('git.notgit')..'%r',
          \ '%#SlNotGitN#'..GetSymbol('git.notgit')..'%*']
    return
  else
    let b:mayhem.sl_cache_git =  [
          \ '%#SlGitC#'..GetSymbol('git.isgit')..'%*',
          \ '%#SlGitN#'..GetSymbol('git.isgit')..'%*']
    return
  endif
endfunc


let g:mayhem.symbols_S.status = {
      \ 'readonly': 'ᴿ',
      \ 'modified': '+',
      \ 'nomodifiable': '􀍼',
      \ 'fencnot8': '∪⃞⃥ ',
      \ 'ffnotnix': '␌⃞ ',
      \ 'diffing' : '􀄐􀕹',
      \ }
let g:mayhem.symbols_8.status = {
      \ 'readonly': 'ᴿ',
      \ 'modified': '+',
      \ 'nomodifiable': ' ⃠',
      \ 'fencnot8': '∪⃞⃥ ',
      \ 'ffnotnix': '␌⃞ ',
      \ 'diffing' : 'DIFF',
      \ }
let g:mayhem.symbols_A.status = {
      \ 'readonly': 'R',
      \ 'modified': '+',
      \ 'nomodifiable': 'x',
      \ 'fencnot8': '!8',
      \ 'ffnotnix': '!F',
      \ 'diffing' : 'DIFF',
      \ }

function RO()
  return &readonly ? GetSymbol('status.readonly') : ""
endfunc
function Modified()
  return ['%{&modifiable?&modified?"',
        \ GetSymbol('status.modified') .. ' ',
        \ '":"":"',
        \ GetSymbol('status.nomodifiable') .. ' ',
        \ '"}']->join('')
endfunc
function CheckUtf8()
  return &fenc !~ "^$\\|utf-8" || &bomb ? GetSymbol('status.fencnot8') : ""
endfunc
function CheckUnix()
  return &fileformat == "unix" ? "" : GetSymbol('status.ffnotnix')
endfunc
function Diffing()
  return &diff ? GetSymbol('status.diffing') : ""
endfunc
" 0/anything and 2/n are usual
function Conceal()
  return (&conceallevel == 0 || (&conceallevel == 2 && &concealcursor !~ "[vic]")) ? ""
        \ : (["", "➊", "➁", "➌"][&conceallevel] .. (&concealcursor =~ "[vic]" ? "!" : ""))
endfunc

" TODO status indicators for:
"      - autocmds active
"       - syntax refresh on save

" Get cached filename for statusline
function ChFName()
  return get(get(b:, 'mayhem', {}), 'sl_cached_filename',
        \ [expand('%'),expand('%')])[NC()]
endfunc

" Get cached filename info for statusline
function ChFInfo()
  return get(get(b:, 'mayhem', {}), 'sl_cached_fileinfo',
        \ ['',''])[NC()]
endfunc


" show hint for files in these folders
" most specific is used
if exists('$VIMHOME')
  let g:mayhem.path_hints = {
        \ expand('$VIMHOME/ftplugin'):       ['(️v/️f)️', ''],
        \ expand('$VIMHOME/after/ftplugin'): ['(️v/️a/️f)️', ''],
        \ expand('$VIMHOME/plugin'):         ['(️v/️p)️', ''],
        \ expand('$VIMHOME/after/plugin'):   ['(️v/️a/️p)️', ''],
        \ expand('$VIMHOME/syntax'):         ['(️v/️s)️', ':syntax'],
        \ expand('$VIMHOME/after/syntax'):   ['(️v/️a/️s)️', ':syntax'],
        \ expand('$VIMHOME/autoload'):       ['(️v/️autol)️', ''],
        \ expand('$VIMHOME/colors'):         ['(️v/️cl)️', ':colors'],
        \ expand('$VIMHOME/templates'):      ['(️v/️tp)️', ':template'],
        \ expand('$VIMRUNTIME/syntax'):      ['$R syntax', ''],
        \ '**/node_modules':      ['NM ', ''],
        \ }
else
  let g:mayhem.path_hints = {}
endif

let g:mayhem.type_ext_map = {
      \ 'javascriptreact': ['jsx'],
      \ 'javascript': ['js'],
      \ 'typescriptreact': ['tsx'],
      \ 'typescript': ['ts'],
      \ 'markdown': ['md'],
      \ 'dosbatch': ['bat'],
      \ }

function s:GetPathHint(path)
  return get(g:mayhem.path_hints, fnamemodify(expand(a:path), ':p:h'), ['', ''])
endfunc

function s:PathDifference(path1, path2)
  echo fnamemodify(expand(a), ':p:h')
endfunc

function s:TypeMatchesFilename(type, filename)
  let ext = fnamemodify(a:filename, ':e')
  let name = fnamemodify(a:filename, ':r')
  let tail = fnamemodify(a:filename, ':t')
  let typemapping = get(g:mayhem.type_ext_map, a:type, [])

  return a:type != '' && a:type == ext
        \ || index(typemapping, ext) >= 0
        \ || name == tail && index(typemapping, name) >= 0
endfunc

function s:Update_FileInfo()
  call s:SetStatusVars()
  let ext = expand('%:e')
  let name = expand('%:r')
  let diffname = getbufvar(bufnr(), 'mayhem_diff_saved', '')
  let tail = expand('%:t')
  let type = getbufvar(bufnr(), '&filetype')
  let [pathhint, typehint] = s:GetPathHint('%')

  if name == ''
    if &diff && diffname != ''
      let b:mayhem.sl_cached_filename = [
        \['%#SlFDfSvNmC#Saved(', diffname, ')%* ', '%{%Modified()%}']->join(''),
        \['%#SlFDfSvNmN#Saved(', diffname, ')%* ', '%{%Modified()%}']->join(''),
        \]
    else
      let b:mayhem.sl_cached_filename = [
        \['%#SlFNoNameC#nameless%* ', '%{%Modified()%}']->join(''),
        \['%#SlFNoNameN#nameless%* ', '%{%Modified()%}']->join(''),
        \]
    endif
  else
    if s:TypeMatchesFilename(type, expand('%'))
      let b:mayhem.sl_cached_filename = [
        \['%{%RO()%}%#SlFNameC#', name, '.%#SlFTypExtC#',
        \ ext, '%* ', '%{%Modified()%}', '%#SlFPathC#', pathhint, '%*']->join(''),
        \['%{%RO()%}%#SlFNameN#', name, '.%#SlFTypExtN#',
        \ ext, '%* ', '%{%Modified()%}', '%#SlFPathN#', pathhint, '%*']->join('')
        \]
    else
      let b:mayhem.sl_cached_filename = [
            \['%{%RO()%}%#SlFNameC#', tail, '%* ', '%{%Modified()%}']->join(''),
            \['%{%RO()%}%#SlFNameN#', tail, '%* ', '%{%Modified()%}']->join('')
            \]
    endif
  endif

  if type == ''
    let b:mayhem.sl_cached_fileinfo = [
      \ '%#SlFTyp2C#typeless%*',
      \ '%#SlFTyp2N#typeless%*',
      \ '']
  else
    let b:mayhem.sl_cached_fileinfo = [
      \['%#SlFTyp2C#', type, typehint, '%*']->join(''),
      \['%#SlFTyp2N#', type, typehint, '%*']->join('')
      \]
  endif
endfunc


function s:SetStatusVars()
  let b:mayhem = get(b:, 'mayhem', {})
  let b:mayhem.sl_normC = get(b:mayhem, 'sl_normC', '')
  let b:mayhem.sl_normN = get(b:mayhem, 'sl_normN', '')

  let b:mayhem.f_projroot = get(ProjectRoot(), 'path')
  " let b:mayhem.f_full = expand('%')
  let b:mayhem.f_tail = expand('%:t')
  let b:mayhem.f_head = expand('%:p:h')
  let b:mayhem.f_ext = expand('%:e')
  let b:mayhem.projname = fnamemodify(b:mayhem.f_projroot,':p:h:t')
  let b:mayhem.f_name = expand('%:p:h')
  let b:mayhem.f_type = getbufvar(bufnr(), '&filetype')
endfunc
" sp|enew|pu=execute('echo getbufvar(bufnr(), "name")')

  " TODO - change this so that the C/NC distinction doesn't need two
  "         identical strings
  " TODO - it would be better to provide a plugin interface
  "       for custom statusbar, winbar, etc. things 
  " TODO - convert to vim9script
  " TODO - finish symbols library
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
        \ ['%{%ChGit()%} %{%ChFName()%} ',
        \ '%#SlSepC#%=%*%<',
        \ '%{%Diffing()%}',
        \ '%( %#SlFlagC#%{%CheckUtf8()%}%{%CheckUnix()%}%*%)',
        \ '%( %#SlHintC#%{%Conceal()%}%*%)',
        \ ' %{%ChFInfo()%}',
        \ ' %{%ScrollHint()%}',
        \ ' %{%ChDiag()%}']->join(''),
        \
        \ ['%{%ChGit()%} %{%ChFName()%} ',
        \ '%#SlSepN#%=%*%<',
        \ '%{%Diffing()%}',
        \ '%( %#SlFlagN#%{%CheckUtf8()%}%{%CheckUnix()%}%*%)',
        \ ' %{%ChFInfo()%}',
        \ ' %{%ScrollHint()%}',
        \ ' %{%ChDiag()%}']->join('')
        \ ]


  " let g:mayhem['sl_prev'] = [
  "   \ '%#SlInfoC#ᴘ⃞  %-f%*%<%=%(%n %l,%c%V %P%) ',
  "   \ '%#SlInfo#ᴘ⃞  %-f%*%<%=%(%n %l,%c%V %P%) ']
  let g:mayhem['sl_prev'] = [
    \ '%#SlInfoC#􀬸 %-f%*%<%=%(%n %l,%c%V%) ',
    \ '%#SlInfoN#􀬸 %-f%*%<%=%(%n %l,%c%V%) ']
  " let g:mayhem['sl_help'] = [
  "       \ '%#SlInfoC#𝓲⃝  %{%FName()%}%*%#SlHintC#%{%FDotExt()%}%<%=%(ln%l %*%P%) ',
  "       \ '%#SlInfoN#𝓲⃝  %{%FName()%}%*%#SlHintN#%{%FDotExt()%}%<%=%(ln%l %*%P%) ']
  let g:mayhem['sl_help'] = [
        \ '%#SlInfoC#􀉚  %{%FName()%}%*%#SlHintC#%{%FDotExt()%}%<%=%(%#SlHintC# help %#SlFPathC#[️%#SlInfoC#%l%#SlFPathC#of%#SlInfoC#%L%#SlFPathC#]️%*%) ',
        \ '%#SlInfoN#􀉚  %{%FName()%}%*%#SlHintN#%{%FDotExt()%}%<%=%(ln%l of %L %*%) ']

  let g:mayhem['sl_term'] = [
    \ '􀩼%#SlTermC# %-f %F %t%*%<%=%(%n %l,%c%V %P%) ',
    \ '􀩼%#SlTermN# %-f%*%<%=%(%n %l,%c%V %P%) ']

  let g:mayhem['sl_messages'] = [
        \['%#SlMessIC#􀤏%* %#SlMessC#Messages%*%=',
        \ ' %{%ScrollHint()%}',
        \ ' %#SlMessIC#􀤏%*']->join(''),
        \['%#SlMessIN#􀤏%* %#SlMessN#Messages%*%=',
        \ ' %{%ScrollHint()%}',
        \ ' %#SlMessIN#􀤏%*']->join(''),
        \]

  let g:mayhem['sl_scriptnames'] = [
        \ ['%#SlHomeLC#SF Symbols%*','%<','%=']->join(''),
        \ ['%#SlHomeLN#SF Symbols%*','%<','%=']->join(''),
        \]


  " ' ℺⃞ 🅀 𝒬⃞  ⍰ \ %%*'
  " Quickfix:
  let g:mayhem['sl_qfix'] = [
        \ '%#SlQfixC#􀩳 %*',
        \ '%#SlQfixN#􀩳 %*']
  " Netrw:
  let g:mayhem['sl_dir'] = [
        \ '%#SlDirC#􀈕 %-F%*%<%=%#SlDirInvC#netrw%*',
        \ '%#SlDirN#􀈕 %-F%*%<%=%#SlDirInvN#netrw%*']

  let test = '%%%=%<%(%{subExpr}%{%subReExpr%} %)'

  " let g:mayhem['sl_home_todo'] = [
  "       \ '%#SlHomeC#HOME Vim Mayhem%*%<%=%#SlHmRtC#%*',
  "       \ '%#SlHomeN#HOME Vim Mayhem%*%<%=%#SlHmRtN#%*']
  " Home:
  let g:mayhem['sl_home'] = [
        \ ['%#SlHomeLC#􁘲  Vim Mayhem%*',
        \ '%<','%=','%#SlHomeMC# %*','%=','%#SlHomeRC# %*']->join(''),
        \ ['%#SlHomeLN#􁘱  Vim Mayhem%*',
        \ '%<','%=','%#SlHomeMN# %*','%=','%#SlHomeRN# %*']->join(''),
        \]

  let g:mayhem['sl_sfsym'] = [
        \ ['%#SlHomeLC#SF Symbols%*','%<','%=']->join(''),
        \ ['%#SlHomeLN#SF Symbols%*','%<','%=']->join(''),
        \]
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
  elseif &buftype == 'terminal'
    return get(get(g:, 'mayhem', {}), 'sl_term', ['sl_termC', 'sl_termN'])[NC()]
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


call autocmd_add([
      \#{
      \ event: ['CursorHold','BufWinEnter','BufFilePost','EncodingChanged'],
      \ pattern: '*', cmd: 'call s:UpdateStatuslines()',
      \ group: 'mayhem_statusline', replace: v:true,
      \},
      \#{
      \ event: 'User', pattern: 'MayhemDiagnosticsUpdated',
      \ cmd: 'call s:Update_Diag()',
      \ group: 'mayhem_statusline', replace: v:true,
      \},
      \])

" autocmd BufEnter    <buffer> match ExtraWhitespace /\s\+$/
" autocmd InsertEnter <buffer> match ExtraWhitespace /\s\+\%#\@<!$/
" autocmd InsertLeave <buffer> match ExtraWhitespace /\s\+$/

command! UpdateCustomStatusline call <SID>UpdateStatuslines()

set statusline=%{%CustomStatusline()%}

UpdateCustomStatusline

" vim:signcolumn=auto:foldcolumn=1:foldmethod=marker:nolist:nowrap
