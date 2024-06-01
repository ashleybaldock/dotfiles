" if exists("g:mayhem_loaded_signs")
"   finish
" endif
" let g:mayhem_loaded_signs = 1


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
