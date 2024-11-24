if exists("g:mayhem_loaded_signs")
  finish
endif
let g:mayhem_loaded_signs = 1


let s:prefix = 'mayhem_'
let s:group = 'signs_of_mayhem'

let g:mayhem = get(g:, 'mayhem', {})
let g:mayhem.sl = get(g:mayhem, 'sl', {})

let g:mayhem.signs = get(g:mayhem, 'signs', {})

"            \ {
"            \  'n[ame]':     'mysign',
"          ⎧ \  's[igntext]': '⌖⃝ ',
"          ⎪ \  't[exthl]':   'SignTextHlGroup',
" optional ⎨ \  'l[inehl]':   'LineHlGroup',
"          ⎪ \  'c[ulhl]':    'CurrentLineHlGroup',
"          ⎩ \  'n[umhl]':    'NumberColumnHlGroup'
"            \ },
let g:mayhem.signs.git = [
      \ { 'n': 'add',         's': '+', 't': 'SignGitAdd', 'l': 'DiffAdd'   ,  },
      \ { 'n': 'mod',         's': '𐰇', 't': 'SignGitChg', 'l': 'DiffChange',  },
      \ { 'n': 'del',         's': '◇', 't': 'SignGitDel', 'l': 'DiffDelete',  },
      \ { 'n': 'd_first',     's': '◇̅', 't': 'SignGitDel', 'l': 'DiffDelete',},
      \ { 'n': 'd_abovebelow','s': '◇̲̅', 't': 'SignGitDel', 'l': 'DiffDelete',},
      \ { 'n': 'd_mod',       's': '◇̲', 't': 'SignGitCgD', 'l': 'DiffDelete',},
      \]
let s:diagsigns = [
      \ {'sign': '✘', 'hlt': 'SignDgErr',  'hll': 'LineDgErr',  'name': 'diag_error',        },
      \ {'sign': '‼︎', 'hlt': 'SignDgWarn', 'hll': 'LineDgWarn', 'name': 'diag_warning',      },
      \ {'sign': '𝓲', 'hlt': 'SignDgInfo', 'hll': 'LineDgInfo', 'name': 'diag_info',         },
      \ {'sign': '⌁', 'hlt': 'SignDgHint', 'hll': 'LineDgHint', 'name': 'diag_hint',         },
      \]

" ┃ ╭╴texthl
" ┃ │  ╭╴numhl   ╭╴linehl (or culhl if cursor on line)
" ╭─∇┬─∇─┬───────∇────────────────────────────────────────╮   
" ╻ ⚑ 123 A Line of the sig̲ns
" ┃  ╵   ╵
" ┃  ╵   ╵
" ┃  ╵   ╵
" ┃  ╵   ╵
" ┃  ╵991╵
" ┃  ╵992╵
" ┃  ╵   ╵
" ┃􀰫1123  A Line of the sig̲ns
" ┃1234567      sign/text  hlt: texthl; hll: linehl; hlc: curhl;
" ┃􀅃
" ┃􀑂
" ┃􀬚
" ┃􀓜
" ┃  
" ┃􀌼
" ┃􀌸
" ┃􀌨


"
" -----------------------------------   Signs   -----------
"
function! s:PlaceSign()
  let aSign = sign_define(s:prefix..'testsign', { 
        \ 'text': '✘+',
        \ 'linehl': 'TestHint5', 
        \ 'numhl': '', 
        \ 'texthl': '',
        \ 'culhl': '',
        \})
  let signid = sign_place(0, s:group, s:prefix..'testsign', bufnr(), { 'lnum': line('.') }) 
  return signid
endfunc

command! TestSign echo <SID>PlaceSign()

"
" Place:
"
function s:PlaceSign(name)
  " Look up sign name
endfunc

