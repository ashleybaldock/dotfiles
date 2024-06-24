"
"
"                     Vivid Mayhem
"
"
"   Related:
"  ../plugin/chars.vim      -  fillchars, listchars etc.
"  ../plugin/highlight.vim  -  Colourscheme Utils
"            ╰─▷ ⎧ :HiHi    -  inline highlight preview  ⎫
"                ⎩ :Synfo   -  floating syntax info      ⎭ 
"
"
"     Originally based on tpope's vividchalk
" 
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
      \ 'yunsavb': '#440000', 'yunsavf': '#f5f5f5',
      \ 'ysignsb': '#10101f',
      \ }, 'keep')

"════════════════════════════════════════════════════════╡ Window

" 𝓲⃞  [gui=] ignored for 'Normal' highlight
hi Normal         guifg=yormalf guibg=yormalb

" Per-window background colors
" See: ../plugin/wincolor.vim
hi WinNormal      guifg=ywnormf guibg=ywnormb gui=none
hi WinReadonly    guifg=ywnormf guibg=ywreadb gui=none
hi WinNoModify    guifg=ywnormf guibg=ywreadb gui=none
hi WinPreview     guifg=ywnormf guibg=ywreadb gui=none
hi WinQuickfix    guifg=#FFFFBB guibg=#0D0616 gui=none
hi WinHelp        guifg=ywhelpf guibg=ywhelpb gui=none
hi WinNetrw       guifg=ywnormf guibg=ywreadb gui=none
hi WinUnsaved     guifg=yunsavf guibg=yunsavb gui=none
hi WinDiff        guifg=#555533 guibg=#111111 gui=italic

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
hi CocHoverRange  guibg=#502a2a gui=none

"════════════════════════════════════════════════════════╡ Search
hi Search         guifg=NONE    guibg=#555555 gui=none
hi IncSearch      guifg=#fefefe guibg=#000000         
hi CurSearch      guifg=NONE    guibg=#444422 gui=reverse

hi Visual none | hi Visual     guibg=#2a2a50 gui=none

hi ModeMsg        guifg=#f050a0 guibg=#440022 gui=italic
" more-prompt/pager
hi MoreMsg        guifg=#00aa00                       
hi ErrorMsg       guifg=NONE    guibg=#ce1111         
hi WarningMsg     guifg=#ff7c00 guibg=#550000         

" Hit-Enter prompt & yes/no questions
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
hi SpecialNone    guifg=#2ada6a guibg=#102210
" ListMinimal
hi EndOfBuMini    guifg=#3a3a3a guibg=#050505
hi NonTextMini    guifg=#303030
hi SpecialMini    guifg=#4a6a4a
" ListDiagnostic
hi EndOfBuDiag    guifg=#3a3a3a guibg=#050505
hi NonTextDiag    guifg=#409040
hi SpecialDiag    guifg=#d70000

" [U8Whitespace] Used for whitespace diagnostic mode
hi U8Whitespace   guifg=#dd1111 guibg=#dd1111

"════════════════════════════════════════════════════════╡ Menu Popups

" Popup menu (e.g. tab completion)
hi Pmenu          guifg=#eeeeff guibg=#220055          
hi PmenuSel       guifg=#ffffff guibg=#440077
" e.g. K in: |match   K [TSC]|
hi PmenuKind      guifg=#00ffaf guibg=#220055          
hi PmenuKindSel   guifg=#00ffaf guibg=#440077 gui=bold 
" e.g. [TSC] in: |match   K [TSC]|
hi PmenuExtra     guifg=#af00af guibg=#220055          
hi PmenuExtraSel  guifg=#af00af guibg=#440077 gui=bold 
hi PmenuSbar                    guibg=#220055                       
hi PmenuThumb                   guibg=#4400dd                       

" Custom
hi HlPop01Bg      guifg=#ddaacc guibg=#100008    
hi HlPop01Bd      guifg=#cc66cc guibg=#100008
hi link HlPop01T HlPop01Bd
hi link HlPop01R HlPop01Bd
hi link HlPop01B HlPop01Bd
hi link HlPop01L HlPop01Bd
hi HlPop02Bg      guifg=#00ff08 guibg=#779908    
hi HlPop02Bd      guifg=#00ff08 guibg=NONE
hi HlPop03Bg      guifg=#ddaacc guibg=#333300    
hi HlPop03Bd      guifg=#ffeedd guibg=NONE
" Floating help window
hi HlPopHelpBg    guifg=ywhelpf guibg=ywhelpb    
hi HlPopHelpBd    guifg=#ffeedd guibg=NONE
" Coc hover float
hi link HlCocPuHovrBg HlPopHelpBg
hi link HlCocPuHovrBd HlPopHelpBd
" Coc suggestion float
hi HlCocPuSugsBg  guifg=#eeeeff guibg=#220055    
hi HlCocPuSugsBd  guifg=#ffeedd guibg=NONE
" Coc diagnostic float
" hi HlCocPuDiagBg  guifg=#ddaacc guibg=#333300    
" hi HlCocPuDiagBd  guifg=#bb0008 guibg=NONE
hi link HlCocPuDiagBg PopDiagErr
hi link HlCocPuDiagBd PopDiagErrBd
" Coc signature float
hi HlCocPuSgtrBg  guifg=#ddaacc guibg=#333300    
hi HlCocPuSgtrBd  guifg=#559999 guibg=NONE

