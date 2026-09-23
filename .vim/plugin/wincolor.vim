if exists("g:mayhem_loaded_wincolor")
  finish
endif
let g:mayhem_loaded_wincolor = 1


" Set individual window backgrounds
" -> See also CustomStatusline in ./statusline.vim
function! s:WinColorUpdate()
  if exists('w:mayhem_wincolor_override')
    exec 'setlocal winhighlight+=!(:' .. get(w:, 'mayhem_wincolor_override', 'WinNormal')
    return
  endif

  " Diff mode
  if &diff
    setlocal winhighlight+=!(:WinDiff
    return
  endif

  " Filetype specific
  if &ft == 'netrw'
    setlocal winhighlight+=!(:WinNetrw
    return
  endif

  " Buffer type specific
  if &buftype == 'quickfix'
    setlocal winhighlight+=!(:WinQuickfix
    return
  endif
  if &buftype == 'preview'
    setlocal winhighlight+=!(:WinPreview
    return
  endif
  if &buftype == 'help'
    setlocal winhighlight+=!(:WinHelp
    return
  endif

  " For all other buffers
  if (&readonly || !&modifiable)
    setlocal winhighlight+=!(:WinReadonly
  else
    setlocal winhighlight+=!(:WinNormal
  endif
endfunc

"
" (Temporarily) Override current window background color
" If duration > 0, reset it again after that long
"
function! s:WinColorOverride(tempwincolor, duration = 0)
  let w:mayhem_wincolor_override = a:tempwincolor
    let localwinhighlight = (&l:winhighlight ?? '')->split(',')->map({i,v -> split(v, ':')})->mayhem#fromentries()
  let w:mayhem_wincolor_saved = get(localwinhighlight, '!(', 'WinNormal')
  call s:WinColorUpdate()
  if a:duration > 0
    call timer_start(a:duration, {_ -> s:WinColorReset()})
  endif
endfunc

function! s:WinColorReset()
  exec 'setlocal wincolor+=!(:' .. get(w:, 'mayhem_wincolor_saved', 'WinNormal')
  unlet w:mayhem_wincolor_override
  unlet w:mayhem_wincolor_saved
  call s:WinColorUpdate()
endfunc

command! WinColorReset call <SID>WinColorReset()
command! WinColorOverride call <SID>WinColorOverride()

call autocmd_add([
      \#{
      \ event: 'OptionSet', pattern: 'diff',
      \ cmd: 'call s:WinColorUpdate()',
      \ group: 'mayhem_wincolor', replace: v:true,
      \},
      \#{
      \ event: ['WinEnter','WinLeave','BufEnter','BufLeave','DiffUpdated'],
      \ pattern: '*',
      \ cmd: 'call s:WinColorUpdate()',
      \ group: 'mayhem_wincolor', replace: v:true,
      \},
      \])

function! s:HighlightUnsavedWindows()
  if (&modified && &l:wincolor != 'WinUnsaved')
    call s:WinColorOverride('WinUnsaved', 800)
  endif
endfunc
  
command! Unsaved windo call <SID>HighlightUnsavedWindows()

