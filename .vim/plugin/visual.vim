if exists("g:mayhem_loaded_visual")
  finish
endif
let g:mayhem_loaded_visual = 1




" xnoremap §v <Plug>Mayhem_GetVisualSelection
if !hasmapto('<ScriptCmd>echom GetVisualSelection()<CR>')
  if !maparg('<Plug>Mayhem_GetVisualSelection', 'x') == ''
    xunmap <Plug>Mayhem_GetVisualSelection
  endif
  xnoremap <unique> <script> <Plug>Mayhem_GetVisualSelection <ScriptCmd>echom GetVisualSelection()<CR>
endif

function! GetVisualSelection() abort
  let [_, fromrow, vcol, voff] = getpos('v')
  let fromcol = vcol + voff
  let [_, torow, ccol, coff, _] = getcurpos()
  let tocol = ccol + coff
  if fromcol > tocol
    let [fromcol, tocol] = [tocol, fromcol]
  endif
  if fromrow > torow
    let [fromrow, torow] = [torow, fromrow]
  endif
  let dcols = tocol - fromcol
  let drows = torow - fromrow
  let mode = mode()
  let inclusive = &selection == 'inclusive'
  let modedesc = get({'v': 'char', 'V': 'line', '': 'area'}, mode, '!')
  let lines = getline(fromrow, torow)

  " Visual line
  if mode == 'V'
    if drows == 1
      echom '[V] 1 row:' fromrow
    else
      echom '[V]' drows 'rows:' fromrow '->' torow
    endif
    return lines
  endif

  let fromcoords = '(' .. fromrow .. ',' .. tocol .. ')' 

  " Visual char
  if mode == 'v'
    if drows == 1 && dcols == 1
      echom '[v] 1 char @' fromcoords
    else
      if drows == 1
        echom '[v] 1 row:' fromrow .. '[' .. fromcol .. ':' .. tocol .. ']'
      else
      echom '[v]' drows 'rows:' fromrow .. '[' .. fromcol .. ':]'
            \'->' torow .. '[:' .. tocol .. ']'
      endif
    endif

    let lines[-1] = lines[-1][: tocol - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][fromcol - 1:]
    return lines
  endif

  " Visual area
  if mode == ''
    echom '[^V]' drows .. '×' .. dcols 'chars: from' fromcoords '->' tocoords

    return map(lines, {_, val -> val[fromcol - 1 : tocol - (&selection == 'inclusive' ? 1 : 2)]})
  endif
endfunc

