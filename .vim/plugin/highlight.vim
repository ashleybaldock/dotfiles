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



function! s:GetCharacterInfo()
  let char = getline('.')[col('.') - 1:-1]
  if IsSfSymbol(char)
    let info = GetSfSymbolInfo(char)
    return [''..info.symbol..' '..info.code..' '..info.name..'']
  else
    redir => output
    silent exec ':Characterize'
    redir END
    return [output]
  endif
endfunc


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

"₁️₂️₃️
"₁⃞ ₂⃞ ₃⃞  ¹⃞ ²⃞ ³⃞ ⁴⃞    ¹️²️³️⁴️⁵️⁶️⁷️⁸️⁹️₁️₂️₃️₄️₅️₆️₇️₈️₉️¹̲►️²̲️³̲️⁴̲️⁵̲️⁶̲️⁷̲️⁸̲️⁹̲️►️₁️₂️₃️₄️₅️₆️₇️►️₈️₉️²³⁴►️⁵⁶⁷⁸⁹₁꛱₂꛱₃꛱₄꛱₅꛱₆꛱₇꛱₈꛱₉꛱
"₁⃞️ ₂⃞️ ₃⃞️  ¹⃞ ²⃞ ³⃞ ⁴⃞ ⁵⃞ ⁶⃞ ⁷⃞ ⁸⃞ ⁹⃞  0︎⃣ 1︎⃣ 2︎⃣ 3︎⃣ 4︎⃣ 5︎⃣ 6︎⃣ 7︎⃣ 8︎⃣ 9︎⃣  
"
" ⎛             ᐅᐳ         ◁️[ ₁️1︎⃣ ⮕  ◁️]  ᐅᐳ  ▷️ᐳ  ▷️ᐳ⮕ᐳ               ⎞
"
"
" join(chain, '▶︎▬ᷞ▬ͥ▬ᷠ▬ᷜ▶︎') join(chain, ' ▬▶︎ ') join(chain, ' -> ') join(chain, ' ʟɪɴ͢ᴋ ')
"
"  􀯭 􀯮 􀯯 􁉽 􁋼 􁉼 􁋽 􁋛 􁋜 􀯰 􁌅 􀯱 􀯲 􀯳 􁊕
"􀅓
"􀅔
"􀅕
"􀅖
"􀨡
"􀅗
"􀅘
" ⎛                                       ⎞
" ⎢ ᴅ  1234: cssUrlFunction  S️tatement  ⎥
" ⎢  ᴄ  567: cssAttrRegion                           ⎥
" ⎢  ᴄ   89: cssDefinition                           ⎥
" ⎝                        Synstack @ Row 62 Col 39  ⎠
"
" ⎛            fg:#aabbcc bg:#227788                       ⎞
" ⎢    1234: cssUrlFunction ───►️ Statement #aabbcc #227788 ⎥
" ⎢ ᴅ  1234: cssUrlFunction ─2︎⃣╶►️ Statement                 ⎥
" ⎢  ᴄ  567: cssAttrRegion                  ⎥
" ⎢  ᴄ   89: cssDefinition 
"
" ⎢      R̲̅9️5️ C̩̍ᵒ̩̍5️6️ Vᶜ5️6️  ᵇʸᵗᵉ9️2️
"
" ⎢      ʀᐧ9️5️ ⎟C⎜5️6️ ᵛᶜᵒˡ5️6️  ᵇʸᵗᵉ⎡⎟9️2️⎟
" ⎢     
"       
"        ⎵ 
"      ᴿ⃞︎]          ̲̅3̲̅3̲̅2̲̅     𝟸̲̅𝟺̲̅𝟹̲̅  𝟮̲̅𝟰̲̅𝟯̲̅ 𝟣̲̅𝟥̲̅𝟧̲̅ 𝟑̲̅𝟔̲̅𝟎̲̅
"
          "\ ' SynStack @️ ʀ̲̅%s |ᴄ|%s ʙ𝗒%s',
