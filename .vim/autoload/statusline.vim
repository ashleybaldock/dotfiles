if exists("g:mayhem_autoloaded_statusline") || &cp
  finish
endif
let g:mayhem_autoloaded_statusline = 1

"
" See: ../plugin/statusline.vim
"

" 􀖈􀖉􀕹􀊫 􀤍
let g:mayhem.symbols_S.search = #{
      \ search: '􀊫',
      \ timeout: '􀖇',
      \}
      " \ search: 'ⲋⳆⲺⲺⲺⳘⲠⳞ ⳊⳌⳄⳒⳅⳓⳋⳍ𐋴 ⳽ჼჽ',
let g:mayhem.symbols_8.search = #{
      \ search: '/',
      \ timeout: '.',
      \}
let g:mayhem.symbols_A.search = #{
      \ search: '',
      \ timeout: '',
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
  let r = searchcount(#{recompute: 0})
  if empty(r)
    let b:mayhem.sl_cache_search = format#CN('')
    return
  endif
  let current = '-'
  let total = '-'
  let symbol = symbols#CN('search.search')

  if r.incomplete ==# 1 " timed out
    let summary = [
      \'%#SlFPath⸮#', '𝚜𝚎𝚊𝚛𝚌𝚑 𝚝𝚒𝚖𝚎𝚍 𝚘𝚞𝚝', 
      \]
    let symbol = symbols#CN('search.timeout')
  elseif r.incomplete ==# 2 " max count exceeded
    if r.total > r.maxcount && r.current > r.maxcount
      let current = printf('>%s', format#numbers(r.current))
      let total = printf('>%s', format#numbers(r.total))
    elseif r.total > r.maxcount
      let total = printf('>%s', format#numbers(r.total))
      let msg 
    endif
  else
    if r.total == 0
      let summary = [
        \'%#SlFPath⸮#', ' 𝚗𝚘 𝚖𝚊𝚝𝚌𝚑𝚎𝚜 ', 
        \]
    else
      if r.current == 0
        let summary = [
          \'%#SlSearch⸮#', format#numbers(r.total),
          \'%#SlFPath⸮#', ' 𝚖𝚊𝚝𝚌𝚑𝚎𝚜 ', 
          \]
      else
      endif
    endif
    let summary = [
      \'%#SlSearch⸮#', format#numbers(r.current),
      \'%#SlFPath⸮#', ' ℴ𝒻 ', 
      \'%#SlSearch⸮#', format#numbers(r.total),
      \]
  endif

  let formattedSearch = statusline#formatSearch()

  let b:mayhem.sl_cache_search = format#CN([
      \'%#SlFPath⸮#', symbol, ' ',
      \'%#SlSearch⸮#', formattedSearch,
      \'%#SlFPath⸮#', ' ',
      \'%#SlSearchSep⸮#','⁞',
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

