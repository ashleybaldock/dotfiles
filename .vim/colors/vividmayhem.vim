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

" These names have to be lower case
call extend(v:colornames, {
      \ 'yormalb': '#0f0f0f', 'yormalf': '#eeeeee',
      \ 'ywreadb': '#090909',
      \ 'ywnormb': '#060606', 'ywnormf': '#dedede',
      \ 'ywhelpb': '#020922', 'ywhelpf': '#e5e5ff',
      \ 'yunsavb': '#440000', 'yunsavf': '#f5f5f5'
      \ }, 'keep')

"════════════════════════════════════════════════════════╡ Window

" 𝓲⃞  [gui=] ignored for 'Normal' highlight
hi Normal         guifg=yormalf guibg=yormalb

" Per-window background colors
hi WinNormal      guifg=ywnormf guibg=ywnormb gui=none
hi WinReadonly    guifg=ywnormf guibg=ywreadb gui=none
hi WinNoModify    guifg=ywnormf guibg=ywreadb gui=none
hi WinPreview     guifg=ywnormf guibg=ywreadb gui=none
hi WinQuickfix    guifg=#FFFFBB guibg=#0D0616 gui=none
hi WinHelp        guifg=ywhelpf guibg=ywhelpb gui=none
hi WinNetrw       guifg=ywnormf guibg=ywreadb gui=none
hi WinUnsaved     guifg=yunsavf guibg=yunsavb gui=none

"════════════════════════════════════════════════════════╡ Cursor
"
hi LineNr         guifg=#ddeeff guibg=#222222
"hi LineNrAbove
"hi LineNrBelow

hi Cursor         guifg=#000000 guibg=#ffffff gui=none
hi CursorLine     guifg=NONE    guibg=#1d002d
"hi CursorLineNr  (w/ relativenumber)
"hi CursorLineFold (in folds column)
hi CursorLineSign guifg=NONE    guibg=#4d006d
hi CursorColumn   guifg=NONE    guibg=#4d006d

"CocCursorRange   " activated cursors ranges
"CocLinkedEditing " activated linked editing ranges
"CocHoverRange    " range of hovered symbol

"════════════════════════════════════════════════════════╡ Search
hi Search         guifg=NONE    guibg=#555555 gui=none
hi IncSearch      guifg=#fefefe guibg=#000000         
hi link CurSearch Search

hi Visual none | hi Visual     guibg=#2a2a50 gui=none

hi MoreMsg        guifg=#00aa00                       
hi ErrorMsg       guifg=NONE    guibg=#ce1111         
hi WarningMsg     guifg=#ff7c00 guibg=#550000         

hi Question none | hi link Question MoreMsg

hi Title          guifg=#dd22dd                       

hi WildMenu       guifg=#000000 guibg=#767fff gui=bold

hi Directory none | hi link Directory Identifier

"════════════════════════════════════════════════════════╡ Invisible(ish)

hi Conceal        guifg=#6666a2 guibg=NONE            
hi Ignore         guifg=#8888aa guibg=#222244         
" Diagnostics related
hi link CocFadeOut             Conceal
hi link CocDeprecatedHighlight CocStrikeThrough
hi link CocUnusedHighlight     CocFadeOut

" Used for: fillchars: eob
"hi EndOfBuffer   guifg=#403030 guibg=#040404
hi EndOfBuffer none | hi link EndOfBuffer EndOfBuNone
" Used for: listchars: eol,extends,precedes;
hi NonText     none | hi link NonText NonTextNone
" Used for: listchars: tab,nbsp,space,multispace,lead,trail;
hi SpecialKey  none | hi link SpecialKey SpecialNone

