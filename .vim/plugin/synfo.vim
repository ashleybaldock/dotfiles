if exists("g:mayhem_loaded_synfo")
  finish
endif
let g:mayhem_loaded_synfo = 1

"
" Related:
"   $VIMHOME/notes/synfo-ui.md
"

" TODO - add to symbols repository when implemented
let s:symbols = get(g:, 'mayhem_symbols_synfo', #{
      \ linksto: '⫘⃗ ',
      \ cleared: '􀣦',
      \ loops: '􀱨',
      \ sp: '􀤑',
      \ color: '􀂓',
      \ fgcolor: '􀯮',
      \ bgcolor: '􀯯',
      \ namedcolor: '􀂯',
      \ nonecolor: '􀂒',
      \ guibold: '􀅓',
      \ guiitalic: '􀅔',
      \ guiul: '􀅕',
      \ guistrike: '􀅖',
      \ guistandout: '􀨡',
      \ guiverse: '􂏾',
      \})

let s:colors = #{
      \ none: 'NONE',
      \ hidden: '#441122',
      \ cleared: '#66aa44',
      \ default: '#8844cc',
      \ fgcolor: '#555555',
      \ bgcolor: '#555555',
      \ nonecolor: '#000000',
      \ idnum: '#884488',
      \ idsep: '#000000',
      \ linksto: '#994400',
      \ linkstoline: '#664400',
      \ loops: '#ee1111',
      \ loopsline: '#664400',
      \ row: '#cc88cc',
      \ rowval: '#dddddd',
      \ col: '#cc88cc',
      \ colval: '#dddddd',
      \ vcol: '#cc88cc',
      \ vcolval: '#dddddd',
      \ byte: '#cc88cc',
      \ byteval: '#dddddd',
      \ hasgui: '#dddddd',
      \ headingline: '#664400',
      \ headingtext: '#cc88cc',
      \}

function! s:ForColor(color) abort
  if a:color == 'fg' || a:color == 'foreground'
    return [s:symbols.fgcolor, s:colors.fgcolor]
  endif
  if a:color == 'bg' || a:color == 'background'
    return [s:symbols.bgcolor, s:colors.bgcolor]
  endif
  if v:colornames->has_key(a:color)
    return [s:symbols.namedcolor, v:colornames[a:color]]
  endif
  if a:color =~ '^#'
    return [s:symbols.color, a:color]
  endif
  return [s:symbols.nonecolor, '#333333']
endfunc

" Reset index for generating text property ids
let s:lastAdhocHlGroupId = 1000

" TODO recycle highlight groups & limit number used for adhoc groups
function! s:nextAdhocHighlightId() abort
  let s:lastAdhocHlGroupId = s:lastAdhocHlGroupId + 1
  return 'synfo' .. s:lastAdhocHlGroupId
endfunc

