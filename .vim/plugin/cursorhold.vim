if exists("g:mayhem_loaded_cursorhold")
  finish
endif
let g:mayhem_loaded_cursorhold = 1

function s:ClearCurHoldHighlights() abort
  augroup CurHoldHighlightOverride
    autocmd!
  augroup END
  call clearmatches()
  " if exists('b:lastCursorHoldHighlight')
  "   silent! matchdelete(b:lastCursorHoldHighlight)
  " endif
endfunc

function s:CurHoldHlBrighterComments() abort
  call s:ClearCurHoldHighlights()
  augroup CurHoldHighlightOverride
    autocmd!
    " autocmd ColorScheme vividmayhem call s:CurHoldHlBrighterComments()
    autocmd CursorMoved <buffer> call s:ClearCurHoldHighlights()
  augroup END
  " sy match cursor +\%#+ contained
  " syn off | syn on
  " sy region htmlCommentCursor2 start=+<!+ end=+>+ contains=cursor

  "
  let b:lastCursorHoldHighlight = matchadd('CommentBright', '\%'.line('.').'l')
  " redraw!
endfunc

function s:CursorHoldHighlights() abort
  if !exists(g:mayhem_curhold_highlights) || !g:mayhem_curhold_highlights
    return
  endif
  if CursorOnComment()
    call s:CurHoldHlBrighterComments()
  endif
endfunc

augroup HighlightHold
  autocmd!
  " autocmd CursorHold <buffer> call s:CursorHoldHighlights()
augroup END




