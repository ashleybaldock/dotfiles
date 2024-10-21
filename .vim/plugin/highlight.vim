if exists("g:mayhem_loaded_highlight")
  finish
endif
let g:mayhem_loaded_highlight = 1




"
" Has two implementations, this one uses `syn match`
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
  " Follow links to the end
  " (or until detecting a loop)
  let chain = []
  let lastName = a:name
  while lastName != ''
    " if name seen already, must be in a loop
    " this isn't a very efficient lookup
    " but highlighting chains are very short
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

"
"
" ⎛                                                  ⎞
" ⎢ ᴅ  1234: cssUrlFunction ⫘⃗  UrlFunc ⫘⃗  Statement  ⎥
" ⎢  ᴄ  567: cssAttrRegion                           ⎥
" ⎢  ᴄ   89: cssDefinition                           ⎥
" ⎝                        Synstack @ Row 62 Col 39  ⎠
"
" ⎛                                       ⎞
" ⎢ ᴅ  1234: cssUrlFunction ⫘⃗  Statement  ⎥
" ⎢  ᴄ  567: cssAttrRegion                ⎥
" ⎢  ᴄ   89: cssDefinition                ⎥
" ⎝             Synstack @ Row 62 Col 39  ⎠
"
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
      " join(chain, '▶︎▬ᷞ▬ͥ▬ᷠ▬ᷜ▶︎') join(chain, ' ▬▶︎ ') join(chain, ' -> ') join(chain, ' ʟɪɴ͢ᴋ ')
    else
      let res = res .. val.name
    endif
    let res = res .. ''
    call setbufline(bufnr, i, res)
    let longest = max([longest, strwidth(res)])
    let i = i + 1
  endfor
  let title = printf('%'..longest..'S', printf(' SynStack @ Row %s, Col %s', line('.'), col('.')))
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
    call s:SynStackDisable()
    call s:SynstackSetup()
    return 1
  endif
  return 0
endfunc

function s:SynStack()
  if !exists("*synstack")
    return
  endif

  if empty(popup_getpos(get(w:, 'mayhem_synstack_popid', 0)))
    echom 'no existing popup, make a new one'

    let w:mayhem_synstack_popid = popup_create('', #{
          \ pos: 'topleft',
          \ line: 'cursor+2',
          \ col: 'cursor',
          \ minwidth: 30,
          \ maxwidth: 80,
          \ minheight: 3,
          \ padding: [0,1,0,1],
          \ border: [1,1,1,1],
          \ highlight: 'HlPop01Bg',
          \ borderhighlight: ['HlPop01T','HlPop01R','HlPop01B','HlPop01L'],
          \ borderchars: [' ','⎥',' ','⎢', '⎛','⎞','⎠','⎝'],
          \ moved: 'any',
          \ filter: 's:SynStackPopupFilter',
          \ filtermode: 'n'
          \ })
  else
    echom 're-using existing popup'
    popup_move(w:mayhem_synstack_popid, #{
          \ pos: 'topleft',
          \ line: 'cursor+2',
          \ col: 'cursor',
          \ minwidth: 30,
          \ maxwidth: 80,
          \ minheight: 3,
          \ })
  endif

  call s:UpdateSynStackBuffer(w:mayhem_synstack_popid)
endfunc

command! SynStack call <SID>SynStack()
command! SynStackBuf vsp|enew|call <SID>UpdateSynStackBuffer(winnr())

function! s:SynStackSetup() abort
  augroup MayhemSynStack
    autocmd!
    if w:mayhem_synstack_enabled == 1
      autocmd CursorHold * call s:SynStack()
    else
      if !empty(popup_getpos(w:mayhem_synstack_popid))
        call popup_close(w:mayhem_synstack_popid)
      endif
    endif
  augroup END
endfunc

function! s:SynStackDisable(winid)
  let w:mayhem_synstack_enabled = 0
  call s:SynStackSetup()
endfunc

function! s:SynStackEnable(winid)
  let w:mayhem_synstack_enabled = 1
  call s:SynStackSetup()
endfunc

function! s:SynStackToggle(winid)
  let w:mayhem_synstack_enabled = !get(w:, 'mayhem_synstack_enabled', 0)
  call s:SynStackSetup()
endfunc

command! SynStackStatus :get(w:, 'mayhem_synstack_enabled', 0)

" command! SynStackAuto let w:mayhem_synstack_enabled =  | call s:SynStackSetup()

command! SynStackToggle :call <SID>SynStackToggle()

command! HighlightThis :hi <c-r><c-w>



"
" Execute a command and paste the result into the current buffer
"
function! ExecAndPut(command, )
    redir => output
    silent exec a:command
    redir END
    let @o = output
    execute "put o"
    return ''
endfunc


" Insert a highlight entry for the current word
command! ExpandHlGroup :call ExecAndPut('hi '..expand("<cword>"))

nnoremap <expr> §`i ExecAndPut('hi '..<c-r><c-w>)

function! JumpToHighlightDefinition(hlname = expand("cword"))
  let file = ''
  let lnum = 0
  redir => output
  silent exec 'verbose hi '..a:hlname
  redir END
endfunc

command! -nargs=? JumpToHighlightDefinition :call JumpToHighlightDefinition(<f-args>)


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
" Highlight syntax group names with themselves
" Uses `matchadd()`, see :syn version above
"
" function! s:AddHighlightHighlight(name) abort
"   let matchid = matchadd(a:name, '\(^\s*\||\s\+\)"\?:\?hi\w*\s*\(clear\)\@!\(link\s\)\?\<\zs'..a:name..'\ze\>')
"   if matchid == -1
"     echo 'HiHi:AddHighlightHighlight: Empty matchid returned'
"   else 
"     if exists('w:highlighthighlights') && type(w:highlighthighlights) == type([])
"       call add(w:highlighthighlights, matchid)
"     else
"       let w:highlighthighlights = [ matchid ]
"     endif
"   endif
"   return a:name
" endfunc

" function! s:ToggleHighlightHighlight() abort
"   if empty(get(w:, 'highlighthighlights', [])) 
"     %s/^:\?hi\w*\s*\(clear\)\@!\(link\s*\)\?\<\zs\(\w\+\)\ze\>/\=s:AddHighlightHighlight(submatch(0))/n
"   else
"     for matchid in get(w:, 'highlighthighlights', [])
"       call matchdelete(matchid)
"     endfor
"     let w:highlighthighlights = []
"   endif
" endfunc

" command! HiHiMatch call <SID>ToggleHighlightHighlight()

