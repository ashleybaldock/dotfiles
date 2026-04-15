if exists("g:mayhem_loaded_synfo")
  finish
endif
let g:mayhem_loaded_synfo = 1


" TODO - add to symbols repository when implemented
let s:symbols = get(g:, 'mayhem_symbols_synfo', #{
      \ linksto: '⫘⃗ ',
      \ cleared: '􀣦',
      \ loop: '􀱨',
      \ fg: '􀯮',
      \ bg: '􀯯',
      \ color: '􀂓',
      \ none: '􀂒',
      \})

let s:colors = #{
      \hidden: '#441122',
      \cleared: '#448822',
      \default: '#441188',
      \idnum: '#881188',
      \idsep: '#991144',
      \linksto: '#994400',
      \}

" Reset index for generating text property ids
let s:lastAdhocHlGroupId = 1000

" TODO recycle highlight groups & limit number used for adhoc groups
function! s:nextAdhocHighlightId()
  let s:lastAdhocHlGroupId = s:lastAdhocHlGroupId + 1
  return 'synfo' .. s:lastAdhocHlGroupId
endfunc

"
" Formats character info for display in SynFo popup
" See: ../autoload/charinfo.vim
"
function! s:FormatCharInfoForSynFo(arg = v:null)
  let chfo = charinfo#get(a:arg)

  return #{text: chfo['characterise_output'], props: []}
endfunc

" command! -bar -nargs=0 CharInfoToggle Toggle g:mayhem_hl_auto_charinfo<CR>

" Follow links to the end (or until detecting a loop)
function s:FormatLinkChain(name)
  let lineParts = []
  let seen = {}
  let nextname = a:name
  let done = v:false
  while !done
    let hl = hlget(nextname)->get(0)
    let seen[hl.name] = v:true
          " \   fg: get(hl, 'guifg', ''),
          " \   bg: get(hl, 'guibg', ''),
          " \   sp: get(hl, 'guisp', ''),
          " \   gui: get(hl, 'gui', #{})
    let lineParts += [
          \ #{
          \   t: get(hl, 'name', '???'),
          \  hi: get(hl, 'name', ''),
          \ },
          \ #{t: '❘', fg: s:colors.idsep},
          \ #{t: format#numbers(get(hl, 'id', 0), 'sans'), fg: s:colors.idnum},
          \]
    if has_key(hl, 'linksto')
      if has_key(seen, hl.linksto)
        let lineParts += [
              \#{t: ' '},
              \#{t: s:symbols.loop, fg: s:colors.loop},
              \]
        let done = v:true
      else
        let lineParts += [
              \#{t: ' '},
              \#{t: s:symbols.linksto, fg: s:colors.linksto},
              \#{t: ' '},
              \]
        let nextname = get(hl, 'linksto', '')
      endif
    else
      let done = v:true
    endif
  endwhile
  return lineParts
endfunc

