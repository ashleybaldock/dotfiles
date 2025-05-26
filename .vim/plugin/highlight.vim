if exists("g:mayhem_loaded_highlight")
  finish
endif
let g:mayhem_loaded_highlight = 1


" TODO - add to symbols repository when implemented
let s:symbol_linksto = get(g:, 'mayhem_symbol_hihi_linksto', '⫘⃗ ')


"
" Has two implementations, this one uses `syn match`
"
" function! s:AddSynMatch(name) abort
"   exec 'syn match ' .. a:name .. ' /\<' .. a:name .. '\>/'
"     \ .. ' contained contains=NONE containedin=VimHiGroup'
"   return a:name
" endfunc

"
" TODO convert this to vim9script for speed
function! s:HighlightHighlight()
  call autocmd_add([#{
        \ event: 'ColorScheme', pattern: 'vividmayhem',
        \ cmd: 'call s:HighlightHighlight()',
        \ group: 'mayhem_hihi_colorscheme_event', replace: v:true,
        \}])

  let hlgroups = hlget()

  for hlgroup in hlgroups
    " echo hlgroup['name']
    exec 'syn match' hlgroup['name'] '/\<' .. hlgroup['name'] .. '\>/'
          \ ' contained contains=NONE containedin=VimGroupName,VimHiGroup,VimGroup'
  endfor
endfunc

function! s:NoHighlightHighlight()
  call autocmd_delete([#{
        \ event: 'ColorScheme', pattern: 'vividmayhem',
        \ group: 'mayhem_hihi_colorscheme_event',
        \}])

  syn enable
endfunc


  " e.g.:
  " syn match HlMkDnCdDelim /\<HlMkDnCdDelim\>/ contained contains=NONE containedin=VimHiGroup
  "
  " TODO - match hi commands after |
  "      - parse output of :hi to get all groups
  "      - use functions instead of commands + make vim9script
  "
  " let w:synmatches = []
  " %s/^:\?hi\w*\s\+\%(clear\)\@!\%(def\w*\s*\)\?\%(link\s*\)\?\<\zs\(\w\+\)\ze\>/\=w:synmatches->add(submatch(0))/ne
  " %s/^:\?syn\w*\s\+\%(match\|region\|keyword\)\s\+\<\zs\(\w\+\)\ze\>/\=w:synmatches->add(submatch(0))/ne
  " for synmatch in w:synmatches
  "   silent exec 'syn match ' .. synmatch .. ' /\<' .. synmatch .. '\>/'
  "     \ .. ' contained contains=NONE containedin=VimGroupName,VimHiGroup,VimGroup'
  " endfor
" endfunc

command! -bar HiHi call <SID>HighlightHighlight()


"
" See: ./sfsymbols.vim
"
function! s:GetCharacterInfo()
  let char = char2nr(getline('.')[col('.')-1:-1])->nr2char()
  let output = 'No Char Info'

  let info = GetSfSymbolInfo(char)
  if info.IsValid()
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
" join(chain, '▶︎▬ᷞ▬ͥ▬ᷠ▬ᷜ▶︎') join(chain, ' ▬▶︎ ') join(chain, ' -> ') join(chain, ' ʟɪɴ͢ᴋ ')
"
"  􀯭 􀯮 􀯯 􁉽 􁋼 􁉼 􁋽 􁋛 􁋜 􀯰 􁌅 􀯱 􀯲 􀯳 􁊕
"􀅓􀅔 􀅕 􀅖 􀨡 

" 􀑋 􀑍 􀯴 􀮵 􀺾 􀿨 􀑏 􁂠 􂡆  􀿫 􂞹 􂞺  􀿪􁰏 
" 􀑌 􀑎 􀯵 􀮶 􀻀 􀿩 􀑐 􁂡 􂡇  􀭨 
" 
" 􀭅 􀆗􀆛􀆙
" 􁚀 􀆘􀆜􀆚
" 􀃬􀃮􀃜􀃞
" 􀣤 􀏃 􀣦􀂒􀃰􀃲 
" 􀣥 􀏄 􀣧􀂓􀃱􀃳
" 􁄻 transparent

