if exists("g:mayhem_loaded_visual")
  finish
endif
let g:mayhem_loaded_visual = 1




" TODO replace with <plug> and move keybind to shortcuts
"
vmap §v <ScriptCmd>echom GetVisualSelection()<CR>

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
      echom 'visual line, single row '..fromrow
    else
      echom 'visual line, '..drows..' rows '..fromrow..' -> '..torow
    endif
    return lines
  endif

  " Visual char
  if mode == 'v'
    if drows == 1 && dcols == 1
      echom 'visual char, single char at ('..fromrow..','..tocol..')'
    else
      if drows == 1
        echom 'visual char, single row '..fromrow..'['..fromcol..':'..tocol..']'
      else
      echom 'visual char, from row '..fromrow..'['..fromcol..':] -> '..torow..'[:'.tocol..']'
      endif
    endif

    let lines[-1] = lines[-1][: tocol - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][fromcol - 1:]
    return lines
  endif

  " Visual area
  if mode == ''
    echom 'visual area, '..drows..'x'..dcols..' from ('..fromrow..','..fromcol..') -> ('..torow..','.tocol..')'

    return map(lines, {_, val -> val[fromcol - 1 : tocol - (&selection == 'inclusive' ? 1 : 2)]})
  endif
endfunc


"
" Vertical (ColorColumn) for first and last column
" Horizontal (Sign w/ line highlight) for top and bottom row
" TODO replace with <plug> and move keybind to shortcuts
"
vmap §o <ScriptCmd>call s:OutlineVisualBlock()<CR>

function s:OutlineVisualBlock() abort
  if mode() != ''
    return
  endif
  let [_, y1, vcol, voff] = getpos('v')
  let x1 = vcol + voff
  let [_, y2, ccol, coff, _] = getcurpos()
  let x2 = ccol + coff
  let dx = abs(x1 - x2)
  let dy = abs(y1 - y2)

  echom 'visual area: ('..x1..','..y1..')->('..x2..','..y2..')'

  exec 'setlocal colorcolumn='..x1..','..x2

  if s:PlacingSignWillShiftColumns()
    return
  endif

  let aSign = sign_define('signvisualleft', {
        \ 'text': '􀆒',
        \ 'linehl': 'ColorColNormal',
        \})
  let aSign = sign_define('signvisualright', {
        \ 'text': '􀆓',
        \ 'linehl': 'ColorColNormal',
        \})
  let aSign = sign_define('signvisualtop', {
        \ 'text': '􀆐',
        \ 'linehl': 'ColorColNormal',
        \ 'numhl': 'ColorColNormal',
        \ 'texthl': 'ColorColNormal',
        \ 'culhl': 'ColorColNormal',
        \})
  let aSign = sign_define('signvisualbot', {
        \ 'text': '􀆑',
        \ 'linehl': 'ColorColNormal',
        \ 'numhl': 'ColorColNormal',
        \ 'texthl': 'ColorColNormal',
        \ 'culhl': 'ColorColNormal',
        \})
  let aSign = sign_define('signvisualsame', {
        \ 'text': '􂦫',
        \ 'linehl': 'ColorColNormal',
        \ 'numhl': 'ColorColNormal',
        \ 'texthl': 'ColorColNormal',
        \ 'culhl': 'ColorColNormal',
        \})
  call sign_unplace('visualextentsigns')
  " call sign_undefine('visualextentsign')
 
  if y1 == y2
    call sign_place(0, 'visualextentsigns', 'signvisualsame',
          \ bufnr(), { 'lnum': y1, 'priority': 11 })
  else
    call sign_place(0, 'visualextentsigns', 'signvisualtop',
          \ bufnr(), { 'lnum': min([y1,y2]), 'priority': 11 })
    call sign_place(0, 'visualextentsigns', 'signvisualbot',
          \ bufnr(), { 'lnum': max([y1,y2]), 'priority': 101 })
  endif
endfunc


"
" Get visibility status for the sign column in the given window
" returns:
"         v:true: Adding a sign will not cause window content to move
"                  i.e. sign column already visible
"        v:false: Adding a sign would shift window contents
"                  i.e. sign column=no, or auto and no signs placed yet
"              signcolumn=yes,
"              signcolumn=auto && number of signs > 0
"              signcolumn=number && number
"              signcolumn=number && nonumber && number of signs > 0
"           1 if sign column is visible 
"
function s:PlacingSignWillShiftColumns(winid = win_getid(winnr()))
  let winsigncolumn = getwinvar(a:winid, '&signcolumn')
  let winsigncount = sign_getplaced(winbufnr(winnr()), {'group':'*'})[0]['signs']->len()
  let winnumber = getwinvar(a:winid, '&number')

  return ('auto' == winsigncolumn && 0 == winsigncount)
  \ || ('number' == winsigncolumn && 0 == winnumber && 0 == winsigncount)
endfunc

"
" Startup for visual block highlighting
"
function s:OnEnterVisualBlock() abort
  let &mouseshape = Remember('vV^V', '&mouseshape')..',v:crosshair'
  call Remember('^V', '&l:colorcolumn')
  call Remember('^V', '&l:cursorcolumn')
  call Remember('^V', '&l:cursorline')

  call autocmd_add([{
        \ 'cmd': 'call s:OutlineVisualBlock()',
        \ 'group': 'mayhem_OutlineVisualBlock',
        \ 'event': 'CursorMoved',
        \ 'replace': v:true
        \}])

  let &l:cursorline = 0
  let &l:cursorcolumn = 0
  call s:OutlineVisualBlock()
endfunc

"
" Shutdown for visual block highlighting
"
function! s:OnLeaveVisualBlock() abort
  call autocmd_delete([{
        \ 'group': 'mayhem_OutlineVisualBlock',
        \ 'event': 'CursorMoved',
        \}])

  call sign_unplace('visualextentsigns')
  " call sign_undefine(['signvisualsame','signvisualbot','signvisualtop'])

  call Restore('^V')
endfunc

call autocmd_add([{
      \ 'replace': v:true,
      \ 'cmd': 'call s:OnEnterVisualBlock()',
      \ 'group': 'mayhem_visual_observer',
      \ 'event': 'User', 'pattern': 'MayhemEnterModeVB',
      \}, {
      \ 'replace': v:true,
      \ 'cmd': 'call s:OnLeaveVisualBlock()',
      \ 'group': 'mayhem_visual_observer',
      \ 'event': 'User', 'pattern': 'MayhemLeaveModeVB',
      \}])

