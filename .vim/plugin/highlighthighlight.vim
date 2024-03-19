
if exists("g:loaded_highlighthighlight")
  finish
endif
let g:loaded_obsession = 1

function! s:AddHighlightHighlight(name) abort
  let matchid = matchadd(a:name, '\(^\s*\||\s\+\)"\?:\?hi\w*\s\(\clear\)\@!\(link\)\?\s*\zs' .. a:name .. '\ze\s\+', 10, -1)
  if exists('w:highlighthighlights') && type(w:highlighthighlights) == type([])
    call add(w:highlighthighlights, matchid)
  else
    let w:highlighthighlights = [ matchid ]
  endif
  return a:name
endfunc

function! s:ToggleHighlightHighlight() abort
  if empty(get(w:, 'highlighthighlights', [])) 
    let w:highlighthighlights = map(filter(getline('1','$'),
          \ 'v:val =~ ''^:\?hi\w*\s\(link\|clear\)\@!\s*\zs\(\w\+\)\ze\s\+'''),
          \ 's:AddHighlightHighlight(submatch(0))')
  else
    for matchid in get(w:, 'highlighthighlights', [])
      call matchdelete(matchid)
    endfor
    let w:highlighthighlights = [ ]
  endif
endfunc

:command! HiHi :call <SID>ToggleHighlightHighlight()



" Capture name of highlight
" '^:\?hi\w*\s\(link\|clear\)\@!\s*\zs\(\w\+\)\ze\s\+'
" Capture names in highlight link
" ^:\?hi\w*\s\+link\s\+\zs\(\w\+\)\s\+\(\w\+\)\ze\s\+

  " let matchid = matchadd(a:name, '^"\?:\?hi\w*\s\(link\|clear\)\@!\s*\zs' .. a:name .. '\ze\s\+', 10, -1)
  " %s/\(^\s*\||\s\+\)"\?:\?hi\w*\s\(\clear\)\@!\(link\)\?\s*\zs\(\w\+\)\ze\s\+/\=AddHighlightHighlight(submatch(0))/
  "echom a:name matchid

" :%s/^:\?hi\s\(link\|clear\)\@!\s*\zs\(\w\+\)\ze\s\+/\=AddHighlightHighlight(submatch(0))/
    "       '\(^\s*\||\s\+\)"\?:\?hi\w*\s\(\clear\)\@!\(link\)\?\s*\zs'

