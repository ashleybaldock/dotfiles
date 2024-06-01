if exists("g:mayhem_loaded_search")
  finish
endif
let g:mayhem_loaded_search = 1

" === Ack / Search ===

function s:AckEscaped(search)
  " The ! avoids jumping to first result automatically
  execute printf('Ack! -Q -- "%s"', substitute(a:search, '\([%"\\]\)', '\\\1', 'g'))
endfunc

function s:AckClipboard()
  call s:AckEscaped(@")
endfunc

function s:AckCurrentWord()
  call s:AckEscaped(expand("<cword>"))
endfunc

function s:AckLastSearch()
  call s:AckEscaped(@/)
endfunc

function! s:AckInput()
  call inputsave()
  let search = input("Ack! ")
  call inputrestore()
  call s:AckEscaped(search)
endfunc

:command! AckInput :exec <SID>AckInput()
:command! AckClipboard :exec <SID>AckClipboard()
:command! AckCurrentWord :exec <SID>AckCurrentWord()
:command! AckLastSearch :exec <SID>AckLastSearch()


