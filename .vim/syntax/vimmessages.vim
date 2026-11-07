if exists("b:current_syntax")
  finish
endif

"
" Syntax for vim :messages
"
" :au BufWritePost <buffer> syn on
"
" Related:
"     $VIMHOME/plugin/messages.vim
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

syn region vimMsgError
      \ start=+^\%(Vim\%((\S\+)\)\?:\|Err\%[or]:\?\)\?\(E\d\+\)+
      \ end=+$+
      \ contains=vimMsgErrNum,vimMsgPath,vimMsgFunc,vimMsgLastFn

syn match vimMsgErrNum 'E\d\+:' contained

syn match vimMsgPthDelim +/+ contained contains=NONE
syn region vimMsgPthLnum contained oneline
      \ matchgroup=vimMsgPthDelim start='\['
      \ end=']'
syn region vimMsgPath contained oneline
      \ start=+ \ze\/+
      \ start=+\.\.\zs\/+
      \ end=+\ze\.\.+
      \ end=+\ze:+
      \ contains=vimMsgPthLnum,vimMsgPthDelim
      \ nextgroup=vimMsgPth skipnl

" syn match vimMsgPathNlb4 / \ze\// contained conceal cchar=

" function {function-name}[{lnum}]  function line
"       script {file-name}[{lnum}]  script line
"                              ..   between items
"function {function-name1}[{lnum}]..{function-name2}[{lnum}]"

      " \ start=+\%(\.\.\\)\@2<=%(function \)\?<SNR>+
syn region vimMsgFunc contained
      \ start=+<SNR>+
      \ start=+function \zs+
      \ end=+\ze\.\.+
      \ end=+\ze\s+
      \ contains=vimMsgFnSNR,vimMsgFnName,vimMsgFnLn,vimMsgNoise,vimMsgAutoSep

syn match vimMsgLastFn '\%(\.\.\)\@2<=\a\w\+\ze:$' contained

syn region vimMsgFnSNR contained
      \ matchgroup=vimMsgNoise start=+<+
      \ matchgroup=vimMsgNoise end=+>+

syn region vimMsgFnLn contained
      \ matchgroup=vimMsgNoise start=+\[+
      \ matchgroup=vimMsgNoise end=+\]+

syn match vimMsgFnName '\a\w\+' contained contains=NONE

syn match vimMsgAutoSep '#' contained contains=NONE

syn match vimMsgAuName '\w\+\ze Autocommands' contained contains=NONE

syn region vimMsgStack contains=vimMsgFunc,vimMsgAuName,vimMsgPath,vimMsgStr
      \ start='Error detected while'
      \ end=':'

syn match vimMsgNoise '_' contained

syn match vimMsgLineNr '^line\s\+\d\+.*$'

syn match vimMsgWrite '^.*written$'

syn region vimMsgCompile
      \ start='^\zeFunction '
      \ end='compiling$' contains=vimMsgCompileFn

syn match vimMsgCompileFn '\%(^Function \)\@12<=\S\+' contained
syn match vimMsgTitle '-- \w\+ Messages --' fold

syn match vimMsgTitle '⁓ Fin ⁓'

hi def vimMsgDict none
hi def link vimMsgDictBrace Delimiter
hi def link vimMsgStr String
hi def link vimMsgNum Number

hi def vimMsgOk       guifg=#066606
hi def vimMsgLineNr   guifg=#dddd00
hi def vimMsgStack    guifg=#dddddd
hi def vimMsgError    guifg=#ff2222
hi def vimMsgErrNum   guifg=#ff2222 guibg=#550000 
hi def vimMsgWrite    guifg=#00bb33
hi def vimMsgPath     guifg=#55dddd
hi def vimMsgPthLnum  guifg=#77dddd
hi def vimMsgPthDelim guifg=#339999
hi def vimMsgFunc     guifg=#339933
hi def vimMsgNoise    guifg=#393939
hi def vimMsgFnSNR    guifg=#339933
hi def vimMsgFnSep    guifg=#393939
hi def link vimMsgFnLn vimMsgFnSNR
hi def link vimMsgFnName Function
hi def link vimMsgAutoSep Statement
hi def link vimMsgAuName Type
hi def link vimMsgCompileFn vimMsgFunc
hi def link vimMsgCompile vimMsgOk
hi def link vimMsgLastFn Function
hi def link vimMsgTitle Comment

let b:current_syntax = "vimmessages"

let &cpo = s:cpo_save
unlet s:cpo_save
