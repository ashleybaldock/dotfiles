if exists("g:mayhem_loaded_search")
  finish
endif
let g:mayhem_loaded_search = 1

" === Ack / Search ===



" Not: 0 1 2 3 4 5 6 7 8 9 \ " |
"      A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 
"      a b c d e f g h i j k l m n o p q r s t u v w x y z
" Or: # 
" (in vim9script)
"
let s:separatorCandidates = split(
      \ "/ _ ! ? $ & @ + ^ ~ - , . : ; < = ` ' ( ) [ ] { }")

" Find best separator that isn't in either pattern or replacement
function! s:FindPatternSeperator(pattern, replacement)
endfunc

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


