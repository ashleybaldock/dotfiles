if exists("g:mayhem_loaded_resize")
  finish
endif
let g:mayhem_loaded_resize = 1

"
" Window Resizing
"


" window with id 1069 has 12 of 44 lines visible. Cursor is on line 22, w0='' .. line(''w0'') .. '' ▬▶︎ w$='' .. line(''w$'')'
command! -addr=windows -count=0 WinSizeInfo EcN 'Window with id ' | EcB win_getid() | EcN ' has ' | EcB (line('w$') - line('w0') + 1) | EcN ' of ' | EcB line('$') | EcN ' lines visible. Cursor is on line ' | EcB line('.') | EcN ' ( w0=' | EcB line('w0') | EcN ' ▬▶︎ w$=' | EcB line('w$') | EcN ' )' 
"
" If window becomes 0 height, exclude from equalalways
"
function s:WindowsResized(windows)
  for wid in a:windows
    " let winheight = winheight(wid)
    " let winea = getwinvar(winnr(wid), '&equalalways')
    " let wineaoff = getwinvar(winnr(wid), 'equalalways')
    if winheight(wid) == 0
      " call setwinvar(wid, '&equalalways', 0)
      call setwinvar(wid, '&winfixheight', 1)
      " call setwinvar(wid, '&winfixwidth', 0)
      " call setwinvar(wid, '&eadirection', 0)
    else
      " call setwinvar(wid, '&equalalways', 1)
      call setwinvar(wid, '&winfixheight', 0)
    endif
  endfor
endfunc

call autocmd_add([
      \#{
      \ event: 'WinResized',
      \ pattern: '*', cmd: 'call s:WindowsResized(v:event.windows)',
      \ group: 'mayhem_resize_equalalways', replace: v:true,
      \},
      \])
