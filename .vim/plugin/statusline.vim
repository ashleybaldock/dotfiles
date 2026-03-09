if exists("g:mayhem_loaded_statusline")
  finish
endif
let g:mayhem_loaded_statusline = 1

scriptencoding utf-8

"
" See Also: ../autoload/tabline.vim
"             ../plugin/statusline.vim
"

"{{{1 TODO Statusline for narrow windows (<16)
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
" }}}

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
  return ext == '' ? '' : '.' .. ext
endfunc


function ChDiag()
  return get(b:, 'mayhem', {})->get('sl_cache_diag', ['D?','DN'])[NC()]
endfunc
"
" 􀋙⃞︎   􀋝⃞︎  􀋙️⃝ 􀋝️⃝ 􁄤️⃝
"
" 􀋙􀃲     􀋝⃞︎         􀋙️⃝ 􀋝️⃝ 􁄤️⃝
"   
" 􀋚︎􀋞︎ 􀋚️⃝ 􀋞️⃝ 􁄠️⃝
" 􀃮􀃯􀃬􀃭􀃰 􀃱􀃲􀃳􀤘⃞︎  􀤙 
" 
" 􀀹️⃝􀀻️⃝􀀽️⃝􀀿️⃝􀁁️⃝􀘘️⃝􀁃️⃝􀁅️⃝􀔊️⃝􀔋️⃝􀔌️⃝􀔍️⃝􀔎️⃝􀔏️⃝􀔐️⃝􀔑️⃝􀔒️⃝􀔓️⃝􀔔️⃝
" 􀀸️⃝􀀺️⃝􀀼️⃝􀀾️⃝􀁀️⃝􀘗️⃝􀁂️⃝􀁄️⃝􀓫️⃝􀓬️⃝􀓭️⃝􀓮️⃝􀓯️⃝􀓰️⃝􀓱️⃝􀓲️⃝􀓳️⃝􀓴️⃝􀓵️⃝
" 􀃈️⃝􀃊️⃝􀃌️⃝􀃎️⃝􀃐️⃝􀘙️⃝􀃒️⃝􀃔️⃝􀔩️⃝􀔪️⃝􀔫️⃝􀔬️⃝􀔭️⃝􀔮️⃝􀔯️⃝􀔰️⃝􀔱️⃝􀔲️⃝􀔳️⃝
" 􀃋️⃝􀃍️⃝􀃏️⃝􀃑️⃝􀘚️⃝􀃓️⃝􀃕️⃝􀕈️⃝􀕉️⃝􀕊️⃝􀕋️⃝􀕌️⃝􀕍️⃝􀕎️⃝􀕏️⃝􀕐️⃝􀕑️⃝􀕒️⃝

"  􀓄️⃝  􀄦️⃝      􀅈️⃝      􀧐️⃝ 􀄪️⃝ 􀅎️⃝ 􀅍️⃝ 􀒆️⃝ 􀅼️⃝ 􀅽️⃝ 􀅬️⃝ 
"    􀓅️⃝             􀅉️⃝ 􀬑️⃝        􀢒️⃝  􀅳️⃝     􀥋⃝ 
"           􀱶️⃝    􀅊️⃝ 􀄾️⃝     􀄫️⃝     􀣴️⃝   􀅷️⃝     􀘽⃝ 
"  􀓂️⃝  􀄤️⃝           􀑹️⃝                􀘾️⃝  
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
"   􀓼️⃝  􀔛️⃝  􀔺️⃝  􀕙️⃝   􀋊️⃝􀋊️⃞􀋊                             
" 􀓽️⃝  􀔜️⃝  􀔻️⃝  􀕚️⃝     􀇾️⃝􀇾􀇾                             
"   􀓾️⃝  􀔝️⃝  􀔼️⃝  􀕛️⃝   􀆅️⃝􀆅􀆅
" 􀓿️⃝  􀔞️⃝  􀔽️⃝  􀕜️⃝     􂟦️⃝ 􂟦'􂟦'
"
"     \  c:['','1⃝ ','2⃝ ','3⃝ ','4⃝ ','5⃝ ','6⃝ ','7⃝ ','8⃝ ','9⃝ '],
"     \  c:['','1􀋊','2⚑️','⚑️3 ','4⃝ ','5⃝ ','6⃝ ','7⃝ ','8⃝ ','9⃝ '],
"     \  n:['','𝟣','𝟤','𝟥','𝟦','𝟧','𝟨','𝟩','𝟪','𝟫'],
"     \  n:['','𝟣⚑️','𝟤⚑️','𝟥⚑️','𝟦⚑️','𝟧⚑️','𝟨⚑️','𝟩⚑️','𝟪⚑️ ','𝟫⚑️ ','𐱄⚑️'],
"     \  n:#{1:'𝟣⚑️',2:'𝟤⚑️',3:'𝟥⚑️',4:'𝟦⚑️',5:'𝟧⚑️',6:'𝟨⚑️',7:'𝟩⚑️',8:'𝟪⚑️',9:'𝟫⚑️'},