let s:sectionBreak = [#{t: ''}]

" ⎢                           ─╴𐔥ɢ ⲃɢ ꮪꮲ╶───╴ɢᴜɪ╶──────╴⎥
" ⎢·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️··️·️·️·️·️𐔥ɢ·️ⲃɢ·️ꮪꮲ·️·️·️·️·️ɢᴜɪ·️·️·️·️·️·️·️·️⎥
" ⎢╶───────────────────────────╴𐔥ɢ ⲃɢ ꮪꮲ╶───╴ɢᴜɪ╶──────╴⎥
let s:hi_col_headings = [
      \ #{ t: '─', fg: s:colors.headingline, repeat: v:true, col: 3 },
      \ #{ t: '╴', fg: s:colors.headingline, col: 3 },
      \ #{ t: '𐔥ɢ', fg: s:colors.headingtext, col: 3 },
      \ #{ t: '·️', fg: s:colors.headingline, col: 3 },
      \ #{ t: 'ⲃɢ', fg: s:colors.headingtext, col: 3 },
      \ #{ t: '·️', fg: s:colors.headingline, col: 3 },
      \ #{ t: 'ꮪꮲ', fg: s:colors.headingtext, col: 3 },
      \ #{ t: '╶╴', fg: s:colors.headingline, col: 3 },
      \ #{ t: 'ɢᴜɪ', fg: s:colors.headingtext, col: 3 },
      \ #{ t: '╶─────────', fg: s:colors.headingline, col: 3 }
      \]

"
" Turns an array of text fragments with formatting instructions
" into a line of text with text properties
"
" TODO - this could be more efficient by adding a lookup dict
" for the auto-generated highlighting groups to avoid duplication
" - parts with identical formatting could share the same prop
function! s:LineWithPropsFromParts(parts, bufnr, lineconfig = #{}) abort
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

    " !highlighting group to use for this part
    " if any of the ad-hoc highlighting options below are given,
    " then this serves as a base for them to modify
    let hi = get(part, 'hi', '')->hlget(v:true)->get(0, #{})
    let higui = get(hi, 'gui', #{})
    let adhoc = #{
          \ guifg: get(part, 'fg', get(hi, 'guifg', 'NONE')),
          \ guibg: get(part, 'bg', get(hi, 'guibg', 'NONE')),
          \ guisp: get(part, 'sp', get(hi, 'guisp', 'NONE')),
          \ gui: #{
          \   bold: get(part, 'b', get(higui, 'bold', 0)),
          \   italic: get(part, 'i', get(higui, 'italic', 0)),
          \   strikethrough: get(part, 's', get(higui, 'strikethrough', 0)),
          \   underline: get(part, 'ul', get(higui, 'underline', 0)),
          \   undercurl: get(part, 'uc', get(higui, 'undercurl', 0)),
          \   underdouble: get(part, 'u2', get(higui, 'underdouble', 0)),
          \   underdotted: get(part, 'ut', get(higui, 'underdotted', 0)),
          \   underdashed: get(part, 'ud', get(higui, 'underdashed', 0)),
          \   reverse: get(part, 'reverse', get(higui, 'reverse', 0)),
          \   standout: get(part, 'standout', get(higui, 'standout', 0)),
          \ },
          \}
    " ad-hoc highlighting
    " if 'hi' is also set, it is copied and these act as overrides

    if mayhem#keysMatch(hi, adhoc, ['guifg', 'guibg', 'guisp'])
          \ && mayhem#keysMatch(hi.gui, adhoc.gui, ['bold','underline','undercurl','underdouble','underdotted','underdashed','strikethrough','reverse','italic','standout'])
      let name = 'synfohi' .. hi.name
      try
        call prop_type_change(name, #{ bufnr: a:bufnr, highlight: hi.name})
      catch /^Vim\%((\a\+)\)\=:E971:/
        call prop_type_add(name, #{ bufnr: a:bufnr, highlight: hi.name})
      endtry
      let props += [#{
            \ col: strlen(line) + 1,
            \ length: strlen(text),
            \ id: name,
            \ type: name,
            \}]
    else
      let name = s:nextAdhocHighlightId()

      let adhoc['name'] = name
      if hlset([adhoc]) < 0
        echom 'hlset failed'
      else
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
      endif
    endif
    let line = line .. text
  endfor
  return #{text: line, props: props}
endfunc

function s:Render(lines, winid) abort
  let bufnr = winbufnr(a:winid)

  let linesWithProps = map(a:lines, {_, line -> s:LineWithPropsFromParts(line, bufnr)})

  return popup_settext(a:winid, linesWithProps)
endfunc



"
" Formats character info for display in SynFo popup
" See: ../autoload/charinfo.vim
"
function! s:FormatCharInfo() abort
  let chfo = charinfo#get()->get(0, #{})
  let composed = get(chfo, 'composed', '')

  let lineParts = [
        \#{t: composed},
        \#{t: ' '},
        \#{t: '='},
        \#{t: ' '},
        \]

  " let lineParts += map(chfo, {i, v -> [
  "       \ #{t: char#display(v['char'])},
  "       \ #{t: ' '},
  "       \ #{t: '+'},
  "       \ #{t: ' '},
  "       \]})

  return lineParts
endfunc

" command! -bar -nargs=0 CharInfoToggle Toggle g:mayhem_hl_auto_charinfo<CR>


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
" ⎛  ˢ️ʸ︎ⁿᶠ︎ᵒ ╶──────────────────╍╴𐔥ɢ·️ⲃɢ·️ꮪꮲ╶╍╴ɢᴜɪ╶───────╴⎞
"
" ⎛·️·️ˢ️ʸ︎ⁿᶠ︎ᵒ·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️ 𐔥ɢ ⲃɢ ꮪꮲ ·️·️·️·️ ɢᴜɪ ·️·️·️·️·️⎞
" ⎢★️ ᴅ⎧cssUrlFunction􀮵𝟤𝟥𝟦𝟧 ╶─􀉣──╌──╌──╌╌─╌─╌─╌─╌─╌─╌╴⎥
" ⎢   │╰‣️Statement❘𝟤𝟥𝟦􀮵    ╶─􀉣􀍠 􀍠 􀍠􀉣􀍠􀍠􀍠􀍠􀍠􀍠 ⎥
" ⎢   │ ╰‣️Constant❘𝟧𝟧𝟧𝟧􀮵       􀯮 􀯯 􀤑  􀅓􀅔􀅕􀅖􀨡􀂷 ⎥
" ⎢   │ ╰‣️Constant❘𝟧𝟧𝟧𝟧􀮵       ╶╶╶╶╶╶╶╶╶╶􀉣╴╴╴╴╴╴╴╴╴╴ ⎥
" ⎢ ᴄ ⎧cssUrl❘􀮵                􀂓 􀯮 􀂒  􀅓􀅔􀅕􀅖􀨡   ⎥
" ⎢  ᴅ⎧cssParam❘􀮵              􀂓 􀯮 􀂒  􀅓􀅔􀅕􀅖􀨡   ⎥
" ⎢╶─╴wincolor╶───────────────╍╴𐔥ɢ·️ⲃɢ·️ꮪꮲ╶╍╴ɢᴜɪ╶───────╴⎥
" ⎢     ╰‣️BaseWin❘𝟤𝟥𝟦❘􀮵        􀂓 􀯮 􀂒  􀅓􀅔􀅕􀅖􀨡   ⎥
" ⎢                             􀆃 􀆃 􀆃️ 􀃪􀃫           
" ⎢ ╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺╺          ꛱ ꛱               ⎥
" ⎢ ⎪ cᷟ⃝  ⎪ c  ◌ᷟ  ◌⃝                           􀓨      ⎥
" ⎢ ╺╺╺╺╺╺╺┍╺╺┍╺╺┍╺╺╺╺╺╺╺╺╺╺╺                          ⎥
" ⎢    x63╶╯  │  │                                     ⎥
" ⎢     u1ddf╶╯  │                                     ⎥
" ⎢        u20dd╶╯                                     ⎥
" ⎢                                                    ⎥
" ⎢ ╭╶╶╶╶╭╶╶╶╥╶╶╶╶╶╶╶╶╶╶╶                              ⎥
" ⎢ ⎪ cᷟ⃝  = c + ◌ᷟ + ◌⃝                                   ⎥
" ⎢ ╰╶╶╶╶╰─┬─╨─┬─╨──┬─╶╶                               ⎥
" ⎢       x63  │  u20dd                                ⎥
" ⎢          u1ddf                                     ⎥
" ⎢                                                    ⎥
" ⎢                                                    ⎥
" ⎢ ╭                                                   
" ⎢ ⎪ cᷟ⃝    c   ◌ᷟ   ◌⃝                                   ⎥
" ⎢ ╰╶╶╶╶ ┌─╴ᐩ┌─╴ᐩ┌──╴╶╶                               ⎥
" ⎢     x63   │   │                                   ⎥
" ⎢       u1ddf╶╯   │                                   ⎥
" ⎢         u20dd╶╯                                   ⎥
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

"          underline    U U̲ U̳ U ＿⎯ ￣〰 ⋯⋯ ══ ﹍＿﹏﹋
"          undercurl    〰﹏⌇
"          underdotted  ᠃᠃ ＿ …︙⠉⠉⡇⡈⡑⠈⠉⧙⦙⫶
"          underdashed  ﹉﹍
"          underdouble  ══ ║॥ 


" Follow links to the end (or until detecting a loop)
function s:FormatLinkChain(name) abort
  let lines = []
  let seen = {}
  let depth = 0
  let nextname = a:name
  let done = v:false
  while !done
    let hl = hlget(nextname)->get(0)
    let seen[hl.name] = v:true

    let [fgsymbol, fgcolor] = s:ForColor(get(hl, 'guifg', 'NONE'))
    let [bgsymbol, bgcolor] = s:ForColor(get(hl, 'guibg', 'NONE'))
    let [spsymbol, spcolor] = s:ForColor(get(hl, 'guisp', 'NONE'))
    let gui = get(hl, 'gui', {})
    let id = get(hl, 'id', 0)
    let lineParts = []

    let lineParts += [
          \ #{t: get(hl, 'cleared') ? 'ᴄ' : ' ', fg: s:colors.cleared},
          \ #{t: get(hl, 'default') ? 'ᴅ' : ' ', fg: s:colors.default},
          \ #{t: ' '}, 
          \]

    let lineParts += [
          \ #{t: depth > 0 ? repeat('  ', max([0, depth - 2])) .. '╰‣️' : ''},
          \ #{
          \   t: get(hl, 'name', '???'),
          \  hi: get(hl, 'name', ''),
          \ },
          \ #{t: '❘', fg: s:colors.idsep},
          \ #{t: format#numbers(id, 'sans'), fg: s:colors.idnum},
          \ #{t: ' '}, #{t: fgsymbol, fg: fgcolor, col: 3},
          \ #{t: ' '}, #{t: bgsymbol, fg: bgcolor, col: 3},
          \ #{t: ' '}, #{t: spsymbol, fg: spcolor, col: 3},
          \]

    if has_key(hl, 'linksto')
      if has_key(seen, hl.linksto)
" ╶╶╶╶╶╶╶╶╶ 􀱨 ╴╴╴╴╴╴╴╴╴ 
        let lineParts += [
              \#{t: ' '},
              \#{t: '╶╶╶╶╶╶╶╶╶╶', fg: s:colors.loopsline},
              \#{t: s:symbols.loops, fg: s:colors.loopsfg},
              \#{t: '╴╴╴╴╴╴╴╴╴╴', fg: s:colors.loopsline},
              \#{t: ' '},
              \]
        let done = v:true
      else
" ╶╶╶╶╶╶╶╶╶╶􀉣╴╴╴╴╴╴╴╴╴╴ 
        let lineParts += [
              \#{t: ' '},
              \#{t: '╶╶╶╶╶╶╶╶╶╶', fg: s:colors.linkstoline},
              \#{t: s:symbols.linksto, fg: s:colors.linksto},
              \#{t: '╴╴╴╴╴╴╴╴╴╴', fg: s:colors.linkstoline},
              \#{t: ' '},
              \]
        let nextname = get(hl, 'linksto', '')
      endif
    else
      let lineParts += [
          \ #{t: ' ', col: 3},
          \ #{t: '􀅓', fg: get(gui, 'bold') ? s:colors.hasgui : s:colors.hidden, col: 3},
          \ #{t: '􀅔', fg: get(gui, 'italic') ? s:colors.hasgui : s:colors.hidden},
          \ #{t: get(gui, 'underdouble') ? '􃐊' : '􀅕',
          \ fg: (get(gui, 'underline')
          \   || get(gui, 'undercurl')
          \   || get(gui, 'underdotted')
          \   || get(gui, 'underdashed')
          \   || get(gui, 'underdouble')) ? s:colors.hasgui : s:colors.hidden, col: 3},
          \ #{t: '􀅖', fg: get(gui, 'strikethrough') ? s:colors.hasgui : s:colors.hidden, col: 3},
          \ #{t: '􀨡', fg: get(gui, 'standout') ? s:colors.hasgui : s:colors.hidden, col: 3},
          \ #{t: '􂏾️ ', fg: (get(gui, 'inverse')
          \ || get(gui, 'reverse')) ? s:colors.hasgui : s:colors.hidden, col: 3},
          \ #{t: ' ', col: 3},
          \]

      let done = v:true
    endif
    let lines = add(lines, lineParts)
  endwhile
  return lines
