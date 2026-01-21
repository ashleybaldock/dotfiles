"
" See Also: 
"          ../../syntax/markdown.vim
"       ../after/syntax/markdown.vim
"    $VIMRUNTIME/syntax/markdown.vim
"  ../../after/ftplugin/markdown.vim
"
" Test Doc:   ../../demo/markdown.md
"

" HlMkDnCode 
" HlMkDnCdDelim
"
hi link HlMkDnCode mdCode
hi HlMkDnCodeBg   guifg=NONE    guibg=#163646 gui=none
hi link HlMkDnCdBlock mdCodeBlock
hi link HlMkDnCdDelim mdCodeDelim  
hi HlMkDnHeader   guifg=#cc44cc               gui=bold
hi HlMkDnLink     guifg=#15aabf               gui=italic,underline

"hi markdownHeadingRule
hi link markdownH1 mdH1
hi link markdownH2 mdH2
hi link markdownH3 mdH3
hi link markdownH4 mdH4
hi link markdownH5 mdH5
hi link markdownH6 mdH6
hi link markdownH1Delimiter Delimiter
hi link markdownH2Delimiter Delimiter
hi link markdownH3Delimiter Delimiter
hi link markdownH4Delimiter Delimiter
hi link markdownH5Delimiter Delimiter
hi link markdownH6Delimiter Delimiter
hi link markdownHeadingDelimiter Delimiter

" hi markdownOrderedListMarker
" hi markdownListMarker
" hi markdownBlockquote
" hi markdownRule

" hi markdownFootnote
" hi markdownFootnoteDefinition

hi link markdownLinkText              htmlLink
hi link markdownAutomaticLink         markdownUrl
hi link markdownUrl                   Float
hi link markdownUrlTitle              String
hi link markdownUrlDelimiter          htmlTag
hi link markdownUrlTitleDelimiter     Delimiter

hi link markdownId mdId
hi link markdownIdDeclaration mdIdDecl
hi link markdownIdDelimiter           markdownLinkDelimiter

hi link markdownItalic HlItalic
hi markdownItalicDelimiter gui=italic,inverse
hi link markdownBold HlBold
hi markdownBoldDelimiter gui=bold,inverse
hi link markdownBoldItalic HlBoldItalic
hi markdownBoldItalicDelimiter gui=bold,italic,inverse
hi link markdownStrike HlStrike
hi markdownStrikeDelimiter gui=strikethrough,inverse

hi link markdownCode HlMkDnCode
hi link markdownCodeBlock HlMkDnCdBlock
hi link markdownCodeDelimiter HlMkDnCdDelim

hi link markdownEscape mdEscape
hi link markdownError mdError

hi link markdownHighlight_sh mdCodeBlockBg
hi link markdownHighlight_javascript mdCodeBlockBg
hi link markdownHighlight_typescript mdCodeBlockBg
hi link markdownHighlight_json mdCodeBlockBg

