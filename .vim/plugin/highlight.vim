if exists("g:mayhem_loaded_highlight")
  finish
endif
let g:mayhem_loaded_highlight = 1


"
" Has two implementations, this one uses `matchadd()`
"
function! s:AddHighlightHighlight(name) abort
  let matchid = matchadd(a:name, '\(^\s*\||\s\+\)"\?:\?hi\w*\s*\(clear\)\@!\(link\s\)\?\<\zs'..a:name..'\ze\>')
  if matchid == -1
    echo 'HiHi:AddHighlightHighlight: Empty matchid returned'
  else 
    if exists('w:highlighthighlights') && type(w:highlighthighlights) == type([])
      call add(w:highlighthighlights, matchid)
    else
      let w:highlighthighlights = [ matchid ]
    endif
  endif
  return a:name
endfunc

function! s:ToggleHighlightHighlight() abort
  if empty(get(w:, 'highlighthighlights', [])) 
    %s/^:\?hi\w*\s*\(clear\)\@!\(link\s*\)\?\<\zs\(\w\+\)\ze\>/\=s:AddHighlightHighlight(submatch(0))/n
  else
    for matchid in get(w:, 'highlighthighlights', [])
      call matchdelete(matchid)
    endfor
    let w:highlighthighlights = []
  endif
endfunc

command! HiHiMatch call <SID>ToggleHighlightHighlight()



"
" Has two implementatins, this one uses `syn match`
"
function! s:AddSynMatch(name) abort
  exec 'syn match ' .. a:name .. ' /\<' .. a:name .. '\>/'
    \ .. ' contained contains=NONE containedin=VimHiGroup'
  return a:name
endfunc

function! s:HighlightHighlight() abort
  augroup HiHi
    autocmd!
    autocmd ColorScheme vividmayhem call s:HighlightHighlight()
  augroup END

  " e.g.:
  " syn match HlMkDnCdDelim /\<HlMkDnCdDelim\>/ contained contains=NONE containedin=VimHiGroup
  "
  let w:synmatches = []
  %s/^:\?hi\w*\s\+\(clear\)\@!\(def\w*\s*\)\?\(link\s*\)\?\<\zs\(\w\+\)\ze\>/\=w:synmatches->add(submatch(0))/ne
  %s/^:\?syn\w*\s\+\(match\|region\|keyword\)\s\+\<\zs\(\w\+\)\ze\>/\=w:synmatches->add(submatch(0))/ne
  for synmatch in w:synmatches
    exec 'syn match ' .. synmatch .. ' /\<' .. synmatch .. '\>/'
      \ .. ' contained contains=NONE containedin=VimGroupName,VimHiGroup'
  endfor
endfunc

command! HiHi call <SID>HighlightHighlight()




function s:GetLinkChain(name)
  " Break if same name encountered twice (= loop or no chain)
  let chain = []
  let lastName = a:name
  while lastName != ''
    if (len(hlget(lastName)) > 0)
      call add(chain, lastName)
      let hl = hlget(lastName)[0]
      let lastName = get(hl, 'linksto', '')
    else
      let lastName = ''
    endif
  endwhile
  return chain
endfunc

