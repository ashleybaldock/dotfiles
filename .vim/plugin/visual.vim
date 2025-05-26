if exists("g:mayhem_loaded_visual")
  finish
endif
let g:mayhem_loaded_visual = 1




" TODO replace with <plug> and move keybind to shortcuts
"
" vmap §v <ScriptCmd>echom GetVisualSelection()<CR>
vnoremap <unique> <script> <Plug>MayhemGetvisualselection <ScriptCmd>echom GetVisualSelection()<CR>

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


"
" vmap §o <ScriptCmd>call s:VisualOutline()<CR>
"
" Vertical (ColorColumn) for first and last column
" Horizontal (Sign w/ line highlight) for top and bottom row
" TODO replace with <plug> and move keybind to shortcuts
"
if !hasmapto('<Plug>MayhemVisualOutline;')
  vnoremap <unique> <script> <Plug>MayhemVisualOutline <ScriptCmd>echom VisualOutline()<CR>
endif

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
  let [_, y1, vcol, voff] = getpos('v')
  let x1 = vcol + voff
  let [_, y2, ccol, coff, _] = getcurpos()
  let x2 = ccol + coff
  let dx = abs(x1 - x2)
  let dy = abs(y1 - y2)

  echom 'visual area: ('..x1..','..y1..')->('..x2..','..y2..')'

  exec 'setlocal colorcolumn='..x1..','..x2

  let aSign = sign_define('linevistop', #{
        \ linehl: 'SignVisTop',
        \ culhl: 'SignVisTop',
        \})
  let aSign = sign_define('linevisbot', #{
        \ linehl: 'SignVisTop',
        \ culhl: 'SignVisTop',
        \})

  if predicates#addingSignWillShiftSignColumn()
    return
  endif

  let aSign = sign_define('signvisualleft', #{
        \ text: '􀆒',
        \ linehl: 'ColorColNormal',
        \})
  let aSign = sign_define('signvisualright', #{
        \ text: '􀆓',
        \ linehl: 'ColorColNormal',
        \})
        " \ text: '􀆐',
        " 􂨧  􂨨  􂪏  􂪑    􀄿􀅀􀄨􀄩
        \ text: '＿',
        " \ text: '⌃^vᵛᵥⅴⅴⅤＶｖ𝗏𝗏＾ˇ ̬ᘁ∧∨',
  let aSign = sign_define('signvistop1', #{
        \ text: ' ',
        \ linehl: 'SignVisTop',
        \ numhl: 'SignVisTop',
        \ texthl: 'SignVisTop',
        \ culhl: 'SignVisTop',
        \})
  let aSign = sign_define('signvistop', #{
        \ text: '𐰯',
        \ linehl: 'SignVisBody',
        \ numhl: 'SignVisBody',
        \ texthl: 'SignVisBody',
        \ culhl: 'SignVisBody',
        \})
  let aSign = sign_define('signvisabove', #{
        \ text: '︾',
        \ linehl: 'SignVisBody',
        \ numhl: 'SignVisBody',
        \ texthl: 'SignVisBody',
        \ culhl: 'SignVisBody',
        \})
  let aSign = sign_define('signvisbelow', #{
        \ text: '︽',
        \ linehl: 'SignVisTop',
        \ numhl: 'SignVisTop',
        \ texthl: 'SignVisTop',
        \ culhl: 'SignVisTop',
        \})
  let aSign = sign_define('signvisbot', #{
        \ text: '𐰞',
        \ linehl: 'SignVisTop',
        \ numhl: 'SignVisTop',
        \ texthl: 'SignVisTTop',
        \ culhl: 'SignVisTop',
        \})
  let aSign = sign_define('signvissame', #{
        \ text: ' ',
        \ linehl: 'SignVisTop',
        \ numhl: 'SignVisTop',
        \ texthl: 'SignVisTop',
        \ culhl: 'SignVisTop',
        \})
  call sign_unplace('visualextentsigns')
 
  let linebefore = min([y1,y2]) - 1
  if linebefore > 0
  call sign_place(0, 'visualextentsigns', 'signvistop1',
        \ bufnr(), { 'lnum': min([y1,y2]) - 1, 'priority': 11 })
  endif

  if y1 == y2
    call sign_place(0, 'visualextentsigns', 'signvissame',
          \ bufnr(), { 'lnum': y1, 'priority': 11 })
  else
    call sign_place(0, 'visualextentsigns', 'signvistop',
          \ bufnr(), { 'lnum': min([y1,y2]), 'priority': 11 })
    call sign_place(0, 'visualextentsigns', 'signvisbot',
          \ bufnr(), { 'lnum': max([y1,y2]), 'priority': 101 })
  endif
endfunc

"
" Startup for visual block highlighting
"
function s:OnEnterVisualBlock() abort
  let &mouseshape = Remember('vV^V', '&mouseshape')..',v:crosshair'
  call Remember('^V', '&l:colorcolumn')
  call Remember('^V', '&l:cursorcolumn')
  let &l:cursorcolumn = 0
  call Remember('^V', '&l:cursorline')
  let &l:cursorline = 0

  call autocmd_add([
        \#{
        \ cmd: 'call s:VisualBlockOutline()',
        \ group: 'mayhem_visual_outline',
        \ event: 'CursorMoved',
        \ pattern: '*',
        \ replace: v:true
        \}
        \])

  call s:VisualBlockOutline()
endfunc

"
" Shutdown for visual block highlighting
"
function! s:OnLeaveVisualBlock() abort
  call autocmd_delete([{
        \ 'group': 'mayhem_visual_outline',
        \ 'event': 'CursorMoved',
        \}])

  call sign_unplace('visualextentsigns')

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
