if exists("g:mayhem_loaded_highlight")
  finish
endif
let g:mayhem_loaded_highlight = 1

" Foreground text shown in a contrasting colour to the colour background
function ColourHighlightTextContrast() abort
endfunc

" Foreground text hidden (same colour as the background)
function ColourHighlightTextHidden() abort
  call hlget()->filter(
        \ {_, x -> x.name =~ '^BG.*'}
        \ )->map(
        \ {_, x -> #{name: x.name, guifg: x.guibg}}
        \ )->hlset()
endfunc

" Background hidden, show only text in colour
function ColourHighlightTextOnly() abort
  call hlget()->filter(
        \ {_, x -> x.name =~ '^BG.*'}
        \ )->map(
        \ {_, x -> #{name: x.name, guifg: x.guibg, guibg: 'NONE'}}
        \ )->hlset()
endfunc


" TODO - add to symbols repository when implemented
let s:symbol_linksto = get(g:, 'mayhem_symbol_hihi_linksto', '⫘⃗ ')
let s:symbols_synfo = #{
      \ fg: '􀯮',
      \ bg: '􀯯',
      \ color: '􀂓',
      \ none: '􀂒',
      \}

let s:colorHidden = '#441122'


"
" TODO convert this to vim9script for speed
function! s:HighlightHighlight() abort
  call autocmd_add([#{
        \ event: 'ColorScheme', pattern: 'vividmayhem',
        \ cmd: 'call s:HighlightHighlight()',
        \ group: 'mayhem_hihi_colorscheme_event', replace: v:true,
        \}])

  let hlgroups = hlget()

  for hlgroup in hlgroups
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

command! -bar HiHi call <SID>HighlightHighlight()


"
" See: ./sfsymbols.vim
"
function! s:GetFormattedCharacterInfo() abort
  let char = char2nr(getline('.')[col('.') - 1 : -1])->nr2char()
  let composedchar = strpart(getline('.'), col('.') - 1, 1, v:true)
  let output = 'No Char Info'

  " SFSymbols doesn't define composing characters itself
  let info = GetSfSymbolInfo(char)
  if info.IsValid()
    let output = '⟨' .. composedchar .. '⟩' .. string(info) .. ' (SFSymbol)'
  else
    " TODO implement similar in ./unicode.vim and remove dep.
    if !exists('g:autoloaded_characterize')
      " Characterize's autoload uses redir, which can't be nested
      silent exec 'Characterize'
    endif
    let v:errmsg = ''
    redir => output
      silent exec 'Characterize ' .. char
    redir END
    if v:errmsg != ''
      echom 'Error running Characterize: ' .. v:errmsg
      let output = 'Char Info Err'
    else
      let output = trim(output)->split(', ')->join(' ╱ ')
    endif
  endif
  return [output]
endfunc


" Follow links to the end (or until detecting a loop)
function s:GetLinkChain(name)
  let chain = []
  let lastName = a:name
  while lastName != ''
    " if name seen already, must be in a loop. This isn't a very efficient
    "lookup, but highlighting chains are usually very short
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

"    𝖱𝗈𝗐 𝟤𝟥 | 𝖢𝗈𝗅𝟦𝟧 | 𝖵𝖢𝗈𝗅𝟧𝟦  
function s:GetFormattedPositionInfo(maxlines = 20) abort
  let cc = charcol('.')
  let vc = virtcol('.')
  let bc = col('.')
  let col = printf('𝖢𝗈𝗅%s', SwapNumbers(cc))
  let vcol = printf('𝖵𝖢𝗈𝗅%s', SwapNumbers(vc))
  let byte = printf('ʙʏᴛᴇ%s', SwapNumbers(bc))
  let numbers = printf('𝖱𝗈𝗐 %s | %s%s%s',
        \ SwapNumbers(line('.')),
        \ SwapNumbers(col),
        \ cc == vc ? '' : printf(' | %s', SwapNumbers(vcol)),
        \ cc == bc ? '' : printf(' | %s', SwapNumbers(byte)))
  return #{text: printf('%'..a:maxlines..'S', numbers), props: []}
endfunc