endfunc

"    𝖱𝗈𝗐 𝟤𝟥 | 𝖢𝗈𝗅𝟦𝟧 | 𝖵𝖢𝗈𝗅𝟧𝟦  
function s:FormatPositionInfo() abort
  let ln = line('.')
  let cc = charcol('.')
  let vc = virtcol('.')
  let bc = col('.')
  return flatten([
        \ [
        \  #{t: '𝖱𝗈𝗐', fg: s:colors.row}, #{t: ' '}, #{t: format#numbers(ln), fg: s:colors.rowval},
        \  #{t: ' '}, #{t: '|'}, #{t: ' '},
        \  #{t: '𝖢𝗈𝗅', fg: s:colors.col},  #{t: format#numbers(cc), fg: s:colors.colval},
        \ ],
        \ cc == vc ? [] : [
        \  #{t: ' '}, #{t: '|'}, #{t: ' '},
        \  #{t: '𝖵𝖢𝗈𝗅', fg: s:colors.vcol}, #{t: format#numbers(vc), fg: s:colors.vcolval},
        \ ],
        \ cc == bc ? [] : [
        \  #{t: ' '}, #{t: '|'}, #{t: ' '},
        \  #{t: 'ʙʏᴛᴇ', fg: s:colors.byte}, #{t: ' '}, #{t: format#numbers(bc), fg: s:colors.byteval},
        \ ],
        \])