" Used for different List styles (see plugin/chars.vim)
" ListNone
hi EndOfBuNone    guifg=#3a3a3a guibg=#050505
hi NonTextNone    guifg=#2a2a2a 
hi SpecialNone    guifg=#3a3a3a 
" ListMinimal
hi EndOfBuMini    guifg=#3a3a3a guibg=#050505
hi NonTextMini    guifg=#303030
hi SpecialMini    guifg=#505050
" ListDiagnostic
hi EndOfBuDiag    guifg=#3a3a3a guibg=#050505
hi NonTextDiag    guifg=#409040
hi SpecialDiag    guifg=#d70000

" [U8Whitespace] Used for whitespace diagnostic mode
hi U8Whitespace   guifg=#dd1111 guibg=#dd1111

"════════════════════════════════════════════════════════╡ Menu Popups

" Popup menu (e.g. tab completion)
hi Pmenu          guifg=#ffffff guibg=#220055          
hi PmenuSel       guifg=#ffffff guibg=#440077 gui=bold 
" e.g. K in: |match   K [TSC]|
hi PmenuKind      guifg=#00ffaf guibg=#220055          
hi PmenuKindSel   guifg=#00ffaf guibg=#440077 gui=bold 
" e.g. [TSC] in: |match   K [TSC]|
hi PmenuExtra     guifg=#af00af guibg=#220055          
hi PmenuExtraSel  guifg=#af00af guibg=#440077 gui=bold 
hi PmenuSbar                   guibg=#220055                       
hi PmenuThumb                  guibg=#4400ff                       
hi link CocPum Pmenu
" hi CocSymbol
hi link CocMenuSel PmenuSel
" Custom
hi HlPop01Bg      guifg=#ddaacc guibg=#100008    
hi HlPop01Bd      guifg=#cc66cc guibg=#100008
hi link HlPop01T HlPop01Bd
hi link HlPop01R HlPop01Bd
hi link HlPop01B HlPop01Bd
hi link HlPop01L HlPop01Bd

" CoC Float window/popup related
"CocFloating            " floating windows/popups,  |Pmenu|
"CocFloatThumb          " scrollbar thumb 
"CocFloatSbar           " scrollbar track
"CocFloatDividingLine   " dividing lines, |NonText|
"CocFloatActive         " activated text, |CocSearch|
"CocErrorFloat          " error text
"CocHintFloat           " hint text
                        

"════════════════════════════════════════════════════════╡ Diffs

hi WinDiff        guifg=#555533 guibg=#111111 gui=italic
hi DiffText       guifg=#feddff guibg=#990088 gui=none
hi DiffAdd        guifg=#defeff guibg=#081145 gui=none
hi DiffChange     guifg=#eeccbb guibg=#2a002a gui=none
hi DiffDelete     guifg=#7a0000 guibg=#3a0000 gui=none

"════════════════════════════════════════════════════════╡ Vertical

hi VertSplit      guifg=#666666 guibg=#151515 gui=none

hi Folded         guifg=#aaddee guibg=NONE    gui=none  
hi FoldColumn     guifg=#00ffff guibg=#001166
hi SignColumn     guifg=#00ffff guibg=#101025

hi ColorColumn    guifg=NONE    guibg=#222255

"════════════════════════════════════════════════════════╡ Signs

hi GitGutterAdd    guifg=#009900 guibg=#0a1f0a gui=none
hi GitGutterChange guifg=#cfc040 guibg=#101025 gui=none
hi GitGutterDelete guifg=#ee2222 guibg=#101025 gui=none
hi GitGutterChangeDelete guifg=#ee2222 guibg=#cfc040 gui=none

hi CocErrorSign   guifg=#dd2222 guibg=#1f0505 gui=none
hi CocWarningSign guifg=#ffaa00 guibg=#301e00 gui=none
hi CocInfoSign    guifg=#00ffff guibg=#101025 gui=none
hi CocHintSign    guifg=#bb99ff guibg=#101025 gui=none

" Sign line highlights
hi CocErrorLine                  guibg=#1f0505 gui=none
" hi CocWarningLine                guibg=#121200 gui=none
" hi CocInfoLine
" hi CocHintLine

