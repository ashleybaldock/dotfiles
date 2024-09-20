if exists("g:mayhem_loaded_signs")
  finish
endif
let g:mayhem_loaded_signs = 1


let s:prefix = 'sign_of_mayhem_'
let s:group = 'signs_of_mayhem'

"     \ {'name': '',
"     \ 'text': '⌁',
"     \ 'texthl': '',
"     \ 'culhl': '',
"     \ 'linehl': ''},
let s:gitsigns = [
      \ {'sign': '+', 'hlt': 'SignGitAdd', 'hll': 'DiffAdd'   , 'name': 'git_add',           },
      \ {'sign': '𐰇', 'hlt': 'SignGitChg', 'hll': 'DiffChange', 'name': 'git_mod',           },
      \ {'sign': '◇', 'hlt': 'SignGitDel', 'hll': 'DiffDelete', 'name': 'git_del',           },
      \ {'sign': '◇̅', 'hlt': 'SignGitDel', 'hll': 'DiffDelete', 'name': 'git_del_first',     },
      \ {'sign': '◇̲̅', 'hlt': 'SignGitDel', 'hll': 'DiffDelete', 'name': 'git_del_abovebelow',},
      \ {'sign': '◇̲', 'hlt': 'SignGitCgD', 'hll': 'DiffDelete', 'name': 'git_del_mod',       },
      \]
let s:diagsigns = [
      \ {'sign': '✘', 'hlt': 'SignDgErr',  'hll': 'LineDgErr',  'name': 'diag_error',        },
      \ {'sign': '‼︎', 'hlt': 'SignDgWarn', 'hll': 'LineDgWarn', 'name': 'diag_warning',      },
      \ {'sign': '𝓲', 'hlt': 'SignDgInfo', 'hll': 'LineDgInfo', 'name': 'diag_info',         },
      \ {'sign': '⌁', 'hlt': 'SignDgHint', 'hll': 'LineDgHint', 'name': 'diag_hint',         },
      \]

function! s:PlaceSign()
  "  numhl  texthl     linehl (or culhl if cursor on line)
  "  ╭─↓─╮ | ╭↓╮ | ╭────────────────↓─────────────────────────╮                  
  "   123  |  ⚑  |  A Line of the sig̲ns
  "  ╰───╯   ╰↑╯   ╰──────────────────────────────────────────╯
  "     sign/text     hlt: texthl; hll: linehl; hlc: curhl;
  "
  " ✘+
  "
  let aSign = sign_define(s:prefix..'testsign', { 
        \ 'text': '✘+',
        \ 'linehl': '', 
        \ 'numhl': '', 
        \ 'texthl': '',
        \ 'culhl': '',
        \})
  let signid = sign_place(0, s:group, s:prefix..'testsign', bufnr(), { 'lnum': 20 }) 
  return signid
endfunc

command! TestSign echo <SID>PlaceSign()


function! s:CodeBlockBackground()
  let aSign = sign_define(s:prefix..'testsign', { 
        \ 'text': ' }',
        \ 'linehl': 'markdownHighlight_sh', 
        \ 'numhl': '', 
        \ 'texthl': '',
        \ 'culhl': '',
        \})
  let signid = sign_place(0, s:group, s:prefix..'codeblockbackground', bufnr(), { 'lnum': 20 }) 
  return signid
endfunc

command! CodeLine echo <SID>CodeBlockLine()


" TODO place signs showing if there are more above/below current window
" position

















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
