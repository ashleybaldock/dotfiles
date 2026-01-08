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

let g:mayhem_abbrpaths = [
      \ ":p:s?"..$VIMRUNTIME.."\/syntax?$𝘝𝘙∕𝘴⋮?",
      \ ":s?"..$VIMRUNTIME.."\/?$𝘝𝘙⋮?",
      \ ":~",
      \ ":s?\\~\/dotfiles\/\.vim\/after\/ftplugin?𝙫∕𝙖/𝙛⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/after\/plugin?𝙫∕𝙖/𝙥⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/after\/syntax?𝙫∕𝙖/𝙨⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/autoload?𝙫∕𝙖𝙪⋮?",
      \ ":s?\\~\/dotfiles\/\.vim\/colors?𝙫∕𝙘𝙡∕?",
      \ ":s?\\~\/dotfiles\/\.vim\/ftplugin?𝙫∕𝙛∕?",
      \ ":s?\\~\/dotfiles\/\.vim\/plugin?𝙫∕𝙥∕?",
      \ ":s?\\~\/dotfiles\/\.vim\/syntax?𝙫∕𝙨∕?",
      \ ":s?\\~\/dotfiles\/\.vim\/templates?𝙫∕𝙩𝙥𝙡∕?",
      \ ":s?\\~\/dotfiles\/\.vim\/notes?𝙫∕𝙣𝙤𝙩𝙚𝙨∕?",
      \ ":s?\\~\/dotfiles\/\.vim?𝙫⋮?",
      \ ":s?\\~\/projects\/noita-wand-simulator\/src\/app\/components\/?𝓦∕𝓈⸍𝒶⁝𝒸?",
      \ ":s?\\~\/projects\/noita-wand-simulator\/src\/app\/?𝓦⋮𝓈𐑢𝒶⋮?",
      \ ":s?\\~\/projects\/noita-wand-simulator\/src\/?𝓦⋮𝘴ⳇ?",
      \ ":s?\\~\/projects\/noita-wand-simulator\/?𝓦⋮?",
      \ ":s?\\~\/projects?𝑷⋮?",
      \]->join('')

function! GuiTabLabelErrors() abort
  return get(t:, 'mayhem_tl_cached_diag_label', '')
endfunc

function! GuiTabLabelName() abort
  return get(b:, 'mayhem_tl_cached_filename', '𝘯𝘦𝘸 𝘵𝘢𝘣')
endfunc

function! GuiTabLabel() abort
  return get(t:, 'mayhem_cache_guitablabel', '! %{%GuiTabLabelName()%}')
endfunc

set guitablabel=%{%GuiTabLabel()%}

function! GuiTabToolTipErrors() abort
  return get(t:, 'mayhem_tl_cached_diag_tip', '')
endfunc

function! GuiTabToolTip() abort
  return get(t:, 'mayhem_cache_guitabtooltip', '')
endfunc

set guitabtooltip=%.400{%GuiTabToolTip()%}


call autocmd_add([
      \#{
      \ event: ['TabEnter'],
      \ pattern: '*', cmd: 'let g:actual_curtab = tabpagenr()',
      \ group: 'mayhem_tl_curtab', replace: v:true,
      \},
      \#{
      \ event: ['BufEnter','BufNew','BufFilePost','BufWinEnter'],
      \ pattern: '*', cmd: 'call tabline#updateCachedBufferName()',
      \ group: 'mayhem_tl_update', replace: v:true,
      \},
      \#{
      \ event: ['WinEnter','TabNew','TabEnter','TabClosed','WinNew','WinClosed','BufFilePost','BufWinEnter'],
      \ pattern: '*', cmd: 'call tabline#gen_guitab_caches()',
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

