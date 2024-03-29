" Based on tpope's vividchalk
"
" so $VIMRUNTIME/syntax/hitest.vim
" 

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "vividmayhem"

"══════════════════════════════════════════════════════╡ Window ╞══════════
" 𝓲⃞  [gui=] ignored for 'Normal' highlight
hi Normal        guifg=#DEDEDE guibg=#000000 gui=none ctermfg=White ctermbg=NONE
" Used to change Normal colours per window based on buffer type
hi WinNormal     guifg=#DEDEDE guibg=#090909 gui=none
hi WinReadonly   guifg=#DEDEDE guibg=#090909 gui=none
hi WinNoModify   guifg=#DEDEDE guibg=#090909 gui=none
hi WinPreview    guifg=#DEDEDE guibg=#090909 gui=none
hi WinHelp       guifg=#e5e5ff guibg=#020922 gui=none

"══════════════════════════════════════════════════════╡ Lines & Cursor ╞══════════
"
hi LineNr        guifg=#DDEEFF guibg=#222222          ctermfg=White ctermbg=DarkBlue
"hi LineNrAbove
"hi LineNrBelow

hi Cursor        guifg=#000000 guibg=#FFFFFF gui=none ctermfg=Black ctermbg=White
hi CursorLine    guifg=NONE    guibg=#1d002d
"hi CursorLineNr  (w/ relativenumber)
"hi CursorLineFold (in folds column)
"hi CursorLineSign (in signs column)
hi CursorColumn  guifg=NONE    guibg=#333333

"══════════════════════════════════════════════════════╡ Search ╞══════════
hi Search        guifg=NONE    guibg=#555555 gui=none ctermfg=NONE  ctermbg=Black     cterm=none
hi IncSearch     guifg=#FEFEFE guibg=#000000          ctermfg=White ctermbg=Black
hi link CurSearch Search

hi Visual none | hi Visual     guibg=#232344 gui=none ctermfg=none                    cterm=none

hi MoreMsg       guifg=#00AA00                        ctermfg=Green
hi ErrorMsg      guifg=NONE    guibg=#CE0000          ctermfg=NONE  ctermbg=DarkRed
hi WarningMsg    guifg=#FF7c00 guibg=#550000          ctermfg=Red

hi Question none | hi link Question MoreMsg

hi Title         guifg=Magenta                        ctermfg=Magenta

hi WildMenu      guifg=#000000 guibg=#767fff gui=bold ctermfg=Black ctermbg=Yellow    cterm=bold

hi Directory none | hi link Directory Identifier

"══════════════════════════════════════════════════════╡ Invisible(ish) ╞══════════
"
hi Conceal       guifg=#6666A2 guibg=NONE             ctermfg=NONE
hi Ignore        guifg=#8888AA guibg=#222244          ctermfg=NONE
" Diagnostics related
hi link CocFadeOut             Conceal
hi link CocDeprecatedHighlight CocStrikeThrough
hi link CocUnusedHighlight     CocFadeOut

" Used for: fillchars: eob
hi EndOfBuffer   guifg=#605050 guibg=#050505
" Used for: listchars: eol,extends,precedes;
hi NonText       guifg=#404040                         ctermfg=8
" Used for: listchars: tab,nbsp,space,multispace,lead,trail;
" e.g.:    			   
hi SpecialKey    guifg=#404040                         ctermfg=8
hi U8Whitespace  guifg=#dd1111 guibg=#dd1111

"══════════════════════════════════════════════════════╡ Menu Popups ╞══════════
"
" Popup menu (e.g. tab completion)
hi Pmenu         guifg=#ffffff guibg=#220055          ctermfg=15 ctermbg=9 cterm=bold 
hi PmenuSel      guifg=#ffffff guibg=#440077 gui=bold ctermfg=15 ctermbg=3 cterm=bold 
" e.g. K in: |match   K [TSC]|
hi PmenuKind     guifg=#00ffaf guibg=#220055          ctermfg=15 ctermbg=9 cterm=bold 
hi PmenuKindSel  guifg=#00ffaf guibg=#440077 gui=bold ctermfg=15 ctermbg=3 cterm=bold 
" e.g. [TSC] in: |match   K [TSC]|
hi PmenuExtra    guifg=#af00af guibg=#220055          ctermfg=15 ctermbg=9 cterm=bold 
hi PmenuExtraSel guifg=#af00af guibg=#440077 gui=bold ctermfg=15 ctermbg=9 cterm=bold 
hi PmenuSbar     guibg=#220055                                   ctermbg=Grey
hi PmenuThumb    guibg=#4400ff                                   ctermbg=White
hi link CocPum Pmenu
" hi CocSymbol
hi link CocMenuSel PmenuSel

"══════════════════════════════════════════════════════╡ Vertical ╞══════════
" (signs, folds etc.)
hi VertSplit       guifg=#666666 guibg=#151515 gui=none  term=reverse cterm=reverse 

hi Folded          guifg=#aaddee guibg=NONE    gui=none  ctermfg=11 ctermbg=DarkBlue
hi FoldColumn                    guibg=#001166
hi SignColumn                    guibg=#101025

