if exists("g:mayhem_autoloaded_tabline") || &cp
  finish
endif
let g:mayhem_autoloaded_tabline = 1

"
" See Also: ../plugin/tabline.vim
"           ../plugin/statusline.vim
"

"
"
" Only the topmost pixels are visible
"█▇▆▅▆▇█▅█▅▇▆▇▆
"
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

function s:name_tpl() abort
  return get(g:, 'mayhem_tl_name_tpl', "%48.48s %s")
endfunc

function! tabline#bufname(bufnr = bufnr()) abort
  let bufname = bufname(a:bufnr)
  if empty(bufname)
    " return "𝑢𝑛𝑛𝑎𝑚𝑒𝑑"
    return "𝑛 𝑎 𝑚 𝑒 𝑙 𝑒 𝑠 𝑠"
  else
    let bufname = fnamemodify(bufname, get(g:, 'mayhem_abbrpaths', ''))
  endif
  return printf(s:name_tpl(), bufname, tabline#modstatus(a:bufnr))
endfunc

function! tabline#update_cached_bufname(bufnr = bufnr()) abort
  call setbufvar(a:bufnr, 'mayhem_tl_cached_filename',
        \ tabline#bufname(a:bufnr))
endfunc

function! tabline#cached_bufname() abort
  return get(b:, 'mayhem_tl_cached_filename', '𝘯𝘦𝘸 𝘵𝘢𝘣')
endfunc


function! tabline#update_cached_diagnostics() abort
  for i in range(1, tabpagenr('$'))
    if !exists('g:did_coc_loaded')
      call settabvar(i, 'mayhem_tl_cached_diag_label',
            \ symbols#inline('diag.off'))
      call settabvar(i, 'mayhem_tl_cached_diag_tip',
            \ symbols#inline('diag.off'))
    else
      let warningCount = 0
      let errorCount = 0

      for bufnr in tabpagebuflist(i)
        let summary = diag#summarise(bufnr)
        let warningCount += get(summary.total, 'warning', 0)
        let errorCount += get(summary.total, 'error', 0)
      endfor

      call settabvar(i, 'mayhem_tl_cached_diag_label',
            \ errorCount > 0 ? printf("%s%s ",
            \ errorCount,
            \ symbols#inline('diag.error')
            \) : symbols#inline('diag.ok')
            \)
      call settabvar(i, 'mayhem_tl_cached_diag_tip', printf("%s%s%s",
        \ errorCount > 0 ? printf("%s%s",
        \   symbols#inline('diag.error'), errorCount) : "",
        \ warningCount > 0 ? printf("%s%s",
        \   symbols#inline('diag.warning'), warningCount) : "",
        \ errorCount == 0 && warningCount == 0 ? symbols#inline('diag.ok') : ""))
    endif
  endfor
endfunc

function! tabline#LabelDiag() abort
  return get(t:, 'mayhem_tl_cached_diag_label', '')
endfunc

function! tabline#gen_label_cache() abort
  let tabul = get(g:, 'mayhem_tab_underline', '')
  let curul = get(g:, 'mayhem_curtab_underline', '')
  for i in range(1, tabpagenr('$'))
    let bufname = get(b:, 'mayhem_tl_cached_filename', tabline#bufname())

    let modified = tabpagebuflist(i)
        \->reduce({acc, bufnr -> acc + getbufvar(bufnr, "&modified", 0)}, 0)

    let current = get(g:, 'actual_curtab', 0) == i

    call settabvar(i, 'mayhem_cache_guitablabel', [
      \printf(" %s", modified ? " ̵̩̩" : " "),
      \printf("%%{%%tabline#LabelDiag()%%} %%{%%tabline#cached_bufname()%%}"),
      \printf("%s", current ? curul : tabul)
      \]->join("\n"))
  endfor
endfunc

function! tabline#cached_label() abort
  return get(t:, 'mayhem_cache_guitablabel', '! %{%tabline#cached_bufname()%}')
endfunc

function! tabline#set_guitablabel() abort
  set guitablabel=%{%tabline#cached_label()%}
endfunc


"􀏜 􃑷  􃛒  􃛕  􀢌 􃛓  􀾪􁁎 􂃻 􂃼 􂃽 􂃾  􀐑 􀐒   ⎍  ⺇𒋰
"

function! tabline#DiagTip() abort
  return get(t:, 'mayhem_tl_cached_diag_tip', '')
endfunc

function! tabline#gen_tip_cache() abort
  for i in range(1, tabpagenr('$'))
    call settabvar(i, 'mayhem_cache_guitabtooltip', [
         \ printf("\\ %s / 𝔬𝔣 / %s /	􀢌 ×%d %%= %%{%%tabline#DiagTip()%%}",
        \ format#numbers(string(i), 'sans'),
        \ format#numbers(tabpagenr('$')->string(), 'sans'),
        \ tabpagewinnr(i, '$'),
        \),
        \printf("%s%%<",
        \ tabpagebuflist(i)
        \  ->map({j, bufnr -> getbufvar(bufnr, 'mayhem_tl_cached_filename')})
        \  ->join("\n")
        \),
        \]->join("\n"))
  endfor
endfunc
function! tabline#cached_tip() abort
  return get(t:, 'mayhem_cache_guitabtooltip', '')
endfunc

function! tabline#set_guitabtooltip() abort
  set guitabtooltip=%.400{%tabline#cached_tip()%}
endfunc

function! tabline#gen_guitab_caches() abort
  call tabline#gen_label_cache()
  call tabline#gen_tip_cache()
endfunc