hi link PopDiagErrBd  SignDgErr
hi link PopDiagWarnBd SignDgWarn
hi link PopDiagInfoBd SignDgInfo
hi link PopDiagHintBd SignDgHint

hi link PopDiagErr    LineDgErr
hi link PopDiagWarn   LineDgWarn
hi link PopDiagInfo   LineDgInfo
hi link PopDiagHint   LineDgHint

" CoC Float window/popup related
hi link CocPum               Pmenu
"CocPumSearch      "matched input characters, linked to |CocSearch| by default.
"CocPumDetail      "highlight label details that follows label 
"CocPumMenu        "menu of complete item.
"CocPumShortcut    "shortcut text of source.
"CocPumDeprecated  "deprecated label.
"CocPumVirtualText "virtual text which enabled by

" hi CocSymbol
hi link CocMenuSel           PmenuSel
hi link CocFloating          Pmenu
hi link CocFloatThumb        PmenuThumb
hi link CocFloatSbar         PmenuSbar
hi link CocFloatDividingLine NonText
hi link CocFloatActive       HlPop02Bg

hi link CocErrorFloat        PopDiagErr 
hi link CocWarningFloat      PopDiagWarn  
hi link CocInfoFloat         PopDiagInfo  
hi link CocHintFloat         PopDiagHint  
                        

"════════════════════════════════════════════════════════╡ Vertical

hi VertSplit      guifg=#666666 guibg=#151515 gui=none

hi Folded         guifg=#aaddee guibg=NONE    gui=none  
hi FoldColumn     guifg=#00ffff guibg=ysignsb gui=none  
hi SignColumn     guifg=NONE    guibg=ysignsb gui=none  

hi ColorColNormal guifg=NONE    guibg=#171031 gui=none  
hi ColorColBright guifg=NONE    guibg=#292243 gui=none  

hi ColorColumn none | hi link ColorColumn ColorColNormal

"════════════════════════════════════════════════════════╡ Diffs
" See: WinDiff for background

hi DiffText       guifg=#feddff guibg=#990088 gui=none
hi DiffAdd        guifg=#defeff guibg=#081145 gui=none
hi DiffChange     guifg=#eeccbb guibg=#2a002a gui=none
hi DiffDelete     guifg=#7a0000 guibg=#3a0000 gui=none

"════════════════════════════════════════════════════════╡ Signs

hi SignGitAdd     guifg=#117711 guibg=ysignsb gui=bold
hi SignGitDel     guifg=#bb1144 guibg=ysignsb gui=underdotted
hi SignGitChg     guifg=#cfc040 guibg=ysignsb gui=none
hi SignGitCgD     guifg=#cfc040 guibg=ysignsb gui=underdotted guisp=#bb0044

hi WarningHint    guifg=NONE    guibg=NONE    gui=underdotted guisp=#ddbb00 

hi SignDgErr      guifg=#dd2222 guibg=#1f0505 gui=none
hi SignDgWarn     guifg=#ffaa00 guibg=#301e00 gui=none
hi SignDgInfo     guifg=#00ffff guibg=#101025 gui=none
hi SignDgHint     guifg=#bb99ff guibg=#101025 gui=none

hi LineDgErr                    guibg=#1f0505 gui=none
hi LineDgWarn                   guibg=#121200 gui=none
hi LineDgInfo                   guibg=#001f1f gui=none
hi LineDgHint                   guibg=#1b191f gui=none

hi link GitGutterAdd              SignGitAdd
hi link GitGutterAddLine          DiffAdd
hi link GitGutterChange           SignGitChg
hi link GitGutterChangeLine       DiffChange
hi link GitGutterChangeDelete     SignGitChgDel
hi link GitGutterChangeDeleteLine DiffChange
hi link GitGutterDelete           SignGitDel
hi link GitGutterDeleteLine       DiffDelete