hi link CocErrorHighlight       ErrorHint
hi link CocWarningHighlight     WarningHint
hi link CocInfoHighlight        InfoHint
hi link CocHintHighlight        HintHint

"════════════════════════════════════════════════════════╡  Horizontal

hi TabLine        guifg=#bbbbbb guibg=#333333 gui=underline 
hi TabLineSel     guifg=#ffffff guibg=#000000               
hi TabLineFill    guifg=#bbbbbb guibg=#808080 gui=underline 

" Background toolbar line
hi ToolbarLine    guifg=NONE    guibg=#030327 gui=none
" Background and foreground for toolbar buttons
hi ToolbarButton  guifg=#EE98EE guibg=#030327 gui=none

"════════════════════════════════════════════════════════╡ Inline Errors

hi ErrorHint      guifg=NONE    guibg=NONE    gui=undercurl   guisp=#fe0000 
hi link Error ErrorHint
hi WarningHint    guifg=NONE    guibg=NONE    gui=underdotted guisp=#ddbb00 
hi link InfoHint  SpellCap
hi link HintHint  SpellLocal

"════════════════════════════════════════════════════════╡ Code Sections

hi Type           guifg=#aaaa77               gui=none
hi Statement      guifg=#ff6600               gui=none 
hi Identifier     guifg=#ffcc00                        
hi Constant       guifg=#339999                        
hi String         guifg=#66fa00                        
hi PreProc        guifg=#aaffff                        

hi Special        guifg=#33aa00               
hi Delimiter      guifg=#33aa00
hi Regexp         guifg=#44b4cc               

"════════════════════════════════════════════════════════╡ Comments

hi Comment        guifg=#cc22dd               gui=none
hi CommentBright  guifg=#33eeff               gui=none

hi HlBold                                     gui=bold
hi HlItalic                                   gui=italic
hi HlUnderline                                gui=underline
hi HlUnCurl                                   gui=undercurl
hi HlUnDouble                                 gui=underdouble
hi HlUnDot                                    gui=underdotted
hi HlUnDash                                   gui=underdashed
hi HlStrike                                   gui=strikethrough
hi HlInverse                                  gui=reverse
hi HlStandout                                 gui=standout
hi HlMkDnCode     guifg=#441144 guibg=#ddaadd gui=reverse
hi HlMkDnHeader   guifg=#cc44cc               gui=bold
hi HlMkDnLink     guifg=#15aabf               gui=italic,underline

" Coc/Markdown
hi link CocBold HlBold
hi link CocItalic HlItalic
hi link CocUnderline HlUnderline
hi link CocStrikeThrough HlStrike
hi link CocMarkdownCode  HlMkDnCode
hi link CocMarkdownHeader HlMkDnHeader
hi link CocMarkdownLink  HlMkDnLink

"════════════════════════════════════════════════════════╡ Status
"
hi StatusLineTerm none | hi link StatusLineTerm  SlTerminal
hi StatusLineTermNC none | hi link StatusLineTermNC SlTerminalNC

