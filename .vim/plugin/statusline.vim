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
      \ error    : #{n:'􀋊',c:'􀋊',i:'􀋊',1:'𝟣⚑️',2:'𝟤⚑️',3:'𝟥⚑️',4:'𝟦⚑️',5:'𝟧⚑️',6:'𝟨⚑️',7:'𝟩⚑️',8:'𝟪⚑️',9:'𝟫⚑️'},
      \ warning  : #{n:'􀁞',c:'􀁞',i:'􀇾',1:'𝟣!',2:'𝟤!',3:'𝟥!',4:'𝟦!',5:'𝟧!',6:'𝟨!',7:'𝟩!',8:'𝟪!',9:'𝟫!'},
      \ ok       : #{n:'􀆅',c:'􀆅︎',i:'􀆅'},
      \ off      : #{n:'􂟦',c:'􂟦︎',i:'􂟦'},
      \}
let g:mayhem.symbols_8.diag = #{
      \ numbers  : ['','1⃝ ','2⃝ ','3⃝ ','4⃝ ','5⃝ ','6⃝ ','7⃝ ','8⃝ ','9⃝ '],
      \ error    : #{n:'⚑️',c:'⚑⃝ ',i:'⚑️',1:'𝟣⚑️',2:'𝟤⚑️',3:'𝟥⚑️',4:'𝟦⚑️',5:'𝟧⚑️',6:'𝟨⚑️',7:'𝟩⚑️',8:'𝟪⚑️',9:'𝟫⚑️'},
      \ warning  : #{n:'!',c:'!⃝ ',i:'!',1:'𝟣!',2:'𝟤!',3:'𝟥!',4:'𝟦!',5:'𝟧!',6:'𝟨!',7:'𝟩!',8:'𝟪!',9:'𝟫!'},
      \ ok       : #{n:'✓️',c:'✓⃝ ',i:'✓️',},
      \ off      : #{n:'?',c:'?⃣ ',i:'?',},
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
    let b:mayhem.sl_cache_diag = format#CN([
          \ '%#SlSynOff⸮#' .. symbols#getc('diag.off') .. '%*'
          \])
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
    let b:mayhem.sl_cache_diag = format#CN([
        \'%#SlSynErr⸮#',
        \get(symbols#get('diag.error'), errorCount, symbols#getc('diag.error')),
        \'%*'
        \])
    return
  endif

  if warnCount > 0
    let b:mayhem.sl_cache_diag = format#CN([
        \'%#SlSynWarn⸮#',
        \get(symbols#get('diag.warning'), warnCount, symbols#getc('diag.warning')),
        \'%*'
        \])
    return
  endif

  let b:mayhem.sl_cache_diag = format#CN([
        \'%#SlSynOk⸮#' .. symbols#getc('diag.ok') .. '%*'
        \])
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
    let b:mayhem.sl_cache_git = format#CN([
          \ '%#SlGitOff⸮#' .. symbols#get('git.gitoff') .. '%*',
          \])
    return
  endif

  let head = FugitiveHead()
  if empty(head)
    let b:mayhem.sl_cache_git = format#CN([
          \ '%#SlNotGit⸮#' .. symbols#get('git.notgit') .. '%*',
          \])
    return
  else
    let b:mayhem.sl_cache_git = format#CN([
          \ '%#SlGit⸮#' .. symbols#get('git.isgit') .. '%*',
          \])
    return
  endif
endfunc

let g:mayhem.symbols_S.pages = #{
      \ qf: '𝒬𝒻',
      \ qfsep: '╱',
      \}
let g:mayhem.symbols_8.pages = #{
      \ qf: '𝒬𝒻',
      \ qfsep: '╱',
      \}
let g:mayhem.symbols_A.pages = #{
      \ qf: 'Qf',
      \ qfsep: '/',
      \}

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

function ChQfTitle() abort
  return get(w:, 'quickfix_title', 'quickfix list')
endfunc
function ChQfSearch() abort
  return getbufvar(bufnr(), 'mayhem_quickfix_search', 'search')
endfunc
function ChQfCt() abort
  return getbufvar(bufnr(), 'mayhem_quickfix_count', '?')
endfunc
function ChQfCtPl() abort
  return (getbufvar(bufnr(), 'mayhem_quickfix_count', 0) == 1) ? '' : 's'
