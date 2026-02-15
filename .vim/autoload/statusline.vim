if exists("g:mayhem_autoloaded_statusline") || &cp
  finish
endif
let g:mayhem_autoloaded_statusline = 1

"
" See: ../plugin/statusline.vim
"

function! statusline#updateDiagnostics(...) abort
  if !exists('g:did_coc_loaded')
    let b:mayhem.sl_cache_diag = [
          \ ['%#SlSynOffC#', symbols#getc('diag.off'), '%*']->join(''),
          \ ['%#SlSynOffN#', symbols#getn('diag.off'), '%*']->join(''),
          \]
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
    let b:mayhem.sl_cache_diag = [
        \ ['%#SlSynErrC#',
        \  get(symbols#get('diag.error'), errorCount, symbols#getc('diag.error')),
        \ '%*']->join(''),
        \ ['%#SlSynErrN#',
        \  get(symbols#get('diag.error'), errorCount, symbols#getn('diag.error')),
        \ '%*']->join(''),
        \]
    return
  endif

  if warnCount > 0
    let symbol = symbols#get('diag.numbers', [])
          \->get(warnCount, symbols#get('diag.warning'))
    let b:mayhem.sl_cache_diag = [
        \ ['%#SlSynWarnC#',symbol,'%*']->join(''),
        \ ['%#SlSynWarnN#',symbol,'%*']->join(''),
        \]
    let b:mayhem.sl_cache_diag = [
        \ ['%#SlSynWarnC#',
        \  get(symbols#get('diag.warning'), warnCount, symbols#getc('diag.warning')),
        \ '%*']->join(''),
        \ ['%#SlSynWarnN#',
        \  get(symbols#get('diag.warning'), warnCount, symbols#getn('diag.warning')),
        \ '%*']->join(''),
        \]
    return
  endif

  let b:mayhem.sl_cache_diag = [
        \ ['%#SlSynOkC#', symbols#getc('diag.ok'), '%*']->join(''),
        \ ['%#SlSynOkN#', symbols#getn('diag.ok'), '%*']->join(''),
        \]
  return
endfunc