"
" ⎛★                                                  ⎞
" ⎢   𝟧𝟤𝟥𝟦⁝cssUrlFunction ꜰ􀂒ʙ􀣦ꜱ􀂓  􀅓􀅔􀅕􀅖􀨡 􂏾     ⎥
" ⎢                                                   ⎥
" ⎢        𝟢𝟣𝟤𝟥𝟦𝟧𝟨𝟩𝟪𝟫  𝟬‹𝟭𝟮›𝟯𝟰𝟱𝟲𝟳𝟴⦉𝟵𝟭⦊                     ⎥
" ⎢        𝟢𝟣𝟤𝟥𝟦𝟧𝟨𝟩𝟪𝟫  𝟬‹𝟭𝟮›𝟯𝟰𝟱𝟲𝟳𝟴⦇𝟵𝟭⦈                     ⎥
" ⎢        𝟢𝟤𝟥𝟦𝟧𝟨𝟩𝟪»𝟫𝟣  𝟬‹𝟭𝟮›𝟯𝟰𝟱𝟲𝟳𝟴❨𝟵𝟭❩                     ⎥
" ⎢      ₅️₆️₇️₈️₉️                                        ⎥
" ⎢                                                   ⎥

let s:subranges = #{
      \ norm:  '0123456789',
      \ vs16:  '0️1️2️3️4️5️6️7️8️9️',
      \ sans:  '𝟢𝟣𝟤𝟥𝟦𝟧𝟨𝟩𝟪𝟫',
      \ sansb: '𝟬𝟭𝟮𝟯𝟰𝟱𝟲𝟳𝟴𝟵',
      \ sup:   '⁰¹²³⁴⁵⁶⁷⁸⁹',
      \ sub:   '₀₁₂₃₄₅₆₇₈₉',
      \ sub16: '₀️₁️₂️₃️₄️₅️₆️₇️₈️₉️',
      \ mono:  '𝟶𝟷𝟸𝟹𝟺𝟻𝟼𝟽𝟾𝟿',
      \ fullw: '０１２３４５６７８９'
      \}
  " let range = split(a:subrange, '\zs')
  "       \ '\=get(l:range, str2nr(submatch(0)), submatch(0))',
"
" Replace range(s) of codepoints in input string
function SwapNumbers(str, subrange = 'sans')
  return substitute(a:str, '[0-9]',
        \ '\=nr2char(strgetchar(s:subranges[a:subrange], str2nr(submatch(0))))',
        \ 'g')