endfunc




function! s:UpdateSynFoBuffer(winid) abort
  " Replacement buffer contents
  let lines = []

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
" ⎢╶╶ Synstack Unavailable ╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴⎥
  if !exists("*synstack")
    let lines = add(lines, [
          \ #{t: '╶╶ ', fg: s:colors.headingline, col: 1},
          \ #{t: 'Synstack Unavailable', fg: s:colors.headingtext, col: 2},
          \ #{t: ' ╴', fg: s:colors.headingline, col: 2},
          \ #{t: '╴', fg: s:colors.headingline, repeat: v:true, col: 2},
          \ #{t: '╴', fg: s:colors.headingline, repeat: v:true, col: 3},
          \])
  else
    let stacknames = synstack(line('.'), col('.'))->map({_,v -> synIDattr(v, 'name')})

" ⎢╶╶ No highlighting here ╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴⎥
    if len(stacknames) == 0
      let lines = add(lines, [
            \ #{t: '╶╶ ', fg: s:colors.headingline, col: 1},
            \ #{t: 'No highlighting here', fg: s:colors.headingtext, col: 2},
            \ #{t: ' ╴', fg: s:colors.headingline, col: 2},
            \ #{t: '╴', fg: s:colors.headingline, repeat: v:true, col: 2},
            \ #{t: '╴', fg: s:colors.headingline, repeat: v:true, col: 3},
            \])
    else
      let lines = add(lines, flatten([[
            \ #{t: '╶', fg: s:colors.headingline, col: 1},
            \ #{t: '─', fg: s:colors.headingline, repeat: v:true, col: 1},
            \ #{t: '─', fg: s:colors.headingline, repeat: v:true, col: 2},
            \ ], s:hi_col_headings
            \]))
    " Stack:
      for name in reverse(stacknames)
        let lines += s:FormatLinkChain(name)
      endfor
    endif
  endif


