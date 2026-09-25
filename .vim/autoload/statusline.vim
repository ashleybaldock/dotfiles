if exists("g:mayhem_autoloaded_statusline") || &cp
  finish
endif
let g:mayhem_autoloaded_statusline = 1

"
" Related:
"    $VIMHOME/autoload/sl.vim
"    $VIMHOME/plugin/statusline.vim
"

" 􀖈􀖉􀕹􀊫 􀤍 ⲋⳆⲺⲺⲺⳘⲠⳞ ⳊⳌⳄⳒⳅⳓⳋⳍ𐋴 ⳽ჼჽ 𐑴𐑢᠆
let g:mayhem.symbols_S.search = #{
      \ search: '􀊫',
      \ timeout: '􀖇',
      \ quote: '″️',
      \ sep: '⋮',
      \ gt: '>️',
      \}
let g:mayhem.symbols_8.search = #{
      \ search: '/',
      \ timeout: '.',
      \ quote: '″️',
      \ sep: '⋮',
      \ gt: '>️',
      \}
let g:mayhem.symbols_A.search = #{
      \ search: '',
      \ timeout: '',
      \ quote: '"',
      \ sep: ':',
      \ gt: '>',
      \}

function! statusline#formatSearch(search = @/)
  let sp = '%#SlSp⸮#'
  let tx = '%#SlSx⸮#'
  let pattern = '\%(\\%\?(\|\\)\|\\<\|\\>\|\\{\%(\-\?\d*\),\?\%(-\?\d\+\)\?\|\\%\|\\[|^$=?+0-9a-yA-Z]\|\*\|\\z[se(1-9]\)'
  let merged = '' .. pattern .. '\@=' .. '\|' .. pattern .. '\@<='
  return split(a:search, merged, 0)
        \->map({_, s -> split(s, '%', 1)->join('%%')})
        \->map({_, s -> s =~ pattern ? sp .. s : tx .. s})
        \->join('')
endfunc

function! statusline#updateSearch(...) abort
  let r = searchcount(#{recompute: 1})
  if empty(r)
    let b:mayhem.sl_cache_search = format#CN('')
    return
  endif
  let current = '-'
  let total = '-'
  let symbol = symbols#CN('search.search')
  let quote = symbols#CN('search.quote')
  let summary = ''

  if r.incomplete ==# 1 " timed out
    let summary = [
      \'%#SlFPath⸮#', '𝚜𝚎𝚊𝚛𝚌𝚑 𝚝𝚒𝚖𝚎𝚍 𝚘𝚞𝚝', 
      \]
    let symbol = symbols#CN('search.timeout')
  " elseif r.incomplete ==# 2 " max count exceeded
  else
    let summary = flatten([
          \ r.current == 0 ? [] : [
          \  r.current > r.maxcount ? ['%#SlGt⸮#', symbols#CN('search.gt')] : [], 
          \  '%#SlSearch⸮#', format#numbers(r.current),
          \  '%#SlFPath⸮#', ' ℴ𝒻 ',
          \ ],
          \ r.total == 0 ? [
          \  '%#SlFPath⸮#', '𝓃𝜊𝓉 𝒻𝜎𝓊𝓃𝒹',
          \ ] : [
          \  r.total > r.maxcount ? ['%#SlGt⸮#', symbols#CN('search.gt')] : [],
          \  '%#SlSearch⸮#', format#numbers(r.total),
          \ ],
          \])
  endif

  let formattedSearch = statusline#formatSearch()

  let b:mayhem.sl_cache_search = format#CN([
      \'%#SlFPath⸮#', symbol, ' ', quote,
      \'%#SlSearch⸮#', formattedSearch,
      \'%#SlFPath⸮#', quote, ' ',
      \'%#SlSearchSep⸮#',symbols#CN('search.sep'),
      \'%#SlFPath⸮#', ' ',
      \ summary,
      \'%#SlFPath⸮#', ' ',
      \'%*'
      \])
endfunc

function! statusline#updateDiagnostics(...) abort
  if !exists('g:did_coc_loaded')
    let b:mayhem.sl_cache_diag = format#CN([
          \ '%#SlSynOff⸮#' .. symbols#CN('diag.off') .. '%*'
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
        \get(symbols#get('diag.error'), errorCount, symbols#CN('diag.error')),
        \'%*'
        \])
    return
  endif

  if warnCount > 0
    let b:mayhem.sl_cache_diag = format#CN([
        \'%#SlSynWarn⸮#',
        \get(symbols#get('diag.warning'), warnCount, symbols#CN('diag.warning')),
        \'%*'
        \])
    return
  endif

  let b:mayhem.sl_cache_diag = format#CN([
        \'%#SlSynOk⸮#' .. symbols#CN('diag.ok') .. '%*'
        \])
  return
endfunc

