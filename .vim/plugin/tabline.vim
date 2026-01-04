if exists("g:mayhem_loaded_tabline")
  finish
endif
let g:mayhem_loaded_tabline = 1

"
" au BufWritePost <buffer> :silent UnsetAndReload
"

function! GuiTabLabel() abort
  let bufname = get(b:, 'mayhem_tl_cached_filename', tabline#bufname())
  let modified = tabpagebuflist(v:lnum)
        \->reduce({acc, bufnr -> acc + getbufvar(bufnr, "&modified", 0)}, 0)

  let current = get(g:, 'actual_curtab', 0) == tabpagenr()

  let diagnostics = get(t:, 'mayhem_tl_cached_diagnostics', #{off:1})
  if get(diagnostics, 'off', 0)
    let reportErrors = symbols#get('diag.inline.off')
  else
    let errors = diagnostics->get('error', 0)
    let reportErrors = errors > 0 ? printf("%s%s", symbols#get('diag.inline.error'), errors) : ""
  endif

  return [
      \printf(" %s", modified ? " ̵̩̩" : " "),
      \printf("%s %-32.32s", reportErrors , bufname),
      \printf("%s", current ? "█▇▆▆▆▆▆▆▆▆▆▆▆▆▆" : "▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅")
      \]->join("\n")
endfunction
       " \ ? '▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆ '

set guitablabel=%{%GuiTabLabel()%}


function! GuiTabToolTip() abort
  let diagnostics = get(t:, 'mayhem_tl_cached_diagnostics', {})
  let warnings = get(diagnostics, 'warning', 0)
  let errors = get(diagnostics, 'error', 0)

  return [
        \printf("%s ℴ𝒻 %s%%= %s%s",
        \ format#numbers(tabpagenr('$')->string(), 'sans'),
        \ format#numbers(tabpagenr()->string(), 'sans'),
        \ errors > 0 ? printf("%s%s", symbols#get('diag.inline.error'), errors) : "",
        \ warnings > 0 ? printf("%s%s", symbols#get('diag.inline.warning'), warnings) : ""
        \),
        \printf("%d window%s:",
        \ tabpagewinnr(v:lnum, '$'),
        \ tabpagewinnr(v:lnum, '$') > 1 ? 's' : ''
        \),
        \printf("%s%%<",
        \ tabpagebuflist(tabpagenr())->map({i, bufnr -> getbufvar(bufnr, 'mayhem_tl_cached_filename')})->join("\n")
        \),
        \]->join("\n")
endfunction

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