hi StatusLine     guifg=#ffffff guibg=#232323 gui=none
hi StatusLineNC   guifg=#dddddd guibg=#151515 gui=none
hi SlTerminal     guifg=#ffffff guibg=#232323 gui=none
hi SlTerminalNC   guifg=#ffffff guibg=#232323 gui=none
hi SlInfoC        guifg=#0088ff guibg=#232323 gui=none  
hi SlInfoN        guifg=#0066ff guibg=#151515 gui=none  
hi SlDirC         guifg=#ddaa33 guibg=#232323 gui=none  
hi SlDirN         guifg=#bb9933 guibg=#151515 gui=none  
hi SlPrevC        guifg=#4427ff guibg=#232323 gui=none  
hi SlPrevN        guifg=#0066ff guibg=#151515 gui=none  
" for the < collapsed separator
hi SlSepC         guifg=#11ee22 guibg=#232323 gui=none
hi SlSepN         guifg=#00dd11 guibg=#151515 gui=none
"
hi link SlB HlBold
hi link SlI HlItalic
hi link SlU HlUnderline
hi SlHintC        guifg=#555555 guibg=#232323 gui=italic
hi SlHintN        guifg=#444444 guibg=#151515 gui=italic
" filename
hi SlFNameC       guifg=#ffffff guibg=#232323 gui=none
hi SlFNameN       guifg=#dddddd guibg=#151515 gui=none
hi SlFNoNameC     guifg=#ccafaf guibg=#232323 gui=italic,underdotted
hi SlFNoNameN     guifg=#bbafaf guibg=#151515 gui=italic,underdotted
hi SlFNameSvdC    guifg=#ffffff guibg=#232323
hi SlFNameSvdN    guifg=yormalf guibg=#151515
hi SlFNameModC    guifg=#ffffff guibg=#232323 gui=italic,underdotted
hi SlFNameModN    guifg=#ffffff guibg=#232323 gui=italic,underdotted
hi SlFTypExtC     guifg=#00cc00 guibg=#232323 gui=bold
hi SlFTypExtN     guifg=#ddd0dd guibg=#151515 gui=bold
hi SlFTypC        guifg=#eeccff guibg=#232323 gui=underline
hi SlFTypN        guifg=#bb99ff guibg=#151515 gui=none
hi link SlFTyp2C  SLHintC
hi link SlFTyp2N  SLHintN
" file & buffer warning flags
hi SlFlagC        guifg=#ff1111 guibg=#232323 gui=none  
hi SlFlagN        guifg=#ee0000 guibg=#151515 gui=none  
" diagnostics
hi SlSynErrC      guifg=#fc0000 guibg=#000000 gui=none  
hi SlSynErrN      guifg=#cc0000 guibg=#000000 gui=none  
hi SlSynWarnC     guifg=#ffaa00 guibg=#000000 gui=none  
hi SlSynWarnN     guifg=#d08800 guibg=#000000 gui=none  
hi SlSynOkC       guifg=#55cc00 guibg=#000000 gui=none  
hi SlSynOkN       guifg=#229900 guibg=#000000 gui=none 
hi SlSynOffC      guifg=#00ffff guibg=#000000 gui=none  
hi SlSynOffN      guifg=#00dddd guibg=#000000 gui=none  
" git
hi SlGitC         guifg=#ffeef0 guibg=#660099 gui=none  
hi SlGitN         guifg=#d0c4e0 guibg=#660099 gui=none  
hi SlNotGitC      guifg=#660099               gui=none  
hi SlNotGitN      guifg=#660099               gui=none  
hi link SlGitOffC  SlSynOffC
hi link SlGitOffN  SlSynOffN

"╔═════════════════════════════════════════════════════╦═╡ Demo
"║ 	                                        ║
"║                               ‐           　        ║
"╚═════════════════════════════════════════════════════╝



" TODO - move these to filetype specific files
"
hi link javascriptRegexpString  Regexp
hi link javascriptNumber        Number
hi link javascriptNull          Constant

" hi link testing44 Constant
" hi link testing33 testing44
" hi link cssFunction testing33

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

" Inlay hint related    
"CocInlayHint           " f|CocHintSign| b|SignColumn|
"CocInlayHintParameter  " parameter kind of inlay hint
"CocInlayHintType       " type kind of inlay hint

                       
"Others~               
"CocSelectedRange       " outgoing calls
"CocLink                " document links
"CocDisabled            " disabled items, eg: menu item
"CocCodeLens            " virtual text of codeLens
"CocMenuSel             " current item in menu dialog (bg color ONLY)
"CocSnippetVisual       " snippet placeholders
"CocInputBoxVirtualText " input box placeholders

" vim:colorcolumn=18,58:signcolumn=no:nolist:nowrap:wfw:ww=125:wfh:wh=12:
