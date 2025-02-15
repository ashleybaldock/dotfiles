"
" Netrw
"
" au BufWritePost <buffer> syn on | HiHi
" au BufWritePost <buffer> HiHi
"
hi netrwVersion  none | hi link netrwVersion  Identifier

hi netrwComment  none | hi link netrwComment Comment
hi netrwGray     none | hi netrwGray guifg=#444444
hi netrwPlain    none
hi netrwSpecial  none

hi netrwHide     none | hi link netrwHide    Comment
hi netrwHidePat  none | hi link netrwHidePat String
hi netrwHideSep  none | hi link netrwHideSep SignDgInfo
hi netrwComma    none | hi link netrwComma   SignDgInfo
hi netrwSlash    none

hi netrwList     none | hi link netrwList    String
hi netrwTags     none | hi link netrwTags    netrwGray
hi netrwTilde    none | hi link netrwTilde   netrwGray

hi netrwSpecFile none | hi link netrwSpecFile netrwGray


hi netrwSortBy   none | hi link netrwComment Comment
hi netrwSortSeq  none | hi link netrwHideSep SignDgInfo

hi netrwTime     none
hi netrwTimeSep  none | hi link netrwTimeSep Delimiter
hi netrwDateSep  none | hi link netrwDateSep Delimiter
hi netrwSizeDate none

hi netrwTreeBar  none | hi link netrwTreeBar Special
hi netrwTreeBarSpace none

hi netrwTmp      none | hi link netrwTmp      netrwGray
hi netrwLink     none | hi link netrwLink     SignDgWarn
hi netrwSymLink  none | hi link netrwSymLink  SignDgInfo

" single char representing type, e.g.
" .bashrc@̲ --> dotfiles/.bashrc
hi netrwClassify none
hi netrwLib      none | hi link netrwLib  DiffChange
hi netrwExe      none | hi link netrwExe  PreProc
hi netrwDir      none | hi netrwDir       guifg=#ffee88
hi netrwDoc      none | hi netrwDoc       guifg=#aaff99
hi netrwCompress none | hi netrwCompress  guifg=#888899
hi netrwPix      none | hi netrwPix       guifg=#88ffdd



hi netrwQuickHelp none| hi link netrwQuickHelp netrwPlain
hi netrwHelpCmd  none | hi link netrwHelpCmd  Function
hi netrwCmdSep   none | hi link netrwCmdSep  Delimiter
hi netrwCmdNote  none | hi link netrwCmdNote netrwPlain
" Color of targets that can trigger copying
hi netrwCopyTgt  none | hi link netrwCopyTgt htmlLink
hi netrwQHTopic  none | hi link netrwQHTopic Number


" hi netrwBak
" hi netrwCoreDump
" hi netrwData
"
" hi netrwHdr
" hi netrwLex
" hi netrwMakefile
" hi netrwObj
" hi netrwMarkFile

" hi netrwYacc     none