" ⎛  ★   fg:􀏄 bg:􀏄 sp:􀏄  􀅓􀅔􀅕􀅖􀨡 􂏾             ⎞
" ⎢ ᴅ  1234: cssUrlFunction  S️tatement               ⎥
" ⎢  ᴄ  567: cssAttrRegion                           ⎥
" ⎢  ᴄ   89: cssDefinition                           ⎥
" ⎝                        Synstack @ Row 62 Col 39  ⎠
"
" ⎛  ★         􀅓️⃝ 􀅔️⃝ 􀅕️⃝ 􀅖️⃝ 􀨡️⃝     􂏾️⃝                  ⎞
"
" ⎛  ★   fg:􀂓 bg:􀂓 sp:􀂓  􀅓 􀅔 􀅕 􀅖 􀨡    􂏾    ⎞
" ⎢ ᴅ  1234: cssUrlFunction  S️tatement               ⎥
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
" fg=􀏄 bg=􀏄 sp=􀏄
" fg=􀏄 bg=􀣤 sp=􀏃
"
" edit colour, rgb + hsl
"
"   ╭ #rrggbb ╮ ⎧ #rrggbb ⎫ ⎧ #rrggbb ⎫
"   ⎨ h  s  l ⎬ ⎧ h  s  l ⎫ ⎧ h  s  l ⎫
"   ⎩1️8️0️ 9️0️ 6️0️⎭ ⎩ 0  0  0 ⎭ ⎩360 1  1 ⎭
" 
"   ╭ #rrggbb ╮
"   ⎨- h 180°+⎬
"   ⎪  s .97  ⎪
"   ⎩  l .60  ⎭
" 
"   ⎬ #rrggbb ⎨
"   ⎪h1️8️0️°⎪
"   ⎪s.️9️7️ ⎪
"   ⎩l.️6️0️ ⎭
" 
"       
"   R 100  H 180
"   G  98  S  97
"   B   7  L  60
"
"   R 100%  H 180°
"   G  98%  S  97%
"   B   7%  L  60%
"                       
"                  ╭#RF1056┬􀏄
"                 􀏄╭ʜ𝟥𝟢𝟢
"                  ╰┼ꜱ.𝟫𝟫
"                   ╰ʟ.𝟢𝟩
" 100 100 100
"
"                  ╭╴ʀ‑︎ɢ‑︎ʙ
" R 100% G _98% B __7%
"        ⎵ 
"      ᴿ⃞︎]          ̲̅3̲̅3̲̅2̲̅     𝟸̲̅𝟺̲̅𝟹̲̅  𝟮̲̅𝟰̲̅𝟯̲̅ 𝟣̲̅𝟥̲̅𝟧̲̅ 𝟑̲̅𝟔̲̅𝟎̲̅
"
          "\ ' SynFo @️ ʀ̲̅%s |ᴄ|%s ʙ𝗒%s',