let g:mayhem.symbols_S.diag = #{
      \ numbers  : #{
      \  n:['','!️𝟣⃞','!️𝟤⃞','!️𝟥⃞','!️𝟦⃞','!️𝟧⃞','!️𝟨⃞','!️𝟩⃞','!️𝟪⃞','!️𝟫️⃞'],
      \  c:['','１⃝︀','２⃝','３⃝','４⃝','５⃝','６⃝','７⃝','８⃝','９⃝'],
      \},
      \ error    : #{ n: '⚑⃝ ', c: '􀋊︎⃣', i: '􀋊', 1:'𝟣⚑️',2:'𝟤⚑️',3:'𝟥⚑️',4:'𝟦⚑️',5:'𝟧⚑️',6:'𝟨⚑️',7:'𝟩⚑️',8:'𝟪⚑️',9:'𝟫⚑️'},
      \ warning  : #{ n: '􀁞', c: '􀅎︎⃝', i: '􀇾', 1:'𝟣!',2:'𝟤!',3:'𝟥!',4:'𝟦!',5:'𝟧!',6:'𝟨!',7:'𝟩!',8:'𝟪!',9:'𝟫!'},
      \ ok       : #{ n: '􀆅', c: '􀆅︎⃣', i: '􀆅'},
      \ off      : #{ n: '􂟦', c: '􂟦︎', i: '􂟦'},
      \}
let g:mayhem.symbols_8.diag = #{
      \ numbers  : ['','1⃝ ','2⃝ ','3⃝ ','4⃝ ','5⃝ ','6⃝ ','7⃝ ','8⃝ ','9⃝ '],
      \ error    : #{ n: '⚑️', c: '⚑⃝ ', i: '⚑️', 1:'𝟣⚑️',2:'𝟤⚑️',3:'𝟥⚑️',4:'𝟦⚑️',5:'𝟧⚑️',6:'𝟨⚑️',7:'𝟩⚑️',8:'𝟪⚑️',9:'𝟫⚑️'},
      \ warning  : #{ n: '!', c: '!⃝ ', i: '!', 1:'𝟣!',2:'𝟤!',3:'𝟥!',4:'𝟦!',5:'𝟧!',6:'𝟨!',7:'𝟩!',8:'𝟪!',9:'𝟫!'},
      \ ok       : #{ n: '✓️', c: '✓⃝ ', i: '✓️',},
      \ off      : #{ n: '?', c: '?⃣ ', i: '?',},
      \}
let g:mayhem.symbols_A.diag = #{
      \ numbers  : ['', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
      \ error    : #{n:'E', c:'E', i: 'E', 1: '1', 2: '2', 3: '3', 4: '4', 5: '5'},
      \ warning  : #{n:'W', c:'W', i: 'W', 1: '1', 2: '2', 3: '3', 4: '4', 5: '5'},
      \ ok       : 'Ø',
      \ off      : '¿',
      \}

