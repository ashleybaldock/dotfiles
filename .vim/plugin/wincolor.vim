if exists("g:mayhem_loaded_wincolor")
  finish
endif
let g:mayhem_loaded_wincolor = 1


" Set individual window backgrounds
" -> See also CustomStatusline in ./statusline.vim
function! s:WinColorUpdate()
  if exists('w:mayhem_wincolor_override')
    let &l:wincolor = get(w:, 'mayhem_wincolor_override', 'WinNormal')
  elseif &diff
    setlocal wincolor=WinDiff
  elseif &buftype == 'quickfix'
    setlocal wincolor=WinQuickfix
  elseif &buftype == 'preview'
    setlocal wincolor=WinPreview
  elseif &buftype == 'help'
    setlocal wincolor=WinHelp
  elseif &ft == 'netrw'
    setlocal wincolor=WinNetrw
  elseif (&readonly || !&modifiable)
    setlocal wincolor=WinReadonly
  else
    setlocal wincolor=WinNormal
  endif
endfunc

" Overide current window background color temporarily
function! s:WinColorOverride(tempwincolor, duration)
  let w:mayhem_wincolor_override = a:tempwincolor
  let w:mayhem_wincolor_saved = &l:wincolor
  call s:WinColorUpdate()
  if (get(a:, 'duration', 0) > 0)
    call timer_start(duration, {_ -> s:WinColorReset(w:mayhem_wincolor_saved)})
  endif
endfunc

function! s:WinColorReset()
  unlet w:mayhem_wincolor_override
  let &l:wincolor = get(w:, 'mayhem_wincolor_saved', 'WinNormal')
  call s:WinColorUpdate()
  echom 'WinColorReset '..&l:wincolor..' '..&wincolor
endfunc

:command! WinColorReset :call <SID>WinColorReset()
:command! WinColorOverride :call <SID>WinColorOverride()

augroup wincolor
  autocmd!

  au OptionSet diff call s:WinColorUpdate()
  au WinEnter,WinLeave,BufEnter,BufLeave,DiffUpdated * call s:WinColorUpdate()
augroup END

function! s:HighlightUnsavedWindows()
  if (&modified && &l:wincolor != 'WinUnsaved')
    s:WinColorOverride('WinUnsaved', 800)
  endif
endfunc
  
:command! Unsaved :windo call <SID>HighlightUnsavedWindows()

