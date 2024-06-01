if exists("g:mayhem_loaded_modechanged")
  finish
endif
let g:mayhem_loaded_modechanged = 1


" TODO
" Add user autocmds for entering/leaving the various modes
" so that individual plugins can handle it locally

" Auto-hide list chars when entering visual mode
function! s:EnterVisualAny() abort
  let s:list_state_on_last_entering_visual = &list
  if exists('g:mayhem_hide_list_in_visual') && g:mayhem_hide_list_in_visual
    set nolist
  endif
endfunc
function! s:LeaveVisualAny() abort
  if s:list_state_on_last_entering_visual
    let &list = s:list_state_on_last_entering_visual
    unlet s:list_state_on_last_entering_visual
  endif
endfunc

function! s:EnterVisualChar() abort
  let s:mouseshape_state_on_last_entering_visual_char = &mouseshape
  let &mouseshape = &mouseshape..',v:beam'
endfunc
function! s:LeaveVisualChar() abort
  if s:mouseshape_state_on_last_entering_visual_char
    let &mouseshape = s:mouseshape_state_on_last_entering_visual_char
    unlet s:mouseshape_state_on_last_entering_visual_char
  endif
endfunc

function! s:EnterVisualLine() abort
  let s:mouseshape_state_on_last_entering_visual_line = &mouseshape
  let &mouseshape = &mouseshape..',v:beam'
endfunc
function! s:LeaveVisualLine() abort
  if s:mouseshape_state_on_last_entering_visual_line
    let &mouseshape = s:mouseshape_state_on_last_entering_visual_line
    unlet s:mouseshape_state_on_last_entering_visual_line
  endif
endfunc

function! s:EnterVisualBlock() abort
  let s:colorcolumn_state_on_last_entering_visual_block = &l:colorcolumn
  " exec 'set colorcolumn='..col('.')
  let &l:colorcolumn = charcol('.')

  let s:mouseshape_state_on_last_entering_visual_block = &mouseshape
  let &mouseshape = &mouseshape..',v:crosshair'
endfunc
function! s:LeaveVisualBlock() abort
  if s:colorcolumn_state_on_last_entering_visual_block
    let &l:colorcolumn = s:colorcolumn_state_on_last_entering_visual_block
  endif
  if s:mouseshape_state_on_last_entering_visual_block
    let &mouseshape = s:mouseshape_state_on_last_entering_visual_block
    unlet s:mouseshape_state_on_last_entering_visual_block
  endif
endfunc


augroup VisualEvent
  autocmd!
  " Enter Visual Mode (Any)
  autocmd ModeChanged *:[vV\x16]* call s:EnterVisualAny()
  " Leave Visual Mode (Any)
  autocmd Modechanged [vV\x16]*:* call s:LeaveVisualAny()

  " Enter Visual Mode (Character)
  autocmd ModeChanged *:v* call s:EnterVisualChar()
  " Leave Visual Mode (Character)
  autocmd ModeChanged v*:* call s:LeaveVisualChar()

  " Enter Visual Mode (Line)
  autocmd ModeChanged *:V* call s:EnterVisualLine()
  " Leave Visual Mode (Line)
  autocmd ModeChanged V*:* call s:LeaveVisualLine()
  " Enter Visual Mode (Block)
  autocmd ModeChanged *:[\x16]* call s:EnterVisualBlock()
  " Leave Visual Mode (Block)
  autocmd Modechanged [\x16]*:* call s:LeaveVisualBlock()
augroup END

