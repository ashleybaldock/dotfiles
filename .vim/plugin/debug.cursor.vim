if exists("g:mayhem_loaded_debug_cursor")
  finish
endif
let g:mayhem_loaded_debug_cursor = 1



function! s:CursorInfoUpdateFocusGained()
  let s:hasfocus = 1
  call s:CursorInfoUpdate()
endfunc

function! s:CursorInfoUpdateFocusLost()
  let s:hasfocus = 0
  call s:CursorInfoUpdate()
endfunc

function! s:CursorInfoUpdate()
  let mousepos = getmousepos()

endfunc

s:cursor_events_group = 'mayhem_debug_cursor_events'

function! s:CursorInfoOff() abort
  unlet s:cursor_info_enabled

  call autocmd_delete([#{group: s:cursor_events_group}])
  
  " remove popup
endfunc

function! s:CursorInfoOn() abort
  let s:cursor_info_enabled = v:true
  call autocmd_add([
      \#{
      \ event: 'FocusGained', pattern: '*',
      \ cmd: 'call s:CursorInfoUpdateFocusGained()',
      \ group: s:cursor_events_group, replace: v:true,
      \},
      \#{
      \ event: 'FocusLost', pattern: '*',
      \ cmd: 'call s:CursorInfoUpdateFocusLost()',
      \ group: s:cursor_events_group, replace: v:true,
      \},
      \#{
      \ event: ['VimResized','CursorMoved','CursorMovedI'], pattern: '*',
      \ cmd: 'call s:CursorInfoUpdate()',
      \ group: s:cursor_events_group, replace: v:true,
      \},
      \])
endfunc

function! s:CursorInfoToggle(action) abort
  if s:cursor_info_enabled
    call s:CursorInfoOff()
  else
    call s:CursorInfoOn()
  endif
endfunc

s:ToggleLookup = #{
      \     on: function(s:CursorInfoOn),
      \    off: function(s:CursorInfoOff),
      \ toggle: function(s:CursorInfoToggle),
      \}

function! s:SimpleToggleComplete(ArgLead, CmdLine, CursorPos)
  return keys(s:toggleLookup)
endfunc

command! -nargs=1 CursorInfo call <SID>ToggleLookup[<f-args>]()

