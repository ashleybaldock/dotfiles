if exists("g:mayhem_loaded_modechanged")
  finish
endif
let g:mayhem_loaded_modechanged = 1

"
" ModeChanged: do things when switching between the visual sub-modes
"

" TODO
"  - Add user autocmds for entering/leaving the various modes
"    so that individual plugins can handle it locally
"
" - If one of these settings is changed while in visual mode,
"   then it'll get overwritten upon exiting. Not hard to fix 
"   (via OptionSet autocmd or comparing the pre- value to the
"   current one) but it's pretty unlikely to be a problem

" Auto-hide list chars when entering visual mode
function! s:EnterVisualAny() abort
  if exists('g:mayhem_hide_list_in_visual') && g:mayhem_hide_list_in_visual
    if !exists('s:list_state_on_last_entering_visual')
      let s:list_state_on_last_entering_visual = &list
    endif
    let &list = 0
  endif
endfunc
function! s:LeaveVisualAny() abort
  if exists('s:list_state_on_last_entering_visual')
    let &list = s:list_state_on_last_entering_visual
    unlet s:list_state_on_last_entering_visual
  endif
  if exists('s:mouseshape_state_on_last_entering_visual')
    let &mouseshape = s:mouseshape_state_on_last_entering_visual
    unlet s:mouseshape_state_on_last_entering_visual
  endif
endfunc

function! s:EnterVisualChar() abort
  if !exists('s:mouseshape_state_on_last_entering_visual')
    let s:mouseshape_state_on_last_entering_visual = &mouseshape
  endif
  let &mouseshape = s:mouseshape_state_on_last_entering_visual..',v:beam'
endfunc
function! s:LeaveVisualChar() abort
endfunc

function! s:EnterVisualLine() abort
  if !exists('s:mouseshape_state_on_last_entering_visual')
    let s:mouseshape_state_on_last_entering_visual = &mouseshape
  endif
  let &mouseshape = s:mouseshape_state_on_last_entering_visual..',v:beam'
endfunc
function! s:LeaveVisualLine() abort
endfunc

function! s:EnterVisualBlock() abort
  if !exists('s:colorcolumn_state_on_last_entering_visual_block')
    let s:colorcolumn_state_on_last_entering_visual_block = &l:colorcolumn
  endif
  let &l:colorcolumn = charcol('.')

  if !exists('s:mouseshape_state_on_last_entering_visual')
    let s:mouseshape_state_on_last_entering_visual = &mouseshape
  endif
  let &mouseshape = s:mouseshape_state_on_last_entering_visual..',v:crosshair'
endfunc
function! s:LeaveVisualBlock() abort
  if exists('s:colorcolumn_state_on_last_entering_visual_block')
    let &l:colorcolumn = s:colorcolumn_state_on_last_entering_visual_block
  endif
endfunc


augroup VisualEvent
  autocmd!
  " Enter Visual Mode (Any)
  au ModeChanged *:[vV\x16]* call s:EnterVisualAny()
  " Leave Visual Mode (Any)
  au Modechanged [vV\x16]*:* call s:LeaveVisualAny()

  " Enter Visual Mode (Character)
  au ModeChanged *:v* call s:EnterVisualChar()
  " Leave Visual Mode (Character)
  au ModeChanged v*:* call s:LeaveVisualChar()

  " Enter Visual Mode (Line)
  au ModeChanged *:V* call s:EnterVisualLine()
  " Leave Visual Mode (Line)
  au ModeChanged V*:* call s:LeaveVisualLine()
  " Enter Visual Mode (Block)
  au ModeChanged *:[\x16]* call s:EnterVisualBlock()
  " Leave Visual Mode (Block)
  au Modechanged [\x16]*:* call s:LeaveVisualBlock()
augroup END

