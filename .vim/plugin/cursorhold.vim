if exists("g:mayhem_loaded_cursorhold")
  finish
endif
let g:mayhem_loaded_cursorhold = 1

let s:matchids = []

" Highlight the cursor location
" TODO

" Highlight the contiguous whitespace surrounding the cursor
" TODO

" Highlight the entire width of the <Tab> that the cursor is on
function s:CursorTab() abort
  let s:matchids['tab'] = matchadd('Error', '\%#	', 2)
endfunc

let g:mayhem_chold_highlight_tab = 0

" Highlight the <cword> under cursor
function s:CursorWord() abort
  if mayhem#Toggled('g:mayhem_chold_highlight_word')
    call matchdelete(s:matchids['word'])
    let s:matchids['word'] = matchadd('Error', '\<\S\{-}\%#\S\{-}\>', 2)
  else
    call matchdelete(s:matchids['word'])
  endif
endfunc

let g:mayhem_chold_highlight_word = 0

" Highlight the string the cursor is within
" (matched pairs of: "", '', `` etc.)
" TODO


" command! -bar -nargs=0 CharInfoToggle Toggle g:mayhem_hl_auto_charinfo<CR>

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