function! s:PlaceHorizontalMarker(bufnr = bufnr(), lnum = line('.'), style = {})
  let line = get(a:style, 'line', 'underdashed')
  let rgb = get(a:style, 'rgb', '#ffff00')
  let text = get(a:style, 'text', '__')

  let group = 'hzmarkers'

  let sgid = [prefix, line, rgb, text].join('_')

  call sign_define([
      \#{
      \ name: sgid,
      \ text: text,
      \ linehl: 'SgHzLnUnLine',
      \},
      \])

  call sign_place(0, group, sgid, a:bufnr, #{ a:lnum, priority: 8 })
endfunc

"
" vmap §o <ScriptCmd>call s:VisualOutline()<CR>
"
" Vertical (ColorColumn) for first and last column
" Horizontal (Sign w/ line highlight) for top and bottom row
"
if !hasmapto('<ScriptCmd>echom VisualOutline()<CR>')
  if !maparg('<Plug>Mayhem_VisualOutline', 'x') == ''
    xunmap <Plug>Mayhem_VisualOutline
  endif
  xnoremap <unique> <script> <Plug>Mayhem_VisualOutline <ScriptCmd>echom VisualOutline()<CR>
endif

let s:augroup = 'mayhem_visual_outline'
let s:group = 'mayhem_visual_outline_signs'
let s:prefix = 'mayhem_visual_outline_sign_'

" echom 'wincol: ('..x_win..')'..
"       \' ╱ virt:'..dx_virt..' ('..x1_virt..','..y_oth..')->('..x2_virt..','..y_cur..')'..
"       \' ╱ char:'..dx_char..' ('..x1_char..','..y_oth..')->('..x2_char..','..y_cur..')'..
"       \' ╱ byte:'..dx_byte..' ('..x1_byte..','..y_oth..')->('..x2_byte..','..y_cur..')'

function! s:VisualOutline() abort
  if mode() == ''
    return s:VisualBlockOutline()
  " elseif mode() == 'V'
  "   line-wise, horizontal + sign column
  " elseif mode() == 'v'
  "   char-wise, same basic idea as for block
  else
    echo 'todo visual outline for other modes'
  endif
endfunc

function s:VisualBlockOutline() abort
  if mode() != ''
    return
  endif

  " Screen position (including sign column etc.)
  let x_win = wincol()

  let y_win_0 = getpos('w0')[1]
  let y_win_last = getpos('w$')[1]

  " Byte positions
  let [_, y_oth, vcol_byte, voff_byte] = getpos('v')
  let x1_byte = vcol_byte + voff_byte
  let [_, y_cur, ccol_byte, coff_byte, _] = getcurpos()
  let x2_byte = ccol_byte + coff_byte
  let dx_byte = abs(x1_byte - x2_byte)

  " Char positions
  let [_, _, vcol_char, voff_char] = getcharpos('v')
  let x1_char = vcol_char + voff_char
  let [_, _, ccol_char, coff_char, _] = getcursorcharpos()
  let x2_char = ccol_char + coff_char
  let dx_char = abs(x1_char - x2_char)

  " Virtual positions (apparent screen columns)
  let x1_virt = virtcol('v')
  let x2_virt = virtcol('.')
  let dx_virt = abs(x1_virt - x2_virt)

  let dy = abs(y_oth - y_cur)

  exec 'setlocal colorcolumn=' .. x1_virt .. ',' .. x2_virt

  call sign_define([
        \#{
        \ name: s:prefix .. 'top',
        \ linehl: 'SgVisLine',
        \ culhl: 'SgVisLine',
        \},
        \#{
        \ name: s:prefix .. 'bot', 
        \ linehl: 'SgVisLine',
        \ culhl: 'SgVisLine',
        \},
        \])

  if predicate#addingSignWillShiftSignColumn()
    return
  endif

  let aSign = sign_define([
        \#{
        \ name: s:prefix .. 'left',
        \ text: '􀆒',
        \ linehl: 'ColorColNormal',
        \},
        \#{
        \ name: s:prefix .. 'right',
        \ text: '􀆓',
        \ linehl: 'ColorColNormal',
        \},
        \#{
        \ name: s:prefix .. 'top_oth-1',
        \ text: '__',
        \ linehl: 'SgVisLine',
        \ numhl: 'SgVisLineLnrA',
        \ texthl: 'SgVisBody',
        \ culhl: 'SgVisLine',
        \},
        \#{
        \ name: s:prefix .. 'top_oth',
        \ text: '  ',
        \ texthl: 'SgVisBody',
        \},
        \#{
        \ name: s:prefix .. 'top_cur-1',
        \ text: '⏶⏷',
        \ linehl: 'SgVisLine',
        \ numhl: 'SgVisLineLnrA',
        \ texthl: 'SgVisBody',
        \},
        \#{
        \ name: s:prefix .. 'top_cur',
        \ text: '⏶⏷',
        \ texthl: 'SgVisBody',
        \},
        \#{
        \ name: s:prefix .. 'above',
        \ text: '︙',
        \ linehl: 'SgVisBody',
        \ numhl: 'SgVisBody',
        \ texthl: 'SgVisBody',
        \ culhl: 'SgVisBody',
        \},
        \#{
        \ name: s:prefix .. 'below',
        \ text: '︙',
        \ linehl: 'SgVisBody',
        \ numhl: 'SgVisBody',
        \ texthl: 'SgVisBody',
        \ culhl: 'SgVisBody',
        \},
        \#{
        \ name: s:prefix .. 'bot_oth',
        \ text: '__',
        \ linehl: 'SgVisLine',
        \ numhl: 'SgVisLineLnrB',
        \ texthl: 'SgVisBody',
        \ culhl: 'SgVisLine',
        \},
        \#{
        \ name: s:prefix .. 'bot_cur',
        \ text: '__',
        \ linehl: 'SgVisLine',
        \ numhl: 'SgVisLineLnrB',
        \ texthl: 'SgVisBody',
        \ culhl: 'SgVisLine',
        \},
        \#{
        \ name: s:prefix .. 'same',
        \ text: ' ',
        \ linehl: 'SgVisLine',
        \ numhl: 'SgVisLine',
        \ texthl: 'SgVisLine',
        \ culhl: 'SgVisLine',
        \},
        \])

  call sign_unplace(s:group)
 
  " let linebefore = min([y_oth,y_cur]) - 1
  " if linebefore > 0
    " call sign_place(0, s:group, s:prefix .. 'top1',
        " \ bufnr(), #{ lnum: linebefore, priority: 11 })
  " endif

  if y_oth == y_cur
    call sign_place(0, s:group, s:prefix .. 'same',
          \ bufnr(), #{ lnum: y_oth, priority: 11 })
  else
    if y_oth < y_cur
      if y_oth < y_win_0
        call sign_place(0, s:group, s:prefix .. 'above',
            \ bufnr(), #{ lnum: y_win_0, priority: 11 })
      else
        call sign_place(0, s:group, s:prefix .. 'top' .. '_oth-1',
            \ bufnr(), #{ lnum: y_oth - 1, priority: 11 })
        call sign_place(0, s:group, s:prefix .. 'top' .. '_oth',
            \ bufnr(), #{ lnum: y_oth, priority: 11 })
      endif
      call sign_place(0, s:group, s:prefix .. 'bot' .. '_cur',
            \ bufnr(), #{ lnum: y_cur, priority: 101 })
      " call sign_place(0, s:group, s:prefix .. 'bot' .. '_cur+1',
      "       \ bufnr(), #{ lnum: y_cur + 1, priority: 101 })
    else
      call sign_place(0, s:group, s:prefix .. 'top' .. '_cur-1',
            \ bufnr(), #{ lnum: y_cur - 1, priority: 11 })
      call sign_place(0, s:group, s:prefix .. 'top' .. '_cur',
            \ bufnr(), #{ lnum: y_cur, priority: 11 })
      if y_oth >= y_win_last
        call sign_place(0, s:group, s:prefix .. 'below',
            \ bufnr(), #{ lnum: y_win_last, priority: 11 })
      else
        call sign_place(0, s:group, s:prefix .. 'bot' .. '_oth',
            \ bufnr(), #{ lnum: y_oth, priority: 101 })
        " call sign_place(0, s:group, s:prefix .. 'bot' .. '_oth+1',
        "     \ bufnr(), #{ lnum: y_oth + 1, priority: 101 })
      endif
    endif
  endif
endfunc

"
" Startup for visual block highlighting
"
function s:OnEnterVisualBlock() abort
  let &mouseshape = Remember('vV^V', '&mouseshape') .. ',v:crosshair'
  call Remember('^V', '&l:colorcolumn')
  call Remember('^V', '&l:cursorcolumn')
  let &l:cursorcolumn = 0
  call Remember('^V', '&l:cursorline')
  let &l:cursorline = 0

  call autocmd_add([
        \#{
        \ cmd: 'call s:VisualBlockOutline()',
        \ group: s:augroup,
        \ event: ['CursorMoved','VimResized','FocusGained','FocusLost','WinScrolled'],
        \ pattern: '*',
        \ replace: v:true
        \}
        \])

  call s:VisualBlockOutline()
endfunc

"
" Shutdown for visual block highlighting
"
function s:OnLeaveVisualBlock() abort
  call autocmd_delete([{
        \ 'group': s:augroup,
        \ 'event': 'CursorMoved',
        \}])

  call sign_unplace(s:group)

  call Restore('^V')
endfunc

call autocmd_add([
      \#{
      \ event: 'User', pattern: 'MayhemEnterModeVB',
      \ cmd: 'call s:OnEnterVisualBlock()',
      \ group: 'mayhem_visual_observer', replace: v:true,
      \},
      \#{
      \ event: 'User', pattern: 'MayhemLeaveModeVB',
      \ cmd: 'call s:OnLeaveVisualBlock()',
      \ group: 'mayhem_visual_observer', replace: v:true,
      \},
      \])

" vim: signcolumn=yes
