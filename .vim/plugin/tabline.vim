if exists("g:mayhem_loaded_tabline")
  finish
endif
let g:mayhem_loaded_tabline = 1

"
" au BufWritePost <buffer> :silent UnsetAndReload
"

"
" See Also: ../autoload/tabline.vim
"             ../plugin/statusline.vim
"

function! GuiTabLabel() abort
  return get(t:, 'mayhem_cache_guitablabel', [])->get(tabpagenr(), '𝘯𝘦𝘸 𝘵𝘢𝘣')
endfunc

set guitablabel=%{%GuiTabLabel()%}

function! GuiTabToolTip() abort
  return get(t:, 'mayhem_cache_guitabtooltip', [])->get(tabpagenr(), '')
endfunc

set guitabtooltip=%.400{%GuiTabToolTip()%}


call autocmd_add([
      \#{
      \ event: ['TabEnter'],
      \ pattern: '*', cmd: 'let g:actual_curtab = tabpagenr()',
      \ group: 'mayhem_tl_curtab', replace: v:true,
      \},
      \#{
      \ event: ['WinEnter','TabNew','TabEnter','TabClosed','WinNew','WinClosed','BufFilePost','BufWinEnter'],
      \ pattern: '*', cmd: 'call tabline#updateCachedBufferName()',
      \ group: 'mayhem_tl_update', replace: v:true,
      \},
      \#{
      \ event: 'User', pattern: 'MayhemDiagnosticsUpdated',
      \ cmd: 'call tabline#updateDiagnostics()',
      \ group: 'mayhem_tl_update', replace: v:true,
      \},
      \])

" return printf("\n%d․  ⦁%d․-⃤    -⃤ %%<%%=%-26.26s%d+\n▄▄̍̍̍̍̍̍̍▄▆̍̍̍̍̍̍̍▄▄ ̊̊̊̊̊̊▄▄ ̈̈̈̈̈̈̈▄▄▄ˈ▄▄|̩̲▄▄ ̥̥̥̥̥̥▄▄", tabpagenr(), bufname(), modified)
" return printf("█   _⃤ _̲⃤ _̳⃤    _⃤ _̅⃤ _̿⃤  ‾⃜⃜⃜⃜⃜⃜⃜⃜⃜⃜⃜  _̲̲̲̲̲̲̲̲⃤ 3̩⃤ 3̩̍⃤ 3̍⃤ 3̩̍⃤ 3 ₂̍̍⃤̍⃤̩̩⃤̩̩⃤ ₂̊̊̊̊̊̊⃤̍̍̍⃤ ₂̍⃤̍⃤̍⃤̍⃤̍⃤⃟  3̍̍̍⃤

"     𝟭ℴ𝒻𝟯 𝟭⁄𝟯 
" _⃯   v̲͎  ‡    ‸ ▪︎ ⚬ _̩̩̩̩̩̩__̻̻̻_̩̻̩̻_̩̩_⃓̶̩̩̩  ˌ̵⃒̩ ˌ̵⃒̩̣   ̵⃒̵̵⃒⃒⃒̣̩̣  ˌ̵⃒̩̩  ˌ̵⃒̩     ̵̩̩    ╷̵̵̵⃒⃒      ̤̤̤̤̤̤̤̤̤    ̬̬̬̬̬̬̬   ̩̩̩̩̩    ̣̣̣̣̣̣̣̣ |̶̲‖ˌˌˌ ˇ̑̑ˆ̴̬̬̬̬̬̬̬‸̣̣̣̣̣̣̣̣˖̩̩̣̣̣̣̩̩⸋̣     %%=\n  %d %-40.40s\n▄ ▇▇▇▇▇▇▇▇▇▇▇▇▇▆▆▆▆▆▆▆▆⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺%%=", tabpagenr(), bufname())
"\printf("%s", ▆▆͘͘͘͘͘͘͘⃤▆▆▆⃤▆̩̩⃤▆▆▆̍̍⃤ 3 3⃤  3̩⃤  3̩̩⃤ 3̩̩⃤ 3⃤  3̍⃤  3̍̍⃤ 3̍̍̍⃤ 3̍̍̍̍⃤ ▆▆▆▆▆▆▆▆▆▆▆ )

