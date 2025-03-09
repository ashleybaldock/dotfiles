if exists("b:current_syntax")
  finish
endif

"
" Syntax for vim :messages
"
" au BufWritePost <buffer> syn on
"

let s:cpo_save = &cpo
set cpo&vim

syn region vimmsgDict
      \ matchgroup=vimmsgDictBrace start=+{+
      \ matchgroup=vimmsgDictBrace end=+}+
      \ contains=vimmsgDict,vimmsgStr,vimmsgNum,vimmsgDictNoise

syn region vimmsgStr
      \ start=+\z('\|"\)+
      \ end=+\z1+

syn match vimmsgNum '\%(:\|\s\)\@1<=\d\+' contained

syn match vimmsgNum '^\d\+$' contains=NONE

hi def vimmsgDict none
hi def link vimmsgDictBrace Delimiter
hi def link vimmsgStr String
hi def link vimmsgNum Number

syn region vimmsgError
      \ start=+^\(Error\|E\d\+\)+
      \ end=+$+
      \ contains=vimmsgErrNum,vimmsgPath,vimmsgFunc,vimmsgLastFn

syn match vimmsgErrNum 'E\d\+:' contained

syn region vimmsgPath contained
      \ start=+\%( \)\@2<=\/+
      \ end=+\ze\.\.+

" function {function-name}[{lnum}]  function line
"       script {file-name}[{lnum}]  script line
"                              ..   between items
"function {function-name1}[{lnum}]..{function-name2}[{lnum}]"

      " \ start=+\%(\.\.\\)\@2<=%(function \)\?<SNR>+
syn region vimmsgFunc contained
      \ start=+<SNR>+
      \ end=+\ze\.\.+
      \ contains=vimmsgFnSNR,vimmsgFnName,vimmsgFnLn,vimmsgnoise

syn match vimmsgLastFn '\%(\.\.\)\@2<=\a\w\+\ze:$' contained

syn region vimmsgFnSNR contained
      \ matchgroup=vimmsgnoise start=+<+
      \ matchgroup=vimmsgnoise end=+>+

syn region vimmsgFnLn contained
      \ matchgroup=vimmsgnoise start=+\[+
      \ matchgroup=vimmsgnoise end=+\]+

syn match vimmsgFnName '\a\w\+' contained

syn match vimmsgnoise '_' contained

syn match vimmsgLineNr '^line\s\+\d\+.*$'

syn match vimmsgWrite '^.*written$'

syn match vimmsgTitle '-- \w\+ Messages --' fold


hi def vimmsgLineNr   guifg=#dddd00
hi def vimmsgError    guifg=#dd2222
hi def vimmsgErrNum   guifg=#000000 guibg=#ff0000 gui=bold
hi def vimmsgWrite    guifg=#00bb33
hi def vimmsgPath     guifg=#55dddd
hi def vimmsgFunc     guifg=#339933
hi def vimmsgnoise    guifg=#393939
hi def vimmsgFnSNR    guifg=#339933
hi def vimmsgFnSep    guifg=#393939
hi def link vimmsgFnLn vimmsgFnSNR
hi def link vimmsgFnName Function
hi def link vimmsgLastFn Function
hi def link vimmsgTitle Comment

let b:current_syntax = "vimmessages"

let &cpo = s:cpo_save
unlet s:cpo_save
