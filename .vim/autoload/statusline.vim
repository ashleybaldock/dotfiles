if exists("g:mayhem_autoloaded_statusline") || &cp
  finish
endif
let g:mayhem_autoloaded_statusline = 1

"
" See: ../plugin/statusline.vim
"

function! statusline#updateSearch(...) abort
  let r = searchcount(#{recompute: 0})
  if empty(r)
    let b:mayhem.sl_cache_search = format#CN('')
    return
  endif
  if r.incomplete ==# 1 " timed out
    let b:mayhem.sl_cache_search = format#CN([
        \'%#SlSearch⸮#',
        \symbols#CN('search.timeout􀖇􀖈􀖉􀱨􀕹􀊫􀬸 􀤍'),
        \'%#SlSearch⸮#',
        \'%#SlFPath⸮#[️%#SlSearch⸮#?%#SlFPath⸮#/️%#SlSearch⸮#?%#SlFPath⸮#]️%#SlSearch⸮# ',
        \'%#SlHint⸮#',
        \ @/,
        \'%*'
        \])
    return
  elseif r.incomplete ==# 2 " max count exceeded
    if r.total > r.maxcount && r.current > r.maxcount
      return printf('/%s [>%d/>%d]', @/, r.current, r.total)
    elseif r.total > r.maxcount
      return printf('/%s [%d/>%d]', @/, r.current, r.total)
    endif
  endif
  return printf(' /%s [%d/%d]', @/, r.current, r.total)
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

