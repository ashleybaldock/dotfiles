if exists("g:mayhem_autoloaded_diag") || &cp
  finish
endif
let g:mayhem_autoloaded_diag = 1

"
" Related:
"   $VIMHOME/plugin/diag.vim
"   $VIMHOME/autoload/signs.vim
"   $VIMHOME/plugin/signs.vim
"


"
" Based on format specified in CocConfig 'diagnostic.format'
"
function! diag#getProviderFromBuffer(bufnr = winbufnr(g:coc_last_float_win)) abort
    let matches = getbufline(cocbufnr, '$', '$')
          \->get(0, '')
          \->matchlist('❯❯\s*\(\S\+\)\s*❯\s*\([EWIH]\)\?❯\s*\(\S\+\)\?\s*$')
    return #{
          \ name: get(matches, 1, 'unknown'),
          \ severity: get(matches, 2, 'E'),
          \ code: get(matches, 3, '')
          \}
endfunc


let s:cachedFetch = []
let s:diagSplitByFileAndSeverity = #{}

function! diag#cached() abort
  return s:cachedFetch
endfunc

function! diag#cachedByFile() abort
  return s:diagSplitByFileAndSeverity
endfunc

function! diag#byFileAndSeverity(diagnostics = diag#cached()) abort
  return mayhem#groupby2(a:diagnostics, 'file', 'severity')
endfunc

function! diag#bufnrToKey(bufnr = bufnr()) abort
  return bufname(a:bufnr)->expand()->fnamemodify(':p')
endfunc

function! diag#summarise(bufnr = bufnr()) abort
  let summary = #{
        \ total: #{error: 0, warning: 0, hint: 0, info: 0},
        \ above: #{error: 0, warning: 0, hint: 0, info: 0},
        \ there: #{error: 0, warning: 0, hint: 0, info: 0},
        \ below: #{error: 0, warning: 0, hint: 0, info: 0},
        \}
  if empty(bufname(a:bufnr))
    return summary
  endif
  
  let bufferDiagnostics = get(diag#cachedByFile(), diag#bufnrToKey(a:bufnr), [])

  let lnum_wintop = line('w0')
  let lnum_winbot = line('w$')

  for severity in keys(bufferDiagnostics)
    let summary.total[tolower(severity)] = len(severity)
    for diag in bufferDiagnostics[severity]
      if diag.lnum < lnum_wintop
        let summary.above[tolower(severity)] = summary.above[tolower(severity)] + 1
      elseif diag.lnum > lnum_winbot
        let summary.below[tolower(severity)] = summary.below[tolower(severity)] + 1
      else
        let summary.there[tolower(severity)] = summary.there[tolower(severity)] + 1
      endif
    endfor
  endfor

  call setbufvar(a:bufnr, 'mayhem_diagnostic_summary', summary)
  " let bufname = fnamemodify(bufname, s:abbrpaths)
  " return printf("%s %s", bufname, tabline#modstatus(a:bufnr))
endfunc

function! diag#update(error, result) abort
  if !empty(a:error)
    let s:cachedFetchError = a:error
    echom 'diag#fetch failed with error: ''' .. a:error .. ''''
  else
    let s:cachedFetch = a:result
    let s:diagSplitByFileAndSeverity = diag#byFileAndSeverity(s:cachedFetch)
  endif

  DoUserAutocmd MayhemDiagnosticsUpdated
endfunc

function! diag#fetch() abort
  call CocActionAsync('diagnosticList', function('diag#update'))
endfunc

function! diag#debugSplit() abort
  let grouped = diag#byFileAndSeverity()
  vsp
  enew
  call append('$', format#dict2json(grouped))
  setlocal filetype=json
  setlocal nomodifiable nomodified 
endfunc

