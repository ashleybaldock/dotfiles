if exists("g:mayhem_autoloaded_tabline") || &cp
  finish
endif
let g:mayhem_autoloaded_tabline = 1

"
" See Also: ../plugin/tabline.vim
"           ../plugin/statusline.vim
"

"█▇▆▅▆▇█▅█▅▇▆▇▆
let s:underline_0 = "▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅"
let s:underline_1 = "▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆"
let s:underline_2 = "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇"
let s:underline_3 = "███████████████"
let g:mayhem_tab_underline = s:underline_0
let g:mayhem_curtab_underline = s:underline_1

function! tabline#modstatus(bufnr = bufnr()) abort
  return getbufvar(a:bufnr, "&modified")
        \  ? getbufvar(a:bufnr, "&modifiable")
        \    : '+'
        \    ? '-'
        \  : ''
endfunc

function! tabline#bufname(bufnr = bufnr()) abort
  let bufname = bufname(a:bufnr)
  if empty(bufname)
    let bufname = "𝑢𝑛𝑛𝑎𝑚𝑒𝑑"
  else
    let bufname = fnamemodify(bufname, get(g:, 'mayhem_abbrpaths', ''))
  endif
  return printf(g:mayhem_tl_name_tpl, bufname, tabline#modstatus(a:bufnr))
endfunc

function! tabline#updateCachedBufferName(bufnr = bufnr()) abort
  call setbufvar(a:bufnr, 'mayhem_tl_cached_filename',
        \ tabline#bufname(a:bufnr))
endfunc

function! tabline#updateDiagnostics() abort
  for i in range(tabpagenr('$'))
    let warningCount = 0
    let errorCount = 0

    if exists('g:did_coc_loaded')
      for bufnr in tabpagebuflist(i)
        let diaginfo = getbufvar(bufnr, 'coc_diagnostic_info', {})
        let warningCount += get(diaginfo, 'warning', 0)
        let errorCount += get(diaginfo, 'error', 0)
      endfor
      call settabvar(i, 'mayhem_tl_cached_diagnostics', #{
          \ error: errorCount,
          \ warning: warningCount,
          \})
      call settabvar(i, 'mayhem_tl_cached_diag_label',
            \ errorCount > 0 ? printf("%s%s ",
            \ errorCount,
            \ symbols#inline('diag.error')
            \) : "")
      call settabvar(i, 'mayhem_tl_cached_diag_tip', printf("%s%s",
        \ errorCount > 0 ? printf("%s%s",
        \   symbols#inline('diag.error'), errorCount) : "",
        \ warningCount > 0 ? printf("%s%s",
        \   symbols#inline('diag.warning'), warningCount) : ""))
    else
      call settabvar(i, 'mayhem_tl_cached_diagnostics', #{
          \ off: v:true,
          \})
      call settabvar(i, 'mayhem_tl_cached_diag_label',
            \ symbols#inline('diag.off'))
      call settabvar(i, 'mayhem_tl_cached_diag_tip',
            \ symbols#inline('diag.off'))
    endif

  endfor
endfunc

function! tabline#gen_guitablabel_cache() abort
  let tabul = get(g:, 'mayhem_tab_underline', '')
  let curul = get(g:, 'mayhem_curtab_underline', '')
  for i in range(tabpagenr('$'))
    let bufname = get(b:, 'mayhem_tl_cached_filename', tabline#bufname())

    let modified = tabpagebuflist(i)
        \->reduce({acc, bufnr -> acc + getbufvar(bufnr, "&modified", 0)}, 0)

    let current = get(g:, 'actual_curtab', 0) == i

    call settabvar(i, 'mayhem_cache_guitablabel', [
      \printf(" %s", modified ? " ̵̩̩" : " "),
      \printf("%%{%%GuiTabLabelErrors()%%}%%{%%GuiTabLabelName()%%}"),
      \printf("%s", current ? curul : tabul)
      \]->join("\n"))
  endfor
endfunc


function! tabline#gen_guitabtooltip_cache() abort
  for i in range(tabpagenr('$'))
    call settabvar(i, 'mayhem_cache_guitabtooltip', [
        \printf("%s ℴ𝒻 %s		 %%{%%GuiTabToolTipErrors()%%}",
        \ format#numbers(tabpagenr('$')->string(), 'sans'),
        \ format#numbers(string(i), 'sans')),
        \printf("%d window%s:",
        \ tabpagewinnr(i, '$'),
        \ tabpagewinnr(i, '$') > 1 ? 's' : ''
        \),
        \printf("%s%%<",
        \ tabpagebuflist(i)
        \  ->map({j, bufnr -> getbufvar(bufnr, 'mayhem_tl_cached_filename')})
        \  ->join("\n")
        \),
        \]->join("\n"))
  endfor
endfunc

function! tabline#gen_guitab_caches() abort
  call tabline#gen_guitablabel_cache()
  call tabline#gen_guitabtooltip_cache()
endfunc
