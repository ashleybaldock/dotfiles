"
" /\\e\[48;5;\(\%([01]\?[0-9]\|2[0-5]\)\?[0-9]\)m/
"
" :au BufWritePost <buffer> syn on
"
syn match ansiEsc /\\\|e\|033\|u001[bB]\|x1[bB]/ contained contains=ansiCSI display skipwhite nextgroup=ansiArg1,ansiCmd
syn match ansiCSI /\[/ contained contains=NONE display
syn match ansiArg1 /\d\+/ contained contains=ansiDelim display skipwhite nextgroup=ansiArg2,ansiEnd
syn match ansiArg2 /\d\+/ contained contains=ansiDelim display skipwhite nextgroup=ansiArg3,ansiEnd
syn match ansiArg3 /\d\+/ contained contains=ansiDelim display skipwhite nextgroup=ansiEnd

syn region ansiSeq keepend
      \ start=/\\e/
      \ start=/\\033/
      \ start=/\\u001[bB]/
      \ start=/\\x1[bB]/
      \ end=/m/
      \ contains=ansiEsc

hi def ansiEsc guifg=#880044
hi def ansiCSI guifg=#888888
hi def ansiArg1 guifg=#228888
hi def ansiArg2 guifg=#882288
hi def ansiArg3 guifg=#888822
hi def ansiDelim guifg=#888888
hi def ansiEnd guifg=#888888

hi def ansiSeq guibg=#444444