endfunc
function ChQfFCt() abort
  return getbufvar(bufnr(), 'mayhem_quickfix_filecount', '?')
endfunc
function ChQfFCtPl() abort
  return (getbufvar(bufnr(), 'mayhem_quickfix_filecount', 0) == 1) ? '' : 's'
endfunc
function ChQfCommand() abort
  return getbufvar(bufnr(), 'mayhem_quickfix_command', ' :?? ')
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
    let b:mayhem.sl_cached_winsize = format#CN([
        \'%#SlDebug⸮#',
        \'%{%winwidth(0)%}' .. symbols#get('status.multx') .. '%{%winheight(0)%}%*'
        \])
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
      let b:mayhem.sl_cached_filename = format#CN([
        \'%#SlFDfSvNm⸮#◀︎╸diff,with:' .. diff_with .. '%* ',
        \'%{%Modified()%}',
        \])
    else
      let b:mayhem.sl_cached_filename = format#CN([
        \'%#SlFNoName⸮#nameless%* ',
        \'%{%Modified()%}'
        \])
    endif
  else
    if mayhem#fileTypeMatchesExt(type, expand('%'))
      let b:mayhem.sl_cached_filename = format#CN([
        \'%{%RO()%}',
        \'%#SlFName⸮#' .. name .. '.%#SlFTypExt⸮#' .. ext .. '%* ',
        \'%{%Modified()%}',
        \'%#SlFPath⸮#' .. hint .. '%*',
        \])
    else
      let b:mayhem.sl_cached_filename = format#CN([
            \'%{%RO()%}',
            \'%#SlFName⸮#' .. tail .. '%* ',
            \'%{%Modified()%}',
            \])
    endif
  endif

  if type == ''
    let b:mayhem.sl_cached_fileinfo = format#CN([
      \'%#SlFTyp2⸮#typeless%*',
      \])
  else
    let b:mayhem.sl_cached_fileinfo = format#CN([
      \'%#SlFTyp2⸮#' .. type .. (subtype == '' ? '' : ':' .. subtype) .. '%*'
      \])
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

  let g:mayhem['sl_norm'] = format#CN([
        \'%{%ChWinSz()%}%{%ChGit()%} %{%ChFName()%} ',
        \'%#SlSep⸮#%=%*%<',
        \'%( %#SlFlag⸮#%{%CheckUtf8()%}%{%CheckFF()%}%*%)',
        \'%( %#SlHint⸮#%{%Conceal()%}%{%CheckScb()%}%*%)',
        \' %{%ChFInfo()%}',
        \' %{%ScrollHint()%}',
        \' %{%ChDiag()%}',
        \'%{%Diffing()%}',
        \])


  " let g:mayhem['sl_prev'] = [
  "   \ '%#SlInfoC#ᴘ⃞  %-f%*%<%=%(%n %l,%c%V %P%) ',
  "   \ '%#SlInfo#ᴘ⃞  %-f%*%<%=%(%n %l,%c%V %P%) ']
  let g:mayhem['sl_prev'] = format#CN([
        \'%#SlInfo⸮#􀬸 %-f%*%<%=%(%n %l,%c%V%) ',
        \])

  " let g:mayhem['sl_help'] = [
  "       \ '%#SlInfoC#𝓲⃝  %{%FName()%}%*%#SlHintC#%{%FDotExt()%}%<%=%(ln%l %*%P%) ',
  "       \ '%#SlInfoN#𝓲⃝  %{%FName()%}%*%#SlHintN#%{%FDotExt()%}%<%=%(ln%l %*%P%) ']
  let g:mayhem['sl_help'] = format#CN([
        \'%#SlInfo⸮#􀉚 %{%FName()%}',
        \'%#SlHint⸮#%{%FDotExt()%}',
        \'%<%=',
        \'%(',
        \'%#SlHint⸮# help ',
        \'%#SlFPath⸮#[️%#SlInfo⸮#%l%#SlFPath⸮#/️%#SlInfo⸮#%L%#SlFPath⸮#]️',
        \'%)',
        \])

  let g:mayhem['sl_term'] = format#CN([
        \'%#SlTerm⸮#%{%TermPaused()%} ',
        \'%-f%*%<%=%(%l,%c%V%) ',
        \'%-f%#SlSep⸮#%*%<%= %#SlTerm⸮#%(%l,%c%V%) ',
        \' %{%ScrollHint()%}',
        \])

  let g:mayhem['sl_messages'] = format#CN([
        \'%{%ChWinSz()%}%#SlMessI⸮#􀤏%* %#SlMess⸮#Messages%*',
        \'%=',
        \' %{%ScrollHint()%}',
        \' %#SlMessI⸮# %*'
        \])

  let g:mayhem['sl_scriptnames'] = format#CN([
        \'%#SlMessI⸮#􀤏%* %#SlMess⸮#Scriptnames%*',
        \'%=',
        \' %{%ScrollHint()%}',
        \' %#SlMessI⸮# %*'
        \])

  let g:mayhem['sl_runtime'] = format#CN([
        \'%#SlMessI⸮#􀤏%* %#SlMess⸮#Runtime%*',
        \'%=',
        \' %{%ScrollHint()%}',
        \' %#SlMessI⸮# %*'
        \])

  " Quickfix:
  " ▌︎⃓ █︎⃓
  let qf = '%#SlQfQf⸮#' .. symbols#get('pages.qf') .. '%*'
  let qs = '%#SlQfSep⸮#' .. symbols#get('pages.qfsep') .. '%*'
  let g:mayhem['sl_qfix_ag'] = format#CN([
        \qs .. qf .. qs,
        \' %#SlQf⸮#″️%#SlQfSearch⸮#%{%ChQfSearch()%}%#SlQf⸮#″️%* ',
        \qs,
        \' %#SlQfCt⸮#%{%ChQfCt()%}%#SlQf⸮# result%{%ChQfCtPl()%}',
        \' in %#SlQfCt⸮#%{%ChQfFCt()%}%#SlQf⸮# file%{%ChQfFCtPl()%}%* ',
        \qs,
        \'%=',
        \'%#SlHint⸮#%{%ChQfCommand()%}%* ',
        \' %{%ScrollHint()%}',
        \' %#SlQf⸮# %*'
        \])

  let g:mayhem['sl_qfix'] = format#CN([
        \qs .. qf .. qs,
        \' %#SlQf⸮#"%#SlQfSearch⸮#%{%ChQfTitle()%}%#SlQf⸮#"%* ',
        \qs,
        \'%=',
        \' %{%ScrollHint()%}',
        \' %#SlQf⸮# %*',
        \])

  " Netrw:
  let g:mayhem['sl_dir'] = format#CN([
        \'%#SlDir⸮#􀈕 %-F%*',
        \'%<',
        \'%=',
        \'%#SlDirInv⸮#netrw%*',
        \])

  " let test = '%%%=%<%(%{subExpr}%{%subReExpr%} %)'

  " let g:mayhem['sl_home_todo'] = [
  "       \ '%#SlHomeC#HOME Vim Mayhem%*%<%=%#SlHmRtC#%*',
  "       \ '%#SlHomeN#HOME Vim Mayhem%*%<%=%#SlHmRtN#%*']
  " Home:
  let g:mayhem['sl_home'] = format#CN([
        \'%{%ChWinSz()%}%#SlHomeL⸮#􁘲  Vim Mayhem%*',
        \'%<',
        \'%=',
        \'%#SlHomeM⸮# %*',
        \'%=',
        \'%#SlHomeR⸮# %*'
        \])

  let g:mayhem['sl_sfsym'] = format#CN([
        \'%#SlHomeL⸮#SF Symbols%*',
        \'%<',
        \'%=',
        \])
endfunc

function NC()
  return g:actual_curwin == win_getid() ? 0 : 1
endfunc

" Related: WinColorUpdate in ./wincolor.vim
function CustomStatusline()
  if &buftype == 'help'
    return get(g:, 'mayhem', {})->get('sl_help', ['sl_helpC', 'sl_helpN'])[NC()]
  elseif &buftype == 'quickfix'
    if get(b:, 'mayhem_quickfix_subtype') == 'ag'
      return get(g:, 'mayhem', {})->get('sl_qfix_ag', ['sl_qfix_agC', 'sl_qfix_agN'])[NC()]
    else
      return get(g:, 'mayhem', {})->get('sl_qfix', ['sl_qfixC', 'sl_qfixN'])[NC()]
    endif
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
