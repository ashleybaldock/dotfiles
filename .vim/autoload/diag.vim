if exists("g:mayhem_autoloaded_diag") || &cp
  finish
endif
let g:mayhem_autoloaded_diag = 1

"
" Related:
"      ../plugin/diag.vim
"              ./signs.vim
"      ../plugin/signs.vim
"

let s:cachedFetch = []
let s:diagSplitByFileAndSeverity = #{}

function! diag#cached() abort
  return s:cachedFetch
endfunc

function! diag#cachedByFile() abort
  return s:diagSplitByFileAndSeverity
endfunc

function! diag#byFileAndSeverity() abort
  return reduce(diag#cached(), {acc, cur -> has_key(acc, bufnr(cur.file))
        \ ? add(acc[bufnr(cur.file)][cur.severity], cur)
        \ : extend(acc, {
        \   bufnr(cur.file): {[cur.severity]: [cur]}
        \  })
        \}, {})
  DoUserAutocmd MayhemDiagnosticsUpdated
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
  
  let bufpath = bufname(a:bufnr)->expand()->fnamemodify(':p')
  let bufferDiagnostics = get(s:diagCache, bufpath, [])

  let lnum_wintop = line('w0')
  let lnum_winbot = line('w$')

  for diag in bufferDiagnostics
    if diag.lnum < lnum_wintop
      let summary.above[tolower(diag.severity)] += 1
    elseif diag.lnum > lnum_winbot
      let summary.below[tolower(diag.severity)] += 1
    endif
  endfor

  call setbufvar(a:bufnr, 'mayhem_diagnostic_summary', summary)
  " let bufname = fnamemodify(bufname, s:abbrpaths)
  " return printf("%s %s", bufname, tabline#modstatus(a:bufnr))
endfunction
function! diag#update(error, result) abort
  if !empty(a:error)
    let s:cachedFetchError = a:error
    echom 'diag#fetch failed with error: ''' .. a:error .. ''''
  else
    let s:cachedFetch = a:result
    let s:diagSplitByFileAndSeverity = diag#byFileAndSeverity(s:cachedFetch)
  endif
endfunc

function! diag#fetch() abort
  call CocAction('diagnosticList', diag#update)
endfunc


function! diag#debugSplit() abort
  let grouped = diag#byFileAndSeverity()
  vsp
  enew
  call append('$', format#dict2json(grouped))
  setlocal filetype=json
  setlocal nomodifiable nomodified 
endfunc