hi GitGutterAdd    guifg=#009900 guibg=#0a1f0a gui=none  ctermfg=2 ctermbg=0 
hi GitGutterChange guifg=#cfc040 guibg=#101025 gui=none  ctermfg=3 ctermbg=0 
hi GitGutterDelete guifg=#ee2222 guibg=#101025 gui=none  ctermfg=1 ctermbg=0 

" Signs & sign column
hi CocErrorSign    guifg=#dd2222 guibg=#1f0505
hi CocErrorLine                  guibg=#1f0505
hi CocWarningSign  guifg=#FFAA00 guibg=#301e00
" hi CocWarningLine                guibg=#121200
hi CocInfoSign     guifg=#00FFFF guibg=#101025
" hi CocInfoLine
hi CocHintSign     guifg=#bb99ff guibg=#101025
" hi CocHintLine
"
"══════════════════════════════════════════════════════╡  Horizontal   ╞══════════
"
hi TabLine       guifg=#bbbbbb guibg=#333333 gui=underline ctermfg=7  ctermbg=8 cterm=underline 
hi TabLineSel    guifg=#ffffff guibg=#000000               ctermfg=15 ctermbg=0
hi TabLineFill   guifg=#bbbbbb guibg=#808080 gui=underline ctermfg=7  ctermbg=7 cterm=underline

hi ToolbarLine   guifg=#6f66af guibg=#110044
hi ToolbarButton guifg=#afaaaf guibg=#00226e gui=none,italic
"══════════════════════════════════════════════════════╡ Inline Errors ╞══════════
"
hi ErrorHint     guifg=NONE    guibg=NONE guisp=#FE0000 gui=undercurl term=reverse ctermbg=12
hi link Error ErrorHint
hi WarningHint   guifg=NONE    guibg=NONE guisp=#DDBB00 gui=underdotted term=reverse ctermbg=12
hi link InfoHint  SpellCap
hi link HintHint  SpellLocal

"══════════════════════════════════════════════════════╡ Code Sections ╞══════════
"
hi Type          guifg=#AAAA77               gui=none ctermfg=Grey
hi Statement     guifg=#FF6600               gui=none ctermfg=Brown
hi Identifier    guifg=#FFCC00                        ctermfg=Yellow      cterm=none
hi Constant      guifg=#339999                        ctermfg=DarkCyan    cterm=none
hi String        guifg=#66FA00                        ctermfg=LightGreen  cterm=none
hi PreProc       guifg=#AAFFFF                        ctermfg=LightCyan

hi Special       guifg=#33AA00                          ctermbg=DarkGreen
hi Regexp        guifg=#44B4CC                          ctermbg=DarkCyan

"══════════════════════════════════════════════════════╡ Diffs ╞══════════
"
hi DiffText      guifg=#FFECEE guibg=#DD2233 gui=none
hi DiffDelete    guifg=#dd0000 guibg=#660000 gui=none

"══════════════════════════════════════════════════════╡ Comments ╞══════════
"
hi Comment       guifg=#CC22DD               gui=none  term=bold ctermfg=DarkMagenta 
hi CommentBright guifg=#33EEFF               gui=none  term=bold ctermfg=DarkMagenta 
"Markdown related
"hi CocBold
"hi CocItalic
"hi CocUnderline
"hi CocStrikeThrough       " e.g. usage of deprecated API
"hi CocMarkdownCode        " inline code (in markdown content)
"hi CocMarkdownHeader      " markdown header (in floating window/popup)
"hi CocMarkdownLink        " markdown link (in floating window/popup)