"    𝖱𝗈𝗐 𝟤𝟥 | 𝖢𝗈𝗅𝟦𝟧 | 𝖵𝖢𝗈𝗅𝟧𝟦  
function s:GetFormattedPositionInfo(maxlines = 20) abort
  let cc = charcol('.')
  let vc = virtcol('.')
  let bc = col('.')
  let col = printf('𝖢𝗈𝗅%s', format#numbers(cc))
  let vcol = printf('𝖵𝖢𝗈𝗅%s', format#numbers(vc))
  let byte = printf('ʙʏᴛᴇ%s', format#numbers(bc))
  let numbers = printf('𝖱𝗈𝗐 %s | %s%s%s',
        \ format#numbers(line('.')),
        \ col,
        \ cc == vc ? '' : printf(' | %s', vcol),
        \ cc == bc ? '' : printf(' | %s', byte))
  return #{text: printf('%'..a:maxlines..'S', numbers), props: []}
endfunc

function! s:ForColor(color)
  if a:color == 'fg' || a:color == 'foreground'
    return [s:symbols.fg, '#333333']
  endif
  if a:color == 'bg' || a:color == 'background'
    return [s:symbols.bg, '#333333']
  endif
  if v:colornames->has_key(a:color)
    return [s:symbols.color, v:colornames[a:color]]
  endif
  if a:color =~ '^#'
    return [s:symbols.color, a:color]
  endif
  return [s:symbols.none, '#333333']
endfunc



let s:sectionBreak = #{text: '', props: []}

function! s:FormatColors()
  let [fgsymbol, fgcolor] = s:ForColor(get(val, 'guifg', ''))
  let [bgsymbol, bgcolor] = s:ForColor(get(val, 'guibg', ''))
  let [spsymbol, spcolor] = s:ForColor(get(val, 'guisp', ''))

  let colors = printf('ꜰ%sʙ%sꜱ%s', fgsymbol, bgsymbol, spsymbol)
endfunc

"
" Turns an array of text fragments with formatting instructions
" into a line of text with text properties
"
" TODO - this could be more efficient by adding a lookup dict
" for the auto-generated highlighting groups to avoid duplication
" - parts with identical formatting could share the same prop
function! s:LineWithPropsFromParts(parts, bufnr, lineconfig = #{})
  let line = ''
  let props = []
  " The column group this line uses for layout
  " Groups are defined the first time they are used,
  " and can be extended later by splitting columns.
  " A Column is referred to by a single character (e.g. a, b, c etc.)
  " A Group consists of a string of Columns and 
  "  sub-Groups [enclosed in square brackets],
  let group = get(a:lineconfig, 'g', '0]')

  for part in a:parts
    " Content:
    "
    let text = get(part, 't', '')

    " Columns:
    " Column this part is aligned within
    " - The column must exist in the group for this line
    "   (if not, behaves as if unset)
    "  If unset, uses the same column as the previous part,
    "  (if this is the first part, default to the first column)
    let col = get(part, 'col', 0)
    " Horizontal position of text within column, one of:
    "  '<-<', '>-<', '>->'
    let justify = get(part, 'j', 'start')
    " How to fill any space left before/after the justified text
    "  Given as an array of 1-3 strings, e.g.:
    "
    "  [((start, )middle)(, end)]
    "                                              1̲0̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲
    " 1:       (middle)                 ['bar'] →️ 'barbarbarb'
    " 2:       (middle/end)       ['bar','baz'] →️ 'barbarbbaz'
    " 3: (start/middle/end) ['foo','bar','baz'] →️ 'foobarbbaz'
    "
    " If there isn't enough space for all the parts the middle is
    " truncated/skipped first, then the start, then the end, e.g. 
    "                     6̲ ̲ ̲ ̲ ̲ ̲   5̲ ̲ ̲ ̲ ̲   4̲ ̲ ̲ ̲   3̲ ̲ ̲   2̲ ̲   1̲
    " ['ST','MI','EN'] →️ 'STMIEN' 'STMEN' 'STEN' 'SEN' 'EN' 'E'
    "
    let pad = get(part, 'pad', ['start'])

    " highlighting group to use for this part
    " if any of the ad-hoc highlighting options below are given,
    " then this serves as a base for them to modify
    let hi = get(part, 'hi', '')
    let base = hlget(hi, v:true)->get(0, #{})
    let adhoc = #{}
    " ad-hoc highlighting
    " if 'hi' is also set, it is copied and these act as overrides
    let adhoc['guifg'] = get(part, 'fg', get(base, 'guifg', 'NONE'))
    let adhoc['guibg'] = get(part, 'bg', get(base, 'guibg', 'NONE'))
    let adhoc['guisp'] = get(part, 'sp', get(base, 'guisp', 'NONE'))
    " let adhoc['gui'] = get(part, 'gui', get(base, 'gui', 'NONE'))

    if !mayhem#keysMatch(base, adhoc, ['guifg', 'guibg', 'guisp', 'gui'])
      let name = s:nextAdhocHighlightId()

      let adhoc['name'] = name
      call hlset([adhoc])
      try
        call prop_type_change(name, #{ bufnr: a:bufnr, highlight: adhoc.name})
      catch /^Vim\%((\a\+)\)\=:E971:/
        call prop_type_add(name, #{ bufnr: a:bufnr, highlight: adhoc.name})
      endtry
      let props += [#{
            \ col: strlen(line) + 1,
            \ length: strlen(text),
            \ id: name,
            \ type: name,
            \}]
    else
      let name = 'synfohi' .. base.name
      try
        call prop_type_change(name, #{ bufnr: a:bufnr, highlight: base.name})
      catch /^Vim\%((\a\+)\)\=:E971:/
        call prop_type_add(name, #{ bufnr: a:bufnr, highlight: base.name})
      endtry
      let props += [#{
            \ col: strlen(line) + 1,
            \ length: strlen(text),
            \ id: name,
            \ type: name,
            \}]
    endif
    let line = line .. text
  endfor
  return #{text: line, props: props}
endfunc

function! s:UpdateSynFoBuffer(winid)
  let bufnr = winbufnr(a:winid)

  " Replacement buffer contents
  let lines = []

  "
  " Top Level Highlight Info:
  "

  " ⎢ ᴅ  9999: SomeGroup fg:􀏄 bg:􀏄 sp:􀏄 gui: 􀅓􀅔􀅕􀅖􀨡􂏾   ⎥

  " val:    
  "   ᴄ cleared ᴅ default : <bool>
  "   gui : <attributes> | guibg guifg guisp : <color>
  "   id : <number>
  "   linksto : <string>
  "   name : <string>
  "
  "   cterm : <attributes> | ctermbg ctermfg ctermul : <color-nr>
  "   term: <attributes>
  "   start stop font
  "
  " <color>: 􀂓#RRGGBB 􀯯bg,background 􀯮fg,foreground 􀂒NONE
  " <attributes>:
  "   - 􀅓bold 􀅔italic 􂏾 [re/in]verse 􀨡standout 􀅖strikethrough¹
	"   - 􀅕under[line/curl¹/double¹/dotted¹/dashed¹]
  "   - nocombine² NONE³
  for val in synID(line("."), col("."), 1)
        \->synIDtrans()
        \->synIDattr("name")
        \->hlget(v:true)
    let lineParts = [
          \#{t: '  ' .. get(val, 'name', '???')
          \ .. format#numbers(val.id, 'sup'), col: 2}]

    let [fgsymbol, fgcolor] = s:ForColor(get(val, 'guifg', ''))
    let [bgsymbol, bgcolor] = s:ForColor(get(val, 'guibg', ''))
    let [spsymbol, spcolor] = s:ForColor(get(val, 'guisp', ''))

    let lineParts += [
          \ #{t: ' '}, #{t: fgsymbol, fg: fgcolor, col: 3},
          \ #{t: ' '}, #{t: bgsymbol, fg: bgcolor, col: 3},
          \ #{t: ' '}, #{t: spsymbol, fg: spcolor, col: 3},
          \]

" 􀣤 􀏃 􀣦􀂒􀃰􀃲   􁄻  
" ⎢╶─╴wincolor╶────────────────╴𐔥ɢ-️ⲃɢ-️ꮪᴩ╶───╴ɢᴜɪ╶──╺·️╸──╸·️╺──╴⎥
" ⎛  ★   ꜰ􀂓ʙ􀯮ꜱ􀂒 (􀅓􀅔􀅕􀅖􀨡􂏾 )              ⎞
"                                         𐔥ɢ ʙɢ ꮪꮲ  ʀᴠ ꭱꮩ    
"
" ⎛                                          ─╸SynFo╺─  ⎞
" ⎢╶╶ No highlighting here ╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴⎥
" ⎢                                                     ⎥
" ⎢╶─╴default╶─────────────────╴𐔥ɢ·️ⲃɢ·️ꮪꮲ╶╴ɢᴜɪ╶──────╴ꭱꮩ╶⎥
" ⎢     ╰‣️Normal❘𝟤❘􀮵           􀂓 􀯮 􀂒  􀅓􀅔􀅕􀅖􀨡 􂏾  ⎥
"
" col1|     col2  width:fit    |     col3  width:22    |
"  w:2|                        |                       |
"
" ⎛╶─⸻ˢ️ʸ︎ⁿ⸻ᶠ︎ᴼ╶─────────────────╍╴𐔥ɢ·️ⲃɢ·️ꮪꮲ╶╍╴ɢᴜɪ╶───────╴⎞
" ⎢★️ ᴅ⎧cssUrlFunction❘𝟤𝟥𝟦𝟧􀮵    􀂓 􀯮 􀂒  􀅓􀅔􀅕􀅖􀨡 ꭱ ⎥
" ⎢   │╰‣️Statement❘𝟤𝟥𝟦􀮵        ╶╶╶╶╶╶╶╶╶╶􀉣╴╴╴╴╴╴╴╴╴╴ ⎥
" ⎢   │  ╰‣️Constant❘𝟧𝟧𝟧𝟧􀮵      ╶╶╶╶╶╶╶╶╶╶􀉣╴╴╴╴╴╴╴╴╴╴ ⎥
" ⎢ ᴄ ⎧cssUrl❘􀮵                􀂓 􀯮 􀂒  􀅓􀅔􀅕􀅖􀨡   ⎥
" ⎢  ᴅ⎧cssParam❘􀮵              􀂓 􀯮 􀂒  􀅓􀅔􀅕􀅖􀨡   ⎥
" ⎢╶─╴wincolor╶───────────────╍╴𐔥ɢ·️ⲃɢ·️ꮪꮲ╶╍╴ɢᴜɪ╶───────╴⎥
" ⎢     ╰‣️BaseWin❘𝟤𝟥𝟦❘􀮵        􀂓 􀯮 􀂒  􀅓􀅔􀅕􀅖􀨡   ⎥
" ⎢                             􀆃 􀆃 􀆃️ 􀃪􀃫           
" ⎢ ╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺          ꛱ ꛱               ⎥
" ⎢ ⎪ cᷟ⃝  ⎪ c  ◌ᷟ  ◌⃝                                     ⎥
" ⎢ ╺╺╺╺╺╺╺┍╺╺┍╺╺┍╺╺╺╺╺╺╺╺╺╺╺                          ⎥
" ⎢    x63╶╯  │  │                                     ⎥
" ⎢     u1ddf╶╯  │                                     ⎥
" ⎢        u20dd╶╯                                     ⎥
" ⎢                                                    ⎥
" ⎢ ╭╶╶╶╶╭╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶                             ⎥
" ⎢ ⎪ cᷟ⃝  ⎪ c  ◌ᷟ  ◌⃝                                     ⎥
" ⎢ ╰╶╶╶╶╰╴╤═ ╤═ ╤═╶╶╶╶╶                               ⎥
" ⎢    x63╶╯  │  │                                     ⎥
" ⎢     u1ddf╶╯  │                                     ⎥
" ⎢        u20dd╶╯                                     ⎥
" ⎢                                                    ⎥
" ⎢   ╰{️   ⎭                                           ⎥
" ⎢                                                    ⎥
" ⎢ ⎧ cᷟ⃝     ⎫                      𐔥ɢ ʙɢ ꮪꮲ  ʀᴠ ꭱꮩ     ⎥
" ⎢ ╰⎧ c    ⎪                                          ⎥
" ⎢  ╰⎧ ◌ᷟ   ⎪                                          ⎥
" ⎢   ╰{️ ◌⃝  ⎭                                          ⎥
" ⎢                                                    ⎥
" ⎢                                ᴝ ᵙᵞᶂᶡᶠ             ⎥
" ⎝  ─╸𝖱𝗈𝗐 𝟤𝟥 | 𝖢𝗈𝗅𝟦𝟧 | 𝖵𝖢𝗈𝗅𝟧𝟦╺─                       ⎠

    " Gui: (bold/underline etc.)
    let gui = get(val, 'gui', {})

    let lineParts += [
          \ #{t: ' ', col: 3},
          \ #{t: '􀅓', fg: get(gui, 'bold', v:false) ? v:none : s:colors.hidden, col: 3},
          \ #{t: '􀅔', fg: get(gui, 'italic', v:false) ? v:none : s:colors.hidden},
          \ #{t: get(gui, 'underdouble', v:false) ? '􃐊' : '􀅕',
          \ fg: (get(gui, 'underline', v:false)
          \   || get(gui, 'undercurl', v:false)
          \   || get(gui, 'underdotted', v:false)
          \   || get(gui, 'underdashed', v:false)
          \   || get(gui, 'underdouble', v:false)) ? v:none : s:colors.hidden, col: 3},
          \ #{t: '􀅖', fg: get(gui, 'strikethrough', v:false) ? v:none : s:colors.hidden, col: 3},
          \ #{t: '􀨡', fg: get(gui, 'standout', v:false) ? v:none : s:colors.hidden, col: 3},
          \ #{t: '􂏾️ ', fg: (get(gui, 'inverse', v:false)
          \ || get(gui, 'reverse', v:false)) ? v:none : s:colors.hidden, col: 3},
          \ #{t: ' ', col: 3},
          \]

"          underline    U U̲ U̳ U ＿⎯ ￣〰 ⋯⋯ ══ ﹍＿﹏﹋
"          undercurl    〰﹏⌇
"          underdotted  ᠃᠃ ＿ …︙⠉⠉⡇⡈⡑⠈⠉⧙⦙⫶
"          underdashed  ﹉﹍
"          underdouble  ══ ║॥ 

    call add(lines, s:LineWithPropsFromParts(lineParts, bufnr))
  endfor

  if len(lines) == 0
" ⎢╶╶ No highlighting here ╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴⎥
    let nohlParts = [
          \ #{t: '╶╶ ', fg: s:colors.hidden, hi: 'SlHomeMN', col: 1},
          \ #{t: 'No highlighting here', hi: 'SlHomeMC', col: 2},
          \ #{t: ' ╴', fg: s:colors.hidden, hi: 'SlHomeMN', pad: '╴', col: 2},
          \ #{t: '╴', fg: s:colors.hidden, hi: 'SlHomeMN', pad: '╴', col: 3},
          \]
    call add(lines, s:LineWithPropsFromParts(nohlParts, bufnr))
  endif

  if &l:wincolor != '' 
" ⎢╶─╴default╶─────────────────╴𐔥ɢ·️ⲃɢ·️ꮪꮲ╶╴ɢᴜɪ╶─────╴ꭱꮩ╶╴⎥
" ⎢╶─╴wincolor╶────────────────╴𐔥ɢ ⲃɢ ꮪꮲ╶───╴ɢᴜɪ╶──────╴⎥
" ⎢╶─╴wincolor╶────────────────╴𐔥ɢ ⲃɢ ꮪꮲ╶───╴ɢᴜɪ╶──────╴⎥
    call add(lines, #{text: 'base(wincolor): ' .. &l:wincolor, props: []})
    let nohlParts = [
          \ #{t: '╶╶ ', fg: s:colors.hidden, hi: 'SlHomeMN', col: 1},
          \ #{t: '╴wincolor╶', hi: 'SlHomeMC', col: 2},
          \ #{t: ' ╴', fg: s:colors.hidden, hi: 'SlHomeMN', pad: '╴', col: 2},
          \ #{t: '╴', fg: s:colors.hidden, hi: 'SlHomeMN', pad: '╴', col: 3},
          \]
    call add(lines, s:LineWithPropsFromParts(nohlParts, bufnr))
  else
    call add(lines, #{text: 'base: ' .. get(hlget('Normal'), 'guifg', ''), props: []})
  endif

  "
  " TODO Conceal Info:
  "

  "
  " TODO Fold Info:
  "

  call foldlevel('.') " level of current fold
  call foldclosed('.') " -1 = not in closed fold, else first line of that fold
  call foldclosedend('.') " -1 = not in closed fold, else last line of that fold
  call foldtextresult('.')
  "
  " Synstack:
  "
  if !exists("*synstack")
    call add(lines, #{text: 'Synstack Unavailable', props: []})
  else
    let stack = synstack(line('.'), col('.'))->map(
          \{_,v -> synIDattr(v, 'name')->hlget()[0]})

    " Stack:
    for val in reverse(stack)
      let lineParts = [
            \ #{t: (get(val, 'cleared') ? 'ᴄ' : ' '), fg: s:colors.cleared},
            \ #{t: (get(val, 'default') ? 'ᴅ' : ' '), fg: s:colors.default},
            \]
      let lineParts += s:FormatLinkChain(val.name)

      call add(lines, s:LineWithPropsFromParts(lineParts, bufnr))
    endfor
  end

  call add(lines, s:sectionBreak)

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
  call add(lines, s:FormatCharInfoForSynFo())

  call add(lines, s:sectionBreak)

  "
  " Position Info:
  "
  call add(lines, s:GetFormattedPositionInfo(max(mapnew(lines, {_, line -> line['text']}))))

  call popup_settext(a:winid, lines)
endfunc

function s:SynFoPopupFilter(winid, key) abort
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

function s:SynFo() abort
  if get(w:, 'mayhem_synfo_winid', 0)
        \->popup_getpos()
        \->empty()
    let w:mayhem_synfo_winid = popup_create('', #{
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
          \ title: ' ★️ '
          \})
  else
    call popup_move(w:mayhem_synfo_winid, #{
          \ pos: 'topleft',
          \ line: 'cursor+2',
          \ col: 'cursor',
          \ minwidth: 30,
          \ maxwidth: 80,
          \ minheight: 3,
          \})
    call popup_setoptions(w:mayhem_synfo_winid, #{
          \ title: ' ★ '
          \})
    call popup_show(w:mayhem_synfo_winid)
  endif

  call s:UpdateSynFoBuffer(w:mayhem_synfo_winid)
endfunc

command! -bar SynFo call <SID>SynFo()

command! SynFoBuf vsp|enew|call <SID>UpdateSynFoBuffer(winnr())

function! s:SynFoClose(winid = win_getid()) abort
  let popid = winnr(a:winid)->getwinvar('mayhem_synfo_winid', 0)
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


" 
" Get expanded hl definition for word under cursor
" e.g.
" Constant   ->   Constant
function! s:ExpandHiGroup(name = expand("<cword>")) abort
  let hinfo = ExecAndReturn('hi ' .. a:name)
  return a:name .. ' ' .. substitute(hinfo, '^\S\+\s\+\S\+\s\+', '', '') 
endfunc
command! -bar -nargs=? ExpandHiGroup echo <SID>ExpandHiGroup(<q-args>)

"
" Open location where hl group was last set
"
" By default, uses the word under the cursor
"
function! HiDefinition(hlname = expand("<cword>"))
  let file = ''
  let lnum = 0
  try
    let [path, line] = matchlist(ExecAndReturn('verbose hi ' .. a:hlname), 'Last set from \(.\+\) line \(\d\+\)')[1:2]
  catch
    echo 'Highlight group ''' .. a:hlname .. ''' does not exist'
    return
  endtry

  echo 'Highlight group ''' .. a:hlname .. ''' last defined: ''' .. path .. ':' .. line ..''''
  return path .. ':' .. line
endfunc

command! -bar -nargs=? HiDefinition echo <SID>HiDefinition(<q-args>)