function! s:UpdateSynStackBuffer(winid)
  let bufnr = winbufnr(a:winid)

  call setbufline(bufnr, 1, 'No Highlighting Here')
  call setbufline(bufnr, 2, '')

  let stack = map(synstack(line('.'), col('.')), 'hlget(synIDattr(v:val, "name"))[0]')

  let i = 1
  let longest = 0
  for val in reverse(stack)
    let res = ""
    if (get(val, 'cleared'))
      let res = 'ᴄ' .. res
    else
      let res = ' ' .. res
    endif
    if (get(val, 'default'))
      let res = 'ᴅ' .. res
    else
      let res = ' ' .. res
    endif
    let res = res .. printf('%5S: ', val.id)
    if (get(val, 'linksto', "") != "")
      let chain = s:GetLinkChain(val.name)
      let matchids = mapnew(chain, {i, link -> win_execute(a:winid, 'call matchadd('''..link..''', ''\<'..link..'\>'')'  )})
      let res = res .. join(chain, ' ⫘⃗  ')
      " let res = res .. join(chain, '▶︎▬ᷞ▬ͥ▬ᷠ▬ᷜ▶︎')
      " let res = res .. join(chain, ' ▬▶︎ ')
      " let res = res .. join(chain, ' -> ')
      " let res = res .. join(chain, ' ʟɪɴ͢ᴋ ')
    else
      let res = res .. val.name
    endif
    let res = res .. ''
    call setbufline(bufnr, i, res)
    let longest = max([longest, strwidth(res)])
    let i = i + 1
  endfor
  let title = printf('%'..longest..'S', printf(' SynStack @ Row %s, Col %s', col('.'), line('.')))
  call setbufline(bufnr, max([3, i]), title)
endfunc

function s:SynStackPopupFilter(winid, key)
  " if a:key == '<LeftMouse>'
  "   let contents = getbufline(winbufnr(a:winid), 1, '$')
  "   echom contents
  "   :vsp|enew|call map(contents, {_, val -> appendbufline(bufnr(), 1, val) })|setlocal nomodified nomodifiable
  "   return 0
  " endif
  if a:key == 'x'
    call popup_close(a:winid)
    return 1
  endif
  return 0
endfunc

function s:SynStack()
  if !exists("*synstack")
    return
  endif

  if exists('w:mayhem_synstack_popid') && !empty(popup_getpos(w:mayhem_synstack_popid))
    popup_close(w:mayhem_synstack_popid)
  endif

  "\ title: ' SynStack ╴╴╴Row ' .. col('.') .. ' Col ' .. line('.') .. ' ',
  let w:mayhem_synstack_popid = popup_create('', #{
        \ pos: 'topleft',
        \ minwidth: 10,
        \ maxwidth: 80,
        \ minheight: 3,
        \ padding: [0,1,0,1],
        \ border: [1,1,1,1],
        \ highlight: 'HlPop01Bg',
        \ borderhighlight: ['HlPop01T','HlPop01R','HlPop01B','HlPop01L'],
        \ borderchars: [' ','⎥',' ','⎢', '⎛','⎞','⎠','⎝'],
        \ line: 'cursor+2',
        \ col: 'cursor',
        \ moved: 'any',
        \ filter: 's:SynStackPopupFilter',
        \ filtermode: 'n'
        \ })

  call s:UpdateSynStackBuffer(w:mayhem_synstack_popid)
endfunc

command! SynStack call <SID>SynStack()
command! SynStackBuf vsp|enew|call <SID>UpdateSynStackBuffer(winnr())

function! s:AutoSynStackStatus() abort
  if exists('g:mayhem_autosynstack_enabled') && g:mayhem_autosynstack_enabled
    return 1
  endif
  return 0
endfunc

function! s:AutoSynStack() abort
  augroup AutoSynStack
    autocmd!
    if s:AutoSynStackStatus() == 1
      autocmd CursorHold * call s:SynStack()
    endif
  augroup END
endfunc

command! SynStackAutoStatus echo <SID>AutoSynStackStatus()

command! SynStackAuto let g:mayhem_autosynstack_enabled = !get(g:, 'mayhem_autosynstack_enabled', 0) | call s:AutoSynStack()


command! HighlightThis :hi <c-r><c-w>

" Capture name of highlight
" '^:\?hi\w*\s\(link\|clear\)\@!\s*\zs\(\w\+\)\ze\s\+'
" Capture names in highlight link
" ^:\?hi\w*\s\+link\s\+\zs\(\w\+\)\s\+\(\w\+\)\ze\s\+

  " let matchid = matchadd(a:name, '^"\?:\?hi\w*\s\(link\|clear\)\@!\s*\zs' .. a:name .. '\ze\s\+', 10, -1)
  " %s/\(^\s*\||\s\+\)"\?:\?hi\w*\s\(\clear\)\@!\(link\)\?\s*\zs\(\w\+\)\ze\s\+/\=AddHighlightHighlight(submatch(0))/
  "echom a:name matchid

" :%s/^:\?hi\s\(link\|clear\)\@!\s*\zs\(\w\+\)\ze\s\+/\=AddHighlightHighlight(submatch(0))/
    "       '\(^\s*\||\s\+\)"\?:\?hi\w*\s\(\clear\)\@!\(link\)\?\s*\zs'



  " %g/^:\?hi\w*\s*\(clear\)\@!\(link\s*\)\?\<\zs\(\w\+\)\ze\>/echo s:AddSynMatch(submatch(0))
  " %g|^:\?hi\w*\s*\(clear\)\@!\(link\s*\)\?\<\zs\(\w\+\)\ze\>|exec 'syn match ' .. submatch(0) .. ' /\<' .. submatch(0).. '\>/ contained contains=NONE containedin=VimHiGroup'
"
"
"