" 
"┏ {…}  javascript
"┃
"┃ let a = () => 'hello world' 
"┃ console.log(a())            
"╹────────────────────────────────
function! CodeBlockBackground()
  let multisign = { 's':' ⎛', 'm':' ⎢', 'e':' ⎝', 't': '' }
  let aSign = sign_define(s:prefix..'codeblockstart', { 
        \ 'text': ' ╭',
        \ 'linehl': 'markdownHighlight_sh', 
        \ 'culhl': 'markdownHighlight_sh',
        \})
  let aSign = sign_define(s:prefix..'codeblockmid', { 
        \ 'text': ' │',
        \ 'linehl': 'markdownHighlight_sh', 
        \})
  let aSign = sign_define(s:prefix..'codeblockend', { 
        \ 'text': ' ╰',
        \ 'linehl': 'markdownHighlight_sh', 
        \})
  let signid1 = sign_place(0, s:group, s:prefix..'codeblockstart', bufnr(), { 'lnum': line('.') }) 
  let signid2 = sign_place(0, s:group, s:prefix..'codeblockmid', bufnr(), { 'lnum': line('.') + 1 }) 
  let signid3 = sign_place(0, s:group, s:prefix..'codeblockmid', bufnr(), { 'lnum': line('.') + 2 }) 
  let signid4 = sign_place(0, s:group, s:prefix..'codeblockend', bufnr(), { 'lnum': line('.') + 3 }) 
  return signid1
endfunc

command! CodeLine echo <SID>CodeBlockLine()


" TODO place signs showing if there are more above/below current window
" position

"
" group:
"  '*' = all groups
"  ''  = global group only  
"
function! s:ListSignsInCurrentBuffer()
  return sign_getplaced(bufnr(), { 'group': '*'})
endfunc
function! s:ListSignsOfMayhemInCurrentBuffer()
  return sign_getplaced(bufnr(), { 'group': s:group })
endfunc

function! s:ListSignsInCurrentLine()
  return sign_getplaced(bufnr(), { 'lnum': line('.'), 'group': '*'})
endfunc
function! s:ListSignsOfMayhemInCurrentLine()
  return sign_getplaced(bufnr(), { 'lnum': line('.'), 'group': s:group })
endfunc

command! AllSignsInThisLine echo <SID>ListSignsInCurrentLine()
command! AllSignsInThisBuffer echo <SID>ListSignsInCurrentBuffer()
command! OurSignsInThisLine echo <SID>ListSignsOfMayhemInCurrentLine()
command! OurSignsInThisBuffer echo <SID>ListSignsOfMayhemInCurrentBuffer()

"
" ----------------------------------- TextProps -----------
"
"  prop_type_add(name, props)
"  prop_type_change(name, props)
" bufnr      : buffer local
" highlight  : hlgroup
" priority   : highest wins, def. 0
" combine    : with syntax, def true
" override   : anything else
" start_incl : inserts @ start included
" end_incl   : inserts @ end included
"
"  prop_type_delete(name, [props])
"  prop_type_get(name, [props])
"  prop_type_list(props)
"
" prop_add(lnum, col, props)
" prop_add_list(props, [item, ...])
"
" prop_clear(lnum [, lnum-end [, bufnr]])
" prop_find(props [, direction])
" prop_list(lnum [, props])
" prop_remove(props [, lnum [, lnum-end]])
"

function! AddTestTextPropType()
  return prop_type_add(s:prefix .. '', {
        \ 'bufnr': bufnr(),
        \ 'highlight': 'TestHint5',
        \ 'priority': 4,
        \ 'combine': 1,
        \ 'override': 0,
        \ 'start_incl': 1,
        \ 'end_incl': 1 
        \ })
endfunc

function! s:ListTextPropsInCurrentBuffer()
  return prop_list(1, {
        \ 'bufnr': bufnr(),
        \ 'end_lnum': -1,
        \ })
endfunc

function! s:ListTextPropsInCurrentLine()
  return prop_list(line('.'), {
        \ 'bufnr': bufnr(),
        \ 'end_lnum': line('.'),
        \ })
endfunc

function! s:ListTextsOfMayhemInCurrentBuffer()
  return prop_list(1, {
        \ 'bufnr': bufnr(),
        \ 'end_lnum': -1,
        \ 'types': [],
        \ 'ids': [] 
        \ })