" ⎢╶─╴default╶─────────────────╴𐔥ɢ ⲃɢ ꮪꮲ╶───╴ɢᴜɪ╶──────╴⎥
" ⎢╶─╴wincolor╶────────────────╴𐔥ɢ ⲃɢ ꮪꮲ╶───╴ɢᴜɪ╶──────╴⎥
  let lines = add(lines, flatten([[
        \ #{t: '╶──', fg: s:colors.headingline, col: 1},
        \ #{t: '╴', fg: s:colors.headingline, col: 2},
        \ #{t: &l:wincolor == '' ? 'default' : 'wincolor', fg: s:colors.headingtext, col: 2},
        \ #{t: '╶', fg: s:colors.headingline, col: 2},
        \ #{t: '─', fg: s:colors.headingline, repeat: v:true, col: 2},
        \ ], s:hi_col_headings
        \]))
  let lines += s:FormatLinkChain(&l:wincolor == '' ? 'Normal' : &l:wincolor)

  let lines = add(lines, s:sectionBreak)

  "
  " TODO Text Object Info:
  "

  "
  " TODO Sign Info:
  "

  "
  " Character Info:
  "
  let lines = add(lines, s:FormatCharInfo())

  let lines = add(lines, s:sectionBreak)

  "
  " Position Info:
  "
  let lines = add(lines, s:FormatPositionInfo())


  return s:Render(lines, a:winid)
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
    call s:SynFoClose()
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

