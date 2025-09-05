if exists("b:current_syntax")
  finish
endif

"
" Syntax for vim :messages
"
" au BufWritePost <buffer> syn on
"
" See Also:
"     ../plugin/messages.vim
"

let s:cpo_save = &cpo
set cpo&vim

syn region vimMsgDict
      \ matchgroup=vimMsgDictBrace start=+{+
      \ matchgroup=vimMsgDictBrace end=+}+
      \ contains=vimMsgDict,vimMsgStr,vimMsgNum,vimMsgDictNoise

syn region vimMsgStr
      \ start=+\z('\|"\)+
      \ end=+\z1+

syn match vimMsgNum '\%(:\|\s\)\@1<=\d\+' contained

syn match vimMsgNum '^\d\+$' contains=NONE

hi def vimMsgDict none
hi def link vimMsgDictBrace Delimiter
hi def link vimMsgStr String
hi def link vimMsgNum Number

syn region vimMsgError
      \ start=+^\(Error\|E\d\+\)+
      \ end=+$+
      \ contains=vimMsgErrNum,vimMsgPath,vimMsgFunc,vimMsgLastFn

syn match vimMsgErrNum 'E\d\+:' contained

      " \ start=+\%( \)\@2<=\/+
syn region vimMsgPath contained
      \ start=+ \ze\/+
      \ end=+\ze\.\.+
      \ end=+\ze:+
      " \ contains=vimMsgPathNlb4

" syn match vimMsgPathNlb4 / \ze\// contained conceal cchar=

" function {function-name}[{lnum}]  function line
"       script {file-name}[{lnum}]  script line
"                              ..   between items
"function {function-name1}[{lnum}]..{function-name2}[{lnum}]"

      " \ start=+\%(\.\.\\)\@2<=%(function \)\?<SNR>+
syn region vimMsgFunc contained
      \ start=+<SNR>+
      \ end=+\ze\.\.+
      \ contains=vimMsgFnSNR,vimMsgFnName,vimMsgFnLn,vimMsgnoise

syn match vimMsgLastFn '\%(\.\.\)\@2<=\a\w\+\ze:$' contained

syn region vimMsgFnSNR contained
      \ matchgroup=vimMsgnoise start=+<+
      \ matchgroup=vimMsgnoise end=+>+

syn region vimMsgFnLn contained
      \ matchgroup=vimMsgnoise start=+\[+
      \ matchgroup=vimMsgnoise end=+\]+

syn match vimMsgFnName '\a\w\+' contained

syn match vimMsgnoise '_' contained

syn match vimMsgLineNr '^line\s\+\d\+.*$'

syn match vimMsgWrite '^.*written$'

syn region vimMsgCompile
      \ start='^\zeFunction '
      \ end='compiling$' contains=vimMsgCompileFn

syn match vimMsgCompileFn '\%(^Function \)\@12<=\S\+' contained
syn match vimMsgTitle '-- \w\+ Messages --' fold

syn match vimMsgTitle '⁓ Fin ⁓'


hi def vimMsgOk       guifg=#066606
hi def vimMsgLineNr   guifg=#dddd00
hi def vimMsgError    guifg=#dd2222
hi def vimMsgErrNum   guifg=#ff0000 guibg=#880000 
hi def vimMsgWrite    guifg=#00bb33
hi def vimMsgPath     guifg=#55dddd
hi def vimMsgFunc     guifg=#339933
hi def vimMsgnoise    guifg=#393939
hi def vimMsgFnSNR    guifg=#339933
hi def vimMsgFnSep    guifg=#393939
hi def link vimMsgFnLn vimMsgFnSNR
hi def link vimMsgFnName Function
hi def link vimMsgCompileFn vimMsgFunc
hi def link vimMsgCompile vimMsgOk
hi def link vimMsgLastFn Function
hi def link vimMsgTitle Comment

let b:current_syntax = "vimmessages"

let &cpo = s:cpo_save
unlet s:cpo_save