endfunc
function! s:ListTextsOfMayhemInCurrentLine()
  return prop_list(line('.'), {
        \ 'bufnr': bufnr(),
        \ 'end_lnum': line('.'),
        \ 'types': [],
        \ 'ids': [] 
        \ })
endfunc

command! AllTextPropsInThisLine echo <SID>ListTextPropsInCurrentLine()
command! AllTextPropsInThisBuffer echo <SID>ListTextPropsInCurrentBuffer()
command! OurTextPropsInThisLine echo <SID>ListTextsOfMayhemInCurrentLine()
command! OurTextPropsInThisBuffer echo <SID>ListTextsOfMayhemInCurrentBuffer()






" let matchid = matchadd(hlgroup, pattern, priority, id, {conceal = 'X', window = N}]]])
" call matchdelete(matchid)
" priority default 10
" id, positive int, -1 = choose automatically
"
" Save Restore:
" echo getmatches()     ⮕  [{},{},...]
" let matches = getmatches()
" call clearmatches()
" echo getmatches()    ⮕  []
" setmatches(matches)
" echo getmatches()     ⮕  [{},{},...]





"  +⎫
"  +⎪
"  ‼
"  ‼︎
"  +⎪
"  𐰇⎫
"  𐰇⎪
"  𐰇⎪
"  𐰇⎭
"  +⎪
"   ✘
"   ✘
"  +⎭

" echo prop_type_add('test1', {'bufnr': bufnr(), 'highlight': 'TestHint1', 'priority': 1, 'combine': 0, 'override': 0 }

" call prop_type_list({ bufnr })
" call prop_type_[get/delete](name, { bufnr })
" call prop_type_[add/change](name, {
"   \ bufnr
"   \ highlight  (group name)
"   \ priority   (larger = higher priority, default 0)
"   \ combine    (false = ignore/overwrite syntax)
"   \ override   (true = override any other highlight)
"   \ start_incl (true = inserts at start/end
"   \ end_incl           position are included)
" \})

" (end_col == col && lnum == end_lnum): zero-width prop
" call prop_add(lnum, col, {
" \ id  (auto, or supply specific number)
" \ bufnr
" \ type   (same as use for prop_type_add)
" \ length  (same-line only)(length of prop in byes)
" \ end_lnum (line nr for end of prop, inclusive)
" \ end_col (column just after end of prop)

" \ text (to display before col, 
"          row above/below if col == 0)
"  \ text_align, (text && col==0) where to display:
"  " after (eol), right (aligned in window, 1 per line)
"  " below (next screen line), above (line before)
" \ text_padding_left (text && col==0) 
" \ text_wrap (wrap or truncate)
" \}


" prop_add({lnum}, {col}, {props})
" prop_add_list({props}, [{item}, ...])

" prop_find({props} [, {direction}])
" prop_list({lnum} [, {props}])
" prop_clear({lnum} [, {lnum-end} [, {bufnr}]])
" prop_remove({props} [, {lnum} [, {lnum-end}]])


function! s:GroupByFile(acc, val)
  if ( has_key(a:acc, a:val['file']) ) 
    call add(a:acc[a:val['file']], a:val)
  else
    let a:acc[a:val['file']] = [ a:val ]
  endif
  return a:acc
endfunc

" TODO caching
" TODO async
function! s:FetchDiagnostics(fresh = 0)
  return reduce(CocAction('diagnosticList'), {acc, cur -> s:GroupByFile(acc, cur)}, {})
endfunc


function! s:DiagnosticSummary()
  let l:above = { 'error': 0, 'warning': 0, 'hint': 0, 'info': 0 }
  let l:below = { 'error': 0, 'warning': 0, 'hint': 0, 'info': 0 }
endfunc


function! s:DebugDiagnostics()
  let grouped = s:FetchDiagnostics(1)
  vsp
  enew
  call append('$', FormatJSON(json_encode(grouped)))
  setlocal filetype=json
  setlocal nomodifiable nomodified 
endfunc

command! -bar DebugDiagnostics call <SID>DebugDiagnostics()
