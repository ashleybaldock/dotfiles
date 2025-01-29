if exists("g:mayhem_loaded_highlight")
  finish
endif
let g:mayhem_loaded_highlight = 1


" TODO - add to symbols repository when implemented
let s:symbol_linksto = get(g:, 'mayhem_symbol_hihi_linksto', '⫘⃗ ')


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


"
" See: ./sfsymbols.vim
"
function! s:GetCharacterInfo()
  let char = char2nr(getline('.')[col('.')-1:-1])->nr2char()
  let output = 'No Char Info'

  if IsSfSymbol(char)
    let info = GetSfSymbolInfo(char)
    let output = ''..info['symbol']..
          \ ' '..info['code']..
          \ ' '..info['name']..' (SFSymbol)'
  else
    " TODO implement similar in ./unicode.vim and remove dep.
    if !exists('g:autoloaded_characterize')
      " Characterize's autoload uses redir, which can't be nested
      silent exec 'Characterize'
    endif
    let v:errmsg = ''
    redir => output
      silent exec 'Characterize '..char
    redir END
    if v:errmsg != ''
      echom 'Error running Characterize: '..v:errmsg
      let output = 'Char Info Err'
    else
      let output = trim(output)->split(', ')[1]
    endif
  endif
  return [output]
endfunc


" Follow links to the end (or until detecting a loop)
function s:GetLinkChain(name)
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
"􀅓􀅔
"
"􀅕
"􀅖
"􀨡
"􀅗
"􀅘􀅔
"
"
"
" ⎛                                       ⎞
" ⎢ ᴅ  1234: cssUrlFunction  S️tatement  ⎥
" ⎢  ᴄ  567: cssAttrRegion                           ⎥
" ⎢  ᴄ   89: cssDefinition                           ⎥
" ⎝                        Synstack @ Row 62 Col 39  ⎠
"
" ⎛ Synstack   fg:#aabbcc bg:#227788 sp: #445566           ⎞
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
  let default1 = 'No Highlighting Here'
  let default2 = ''
  let alt1 = 'Synstack Unavailable'
  let i = 1
  " Be better to make an array and then write               TODO
  " the buffer all at once (and handle justifying text)
  " Would also permit breaking this long function up into bits
  let longest = max([strwidth(default1), strwidth(default2)])
                                            
  call setbufline(bufnr, 1, default1)
  call setbufline(bufnr, 2, default2)

  if !exists("*synstack")
    call setbufline(bufnr, 1, alt1)
  else
    let stack = map(synstack(line('.'), col('.')),
          \ 'hlget(synIDattr(v:val, "name"))[0]')

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
    " Hide intermediate links in chain to save space?       TODO
      if (get(val, 'linksto', "") != "")
        let chain = s:GetLinkChain(val.name)
        let matchids = mapnew(chain,
              \ {i, link -> 
              \  win_execute(a:winid,
              \   'call matchadd('''..link..''', ''\<'..link..'\>'')'  )})
        let res = res .. join(chain, ' '..s:symbol_linksto..' ')
      else
        let res = res .. val.name
      endif
      let res = res .. ''
      call setbufline(bufnr, i, res)
      let longest = max([longest, strwidth(res)])
      let i = i + 1
    endfor
  endif
  "
  " Get info about character under cursor
  " let charinfo = printf('%'..longest..'S', ExecAndReturn('Characterize'))
  let [charinfo] = s:GetCharacterInfo()
  let longest = max([longest, strwidth(charinfo)])
  call setbufline(bufnr, max([3, i]), l:charinfo)
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
  call setbufline(bufnr, max([4, i + 1]), title)
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
  if empty(popup_getpos(get(w:, 'mayhem_synstack_popid', 0)))
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
          \ filtermode: 'n',
          \ title: ' ★ '
          \ })
  else
    call popup_move(w:mayhem_synstack_popid, #{
          \ pos: 'topleft',
          \ line: 'cursor+2',
          \ col: 'cursor',
          \ minwidth: 30,
          \ maxwidth: 80,
          \ minheight: 3,
          \ title: ''
          \ })
  endif

  call s:UpdateSynStackBuffer(w:mayhem_synstack_popid)
endfunc

command! -bar SynStack call <SID>SynStack()

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
    if exists(w:mayhem_synstack_enabled)
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


" Insert a highlight entry for the current word
command! ExpandHlGroup call ExecAndPut('hi '..expand("<cword>"))


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
