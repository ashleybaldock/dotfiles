if exists("g:mayhem_loaded_diag")
  finish
endif
let g:mayhem_loaded_diag = 1

"
" Related:
"      ../autoload/diag.vim
"                ./signs.vim
"      ../autoload/signs.vim
"

command! -bar DebugDiagnostics call diag#debugSplit()

call autocmd_add([
      \#{
      \ event: 'User',
      \ pattern: 'MayhemDiagnosticsNeedUpdate',
      \ cmd: 'call diag#fetch()',
      \ group: 'mayhem_diag', replace: v:true,
      \},
      \])