" TODO - Add gutter display of errors elsewhere in file
function s:Update_Diag()
  if !exists('g:did_coc_loaded')
    let b:mayhem.sl_cache_diag = [
          \ ['%#SlSynOffC#', symbols#getc('diag.off'), '%*']->join(''),
          \ ['%#SlSynOffN#', symbols#getn('diag.off'), '%*']->join(''),
          \]
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
    let b:mayhem.sl_cache_diag = [
        \ ['%#SlSynErrC#',
        \  get(symbols#get('diag.error'), errorCount, symbols#getc('diag.error')),
        \ '%*']->join(''),
        \ ['%#SlSynErrN#',
        \  get(symbols#get('diag.error'), errorCount, symbols#getn('diag.error')),
        \ '%*']->join(''),
        \]
    return
  endif

  if warnCount > 0
    let b:mayhem.sl_cache_diag = [
        \ ['%#SlSynWarnC#',
        \  get(symbols#get('diag.warning'), warnCount, symbols#getc('diag.warning')),
        \ '%*']->join(''),
        \ ['%#SlSynWarnN#',
        \  get(symbols#get('diag.warning'), warnCount, symbols#getn('diag.warning')),
        \ '%*']->join(''),
        \]
    return
  endif

  let b:mayhem.sl_cache_diag = [
        \ ['%#SlSynOkC#', symbols#getc('diag.ok'), '%*']->join(''),
        \ ['%#SlSynOkN#', symbols#getn('diag.ok'), '%*']->join(''),
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
"  􀖄️⃝ 􀖅️⃝ 􀙠️⃝ 􀙡️⃝
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
  return get(b:, 'mayhem', {})->get('sl_cache_git', ['G?','GN'])[NC()]
endfunc

" Update cached git status
" TODO - add detailed git status info
function s:Update_Git()
  if !exists('g:loaded_fugitive')
    let b:mayhem.sl_cache_git = [
          \ '%#SlGitOffC#' .. symbols#get('git.gitoff') .. '%*',
          \ '%#SlGitOffN#'  .. symbols#get('git.gitoff') .. '%*'
          \]
    return
  endif

  let head = FugitiveHead()
  if empty(head)
    let b:mayhem.sl_cache_git =  [
          \ '%#SlNotGitC#' .. symbols#get('git.notgit') .. '%*',
          \ '%#SlNotGitN#' .. symbols#get('git.notgit') .. '%*'
          \]
    return
  else
    let b:mayhem.sl_cache_git =  [
          \ '%#SlGitC#'  ..  symbols#get('git.isgit')  ..  '%*',
          \ '%#SlGitN#'  ..  symbols#get('git.isgit' ) ..  '%*'
          \]
    return
  endif
endfunc


let g:mayhem.symbols_S.status = {
      \ 'readonly'    : 'ᴿ',
      \ 'modified'    : '+',
      \ 'nomodifiable': '􀍼',
      \ 'fencnot8'    : '∪⃞⃥ ',
      \ 'ffnotnix'    : '␌⃞ ',
      \ 'scrollbind'  : '􀒠',
      \ 'diffing'     : '􀄐􀕹',
      \ 'diffleft'    : '􀤴􀕹',
      \ 'diffright'   : '􀄐􀤵',
      \ 'multx'       : '×',
      \ 'termpause'   : '􀊛',
      \ 'termplay'    : '􀩼',
      \ 'termtoggle'  : '􀊇',
      \ }
let g:mayhem.symbols_8.status = {
      \ 'readonly'    : 'ᴿ',
      \ 'modified'    : '+',
      \ 'nomodifiable': ' ⃠',
      \ 'fencnot8'    : '∪⃞⃥ ',
      \ 'ffnotnix'    : '␌⃞ ',
      \ 'scrollbind'  : '⚯',
      \ 'diffing'     : 'DIFF',
      \ 'diffleft'    : '𐰶DI',
      \ 'diffright'   : 'FF𐰷',
      \ 'multx'       : '×',
      \ 'termpause'   : '⏸⃞',
      \ 'termplay'    : '>⃞ ',
      \ 'termtoggle'  : '⏯︎',
      \ }
let g:mayhem.symbols_A.status = {
      \ 'readonly'    : 'R',
      \ 'modified'    : '+',
      \ 'nomodifiable': 'x',
      \ 'fencnot8'    : '!8',
      \ 'ffnotnix'    : '!F',
      \ 'scrollbind'  : 's',
      \ 'diffing'     : 'DIFF',
      \ 'diffleft'    : '<DI',
      \ 'diffright'   : 'FF>',
      \ 'multx'       : 'x',
      \ 'termpause'   : '>',
      \ 'termplay'    : '>',
      \ 'termtoggle'  : 't',
      \ }

function RO() abort
  return &readonly ? symbols#get('status.readonly') : ""
endfunc

function Modified() abort
  return ['%{&modifiable?&modified?"',
        \ symbols#get('status.modified') .. ' ',
        \ '":"":"',
        \ symbols#get('status.nomodifiable') .. ' ',
        \ '"}']->join('')
endfunc

function CheckUtf8() abort
  return &fenc !~ "^$\\|utf-8" || &bomb ? symbols#get('status.fencnot8') : ""
endfunc

function CheckScb() abort
  return &scrollbind ? symbols#get('status.scrollbind') : ""
endfunc

function CheckFF() abort
  return &fileformat == "unix" ? "" : symbols#get('status.ffnotnix')
endfunc

function TermPaused() abort
  return mode() =~# 'n' ?  symbols#get('status.termpause') : symbols#get('status.termplay')
endfunc

function Diffing() abort
  let diff_left = getbufvar(bufnr(), 'mayhem_diff_left', 0)
  let diff_right = getbufvar(bufnr(), 'mayhem_diff_right', 0)
  if &diff
    if diff_left
      return symbols#get('status.diffingleft')
    elseif diff_right
      return symbols#get('status.diffingright')
    else
      return symbols#get('status.diffing')
    endif
  else
    return ''
  endif
endfunc

function ChQuickfix() abort
  return getbufvar(bufnr(), 'mayhem_quickfix_title', '[Quickfix]')
endfunc

" 0/anything and 2/n are usual
function Conceal() abort
  return (&conceallevel == 0 || (&conceallevel == 2 && &concealcursor !~ "[vic]")) ? ""
        \ : (["", "➊", "➁", "➌"][&conceallevel] .. (&concealcursor =~ "[vic]" ? "!" : ""))
endfunc

" TODO status indicators for:
"      - autocmds active
"       - syntax refresh on save

" Get cached filename for statusline
function ChFName() abort
  return get(b:, 'mayhem', {})->get('sl_cached_filename', [expand('%'),expand('%')])[NC()]
endfunc

" Get cached filename info for statusline
function ChFInfo() abort
  return get(b:, 'mayhem', {})->get('sl_cached_fileinfo', ['',''])[NC()]
endfunc

function s:Update_WinSize() abort
  call s:SetStatusVars()

  if toggle#get('g:mayhem_sl_show_winsize')
    let b:mayhem.sl_cached_winsize = [
        \['%#SlDebugC#', '%{%winwidth(0)%}', symbols#get('status.multx'), '%{%winheight(0)%}','%*']->join(''),
        \['%#SlDebugN#', '%{%winwidth(0)%}', symbols#get('status.multx'), '%{%winheight(0)%}','%*']->join(''),
        \]
  else
    let b:mayhem.sl_cached_winsize = ['','']
  endif
endfunc
function ChWinSz() abort
  return get(b:, 'mayhem', {})->get('sl_cached_winsize', ['',''])[NC()]
endfunc

function s:Update_FileInfo() abort
  call s:SetStatusVars()
  let ext = expand('%:e')
  let name = expand('%:r')
  let diffname = getbufvar(bufnr(), 'mayhem_diff_saved', '')
  let diff_left = getbufvar(bufnr(), 'mayhem_diff_left', 0)
  let diff_right = getbufvar(bufnr(), 'mayhem_diff_right', 0)
  let diff_with = getbufvar(bufnr(), 'mayhem_diff_with', 0)
  let tail = expand('%:t')
  let type = getbufvar(bufnr(), '&filetype')
  let hint = mayhem#getHintForPath('%')
  let subtype = mayhem#getSubtypeForPath('%')

  if name == ''
    if &diff && diff_right
      let b:mayhem.sl_cached_filename = [
        \['%#SlFDfSvNmC#◀︎╸diff,with:', diff_with, '%* ', '%{%Modified()%}']->join(''),
        \['%#SlFDfSvNmN#◀︎╸diff,with:', diff_with, '%* ', '%{%Modified()%}']->join(''),
        \]
    else
      let b:mayhem.sl_cached_filename = [
        \['%#SlFNoNameC#nameless%* ', '%{%Modified()%}']->join(''),
        \['%#SlFNoNameN#nameless%* ', '%{%Modified()%}']->join(''),
        \]
    endif
  else
    if mayhem#fileTypeMatchesExt(type, expand('%'))
      let b:mayhem.sl_cached_filename = [
        \['%{%RO()%}%#SlFNameC#', name, '.%#SlFTypExtC#',
        \ ext, '%* ', '%{%Modified()%}', '%#SlFPathC#', hint, '%*']->join(''),
        \['%{%RO()%}%#SlFNameN#', name, '.%#SlFTypExtN#',
        \ ext, '%* ', '%{%Modified()%}', '%#SlFPathN#', hint, '%*']->join('')
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
      \['%#SlFTyp2C#', type, subtype == '' ? '' : ':' .. subtype, '%*']->join(''),
      \['%#SlFTyp2N#', type,  subtype == '' ? '' : ':' .. subtype, '%*']->join('')
      \]
  endif
endfunc


function s:SetStatusVars() abort
  let b:mayhem = get(b:, 'mayhem', {})
  let b:mayhem.sl_normC = get(b:mayhem, 'sl_normC', '')
  let b:mayhem.sl_normN = get(b:mayhem, 'sl_normN', '')

  let b:mayhem.f_projroot = get(ProjectRoot(), 'path')
  let b:mayhem.projname = fnamemodify(b:mayhem.f_projroot,':p:h:t')
  let b:mayhem.f_tail = expand('%:t')
  let b:mayhem.f_head = expand('%:p:h')
  let b:mayhem.f_ext = expand('%:e')
  let b:mayhem.f_name = expand('%:p:h')
  let b:mayhem.f_type = getbufvar(bufnr(), '&filetype')
endfunc
" sp|enew|pu=execute('echo getbufvar(bufnr(), "name")')


" TODO - change this so that the C/NC distinction doesn't need two
"         identical strings
"   - preprocessing step which looks for a marker and replaces with N or C
" TODO - it would be better to provide a plugin interface
"       for custom statusbar, winbar, etc. things 
" TODO - convert to vim9script
" TODO - finish symbols library
function s:UpdateStatuslines() abort
  call s:SetStatusVars()
  call s:Update_FileInfo()
  call s:Update_Git()
  call s:Update_Diag()
  call s:Update_WinSize()

  "     Size:  left╺╮  ╭╸zeros
  "               %{-}{0}{minwid}.{maxwid}
  " Truncate: %< ║ %-f %< %f ┃ abcdefghi.vim < efghi.vim ┃
  " Separate: %= ║ L%=Mid%=R ┃ L          Mid          R ┃

  let g:mayhem['sl_norm'] = [
        \['%{%ChWinSz()%}%{%ChGit()%} %{%ChFName()%} ',
        \'%#SlSepC#%=%*%<',
        \'%( %#SlFlagC#%{%CheckUtf8()%}%{%CheckFF()%}%*%)',
        \'%( %#SlHintC#%{%Conceal()%}%{%CheckScb()%}%*%)',
        \' %{%ChFInfo()%}',
        \' %{%ScrollHint()%}',
        \' %{%ChDiag()%}',
        \'%{%Diffing()%}',
        \]->join(''),
        \
        \['%{%ChWinSz()%}%{%ChGit()%} %{%ChFName()%} ',
        \'%#SlSepN#%=%*%<',
        \'%( %#SlFlagN#%{%CheckUtf8()%}%{%CheckFF()%}%*%)',
        \'%( %#SlHintN#%{%Conceal()%}%{%CheckScb()%}%*%)',
        \' %{%ChFInfo()%}',
        \' %{%ScrollHint()%}',
        \' %{%ChDiag()%}',
        \'%{%Diffing()%}',
        \]->join('')
        \]


  " let g:mayhem['sl_prev'] = [
  "   \ '%#SlInfoC#ᴘ⃞  %-f%*%<%=%(%n %l,%c%V %P%) ',
  "   \ '%#SlInfo#ᴘ⃞  %-f%*%<%=%(%n %l,%c%V %P%) ']
  let g:mayhem['sl_prev'] = [
        \[
        \'%#SlInfoC#􀬸 %-f%*%<%=%(%n %l,%c%V%) ',
        \]->join(''),
        \[
        \'%#SlInfoN#􀬸 %-f%*%<%=%(%n %l,%c%V%) '
        \]->join('')
        \]

  " let g:mayhem['sl_help'] = [
  "       \ '%#SlInfoC#𝓲⃝  %{%FName()%}%*%#SlHintC#%{%FDotExt()%}%<%=%(ln%l %*%P%) ',
  "       \ '%#SlInfoN#𝓲⃝  %{%FName()%}%*%#SlHintN#%{%FDotExt()%}%<%=%(ln%l %*%P%) ']
  let g:mayhem['sl_help'] = [
        \[
        \'%#SlInfoC#􀉚 %{%FName()%}',
        \'%#SlHintC#%{%FDotExt()%}',
        \'%<%=',
        \'%(',
        \'%#SlHintC# help ',
        \'%#SlFPathC#[️%#SlInfoC#%l%#SlFPathC#/️%#SlInfoC#%L%#SlFPathC#]️',
        \'%)',
        \]->join(''),
        \[
        \'%#SlInfoN#􀉚 %{%FName()%}',
        \'%#SlHintN#%{%FDotExt()%}',
        \'%<%=',
        \'%(',
        \'%#SlHintN# help ',
        \'%#SlFPathN#[️%#SlInfoN#%l%#SlFPathN#/️%#SlInfoN#%L%#SlFPathN#]️',
        \'%)',
        \]->join(''),
        \]

  let g:mayhem['sl_term'] = [
        \[
        \'%#SlTermC#%{%TermPaused()%} ',
        \'%-f%*%<%=%(%l,%c%V%) ',
        \ ' %{%ScrollHint()%}',
        \]->join(''),
        \[
        \'%#SlTermN#%{%TermPaused()%} ',
        \'%-f%#SlSepN#%*%<%= %#SlTermN#%(%l,%c%V%) ',
        \ ' %{%ScrollHint()%}',
        \]->join(''),
        \]

  let g:mayhem['sl_messages'] = [
        \[
        \'%{%ChWinSz()%}%#SlMessIC#􀤏%* %#SlMessC#Messages%*%=',
        \' %{%ScrollHint()%}',
        \' %#SlMessIC# %*'
        \]->join(''),
        \[
        \'%{%ChWinSz()%}%#SlMessIN#􀤏%* %#SlMessN#Messages%*%=',
        \' %{%ScrollHint()%}',
        \' %#SlMessIN# %*'
        \]->join(''),
        \]

  let g:mayhem['sl_scriptnames'] = [
        \['%#SlMessIC#􀤏%* %#SlMessC#Scriptnames%*%=',
        \ ' %{%ScrollHint()%}',
        \ ' %#SlMessIC# %*']->join(''),
        \['%#SlMessIN#􀤏%* %#SlMessN#Scriptnames%*%=',
        \ ' %{%ScrollHint()%}',
        \ ' %#SlMessIN# %*']->join(''),
        \]

  let g:mayhem['sl_runtime'] = [
        \['%#SlMessIC#􀤏%* %#SlMessC#Runtime%*%=',
        \ ' %{%ScrollHint()%}',
        \ ' %#SlMessIC# %*']->join(''),
        \['%#SlMessIN#􀤏%* %#SlMessN#Runtime%*%=',
        \ ' %{%ScrollHint()%}',
        \ ' %#SlMessIN# %*']->join(''),
        \]

  " Quickfix:
  let g:mayhem['sl_qfix'] = [
        \['%#SlQfixC#􀩳 %*',
        \ '%{%ChQuickfix()%}',
        \ ' %#SlMessIC# %*']->join(''),
        \['%#SlQfixN#􀩳 %*',
        \ '%{%ChQuickfix()%}',
        \ ' %#SlMessIN# %*']->join(''),
        \]

  " Netrw:
  let g:mayhem['sl_dir'] = [
        \ '%#SlDirC#􀈕 %-F%*%<%=%#SlDirInvC#netrw%*',
        \ '%#SlDirN#􀈕 %-F%*%<%=%#SlDirInvN#netrw%*'
        \]

  " let test = '%%%=%<%(%{subExpr}%{%subReExpr%} %)'

  " let g:mayhem['sl_home_todo'] = [
  "       \ '%#SlHomeC#HOME Vim Mayhem%*%<%=%#SlHmRtC#%*',
  "       \ '%#SlHomeN#HOME Vim Mayhem%*%<%=%#SlHmRtN#%*']
  " Home:
  let g:mayhem['sl_home'] = [
        \[
        \'%{%ChWinSz()%}%#SlHomeLC#􁘲  Vim Mayhem%*',
        \'%<','%=','%#SlHomeMC# %*','%=','%#SlHomeRC# %*'
        \]->join(''),
        \[
        \'%{%ChWinSz()%}%#SlHomeLN#􁘱  Vim Mayhem%*',
        \'%<','%=','%#SlHomeMN# %*','%=','%#SlHomeRN# %*'
        \]->join(''),
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
    return get(g:, 'mayhem', {})->get('sl_help', ['sl_helpC', 'sl_helpN'])[NC()]
  elseif &buftype == 'quickfix'
    return get(g:, 'mayhem', {})->get('sl_qfix', ['sl_qfixC', 'sl_qfixN'])[NC()]
  elseif &buftype == 'preview'
    return get(g:, 'mayhem', {})->get('sl_prev', ['sl_prevC', 'sl_prevN'])[NC()]
  elseif &buftype == 'terminal'
    return get(g:, 'mayhem', {})->get('sl_term', ['sl_termC', 'sl_termN'])[NC()]
  endif

  if &ft == 'netrw'
    return get(g:, 'mayhem', {})->get('sl_dir', ['sl_dirC', 'sl_dirN'])[NC()]
  elseif &ft == 'vimmessages'
    return get(g:, 'mayhem', {})->get('sl_messages', ['sl_messagesC', 'sl_messagesN'])[NC()]
  elseif &ft == 'mayhemhome'
    return get(g:, 'mayhem', {})->get('sl_home', ['sl_homeC', 'sl_homeN'])[NC()]
  endif

  return get(g:, 'mayhem', {})->get('sl_norm', ['sl_normC', 'sl_normN'])[NC()]
endfunc


call autocmd_add([
      \#{
      \ event: ['WinResized'],
      \ pattern: '*', cmd: 'call s:Update_WinSize()',
      \ group: 'mayhem_sl_winsize', replace: v:true,
      \},
      \#{
      \ event: 'User', pattern: 'Toggle_g:mayhem_sl_show_winsize',
      \ cmd: 'call s:Update_WinSize()',
      \ group: 'mayhem_sl_winsize', replace: v:true,
      \},
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