"        𝘤𝘰𝘭 𝘳𝘰𝘸   
"
" ╷   ╷   ╷ 80╷
" ⎝            Synstack @   Rʷ̲ 62 Cˡ 39  ⎠      ╵Vr╴╵Ch╴╵Col╵
"
" ⎝       Synstack @ row _6̲2̲_ │ ͦͨͮͮ ͦ︎ ͦͨʰʰ️ʰ︎ˡ39│ᵛᵛ️ᵛ︎ ͨͮ35│ ͪͨ29│️ 39 [v 35|c 35]   ⎠
"     3̲̅9̲̅   ⏐62⏐
" 
" ᴿᴼᵂᴿ️ᴼ️ᵂ️ᴿ⃞︎ ᴼ⃞︎ ᵂ⃞︎ ʳᵒʷʳ️ᵒ️ʷ️ʳ⃞︎ ᵒ⃞︎ ʷ⃞︎   ⁿⁿⁿʲʲʲʰʰʰˡˡˡʷʷʷ   ┐├▻ ◁┤ ├─▸ ◄─┤ ◂─┤ ◀︎─┤ 
" ᴸᴼᴬᴰᴸ️ᴼ️ᴬ️ᴰ️ᴸ︎ᴼ︎ᴬ︎ᴰ︎  ᴏ                             ''
"   ʳᵒʷ ᶜᵒˡ ᵛᐧᶜᵒˡ ᶜʰᐧᶜᵒˡ ᵇʸᵗᵉᐧ                ''
"   ᴿᵒʷ ᶜᵒˡ ᵛꜞʳᵗᐧᶜᵒˡ ᶜʰᐧᶜᵒˡ          V
"   Rᵒʷ ᴄᵒˡ vᶜᵒˡ chᶜᵒˡ  R C V H ᴠ Vˡͦͨ ᶜᵒˡCᴏʟ |️ᴄ|️ ʜᶜᵒˡCᴏʟͦ  ᴠɪᴛCᴏʟ ʜᴀCᴏ   ▕️  ʀ̲̅
"
" ᵛᵥᵛ️ᵥ️ᵛ︎ᵥ︎ ˯˰˱͔˲͕ ˱͕˲͔ ˱͐˲͐ ˖̝˖˖️̝˗˗️ ˳̣˳̣️.̣.̣️ ˌ̩˯̩ ::️˸˸ ᵣᵣ️ᵣ︎ ᶜᵒᶫˣʼ̊ᶜ️ᵒ️ᶫ️ˣ️ʼ̊️ᶜ︎ᵒ︎ᶫ︎ˣ︎ʼ̊︎ ˤʕʖʔ ⎥  ͖ ˪˫ . |̴̰ ‖̻⸋⸋️⸋︎⸋̻︎‖̪ ‖̝
"
"   ˹˺˻˼˽˾ꜚ˿ ̚  ˺͐ ‿ˌ  ˲͕͐ ˱͔ 
          
"                                           
function! s:ForColor(color)
  if a:color == 'NONE'
    return ['􀣤', '#333333']
  endif
  if a:color == 'fg' || a:color == 'foreground'
    return ['􀯮', '#333333']
  endif
  if a:color == 'bg' || a:color == 'background'
    return ['􀯯', '#333333']
  endif
  if v:colornames->has_key(a:color)
    return ['􀏄', v:colornames[a:color]]
  endif
  if a:color =~ '^#'
    return ['􀏄', a:color]
  endif
  return ['􀏃', '#333333']
endfunc

function! s:UpdateSynFoBuffer(winid)     
  let bufnr = winbufnr(a:winid)

  " Replacement buffer contents
  let lines = []

  "
  " Top Level Highlight Info:
  "
  let results = synID(line("."), col("."), 1)->synIDtrans()->synIDattr("name")->hlget(v:true)

  " ⎢ ᴅ  9999: SomeGroup fg:􀏄 bg:􀏄 sp:􀏄 gui: 􀅓􀅔􀅕􀅖􀨡􂏾   ⎥

  for val in results
    let [fgsymbol, fgcolor] = s:ForColor(get(val, 'guifg', ''))
    let [bgsymbol, bgcolor] = s:ForColor(get(val, 'guibg', ''))
    let [spsymbol, spcolor] = s:ForColor(get(val, 'guisp', ''))

    let colors = printf('fg:%s bg:%s sp:%s', fgsymbol, bgsymbol, spsymbol)

    call hlset([{'name': 'HlSynfoFG', 'guifg': fgcolor}])
    call hlset([{'name': 'HlSynfoBG', 'guifg': bgcolor}])
    call hlset([{'name': 'HlSynfoSP', 'guifg': spcolor}])

    call clearmatches(a:winid)
    call matchadd('HlSynfoFG', 'fg:\zs􀏄\ze\s', 10, -1, {'window': a:winid})
    call matchadd('HlSynfoBG', 'bg:\zs􀏄\ze\s', 10, -1, {'window': a:winid})
    call matchadd('HlSynfoSP', 'sp:\zs􀏄\ze\s', 10, -1, {'window': a:winid})

