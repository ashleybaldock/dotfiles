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
function! s:EnterVisual() abort
  if exists('g:mayhem_hide_list_in_visual') && g:mayhem_hide_list_in_visual
    if !exists('s:list_state_on_last_entering_visual')
      let s:list_state_on_last_entering_visual = &list
    endif
    let &list = 0
  endif
endfunc
function! s:LeaveVisual() abort
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
  if exists('#User#MayhemEnterModeVC')
    doautocmd User MayhemEnterModeVC
  endif

  if !exists('s:mouseshape_state_on_last_entering_visual')
    let s:mouseshape_state_on_last_entering_visual = &mouseshape
  endif
  let &mouseshape = s:mouseshape_state_on_last_entering_visual..',v:beam'
endfunc

function! s:LeaveVisualChar() abort
  if exists('#User#MayhemLeaveModeVC')
    doautocmd User MayhemLeaveModeVC
  endif

endfunc

function! s:EnterVisualLine() abort
  if exists('#User#MayhemEnterModeVL')
    doautocmd User MayhemEnterModeVL
  endif

  let &mouseshape = Remember('vV^V', '&mouseshape')..',v:beam'
  " if !exists('s:mouseshape_state_on_last_entering_visual')
  "   let s:mouseshape_state_on_last_entering_visual = &mouseshape
  " endif
  " let &mouseshape = s:mouseshape_state_on_last_entering_visual..',v:beam'
endfunc

function! s:LeaveVisualLine() abort
  if exists('#User#MayhemLeaveModeVL')
    doautocmd User MayhemLeaveModeVL
  endif
endfunc

function! s:EnterVisualBlock() abort
  let &mouseshape = Remember('vV^V', '&mouseshape')..',v:crosshair'

  if exists('#User#MayhemEnterModeVB')
    doautocmd User MayhemEnterModeVB
  endif
endfunc
  " if !exists('s:colorcolumn_state_on_last_entering_visual_block')
  "   let s:colorcolumn_state_on_last_entering_visual_block = &l:colorcolumn
  " endif
  " let &l:colorcolumn = charcol('.')

  " if !exists('s:mouseshape_state_on_last_entering_visual')
  "   let s:mouseshape_state_on_last_entering_visual = &mouseshape
  " endif
  " let &mouseshape = s:mouseshape_state_on_last_entering_visual..',v:crosshair'

function! s:LeaveVisualBlock() abort
  if exists('#User#MayhemLeaveModeVB')
    doautocmd User MayhemLeaveModeVB
  endif
endfunc

  " if exists('s:colorcolumn_state_on_last_entering_visual_block')
  "   let &l:colorcolumn = s:colorcolumn_state_on_last_entering_visual_block
  " endif

"
" Store settings for later restoration
"
"  a:key     : name for group of stored settings
"              used to restore them all with Restore()
"  a:setting : string, exec'd to get value to store
"              used when restoring it later
"  return    : the stored value of a:setting
"              this is useful to append to a setting, e.g.
"     let &virtualedit = Remember('x', '&virtualedit')..',block'
"
"  A setting can only be stored once under a given key
"  When Restore('key') is called, all settings for that key
"  are restored, and the key can be used again, e.g.:
"
"  func EnterModeA()
"    let &virtualedit = Remember('A', '&virtualedit')..',block'
"  endf
"  func LeaveModeA()
"    Restore('A')
"  endf
"  echom &virtualedit  -> 'onemore'
"  call EnterModeA()   <- Saves previous value for &virtualedit
"  echom &virtualedit  -> 'onemore,block'
"  call EnterModeA()   <- &virtualedit has already been saved,
"                         the saved value is combined with ',block'
"  echom &virtualedit  -> 'onemore,block'
"  call LeaveModeA()   <- Stored value is restored
"  echom &virtualedit  -> 'onemore'
"
let s:memories = {}
function! Remember(key, setting)
  let s:memories[a:key] = get(s:memories, a:key, {})
  let s:memories[a:key][a:setting] = get(s:memories[a:key], a:setting, ExecAndReturn(a:setting))
  return s:memories[a:key][a:setting]
endfunc

"
" Restore any settings previously saved by Remember()
"
"  a:key     : name of group of stored settings to restore
"
function! Restore(group)
  for [key, value] in items(get(s:memories, a:group, {}))
    exec 'let '..key..' = '..value
  endfor
endfunc

augroup VisualEvent
  autocmd!
  " Leave Visual Mode (Any)
  " (only fired if new mode is not v, V or ^V)
  au Modechanged [vV\x16]:[^vV\x16]\+ call s:LeaveVisual()
  " Enter Any Visual Mode
  " (only fired if old mode was not v, V or ^V)
  au ModeChanged [^vV\x16]\+:[vV\x16]* call s:EnterVisual()

  " Leave Visual Mode (Character)
  au ModeChanged v*:* call s:LeaveVisualChar()
  " Leave Visual Mode (Line)
  au ModeChanged V*:* call s:LeaveVisualLine()
  " Leave Visual Mode (Block)
  au Modechanged [\x16]*:* call s:LeaveVisualBlock()

  " Enter Visual Mode (Character)
  au ModeChanged *:v* call s:EnterVisualChar()
  " Enter Visual Mode (Line)
  au ModeChanged *:V* call s:EnterVisualLine()
  " Enter Visual Mode (Block)
  au ModeChanged *:[\x16]* call s:EnterVisualBlock()
augroup END