hi link CocErrorVirtualText   SignDgErr 
hi link CocWarningVirtualText SignDgWarn  
hi link CocInfoVirtualText    SignDgInfo  
hi link CocHintVirtualText    SignDgHint  

hi link CocErrorSign   SignDgErr 
hi link CocWarningSign SignDgWarn  
hi link CocInfoSign    SignDgInfo  
hi link CocHintSign    SignDgHint  

" Sign line highlights
hi link CocErrorLine   LineDgErr
" hi link CocWarningLine LineDgWarn
" hi link CocInfoLine    LineDgInfo
" hi link CocHintLine    LineDgHint
"hi CocSelectedLine
"hi CocSelectedText

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
hi ToolbarButton  guifg=#fEc8fE guibg=#030327 gui=none

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
"
hi Comment        guifg=#cc22dd               gui=none
hi CommentBright  guifg=#33eeff               gui=none

"════════════════════════════════════════════════════════╡ Format Aliases

hi HlBold         gui=bold
hi HlItalic       gui=italic
hi HlUnderline    gui=underline
hi HlUnCurl       gui=undercurl
hi HlUnDouble     gui=underdouble
hi HlUnDot        gui=underdotted
hi HlUnDash       gui=underdashed
hi HlStrike       gui=strikethrough
hi HlInverse      gui=reverse
hi HlStandout     gui=standout

"════════════════════════════════════════════════════════╡ Markdown
"
hi HlMkDnCode     guifg=#441144 guibg=#ddaadd gui=reverse
hi HlMkDnCdBlock  guifg=#c9c9a3 guibg=#060606 gui=none
hi HlMkDnCdDelim  guifg=#ffff00 guibg=NONE    gui=strikethrough,bold 
hi HlMkDnHeader   guifg=#cc44cc               gui=bold
hi HlMkDnLink     guifg=#15aabf               gui=italic,underline

hi link markdownCode HlMkDnCode
hi link markdownCodeBlock HlMkDnCdBlock
hi link markdownCodeDelimiter HlMkDnCdDelim

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
"║ 	  "  " "   "                            ║
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

"
" Floating Windows: popup windows and dialogs
" CocFloating            " For floating window background.
" CocFloatDividingLine   " For dividing lines.
" CocFloatActive         " For active parts.
" CocMenuSel             " For selected line.
"
" CocDisabled            " disabled items, eg: menu item
" CocMenuSel             " current item in menu dialog (bg color ONLY)
 

"
" Diagnostics:
"
" |CocUnusedHighlight| > |CocDeprecatedHighlight| > |CocErrorHighlight|
"   > |CocWarningHighlight| > |CocInfoHighlight| > |CocHintHighlight|
"
" CocFadeOut             " faded out text, such as for highlighting unnecessary code.
"
" CocErrorSign           " error signs.
" CocWarningSign         " warning signs.
" CocInfoSign            " information signs.
" CocHintSign            " hint signs.
"
" CocErrorVirtualText    " error virtual text.
" CocWarningVirtualText  " warning virtual text.
" CocInfoVirtualText     " information virtual text.
" CocHintVirtualText     " hint virtual text.
"
" CocErrorHighlight      " error code range.
" CocWarningHighlight    " warning code range.
" CocInfoHighlight       " information code range.
" CocHintHighlight       " hint code range.
" CocDeprecatedHighlight " deprecated code range, links to |CocStrikeThrough| by default.
" CocUnusedHighlight     " unnecessary code range, links to |CocFadeOut| by default.
"
" CocErrorLine           " line highlight of sign which contains error.
" CocWarningLine         " line highlight of sign which contains warning.
" CocInfoLine            " line highlight of sign which information.
" CocHintLine            " line highlight of sign which contains hint.

" Document Highlights:
" Matching Symbols: in the buffer at cursor position
" CocHighlightText       " default symbol highlight
" CocHighlightRead       " Read kind of document symbol
" CocHighlightWrite      " Write kind of document symbol
"
" CocLink                " document links
"
" Inlay Hints:
" CocInlayHint           " f|CocHintSign| b|SignColumn|
" CocInlayHintParameter  " parameter kind of inlay hint
" CocInlayHintType       " type kind of inlay hint
"
" Virtual Text:
" CocCodeLens            " virtual text of codeLens
" CocInputBoxVirtualText " input box placeholders
" CocSnippetVisual       " snippet placeholders
"
" Ranges:
" CocHoverRange          " range of current hovered symbol
" CocSelectedRange       " range of outgoing calls
" CocCursorRange         " for highlight of activated cursors ranges.
" CocLinkedEditing       " for highlight of activated linked editing ranges.




" vim:colorcolumn=18,58:nolist:nowrap:wfw:ww=125:wfh:wh=12:
