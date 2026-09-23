if exists("g:mayhem_loaded_statusline")
  finish
endif
let g:mayhem_loaded_statusline = 1

scriptencoding utf-8

"
" Related:
"   $VIMHOME/autoload/tabline.vim
"   $VIMHOME/autoload/statusline.vim
"   $VIMHOME/autoload/sl.vim
"   $VIMHOME/autoload/symbols.vim
"   $VIMHOME/autoload/format.vim
"   $VIMHOME/after/syntax/vim.statusline.vim
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

function FName() abort
  return expand('%:t:r')
endfunc
function FDotExt() abort
  let ext = expand('%:e')
  return ext == '' ? '' : '.' .. ext
endfunc


function ChDiag() abort
  return sl#getCN(b:, 'sl_cache_diag', ['D?', 'DN'])
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
"   􀃋️⃝􀃍️⃝􀃏️⃝􀃑️⃝􀘚️⃝􀃓️⃝􀃕️⃝􀕈️⃝􀕉️⃝􀕊️⃝􀕋️⃝􀕌️⃝􀕍️⃝􀕎️⃝􀕏️⃝􀕐️⃝􀕑️⃝􀕒️⃝

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
"   􀓶️⃝  􀔕️⃝  􀔴️⃝  􀕓️⃝                         􀛨         
" 􀓷️⃝  􀔖️⃝  􀔵️⃝  􀕔️⃝                           􀺸          
"   􀓸️⃝  􀔗️⃝  􀔶️⃝  􀕕️⃝   􀆉️⃝  􀁲️⃝  􀁳️⃝  􀄂️⃝  􀄃️⃝    􀺶         
" 􀓹️⃝  􀔘️⃝  􀔷️⃝  􀕖️⃝   􀆊️⃝  􀁴️⃝  􀁵️⃝  􀄄️⃝  􀄅️⃝      􀛩           􀸏️⃝ 
"   􀓺️⃝  􀔙️⃝  􀔸️⃝  􀕗️⃝   􀆇️⃝  􀁮️⃝  􀁯️⃝  􀃾️⃝  􀃿️⃝    􀛪         􀡅️⃝ 
" 􀓻️⃝  􀔚️⃝  􀔹️⃝  􀕘️⃝   􀆈️⃝  􀁰️⃝  􀁱️⃝  􀄀️⃝  􀄁️⃝      􀢋           􁇵️⃝ 
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
  return sl#getCN(b:, 'sl_cache_git', ['G?', 'GN'])
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

"
"􃜱a  􃚱y  􃚲g 􃚳⃓ 􃚴  􃞟⃦⃦⃦⃦  􃝦  􃝧   􃜎  􃜏  􃜈x️  􃜉  􃐯  􃀧  􃀩  􂇕   􂷸f
"􃏡️⃝a   􃏞︎⃝    􃎺️⃝     􃏢️⃝    􃇐   􃈃  􃐵   􃑼{️   􃊍)  􃂄️‚ (️,  􃂄̲ 􃂄—
" 􀱢 􀅷 􀅍 􀅎 􀅽️̲ 􀆀 􀆂

let g:mayhem.symbols_S.status = {
      \ 'readonly'     : 'ᴿ',
      \ 'modified'     : '+',
      \ 'nomodifiable' : '􀍼',
      \ 'fencnot8'     : '∪⃞⃥ ',
      \ 'ffnotnix'     : '␌⃞ ',
      \ 'scrollbind'   : '􀒠',
      \ 'diffing'      : '􃜥  ',
      \ 'diffleft'     : '􀐓 ',
      \ 'diffright'    : '􀐔 ',
      \ 'multx'        : '×',
      \ 'termpause'    : '􀊛',
      \ 'termplay'     : '􀩼',
      \ 'termtoggle'   : '􀊇',
      \ 'help'         : '􀉚',
      \ 'prev'         : '􀬸',
      \ 'cmdwin'       : '􀱢',
      \ 'cmdwinsearch' : '􀅍/',
      \ 'cmdwinother'  : '􀩼',
      \ }
let g:mayhem.symbols_8.status = {
      \ 'readonly'     : 'ᴿ',
      \ 'modified'     : '+',
      \ 'nomodifiable' : ' ⃠',
      \ 'fencnot8'     : '∪⃞⃥ ',
      \ 'ffnotnix'     : '␌⃞ ',
      \ 'scrollbind'   : '⚯',
      \ 'diffing'      : 'DIFF',
      \ 'diffleft'     : '𐰶DI',
      \ 'diffright'    : 'FF𐰷',
      \ 'multx'        : '×',
      \ 'termpause'    : '⏸⃞',
      \ 'termplay'     : '>⃞ ',
      \ 'termtoggle'   : '⏯︎',
      \ 'help'         : '𝓲⃝',
      \ 'prev'         : 'ᴘ⃞',
      \ 'cmdwinsearch' : 'cmd(search)',
      \ 'cmdwinother'  : 'cmd',
      \ }
let g:mayhem.symbols_A.status = {
      \ 'readonly'     : 'R',
      \ 'modified'     : '+',
      \ 'nomodifiable' : 'x',
      \ 'fencnot8'     : '!8',
      \ 'ffnotnix'     : '!F',
      \ 'scrollbind'   : 's',
      \ 'diffing'      : 'DIFF',
      \ 'diffleft'     : '<DI',
      \ 'diffright'    : 'FF>',
      \ 'multx'        : 'x',
      \ 'termpause'    : '>',
      \ 'termplay'     : '>',
      \ 'termtoggle'   : 't',
      \ 'help'         : 'help',
      \ 'prev'         : 'preview',
      \ 'cmdwinsearch' : 'cmd(search)',
      \ 'cmdwinother'  : 'cmd',
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

function DiffWith() abort
  return getbufvar(bufnr(), 'mayhem_diff_with', '')
endfunc
"
" : > / ? @ - =
"
function CmdWinType() abort
  return getcmdtype() =~# '[/?]' ?  symbols#get('status.cmdwinsearch') : symbols#get('status.cmdwinother')
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

" Get cached search count
function ChSearch() abort
  return v:hlsearch ? sl#getCN(b:, 'sl_cache_search', ['', '']) : ''
endfunc

" Get cached filename
function ChFName() abort
  return sl#getCN(b:, 'sl_cached_filename', [expand('%'),expand('%')])
endfunc

" Get cached file info
function ChFInfo() abort
  return sl#getCN(b:, 'sl_cached_fileinfo', ['', ''])
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
  return sl#getCN(b:, 'sl_cached_winsize', ['', ''])
endfunc

function MessTime() abort
  return format#timeSince(get(b:, 'mayhem_messages_lastupdated', 0))
endfunc

function s:Update_FileInfo() abort
  call s:SetStatusVars()
  let ext = expand('%:e')
  let name = expand('%:r')
  let tail = expand('%:t')
  let type = getbufvar(bufnr(), '&filetype')
  let hint = mayhem#getHintForPath('%')
  let subtype = mayhem#getSubtypeForPath('%')

  if name == ''
      " \'%#SlFNoName⸮#nameless%* ',
      " \ 𝓷𝓪𝓶𝓮𝓵𝓮𝓼𝓼 𝒏𝒂𝒎𝒆𝒍𝒆𝒔𝒔 𝑛𝑎𝑚𝑒𝑙𝑒𝑠𝑠
        " \𝐧𝐚𝐦𝐞𝐥𝐞𝐬𝐬 𝔫𝔞𝔪𝔢𝔩𝔢𝔰𝔰 𝖓𝖆𝖒𝖊𝖑𝖊𝖘𝖘 𝘯𝘢𝘮𝘦𝘭𝘦𝘴𝘴 𝚗𝚊𝚖𝚎𝚕𝚎𝚜𝚜
    let b:mayhem.sl_cached_filename = format#CN([
      \'%#SlFNoName⸮#𝑛𝑎𝑚𝑒𝑙𝑒𝑠𝑠%* ',
      \'%{%Modified()%}'
      \])
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

function s:UpdateStatuslines() abort
  call s:SetStatusVars()
  call s:Update_FileInfo()
  call s:Update_Git()
  call s:Update_Diag()
  call statusline#updateSearch()
  call s:Update_WinSize()