"        𝘤𝘰𝘭 𝘳𝘰𝘸   
"
" ╷   ╷   ╷ 80╷
" ⎝            Synstack @   Rʷ̲ 62 Cˡ 39  ⎠      ╵Vr╴╵Ch╴╵Col╵
"
" ⎝       Synstack @ row _6̲2̲_ │ ͦͨͮͮ ͦ︎ ͦͨʰʰ️ʰ︎ˡ39│ᵛᵛ️ᵛ︎ ͨͮ35│ ͪͨ29│️ 39 [v 35|c 35]   ⎠
"     3̲̅9̲̅   ⏐62⏐
" 
" ᴿᴼᵂᴿ️ᴼ️ᵂ️ᴿ⃞︎ ᴼ⃞︎ ᵂ⃞︎ ʳᵒʷʳ️ᵒ️ʷ️ʳ⃞︎ ᵒ⃞︎ ʷ⃞︎   ⁿⁿⁿʲʲʲʰʰʰˡˡˡʷʷʷ
" ᴸᴼᴬᴰᴸ️ᴼ️ᴬ️ᴰ️ᴸ︎ᴼ︎ᴬ︎ᴰ︎  ᴏ   
"   ʳᵒʷ ᶜᵒˡ ᵛᐧᶜᵒˡ ᶜʰᐧᶜᵒˡ ᵇʸᵗᵉᐧ
"   ᴿᵒʷ ᶜᵒˡ ᵛꜞʳᵗᐧᶜᵒˡ ᶜʰᐧᶜᵒˡ          V
"   Rᵒʷ ᴄᵒˡ vᶜᵒˡ chᶜᵒˡ  R C V H ᴠ Vˡͦͨ ᶜᵒˡCᴏʟ |️ᴄ|️ ʜᶜᵒˡCᴏʟͦ  ᴠɪᴛCᴏʟ ʜᴀCᴏ   ▕️  ʀ̲̅
"
" ᵛᵥᵛ️ᵥ️ᵛ︎ᵥ︎ ˯˰˱͔˲͕ ˱͕˲͔ ˱͐˲͐ ˖̝˖˖️̝˗˗️ ˳̣˳̣️.̣.̣️ ˌ̩˯̩ ::️˸˸ ᵣᵣ️ᵣ︎ ᶜᵒᶫˣʼ̊ᶜ️ᵒ️ᶫ️ˣ️ʼ̊️ᶜ︎ᵒ︎ᶫ︎ˣ︎ʼ̊︎ ˤʕʖʔ ⎥  ͖ ˪˫ . |̴̰ ‖̻⸋⸋️⸋︎⸋̻︎‖̪ ‖̝
"
"   ˹˺˻˼˽˾ꜚ˿ ̚  ˺͐ ‿ˌ  ˲͕͐ ˱͔ 
          
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
  "                                                                        TODO
  "                              Hide intermediate links in chain to save space
    if (get(val, 'linksto', "") != "")
      let chain = s:GetLinkChain(val.name)
      let matchids = mapnew(chain, {i, link -> win_execute(a:winid, 'call matchadd('''..link..''', ''\<'..link..'\>'')'  )})
      let res = res .. join(chain, ' ⫘⃗  ')
    else
      let res = res .. val.name
    endif
    let res = res .. ''
    call setbufline(bufnr, i, res)
    let longest = max([longest, strwidth(res)])
    let i = i + 1
  endfor
  "                                                     TODO
  "              Add info about character at cursor position
  "
  let cc = charcol('.')
  let vc = virtcol('.')
  let bc = col('.')
  let col = printf('𝖢𝗈𝗅%s', cc)
  let vcol = printf('𝖵%s', vc)
  let byte = printf('𝖡%s', bc)
  let numbers = printf('𝖱𝗈𝗐 %s %s%s%s',
        \ line('.'),
        \ col,
        \ cc == vc ? '' : printf('(%s)', vcol),
        \ cc == bc ? '' : printf('(%s)', byte))
  let title = printf('%'..longest..'S', numbers)
  " let title = printf('%'..longest..'S', printf(' SynStack @ Row %s Col %s (V %s H %s)', line('.'), col('.'), virtcol('.'), charcol('.')))
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

function! s:SynStackClose(winid = win_getid()) abort
  let popid = getwinvar(winnr(a:winid), 'mayhem_synstack_popid', 0)
  if popid > 0 && !empty(popup_getpos(popid))
    call popup_close(popid)
  endif
endfunc

function! s:SynStackSetup() abort
  augroup MayhemSynStack
    autocmd!
    if s:mayhem_synstack_enabled == 1
      autocmd CursorHold * if w:mayhem_synstack_enabled == 1 | call s:SynStack() | else |call s:SynStackClose() | endif
    endif
  augroup END
endfunc

function! s:SynStackDisable(winid = win_getid()) abort
  call setwinvar(winnr(a:winid), 'mayhem_synstack_enabled', 0)
  call s:SynStackSetup()
endfunc

function! s:SynStackEnable(winid = win_getid()) abort
  call setwinvar(winnr(a:winid), 'mayhem_synstack_enabled', 1)
  call s:SynStackSetup()
endfunc

function! s:SynStackToggle(winid = win_getid()) abort
  call setwinvar(winnr(a:winid), 'mayhem_synstack_enabled', !getwinvar(winnr(a:winid), 'mayhem_synstack_enabled', 0))
  call s:SynStackSetup()
endfunc

command! SynStackStatus echo get(s:, 'mayhem_synstack_enabled', 0)

command! -nargs=? SynStackAuto call <SID>SynStackEnable(<f-args>)

command! -nargs=? SynStackToggle call <SID>SynStackToggle(<f-args>)

command! HighlightThis hi <c-r><c-w>


"
" Execute a command and paste the result into the current buffer
"
function! ExecAndPut(command)
    redir => output
    silent exec a:command
    redir END
    let @o = output
    execute "put o"
    return ''
endfunc


" Insert a highlight entry for the current word
command! ExpandHlGroup call ExecAndPut('hi '..expand("<cword>"))

nnoremap <expr> §`i ExecAndPut('hi '..<c-r><c-w>)

function! JumpToHighlightDefinition(hlname = expand("cword"))
  let file = ''
  let lnum = 0
  redir => output
  silent exec 'verbose hi '..a:hlname
  redir END
endfunc

command! -nargs=? JumpToHighlightDefinition call JumpToHighlightDefinition(<f-args>)


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