endfunc
"                                           
function! s:ForColor(color)
  " if a:color == 'NONE'
  "   return ['􀣦', '#333333']
  " endif
  if a:color == 'fg' || a:color == 'foreground'
    return [s:symbols_synfo['fg'], '#333333']
  endif
  if a:color == 'bg' || a:color == 'background'
    return [s:symbols_synfo['bg'], '#333333']
  endif
  if v:colornames->has_key(a:color)
    return [s:symbols_synfo['color'], v:colornames[a:color]]
  endif
  if a:color =~ '^#'
    return [s:symbols_synfo['color'], a:color]
  endif
  return [s:symbols_synfo['none'], '#333333']
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
function! s:LineWithPropsFromParts(parts, bufnr, lineconfig)
  let line = ''
  let props = []
  " The column group this line uses for layout
  " Groups are defined the first time they are used,
  " and can be extended later by splitting columns.
  " A Column is referred to by a single character (e.g. a, b, c etc.)
  " A Group consists of a string of Columns and 
  "  sub-Groups [enclosed in square brackets],
  let group = get(lineconfig, 'g', '0]')

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
    let hi = get(part, 'hi', v:none)
    " ad-hoc highlighting (creates buffer-local highlight group)
    " if 'hi' is also set, it is copied and these act as overrides
    let fg = get(part, 'fg', v:none)
    let bg = get(part, 'bg', v:none)
    let sp = get(part, 'sp', v:none)
    let gui = get(part, 'gui', v:none)

    if fg != v:none
      let s:hlid = s:hlid + 1
      let id = 'hif' .. s:hlid

      call hlset([#{name: id, guifg: fg}])
      call prop_type_add(id, #{ bufnr: a:bufnr, highlight: id})
      let props += [#{col: strlen(line) + 1, length: strlen(text), id: id, type: id}]
    endif
    let line = line .. text
  endfor
  return #{text: line, props: props}
endfunc

function! s:UpdateSynFoBuffer(winid)
  let bufnr = winbufnr(a:winid)

  " Replacement buffer contents
  let lines = []
  " Reset index for generating text property ids
  let s:hlid = 1000

  "
  " Top Level Highlight Info:
  "
  let results = synID(line("."), col("."), 1)->synIDtrans()->synIDattr("name")->hlget(v:true)

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
  "   - 􀅓bold 􀅔italic 􂏾[re/in]verse 􀨡standout 􀅖strikethrough¹
	"   - 􀅕under[line/curl¹/double¹/dotted¹/dashed¹]
  "   - nocombine² NONE³

  for val in results
    let lineParts = [#{t: '  ' .. get(val, 'name', '???') .. '»' .. SwapNumbers(val.id, 'sansb'), col: 2}]

    let [fgsymbol, fgcolor] = s:ForColor(get(val, 'guifg', ''))
    let [bgsymbol, bgcolor] = s:ForColor(get(val, 'guibg', ''))
    let [spsymbol, spcolor] = s:ForColor(get(val, 'guisp', ''))

    let lineParts += [#{t: ' '}, #{t: fgsymbol, fg: fgcolor, col: 3}]
    let lineParts += [#{t: ' '}, #{t: bgsymbol, fg: bgcolor, col: 3}]
    let lineParts += [#{t: ' '}, #{t: spsymbol, fg: spcolor, col: 3}]

" 􀣤 􀏃 􀣦􀂒􀃰􀃲   􁄻  
" ⎢╶─╴wincolor╶────────────────╴𐔥ɢ-️ⲃɢ-️ꮪᴩ╶───╴ɢᴜɪ╶──────╴⎥
" ⎛  ★   ꜰ􀂓ʙ􀯮ꜱ􀂒 (􀅓􀅔􀅕􀅖􀨡􂏾 )              ⎞

" ⎛                                          ─╸SynFo╺─  ⎞
" ⎢╶╶ No highlighting here ╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴⎥
" ⎢                               ᢁ                     ⎥
" ⎢╶─╴default╶─────────────────╴𐔥ɢ·️ⲃɢ·️ꮪꮲ╶╴ɢᴜɪ╶─────╴ꭱꮩ╶╴⎥
" ⎢     ╰‣️Normal❘𝟤❘􀮵           􀂓 􀯮 􀂒  􀅓􀅔􀅕􀅖􀨡􂏾   ⎥
"
" col1|     col2  width:fit    |     col3  width:22    |
"  w:2|                        |                       |
" ⎛                                          ─╸SynFo╺─  ⎞
" ⎢★️ ᴅ⎧cssUrlFunction❘𝟤𝟥𝟦𝟧❘􀮵   􀂓 􀯮 􀂒 􂏾  􀅓􀅔􀅕􀅖􀨡  ⎥
" ⎢   │╰‣️Statement❘𝟤𝟥𝟦❘􀮵        ╶╶╶╶╶╶╶╶╶􀉣╴╴╴╴╴╴╴╴╴   ⎥
" ⎢   │  ╰‣️Constant❘𝟧𝟧𝟧𝟧❘􀮵      ╶╶╶╶╶╶╶╶╶􀉣╴╴╴╴╴╴╴╴╴   ⎥
" ⎢ ᴄ ⎧cssUrl❘􀮵                􀂓 􀯮 􀂒 􂏾  􀅓􀅔􀅕􀅖􀨡  ⎥
" ⎢  ᴅ⎧cssParam❘􀮵              􀂓 􀯮 􀂒 􂏾  􀅓􀅔􀅕􀅖􀨡  ⎥
" ⎢╶─╴wincolor╶────────────────╴𐔥ɢ ⲃɢ ꮪꮲ╶───╴ɢᴜɪ╶──────╴⎥
" ⎢     ╰‣️BaseWin❘𝟤𝟥𝟦❘􀮵        􀂓 􀯮 􀂒 􂏾  􀅓􀅔􀅕􀅖􀨡  ⎥
" ⎢                                                     ⎥
" ⎢ ⎧ cᷟ⃝     ⎫                      𐔥ɢ ʙɢ ꮪꮲ  ʀᴠ ꭱꮩ                ⎥
" ⎢ ╰⎧ c    ⎪                                      ⎥
" ⎢  ╰⎧ ◌ᷟ   ⎪                                 ⎥
" ⎢   ╰{️ ◌⃝  ⎭                           ⎥
" ⎢                                                      ⎥
" ⎝  𝖱𝗈𝗐 𝟤𝟥 | 𝖢𝗈𝗅𝟦𝟧 | 𝖵𝖢𝗈𝗅𝟧𝟦                             ⎠

    " Gui: (bold/underline etc.)
    let gui = get(val, 'gui', {})

    let lineParts += [
          \ #{t: ' ', col: 3},
          \ #{t: '􀅓', fg: get(gui, 'bold', v:false) ? v:none : s:colorHidden, col: 3},
          \ #{t: '􀅔', fg: get(gui, 'italic', v:false) ? v:none : s:colorHidden},
          \ #{t: get(gui, 'underdouble', v:false) ? '􃐊' : '􀅕',
          \ fg: (get(gui, 'underline', v:false)
          \   || get(gui, 'undercurl', v:false)
          \   || get(gui, 'underdotted', v:false)
          \   || get(gui, 'underdashed', v:false)
          \   || get(gui, 'underdouble', v:false)) ? v:none : s:colorHidden, col: 3},
          \ #{t: '􀅖', fg: get(gui, 'strikethrough', v:false) ? v:none : s:colorHidden, col: 3},
          \ #{t: '􀨡', fg: get(gui, 'standout', v:false) ? v:none : s:colorHidden, col: 3},
          \ #{t: '􂏾️ ', fg: (get(gui, 'inverse', v:false)
          \ || get(gui, 'reverse', v:false)) ? v:none : s:colorHidden, col: 3},
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
          \ #{t: '╶╶ ', fg: s:colorHidden, hi: 'SlHomeMN', col: 1},
          \ #{t: 'No highlighting here', hi: 'SlHomeMC', col: 2},
          \ #{t: ' ╴', fg: s:colorHidden, hi: 'SlHomeMN',pad: '╴', col: 2},
          \ #{t: '╴', fg: s:colorHidden, hi: 'SlHomeMN',pad: '╴', col: 3},
          \]
    " call add(lines, #{text: 'No highlighting here', props: []})
    call add(lines, s:LineWithPropsFromParts(nohlParts, bufnr))
  endif

  if &l:wincolor != '' 
" ⎢╶─╴wincolor╶────────────────╴𐔥ɢ ⲃɢ ꮪꮲ╶───╴ɢᴜɪ╶──────╴⎥
    call add(lines, #{text: 'base(wincolor): ' .. &l:wincolor, props: []})
  else
    call add(lines, #{text: 'base: ' .. get(hlget('Normal'), 'guifg', ''), props: []})
  endif

  "
  " TODO Conceal Info:
  "

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
      " let line = [#{t: '  ' .. get(val, 'name', '???') .. '»' .. SwapNumbers(val.id, 'sansb')}]
      let res = ""
      let res = res .. (get(val, 'cleared') ? 'ᴄ' : ' ')
      let res = res .. (get(val, 'default') ? 'ᴅ' : ' ')
      let res = res .. " "
    " Id:
    " Hide intermediate links in chain to save space?       TODO
      if (get(val, 'linksto', "") != "")
        let chain = s:GetLinkChain(val.name)
        let matchids = mapnew(chain,
              \ {i, link -> 
              \  win_execute(a:winid, 'call matchadd('''
              \  .. link .. ''', ''\<' .. link .. '\>'')'  )})
        let res = res .. join(mapnew(chain,
              \ {i, link -> link .. '»' .. SwapNumbers((hlget(link)[0]->get('id')), 'sansb')}
              \ ), ' ' .. s:symbol_linksto .. ' ')
      else
        let res = res .. val.name .. '»' .. SwapNumbers(val.id, 'sansb')
      endif
      let res = res .. ''

      call add(lines, #{text: res, props: []})
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
  let [charinfo] = s:GetFormattedCharacterInfo()
  call add(lines, #{text: charinfo, props: []})

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


" 
" Get expanded hl definition for word under cursor
" e.g.
" Constant   ->   Constant
function! s:ExpandHiGroup(name = expand("<cword>")) abort
  let hinfo = ExecAndReturn('hi ' .. a:name)
  return a:name .. ' ' .. substitute(hinfo, '^\S\+\s\+\S\+\s\+', '', '') 
endfunc
command! ExpandHiGroup call <SID>ExpandHiGroup(expand("<cword>"))

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

command! -bar -nargs=1 HiDefinition exec ':norm f HiDefinition(<f-args>)

"₁️₂️₃️
"₁⃞ ₂⃞ ₃⃞  ¹⃞ ²⃞ ³⃞ ⁴⃞    ¹️²️³️⁴️⁵️⁶️⁷️⁸️⁹️₁️₂️₃️₄️₅️₆️₇️₈️₉️¹̲►️²̲️³̲️⁴̲️⁵̲️⁶̲️⁷̲️⁸̲️⁹̲️►️₁️₂️₃️₄️₅️₆️₇️►️₈️₉️²³⁴►️⁵⁶⁷⁸⁹₁꛱₂꛱₃꛱₄꛱₅꛱₆꛱₇꛱₈꛱₉꛱
"₁⃞️ ₂⃞️ ₃⃞️  ¹⃞ ²⃞ ³⃞ ⁴⃞ ⁵⃞ ⁶⃞ ⁷⃞ ⁸⃞ ⁹⃞  0︎⃣ 1︎⃣ 2︎⃣ 3︎⃣ 4︎⃣ 5︎⃣ 6︎⃣ 7︎⃣ 8︎⃣ 9︎⃣  
"
" ⎛             ᐅᐳ         ◁️[ ₁️1︎⃣ 1 ▷️⮕ᐳ  ◁️]  ᐅᐳ  ▷️ᐳ  ▷️ᐳ⮕ᐳ               ⎞
" join(chain, '▶︎▬ᷞ▬ͥ▬ᷠ▬ᷜ▶︎') join(chain, ' ▬▶︎ ') join(chain, ' -> ') join(chain, ' ʟɪɴ͢ᴋ ')
"
"  􀯭 􀯮 􀯯 􁉽 􁋼 􁉼 􁋽 􁋛 􁋜 􀯰 􁌅 􀯱 􀯲 􀯳 􁊕
"  􀅓️⃞ 􀅔️⃞ 􀅕️ 􀅖️⃞  􀨡️⃞  

" 􀑋 􀑍 􀯴 􀮵 􀺾 􀿨 􀑏 􁂠 􂡆  􀿫 􂞹 􂞺  􀿪􁰏 
" 􀑌 􀑎 􀯵 􀮶 􀻀 􀿩 􀑐 􁂡 􂡇  􀭨 
" 
" 􀭅 􀆗􀆛􀆙               ◲⃞ ▬ ◱⃞     ◶⃞   ◵⃞    
" 􁚀 􀆘􀆜􀆚               ❚    ❚             
" 􀃬􀃮􀃜􀃞                ◳⃞   ◰⃞    ◷⃞   ◴⃞   
" 􀣤 􀏃 􀣦􀂒􀃰􀃲                           
" 􀣥 􀏄 􀣧􀂓􀃱􀃳                           
" 􁄻 transparent                           

" ⎛  ★   fg􀏄 bg􀏄 sp􀏄  􀅓􀅔􀅕􀅖􀨡 􂏾                ⎞
" ⎢                                                  ⎥
" ⎢ ᴅ  1234: cssUrlFunction S️tatement                ⎥
" ⎢  ᴄ  567: cssAttrRegion                           ⎥
" ⎢  ᴄ   89: cssDefinition                           ⎥
" ⎝                                 @ Row 62 Col 39  ⎠
" 
" ∙ • ・◦ ● ○ ◎ ◉ ⦿  ‣ ▵ ▴ ➤ ➢ ➣  ✢ ✣ ✤ ✧ ★ ☆    ✻ ✲ ✱ 
" ∙⃞ •⃞ ・⃞◦⃞ ●⃞ ○⃞ ◎⃞ ◉⃞ ⦿⃞  ‣⃞ ▵⃞ ▴⃞ ➤⃞ ➢⃞ ➣⃞  ✢⃞ ✣⃞ ✤⃞ ✧⃞ ★⃞ ☆⃞    ✻⃞ ✲⃞ ✱⃞ 
"
" ※ ※⃞️ ※⃞  ▪▪︎⃞ ▪⃞︎  ▫▫︎⃞ ▫⃞︎    ❘️❘⃞ ❘❘⃞︎ ❙️❙⃞ ❙❙⃞︎ 
"                                                                            
" ∙️ •️ ・️◦️ ●️ ○️ ◎️ ◉◉️ ◉️⃝ ⦿⃝ ⦿⦿⃝︎    ◎⃝︎  ◎⃝◎⃝️      ⦿️   ‣️ ▵️ ▴️ ➤️ ➢️ ➣️  ✢️ ✣️ ✤️ ✧️ ★️ ☆️    ✻️ ✲️ ✱️ 
"
" ✗ ✗⃞︎ ✗️ ✗⃞️  ✘ ✘⃞︎ ✘️ ✘⃞      ✓✔︎✓️✔︎︎️ ✓⃞ ✔︎⃞   ✕ ✕⃞︎  ✕️ ✕⃞   ✖︎ ✖⃞︎  ✖︎⃞   
"・∙️∙•●️•️● ○ ◎ ◉ ⦿ 
"
"  ↵ ↲ ↳ ↰ ↱ ↴  ⤶ ⤴︎ ⤵︎ ⤷  ⤥ ⤤ ⤹ ⤸ ↩︎ ↪︎ ⤾ ⤿ ⤺ ⤻
"  ↵︎ ↲︎ ↳︎ ↰︎ ↱︎ ↴︎  ⤶︎ ⤴︎︎ ⤵︎︎ ⤷︎  ⤥︎ ⤤︎ ⤹︎ ⤸︎ ↩︎︎ ↪︎︎ ⤾︎ ⤿︎ ⤺︎ ⤻︎
"  ↵️ ↲️ ↳️ ↰️ ↱️ ↴️  ⤶️ ⤴︎️ ⤵︎️ ⤷️  ⤥️ ⤤️ ⤹️ ⤸️ ↩︎️ ↪︎️ ⤾️ ⤿️ ⤺️ ⤻️
"  ↵️︎ ↲️️ ↳️ ↰️ ↱️ ↴️  ⤶️ ⤴︎️ ⤵︎️ ⤷️  ⤥️ ⤤️ ⤹️ ⤸️ ↩︎️ ↪︎️ ⤾️ ⤿️ ⤺️ ⤻️
"
"  ◦️ ◦   ○️ ◎️ ◉️ ⦿️  ‣️ ▵️ ▴️ ➤️ ➢️ ➣️  ✢️ ✣️ ✤️ ✧️ 
"
"  ★ ☆ ★⃝︎  ☆⃝︎  ★⃝  ☆⃝  ★️ ☆️  ★⃞ ☆⃞  ★⃞︎ ☆⃞︎   ✻️ ✲️ ✱️  ✓️ ✔︎️  ✕️ ✖︎️  ✗️ ✘️  ※️      ❘️ ❙️
"
"
" ⎛  ★ cssUrlFunction:1234 ꜰ􀏄 ʙ􀏄 ꜱ􀏄  􀅓􀅔􀅕􀅖􀨡 􂏾  ⎞
" ⎢ ᴅ   ↳️ S️tatement:667  Error:554                    ⎥
" ⎢                                                   ⎥
" ⎢  ᴄ  567: cssAttrRegion                            ⎥
" ⎢  ᴄ   89: cssDefinition                            ⎥
" ⎝                        Synstack @ Row 62 Col 39   ⎠
"
" ⎛  ★️         􀅓️⃝ 􀅔️⃝ 􀅕️⃝ 􀅖️⃝ 􀨡️⃝     􂏾️⃝                  ⎞
"
" ⎛  ★   fg:􀂓 bg:􀂓 sp:􀂓  􀅓 􀅔 􀅕 􀅖 􀨡    􂏾      ⎞
" ⎢ɴ ᴅ  1234: cssUrlFunction  S️tatement              ⎥
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
"

  " e.g.:
  " syn match HlMkDnCdDelim /\<HlMkDnCdDelim\>/ contained contains=NONE containedin=VimHiGroup
  "
  " let w:synmatches = []
  " %s/^:\?hi\w*\s\+\%(clear\)\@!\%(def\w*\s*\)\?\%(link\s*\)\?\<\zs\(\w\+\)\ze\>/\=w:synmatches->add(submatch(0))/ne
  " %s/^:\?syn\w*\s\+\%(match\|region\|keyword\)\s\+\<\zs\(\w\+\)\ze\>/\=w:synmatches->add(submatch(0))/ne
  " for synmatch in w:synmatches
  "   silent exec 'syn match ' .. synmatch .. ' /\<' .. synmatch .. '\>/'
  "     \ .. ' contained contains=NONE containedin=VimGroupName,VimHiGroup,VimGroup'
  " endfor
" endfunc

" Has two implementations, this one uses `syn match`
"
" function! s:AddSynMatch(name) abort
"   exec 'syn match ' .. a:name .. ' /\<' .. a:name .. '\>/'
"     \ .. ' contained contains=NONE containedin=VimHiGroup'
"   return a:name
" endfunc

" ⎛  ★                                                   ⎞
" ⎢ ᴅ 1234╺┳╸cssUrlFunction    􀂓 􀯮 􀂒 􂏾   􀅓􀅔􀅕􀅖􀨡  ⎥
" ⎢    134 ┃ ╰‣️Statement       ─╶╶╶╶╶╶╶╶╶􀉣╴╴╴╴╴╴╴╴╴─   ⎥
" ⎢     34 ┃   ╰‣️Constant      ─╶╶╶╶╶╶╶╶╶􀉣╴╴╴╴╴╴╴╴╴─   ⎥
" ⎢ ᴅ  424 ┠╴cssUrl            􀂓 􀯮 􀂒 􂏾   􀅓􀅔􀅕􀅖􀨡  ⎥
" ⎢  ᴄ 111 ┠╴cssParam          􀂓 􀯮 􀂒 􂏾   􀅓􀅔􀅕􀅖􀨡  ⎥

" ⎛  ★                                                   ⎞
" ⎢ ᴅ 1234:╺┳╸cssUrlFunction   𝘍􀂓 􀯮 􀂒 (􀅓􀅔􀅕􀅖􀨡􂏾 )  ⎥
" ⎢    134: ┃ ⫘⃗  Statement      ᶠᵍ ᵇᵍ ˢᵖ                 ⎥
" ⎢    134: ┃ ⫘⃗  Statement      ᶠᵍ ᵇᵍ ˢᵖ                 ⎥
" ⎢    134: ┃ ⫘⃗  Statement      𐔥ɢ ʙɢ ꮪꮲ                 ⎥
" ⎢     34: ┃  ⫘⃗  Constant      ꜰᴳ ᴮᴳ  ᴾ                 ⎥
" ⎢ ᴅ  424: ┠╴cssUrl           ꜰ􀂓ʙ􀯮ꜱ􀂒 (􀅓􀅔􀅕􀅖􀨡􂏾 )  ⎥
" ⎢  ᴄ 111: ┠╴cssParam         ꜰ􀂓ʙ􀯮ꜱ􀂒 (􀅓􀅔􀅕􀅖􀨡􂏾 )  ⎥
"
" ⎛  ★                                                   ⎞
" ⎢ ᴅ 1234:╺┳╸cssUrlFunction􀮵   􀂓 􀯮 􀂒 􀅓􀅔􀅕􀅖􀨡􂏾  􂚭 ⎥
" ⎢    134: ┃ ⫘⃗  Statement􂚭                              ⎥
" ⎢     34: ┃  ⫘⃗  Constant􀮵                             ⎥
" ⎢ ᴅ  424: ┠╴cssUrl􀮶           􀂓 􀯮 􀂒 􀅓􀅔􀅕􀅖􀨡􂏾    ⎥
" ⎢  ᴄ 111: ┠╴cssParam           􀂓 􀯮 􀂒 􀅓􀅔􀅕􀅖􀨡􂏾    ⎥
" ╭    ╮ ╭    ╮ ╭    ╮ ╭    ╮ 
" │ cᷟ⃝  │:{️ c }️│‥│ ◌ᷟ○ᷟ︎ │‥│ ◌⃝  │ 
" ╰    ╯ ╰    ╯ ╰    ╯ ╰    ╯ 