"     Size:  left╺╮  ╭╸zeros
"               %{-}{0}{minwid}.{maxwid}
"    Truncate:  %< ║ %-f %< %f ┃ abcdefghi.vim < efghi.vim ┃
" Equal Space:    %= ║ L%=Mid%=R ┃ L          Mid          R ┃


  let eq = get(g:, 'mayhem_debug_sl_eq', v:false)
        \ ? '%#SlSep⸮#❮%=❮%*' : '%#SlSep⸮#%=%*'

  let g:mayhem['sl_norm'] = format#CN([
        \'%{%ChWinSz()%}',
        \'%{%ChGit()%}',
        \' %{%ChFName()%} ',
        \'%<',
        \eq,
        \' %{%ChSearch()%}',
        \eq,
        \'%( %#SlFlag⸮#%{%CheckUtf8()%}%{%CheckFF()%}%*%)',
        \'%( %#SlHint⸮#%{%Conceal()%}%{%CheckScb()%}%*%)',
        \' %{%ChFInfo()%}',
        \' %{%ScrollHint()%}',
        \' %{%ChDiag()%}',
        \])

  let g:mayhem['sl_diff_left'] = format#CN([
        \symbols#get('status.diffing'),
        \' %{%ChFName()%} ',
        \'%<',
        \eq,
        \' %{%ChSearch()%}',
        \eq,
        \symbols#get('status.diffleft'),
        \])
  let g:mayhem['sl_diff_right'] = format#CN([
        \symbols#get('status.diffright'),
        \eq,
        \'%#SlFDfSvNm⸮#◀︎╸diff,with:%{%DiffWith()%}%* ',
        \' %{%ChFInfo()%}',
        \' %{%ScrollHint()%}',
        \' %{%ChDiag()%}',
        \])

  let g:mayhem['sl_prev'] = format#CN([
        \'%#SlInfo⸮#',
        \symbols#get('status.prev'),
        \' %-f%*',
        \'%<',
        \eq,
        \'%(%n %l,%c%V%) ',
        \])

  let g:mayhem['sl_help'] = format#CN([
        \'%#SlInfo⸮#',
        \symbols#get('status.help'),
        \' %{%FName()%}',
        \'%#SlHint⸮#%{%FDotExt()%}',
        \eq,
        \'%<',
        \eq,
        \' %-10.30(%{%ChSearch()%}%)',
        \eq,
        \'%(',
        \'%#SlHint⸮# help ',
        \'%#SlFPath⸮#[%#SlInfo⸮#%l%#SlFPath⸮#/%#SlInfo⸮#%L%#SlFPath⸮#]',
        \'%)',
        \])

  let g:mayhem['sl_term'] = format#CN([
        \'%#SlTerm⸮#%{%TermPaused()%} %-f%*',
        \'%<',
        \eq,
        \' %#SlTerm⸮#%(%l,%c%V%)%* ',
        \' %{%ScrollHint()%}',
        \])

  let g:mayhem['sl_cmdwin'] = format#CN([
        \'%#SlTerm⸮#%{%TermPaused()%} %-f%*',
        \'%<',
        \eq,
        \' %#SlTerm⸮#%(%l,%c%V%)%* ',
        \' %{%ScrollHint()%}',
        \])

  let g:mayhem['sl_messages'] = format#CN([
        \'%{%ChWinSz()%}%#SlMessI⸮#􀤏%* %#SlMess⸮#Messages%*',
        \eq,
        \'%#SlHint⸮#updated: %{%MessTime()%} ago%* ',
        \' %{%ScrollHint()%}',
        \' %#SlMessI⸮# %*'
        \])

  let g:mayhem['sl_scriptnames'] = format#CN([
        \'%#SlMessI⸮#􀤏%* %#SlMess⸮#Scriptnames%*',
        \eq,
        \' %{%ScrollHint()%}',
        \' %#SlMessI⸮# %*'
        \])

  let g:mayhem['sl_runtime'] = format#CN([
        \'%#SlMessI⸮#􀤏%* %#SlMess⸮#Runtime%*',
        \eq,
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
        \eq,
        \'%#SlHint⸮#%{%ChQfCommand()%}%*',
        \' %{%ScrollHint()%} ',
        \'%#SlQf⸮# %*'
        \])

  let g:mayhem['sl_qfix'] = format#CN([
        \qs .. qf .. qs,
        \' %#SlQf⸮#"%#SlQfSearch⸮#%{%ChQfTitle()%}%#SlQf⸮#"%* ',
        \qs,
        \eq,
        \' %{%ScrollHint()%}',
        \' %#SlQf⸮# %*',
        \])

  " Netrw:
  let g:mayhem['sl_dir'] = format#CN([
        \'%#SlDir⸮#􀈕 %-F%*',
        \'%<',
        \eq,
        \'%#SlDirInv⸮#netrw%*',
        \])

  " let test = '%%%=%<%(%{subExpr}%{%subReExpr%} %)'

  " let g:mayhem['sl_home_todo'] = [
  "       \ '%#SlHomeC#HOME Vim Mayhem%*%<%=%#SlHmRtC#%*',
  "       \ '%#SlHomeN#HOME Vim Mayhem%*%<%=%#SlHmRtN#%*']
  " Home:
  let g:mayhem['sl_home'] = format#CN([
        \'%{%ChWinSz()%}%#SlHomeL⸮#􁘲  Vim Mayhem%*',
        \eq,
        \'%<',
        \' %{%ChSearch()%}',
        \eq,
        \'%#SlHomeM⸮#%*',
        \eq,
        \'%#SlHomeR⸮#%*'
        \])

  let g:mayhem['sl_sfsym'] = format#CN([
        \'%#SlHomeL⸮#SF Symbols%*',
        \'%<',
        \eq,
        \])
