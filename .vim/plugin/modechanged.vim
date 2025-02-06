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

function! s:EnterVisual() abort
  if exists('#User#MayhemEnterVisual')
    doautocmd User MayhemEnterVisual
  endif

  " Auto-hide list chars when entering visual mode
  if exists('g:mayhem_hide_list_in_visual') && g:mayhem_hide_list_in_visual
    call Remember('vV^V', '&l:list')
    let &l:list = 0
  endif
endfunc

"
" When leaving any visual mode, going to a non-visual one
"
" 1.         MayhemLeaveVisual
" 2. One of: MayhemLeaveModeVC | MayhemLeaveModeVL | MayhemLeaveModeVB
"
function! s:LeaveVisual() abort
  if exists('#User#MayhemLeaveVisual')
    doautocmd User MayhemLeaveVisual
  endif

  call Restore('vV^V')
endfunc

function! s:EnterVisualChar() abort
  if exists('#User#MayhemEnterModeVC')
    doautocmd User MayhemEnterModeVC
  endif

  let &mouseshape = Remember('vV^V', '&mouseshape')..',v:beam'
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

function! s:LeaveVisualBlock() abort
  if exists('#User#MayhemLeaveModeVB')
    doautocmd User MayhemLeaveModeVB
  endif
endfunc

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

function! GetSetting(setting) abort
  exec 'let v = '..a:setting
  return v
endfunc

function! Remember(key, setting) abort
  let s:memories[a:key] = get(s:memories, a:key, {})
  let s:memories[a:key][a:setting] =
        \ get(s:memories[a:key], a:setting, GetSetting(a:setting))
  return s:memories[a:key][a:setting]
endfunc

"
" Restore any settings previously saved by Remember()
"
"  a:key     : name of group of stored settings to restore
"
function! Restore(group) abort
  if has_key(s:memories, a:group)
    for [key, value] in items(remove(s:memories, a:group))
      echom a:group
      echom key
      echom value
      exec 'let '..key..' = '''..value..''''
    endfor
  endif
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