" 􀣤 􀏃 􀣦􀂒􀃰􀃲 
" ⎛  ★   fg:􀏄 bg:􀏄 sp:􀏄  􀅓􀅔􀅕􀅖􀨡 􂏾             ⎞
"
" ⎛  ★                                               ⎞
" ⎢   fg:􀏄 bg:􀏄 sp:􀏄  􀅓􀅔􀅕􀅖􀨡 􂏾             ⎥
" ⎢ ᴅ  1234: cssUrlFunction  S️tatement               ⎥
" 
    " Gui: (bold/underline etc.)
    let gui = get(val, 'gui', {})


    let flags = [
          \ 'gui:',
          \ get(gui, 'bold', v:false) ? '􀅓' : '  ',
          \ get(gui, 'italic', v:false) ? '􀅔' : '  ',
          \ get(gui, 'underline', v:false) ? '􀅕' : '  ',
          \ get(gui, 'strikethrough', v:false) ? '􀅖' : '  ',
          \ get(gui, 'undercurl', v:false) ? 'uc ' : '   ',
          \ get(gui, 'underdotted', v:false) ? 'ud ' : '   ',
          \ get(gui, 'underdashed', v:false) ? 'us ' : '   ',
          \ get(gui, 'underdouble', v:false) ? 'u2 ' : '   ',
          \ (get(gui, 'inverse', v:false)
          \ || get(gui, 'reverse', v:false)) ? '􂏾️⃝  ' : '   ',
          \ get(gui, 'standout', v:false) ? '􀢒️⃝ ' : '   ',
          \]->join(' ')

    let res = '  ' .. printf('%5S: ', val.id) .. 
          \ colors .. ' ' .. flags

    call add(lines, res)
  endfor
  if len(lines) == 0
    call add(lines, 'No highlighting here')
  endif

  "
  " TODO Conceal Info:
  "

  "
  " Synstack:
  "
  if !exists("*synstack")
    call add(lines, 'Synstack Unavailable')
  else
    let stack = synstack(line('.'), col('.'))->map(
          \{_,v -> synIDattr(v, 'name')->hlget()[0]})

    " Stack:
    for val in reverse(stack)
      let res = ""
      let res = (get(val, 'cleared') ? 'ᴄ' : ' ') .. res
      let res = (get(val, 'default') ? 'ᴅ' : ' ') .. res
    " Id:
      let res = res .. printf('%5S: ', val.id)
    " Hide intermediate links in chain to save space?       TODO
      if (get(val, 'linksto', "") != "")
        let chain = s:GetLinkChain(val.name)
        let matchids = mapnew(chain,
              \ {i, link -> 
              \  win_execute(a:winid, 'call matchadd('''
              \  .. link .. ''', ''\<' .. link .. '\>'')'  )})
        let res = res .. join(chain, ' ' .. s:symbol_linksto ..' ')
      else
        let res = res .. val.name
      endif
      let res = res .. ''

      call add(lines, res)
    endfor
  end

  "
  " TODO Text Object Info:
  "

  "
  " TODO Sign Info:
  "

  "
  " Character Info:
  "
  " let charinfo = printf('%'..longest..'S', ExecAndReturn('Characterize'))
  let [charinfo] = s:GetCharacterInfo()
  call add(lines, charinfo)

  "
  " Position Info:
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
  let title = printf('%'..max(lines)..'S', numbers)
  " let title = printf('%'..longest..'S', printf(' SynStack @ Row %s Col %s (V %s H %s)', line('.'), col('.'), virtcol('.'), charcol('.')))
  " call setbufline(bufnr, max([4, i + 1]), title)
  call add(lines, title)

  silent call deletebufline(bufnr, 1, '$')

  call appendbufline(bufnr, 0, lines)

endfunc

function s:SynFoPopupFilter(winid, key)
  " if a:key == '<LeftMouse>'
  "   let contents = getbufline(winbufnr(a:winid), 1, '$')
  "   echom contents
  "   :vsp|enew|call map(contents, {_, val -> appendbufline(bufnr(), 1, val) })|setlocal nomodified nomodifiable
  "   return 0
  " endif
    " return 0
  " endif
  if a:key == 'x'
    call s:SynFoDisable()
    call s:SynstackSetup()
    return 1
  endif
  return 0
endfunc

function s:SynFo()
  if empty(popup_getpos(get(w:, 'mayhem_winid_synfo', 0)))
    let w:mayhem_winid_synfo = popup_create('', #{
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
          \ filter: 's:SynFoPopupFilter',
          \ filtermode: 'n',
          \ title: ' ★ '
          \ })
  else
    call popup_move(w:mayhem_winid_synfo, #{
          \ pos: 'topleft',
          \ line: 'cursor+2',
          \ col: 'cursor',
          \ minwidth: 30,
          \ maxwidth: 80,
          \ minheight: 3,
          \ title: ' ꛵ '
          \ })
  endif

  call s:UpdateSynFoBuffer(w:mayhem_winid_synfo)
endfunc

command! -bar SynFo call <SID>SynFo()

command! SynFoBuf vsp|enew|call <SID>UpdateSynFoBuffer(winnr())

function! s:SynFoClose(winid = win_getid()) abort
  let popid = getwinvar(winnr(a:winid), 'mayhem_winid_synfo', 0)
  if popid > 0 && !empty(popup_getpos(popid))
    call popup_close(popid)
  endif
endfunc

function! s:SynFoSetup() abort
  if exists(w:mayhem_synfo_enabled)
  call autocmd_add([#{
        \ event: 'CursorHold', pattern: '*',
        \ cmd: 'if w:mayhem_synfo_enabled == 1 | call s:SynFo() | else | call s:SynFoClose() | endif',
        \ group: 'mayhem_synfo', replace: v:true,
        \}])
  endif
endfunc

function! s:SynFoDisableInWindow(winid = win_getid()) abort
  call setwinvar(winnr(a:winid), 'mayhem_synfo_enabled', 0)
  call s:SynFoSetup()
endfunc

function! s:SynFoDisableInAll() abort
  for wn in range(1, winnr('$'))
    call setwinvar(wn, 'mayhem_synfo_enabled', 0)
  endfor
  call s:SynFoSetup()
endfunc

function! s:SynFoEnableInWindow(winid = win_getid()) abort
  call setwinvar(winnr(a:winid), 'mayhem_synfo_enabled', 0)
  call s:SynFoSetup()
endfunc

function! s:SynFoToggleInWindow(winid = win_getid()) abort
  call setwinvar(winnr(a:winid), 'mayhem_synfo_enabled',
        \ !getwinvar(winnr(a:winid), 'mayhem_synfo_enabled', 0))
  call s:SynFoSetup()
endfunc

function! s:SynFoToggleInWindow(winid = win_getid()) abort
  return getwinvar(winnr(a:winid), 'mayhem_synfo_enabled', 0)
endfunc

command! -nargs=? SynFoStatus call <SID> SynFoStatus(<f-args>)

command! -nargs=? SynFoAuto call <SID>SynFoEnable(<f-args>)

command! -nargs=? SynFoWindowOn call <SID>SynFoEnableInWindow(<f-args>)

command! -nargs=? SynFoWindowOff call <SID>SynFoDisableInWindow(<f-args>)

command! SynFoAllOff call <SID>SynFoDisableInAll()

command! -nargs=? SynFoWindowToggle call <SID>SynFoToggle(<f-args>)

" Synfo status
" Synfo win
" Synfo nowin
" Synfo no

function! s:SynfoComplete(A,L,P)
  echom A '||' L '||' P
  return [A]
endfunc
command! -nargs=? -complete=customlist,s:SynfoComplete Synfo echo <args>



command! HighlightThis hi <c-r><c-w>


" Insert the highlight entry for the current word
command! ExpandHlGroup call ExecAndPut('hi ' .. expand("<cword>"))


function! JumpToHighlightDefinition(hlname = expand("<cword>"))
  let file = ''
  let lnum = 0
  redir => output
  silent exec 'verbose hi ' .. a:hlname
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