endfunc

"
" Related: WinColorUpdate in ./wincolor.vim
"
function CustomStatusline() abort
  if &buftype == 'help'
    return sl#getCN(g:, 'sl_help')
  elseif &buftype == 'quickfix'
    if get(b:, 'mayhem_quickfix_subtype') == 'ag'
      return sl#getCN(g:, 'sl_qfix_ag')
    else
      return sl#getCN(g:, 'sl_qfix')
    endif
  elseif &buftype == 'preview'
    return sl#getCN(g:, 'sl_prev')
  elseif &buftype == 'terminal'
    return sl#getCN(g:, 'sl_term')
  endif

  if &diff
    if get(b:, 'mayhem_diff_left', v:false)
      return sl#getCN(g:, 'sl_diff_left')
    elseif get(b:, 'mayhem_diff_right', v:false)
      return sl#getCN(g:, 'sl_diff_right')
    else
      return sl#getCN(g:, 'sl_diff')
    endif
  endif

  if get(b:, 'mayhem_cmdwin', v:false)
    return sl#getCN(g:, 'sl_cmdwin')
  endif

  if &ft == 'netrw'
      return sl#getCN(g:, 'sl_dir')
  elseif &ft == 'vimmessages'
    return sl#getCN(g:, 'sl_messages')
  elseif &ft == 'vimscriptnames'
    return sl#getCN(g:, 'sl_scriptnames')
  elseif &ft == 'vimruntime'
    return sl#getCN(g:, 'sl_runtime')
  elseif &ft == 'mayhemhome'
    return sl#getCN(g:, 'sl_home')
  endif

  return sl#getCN(g:, 'sl_norm')
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
      \ event: ['CursorHold','BufWinEnter','BufFilePost','EncodingChanged','DiffUpdated'],
      \ pattern: '*', cmd: 'call s:UpdateStatuslines()',
      \ group: 'mayhem_statusline', replace: v:true,
      \},
      \#{
      \ event: 'User', pattern: 'MayhemDiagnosticsUpdated',
      \ cmd: 'call s:Update_Diag()',
      \ group: 'mayhem_statusline_diagnostics', replace: v:true,
      \},
      \#{
      \ event: 'User', pattern: 'MayhemSearchCountUpdated',
      \ cmd: 'call statusline#updateSearch()',
      \ group: 'mayhem_statusline_search', replace: v:true,
      \},
      \])

" autocmd BufEnter    <buffer> match ExtraWhitespace /\s\+$/
" autocmd InsertEnter <buffer> match ExtraWhitespace /\s\+\%#\@<!$/
" autocmd InsertLeave <buffer> match ExtraWhitespace /\s\+$/

command! UpdateCustomStatusline call <SID>UpdateStatuslines()

set statusline=%{%CustomStatusline()%}

UpdateCustomStatusline

" vim:signcolumn=auto:foldcolumn=1:foldmethod=marker:nolist:nowrap