"══════════════════════════════════════════════════════╡ Status ╞══════════
"
hi StatusLine      guifg=#FFFFFF guibg=#232323 gui=none  cterm=bold ctermfg=0 ctermbg=5 
hi StatusLineNC    guifg=#DDDDDD guibg=#151515 gui=none  cterm=none ctermfg=0 
hi SlInfoC         guifg=#0088FF guibg=#232323 gui=none  ctermfg=Cyan
hi SlInfoN         guifg=#0066ff guibg=#151515 gui=none  ctermfg=Cyan
hi SlDirC          guifg=#ddaa33 guibg=#232323 gui=none  ctermfg=Cyan
hi SlDirN          guifg=#bb9933 guibg=#151515 gui=none  ctermfg=Cyan
hi SlPrevC         guifg=#4427FF guibg=#232323 gui=none  ctermfg=Cyan
hi SlPrevN         guifg=#0066ff guibg=#151515 gui=none  ctermfg=Cyan
" for the < collapsed separator
hi SlSepC          guifg=#11ee22 guibg=#232323 gui=none
hi SlSepN          guifg=#00dd11 guibg=#151515 gui=none
"
hi SlB                                         gui=bold
hi SlI                                         gui=italic
hi SlU                                         gui=underline
hi SlHintC         guifg=#555555 guibg=#232323 gui=italic
hi SlHintN         guifg=#444444 guibg=#151515 gui=italic
" filename
hi SlFNameC        guifg=#FFFFFF guibg=#232323 gui=none
hi SlFNameN        guifg=#DDDDDD guibg=#151515 gui=none
hi SlFNoNameC      guifg=#ccafaf guibg=#232323 gui=italic,underdotted
hi SlFNoNameN      guifg=#bbafaf guibg=#151515 gui=italic,underdotted
hi SlFNameSvdC     guifg=#FFFFFF guibg=#232323
hi SlFNameSvdN     guifg=#eeeeee guibg=#151515
hi SlFNameModC     guifg=#FFFFFF guibg=#232323 gui=italic,underdotted
hi SlFNameModN     guifg=#FFFFFF guibg=#232323 gui=italic,underdotted
hi SlFTypExtC      guifg=#00cc00 guibg=#232323 gui=bold
hi SlFTypExtN      guifg=#ddd0dd guibg=#151515 gui=bold
hi SlFTypC         guifg=#eeccff guibg=#232323 gui=underline
hi SlFTypN         guifg=#bb99ff guibg=#151515 gui=none
hi link SlFTyp2C   SLHintC
hi link SlFTyp2N   SLHintN
" file & buffer warning flags
hi SlFlagC         guifg=#FF1111 guibg=#232323 gui=none  ctermfg=197
hi SlFlagN         guifg=#EE0000 guibg=#151515 gui=none  ctermfg=197
" diagnostics
hi SlSynErrC       guifg=#FC0000 guibg=#000000 gui=none  ctermfg=197
hi SlSynErrN       guifg=#CC0000 guibg=#000000 gui=none  ctermfg=197
hi SlSynWarnC      guifg=#FFAA00 guibg=#000000 gui=none  ctermfg=220
hi SlSynWarnN      guifg=#D08800 guibg=#000000 gui=none  ctermfg=220
hi SlSynOkC        guifg=#55CC00 guibg=#000000 gui=none  ctermfg=LightGreen
hi SlSynOkN        guifg=#229900 guibg=#000000 gui=none  ctermfg=LightGreen
hi SlSynOffC       guifg=#00FFFF guibg=#000000 gui=none  ctermfg=Cyan
hi SlSynOffN       guifg=#00DDDD guibg=#000000 gui=none  ctermfg=Cyan
" git
hi SlGitC          guifg=#FFEEF0 guibg=#660099 gui=none  ctermfg=92
hi SlGitN          guifg=#D0C4E0 guibg=#660099 gui=none  ctermfg=92
hi SlNotGitC       guifg=#660099               gui=none  ctermfg=92
hi SlNotGitN       guifg=#660099               gui=none  ctermfg=92
hi link SlGitOffC           SlSynOffC
hi link SlGitOffN           SlSynOffN


  " 	                                            ‐           　 
  "
" TODO - move these to filetype specific files
"
hi link javascriptRegexpString  Regexp
hi link javascriptNumber        Number
hi link javascriptNull          Constant

hi link CocErrorHighlight       ErrorHint
hi link CocWarningHighlight     WarningHint
hi link CocInfoHighlight        InfoHint
hi link CocHintHighlight        HintHint


hi link jsonNoQuotesError       ErrorHint
hi link jsonMissingCommaError   ErrorHint

" floating/popup windows and dialogs
"CocFloating            " For floating window background.
"CocFloatDividingLine   " For dividing lines.
"CocFloatActive         " For active parts.
"CocMenuSel             " For selected line.
  
"CocInlayHint
"CocInlayHintType
"CocInlayHintParameter

" diagnostics
" code range
"CocErrorHighlight
"CocWarningHighlight
"CocInfoHighlight
"CocHintHighlight
" virtual text
"CocErrorVirtualText
"CocWarningVirtualText
"CocInfoVirtualText
"CocHintVirtualText

" Document highlight related
" matching symbols in the buffer at cursor position
"CocHighlightText       " default symbol highlight
"CocHighlightRead       " Read kind of document symbol
"CocHighlightWrite      " Write kind of document symbol

" Float window/popup related
"CocFloating            " floating windows/popups,  |Pmenu|
"CocFloatThumb          " scrollbar thumb 
"CocFloatSbar           " scrollbar track
"CocFloatDividingLine   " dividing lines, |NonText|
"CocFloatActive         " activated text, |CocSearch|
"CocErrorFloat          " error text
"CocHintFloat           " hint text
                        
" Inlay hint related    
"CocInlayHint           " f|CocHintSign| b|SignColumn|
"CocInlayHintParameter  " parameter kind of inlay hint
"CocInlayHintType       " type kind of inlay hint

                       
"Others~               
"CocDisabled            " disabled items, eg: menu item
"CocCodeLens            " virtual text of codeLens
"CocCursorRange         " activated cursors ranges
"CocLinkedEditing       " activated linked editing ranges
"CocHoverRange          " range of hovered symbol
"CocMenuSel             " current item in menu dialog (bg color ONLY)
"CocSelectedRange       " outgoing calls
"CocSnippetVisual       " snippet placeholders
"CocLink                " document links
"CocInputBoxVirtualText " input box placeholders

" vim:signcolumn=no:nolist:nowrap:wfw:ww=125:wfh:wh=12:
