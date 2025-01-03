"
"                    Vivid Mayhem
"
"   Related:
"   ./termayhem.vim          - Terminal colorscheme
"  ../plugin/chars.vim       - fillchars, listchars etc.
"  ../plugin/highlight.vim   - Colourscheme Utils
"            ╰─▷ ⎧ :HiHi     - inline highlight preview  ⎫
"                ⎩ :SynStack - floating syntax info      ⎭
"
"  ../after/syntax/vim.vim   - Tweaks to highlighting
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
      \ 'yormalb': '#0f0f0f', 'yormalf': '#f2f2f2',
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
hi LineNr         guifg=#400060 guibg=#100020
hi LineNrAbove    guifg=#6d008d guibg=#100020 gui=none
hi LineNrBelow    guifg=#6d448d guibg=#101120 gui=none

hi Cursor         guifg=#000000 guibg=#ffffff gui=none
hi CursorLine     guifg=NONE    guibg=#1d002d
hi CursorLineNr   guifg=#dda4fd guibg=#400060 gui=none
hi CursorLineFold guifg=#ff0066 guibg=#0d0020
hi CursorLineSign guifg=NONE    guibg=NONE
hi CursorColumn   guifg=NONE    guibg=#4d006d

"CocCursorRange   " activated cursors ranges
"CocLinkedEditing " activated linked editing ranges
" range of outgoing calls
hi CocSelectedRange guibg=#00ffff
hi CocHoverRange  guibg=#502a2a gui=none

" Document Highlights:
" Matching Symbols: in the buffer at cursor position
" default symbol highlight
hi CocHighlightText       guifg=NONE gui=none guibg=#022c2c
" Read kind of document symbol
hi CocHighlightRead       guifg=NONE gui=none guibg=#021602
" Write kind of document symbol
hi CocHighlightWrite      guifg=NONE gui=none guibg=#2c0202

" CocLink                " document links

" Inlay Hints:
hi CocInlayHint           guifg=#bb99ff guibg=ysignsb
" parameter kind of inlay hint
hi CocInlayHintParameter  guifg=#ff99ff guibg=ysignsb
" type kind of inlay hint
hi CocInlayHintType       guifg=#ff99bb guibg=ysignsb

"
"════════════════════════════════════════════════════════╡ Search
"
hi Search         guifg=NONE    guibg=#555555 gui=none
hi IncSearch      guifg=#fefefe guibg=#000000         
hi CurSearch      guifg=NONE    guibg=#444422 gui=reverse

hi QuickFixLine   guibg=NONE
hi link qfError        Error
hi link qfFileName     Directory
hi link qfLineNr       LineNr
hi qfLineNr       guifg=#999911
hi qfSeparator    guifg=#999911

"
"════════════════════════════════════════════════════════╡ Visual
"
hi Visual none | hi Visual      guibg=#2a2a50 gui=none

hi ModeMsg        guifg=#f050a0 guibg=#440022 gui=italic
" more-prompt/pager
hi MoreMsg        guifg=#00aa00                       
hi ErrorMsg       guifg=NONE    guibg=#ce1111         
hi WarningMsg     guifg=#ff7c00 guibg=#550000         

" Hit-Enter prompt & yes/no questions
hi Question none | hi link Question MoreMsg

hi Title          guifg=#dd22dd                       

hi WildMenu       guifg=#000000 guibg=#767fff gui=bold

"
"════════════════════════════════════════════════════════╡ Invisible(ish)
"
" Replacements for concealed text
hi Conceal        guifg=#7777a2 guibg=NONE            
hi Conceal        guifg=#33aadd
hi link vimSynMtchCchar Conceal
hi link cssUnitDecorators Conceal
hi Ignore         guifg=#8888aa guibg=#222244         
"
" Diagnostics related
hi CocFadeOut     guifg=#6666a2 guibg=NONE            
"
" Used for: fillchars: eob
"hi EndOfBuffer   guifg=#403030 guibg=#040404
hi EndOfBuffer none | hi link EndOfBuffer EndOfBuNone
"
" Used for: listchars: eol,extends,precedes;
hi NonText     none | hi link NonText NonTextNone
"
" Unicode: Whitespace, Control Chars and Variation Selectors
" See: ../demo/unicode-whitespace
"      ../plugin/unicode.vim
"
hi SpecialSpace   guibg=#440044 gui=underdouble guisp=#8800aa
hi VS1516         guibg=#221100 gui=underdouble guisp=#aa2299
hi VS16           guibg=#221100 gui=underline   guisp=#aa4444

hi VS15           guibg=#001a2a gui=underline   guisp=#005ab6
hi VS16           guibg=#221100 gui=underline   guisp=#993300
hi VS1516         guibg=#112200 gui=underdouble guisp=#999900
hi VS1615         guibg=#002211 gui=underdouble guisp=#009999

" Used for: listchars: tab,nbsp,space,multispace,lead,trail;
hi SpecialKey  none | hi link SpecialKey SpecialNone
"
" Used for different List styles
" See: ../plugin/chars.vim)
"
" ListNone
hi EndOfBuNone    guifg=#3a3a3a guibg=#050505
hi NonTextNone    guifg=#2a2a2a 
hi SpecialNone    guifg=#2ada6a guibg=#102210
"
" ListMinimal
hi EndOfBuMini    guifg=#3a3a3a guibg=#050505
hi NonTextMini    guifg=#303030
hi SpecialMini    guifg=#4a6a4a
"
" ListDiagnostic
hi EndOfBuDiag    guifg=#3a3a3a guibg=#050505
hi NonTextDiag    guifg=#409040
hi SpecialDiag    guifg=#d70000
"
" [U8Whitespace] Used for whitespace diagnostic mode
hi U8Whitespace   guifg=#ff6666 guibg=#dd1111

"
"════════════════════════════════════════════════════════╡ Floating Windows
"
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

" Coc Floating window
hi link CocPum            Pmenu
hi link CocPumSearch      CocSearch
hi link CocPumDetail      Comment
hi link CocPumMenu        CocFloating
hi link CocPumShortcut    Comment
hi link CocPumDeprecated  CocStrikeThrough
hi link CocPumVirtualText CocVirtualText

hi link CocMenuSel           PmenuSel
hi link CocFloating          Pmenu
hi link CocFloatThumb        PmenuThumb
hi link CocFloatSbar         PmenuSbar
hi link CocFloatDividingLine NonText
hi link CocFloatActive       HlPop02Bg
hi link CocDisabled          CocVirtualText

hi link CocErrorFloat        PopDiagErr 
hi link CocWarningFloat      PopDiagWarn  
hi link CocInfoFloat         PopDiagInfo  
hi link CocHintFloat         PopDiagHint  
                        
"
"════════════════════════════════════════════════════════╡ Vertical
"
hi VertSplit      guifg=#666666 guibg=#151515 gui=none

hi Folded         guifg=#aaddee guibg=NONE    gui=none  
hi FoldColumn     guifg=#00ffff guibg=ysignsb gui=none  
hi SignColumn     guifg=NONE    guibg=ysignsb gui=none  

hi ColorColNormal guifg=NONE    guibg=#171031 gui=none  
hi ColorColBright guifg=NONE    guibg=#292243 gui=none  

hi ColorColumn none | hi link ColorColumn ColorColNormal

"
"════════════════════════════════════════════════════════╡ Diffs
" See: WinDiff for background

hi DiffText       guifg=#feddff guibg=#990088 gui=none
hi DiffAdd        guifg=#defeff guibg=#081145 gui=none
hi DiffChange     guifg=#eeccbb guibg=#2a002a gui=none
hi DiffDelete     guifg=#7a0000 guibg=#3a0000 gui=none

"
"════════════════════════════════════════════════════════╡ Signs
" See: ../plugin/signs.vim
"
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

hi link VtextDgErr     SignDgErr 
hi link VtextDgWarn    SignDgWarn  
hi link VtextDgInfo    SignDgInfo  
hi link VtextDgHint    SignDgHint  

hi link GitGutterAdd              SignGitAdd
hi link GitGutterAddLine          DiffAdd
hi link GitGutterChange           SignGitChg
hi link GitGutterChangeLine       DiffChange
hi link GitGutterChangeDelete     SignGitChgDel
hi link GitGutterChangeDeleteLine DiffChange
hi link GitGutterDelete           SignGitDel
hi link GitGutterDeleteLine       DiffDelete

" Virtual Text:
hi link CocErrorVirtualText   VtextDgErr 
hi link CocWarningVirtualText VtextDgWarn
hi link CocInfoVirtualText    VtextDgInfo
hi link CocHintVirtualText    VtextDgHint

hi CocCodeLens    guifg=#999999
hi CocVirtualText guifg=#504945
hi link CocInputBoxVirtualText   CocVirtualText
hi link CocSnippetVisual         Visual

" Signs:
hi link CocErrorSign   SignDgErr 
hi link CocWarningSign SignDgWarn  
hi link CocInfoSign    SignDgInfo  
hi link CocHintSign    SignDgHint  

" Sign Lines:
hi link CocErrorLine   LineDgErr
" hi link CocWarningLine LineDgWarn
" hi link CocInfoLine    LineDgInfo
" hi link CocHintLine    LineDgHint
" hi CocSelectedLine
hi CocSelectedText guifg=#fb4934

" Priority order
" ↳ Unused ↳ Deprecated ↳ Error ↳ Warning ↳ Info ↳ Hint
hi link CocUnusedHighlight      CocFadeOut
hi link CocDeprecatedHighlight  CocStrikeThrough
hi link CocErrorHighlight       ErrorHint
hi link CocWarningHighlight     WarningHint
hi link CocInfoHighlight        InfoHint
hi link CocHintHighlight        HintHint

"════════════════════════════════════════════════════════╡  Horizontal

hi TabLine        guifg=#bbbbbb guibg=#333333 gui=underline 
hi TabLineSel     guifg=#ffffff guibg=#000000               
hi TabLineFill    guifg=#bbbbbb guibg=#808080 gui=underline 

" WinBar:
" Background for the whole bar
hi ToolbarLine    guifg=NONE    guibg=#030327 gui=none
" Background and foreground for toolbar buttons
hi ToolbarButton  guifg=#eeeeee guibg=#232347 gui=none

"════════════════════════════════════════════════════════╡ Inline Errors

hi ErrorHint      guifg=NONE    guibg=NONE    gui=undercurl   guisp=#fe0000 
hi link Error ErrorHint

hi WarningHint    guifg=NONE    guibg=NONE    gui=underdotted guisp=#ddbb00 
hi link InfoHint  SpellCap
hi link HintHint  SpellLocal

hi TestHint1      guifg=#ddddaa gui=underdouble,strikethrough guisp=#cc22dd 
hi TestHint2      guifg=#ddddaa gui=underdouble,strikethrough guisp=#22ccff 
hi TestHint3      guifg=#ddddaa gui=underdouble,strikethrough guisp=#22ff22 
hi TestHint4      guifg=#ddddaa gui=underdouble,strikethrough guisp=#ffff22 
hi TestHint5      guifg=NONE gui=underline guisp=#ff5522

"════════════════════════════════════════════════════════╡ Code Sections

hi Constant       guifg=#339999 guibg=NONE    gui=none
hi String         guifg=#66fa00 guibg=NONE    gui=none
hi link Character Constant
hi Number         guifg=#44aaaa guibg=NONE    gui=none
hi link Boolean Constant
hi link Float Constant

hi Identifier     guifg=#ffcc00 guibg=NONE    gui=none
hi Function       guifg=#eebb11 guibg=NONE    gui=none
hi link Method Function

hi Statement      guifg=#ff6600 guibg=NONE    gui=none 
hi link Conditional Statement
hi link Repeat	    Statement
hi link Label	      Statement
hi link Operator    Statement
hi link Keyword     Statement
hi link Exception   Statement

hi PreProc        guifg=#aaffff guibg=NONE    gui=none
hi link Include   PreProc
hi link Define	  PreProc
hi link Macro	    PreProc
hi link PreCondit PreProc

hi Type           guifg=#aaaa77 guibg=NONE    gui=none
hi link StorageClass Type
hi link Structure    Type
hi link Typedef      Type

hi Special        guifg=#33aa00 guibg=NONE    gui=none
hi link SpecialChar    Special
hi link Tag	           Special
hi Delimiter      guifg=#33aa00 guibg=NONE    gui=none
hi link SpecialComment Special
hi link Debug	         Special

hi Underlined     guifg=#80a0ff gui=underline 

hi Regexp         guifg=#44b4cc guibg=NONE    gui=none

"════════════════════════════════════════════════════════╡ Comments
"
hi Comment        guifg=#cc22dd guibg=NONE    gui=none
hi CommentBright  guifg=#33eeff guibg=NONE    gui=none

"════════════════════════════════════════════════════════╡ Format Aliases
"
hi HlBold         gui=bold
hi HlBoldItalic   gui=bold,italic
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
hi htmlComment    guifg=#999999 guibg=#111111

" HlMkDnCode 
" HlMkDnCdDelim
"
hi HlMkDnCode     guifg=#ddaadd guibg=#441144 gui=underline           guisp=#ddaadd
hi HlMkDnCodeBg   guifg=NONE    guibg=#163646 gui=none
hi HlMkDnCdBlock  guifg=#c9c9a3 guibg=#060606 gui=none
hi HlMkDnCdDelim  guifg=#ffff00 guibg=NONE    gui=bold,strikethrough
hi HlMkDnHeader   guifg=#cc44cc               gui=bold
hi HlMkDnLink     guifg=#15aabf               gui=italic,underline

"hi markdownHeadingRule
hi markdownH1     guifg=#cc44cc               gui=bold,italic         guisp=#00cc11
hi markdownH2     guifg=#cc44cc               gui=underline           guisp=#00cc11
hi markdownH3     guifg=#cc44cc               gui=underdashed         guisp=#00cc11
hi markdownH4     guifg=#cc44cc               gui=underdotted         guisp=#00aa11
hi markdownH5     guifg=#cc44cc               gui=underdotted,italic  guisp=#aa66aa
hi markdownH6     guifg=#cc44cc               gui=italic              guisp=#aa66aa
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

hi markdownId guifg=#cc00ff guibg=#440000
hi markdownIdDeclaration guifg=#cc00ff guibg=#440000
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

hi markdownEscape guifg=#33aa00 guibg=#061400    gui=none
hi link markdownError Error

hi link markdownHighlight_sh HlMkDnCodeBg
hi link markdownHighlight_javascript HlMkDnCodeBg
hi link markdownHighlight_typescript HlMkDnCodeBg
hi link markdownHighlight_json HlMkDnCodeBg

" Coc/Markdown
hi link CocBold HlBold
hi link CocItalic HlItalic
hi link CocUnderline HlUnderline
hi link CocStrikeThrough HlStrike
hi link CocMarkdownCode  HlMkDnCode
hi link CocMarkdownHeader HlMkDnHeader
hi link CocMarkdownLink  HlMkDnLink


"
"════════════════════════════════════════════════════════╡ Netrw
"
hi Directory     none | hi link Directory Identifier

hi netrwClassify none | hi link netrwClassify Function
hi netrwLink     none | hi link netrwLink     Special
hi netrwSymLink  none | hi link netrwSymLink  Question
hi netrwDir      none | hi link netrwDir      Directory
hi netrwExe      none | hi link netrwExe      PreProc
hi netrwList     none | hi link netrwList     Statement
hi netrwComma    none | hi link netrwComma    netrwComment
hi netrwVersion  none | hi link netrwVersion  Identifier
hi netrwCmdSep   none | hi link netrwCmdSep   Delimiter
hi netrwHelpCmd  none | hi link netrwHelpCmd  Function
hi clear netrwQuickHelp


"════════════════════════════════════════════════════════╡ Status
"
hi StatusLineTerm none | hi link StatusLineTerm  SlTerminal
hi StatusLineTermNC none | hi link StatusLineTermNC SlTerminalNC

hi StatusLine     guifg=#ffffff guibg=#232323 gui=none
hi StatusLineNC   guifg=#dddddd guibg=#151515 gui=none
hi SlTermC        guifg=#eeeeff guibg=#232323 gui=none
hi SlTermN        guifg=#ccccee guibg=#232323 gui=none
hi SlInfoC        guifg=#0088ff guibg=#232323 gui=none
hi SlInfoN        guifg=#0066ff guibg=#151515 gui=none
hi SlMessC        guifg=#aa6622 guibg=#232323 gui=none
hi SlMessN        guifg=#884422 guibg=#151515 gui=none
hi SlHomeLC       guifg=#aa00dd guibg=#232323 gui=none
hi SlHomeMC       guifg=#dd00dd guibg=#232323 gui=none
hi SlHomeRC       guifg=#dd00aa guibg=#232323 gui=none
hi SlHomeLN       guifg=#9900bb guibg=#151515 gui=none
hi SlHomeMN       guifg=#bb00bb guibg=#151515 gui=none
hi SlHomeRN       guifg=#bb0099 guibg=#151515 gui=none
hi SlDirC         guifg=#ddaa33 guibg=#232323 gui=none
hi SlDirN         guifg=#bb9933 guibg=#151515 gui=none
hi SlDirInvC      guifg=#ddaa33 guibg=#232323 gui=inverse
hi SlDirInvN      guifg=#bb9933 guibg=#151515 gui=inverse
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
" unnamed§
hi SlFNoNameC     guifg=#ccafaf guibg=#232323 gui=italic,underdotted
hi SlFNoNameN     guifg=#bbafaf guibg=#151515 gui=italic,underdotted
" Diff with original (disk) version
hi SlFDfSvNmC     guifg=#ccccaf guibg=#232323 gui=italic,underdotted
hi SlFDfSvNmN     guifg=#bbbbaf guibg=#151515 gui=italic,underdotted
hi SlFNameSvdC    guifg=#ffffff guibg=#232323
hi SlFNameSvdN    guifg=yormalf guibg=#151515
hi SlFNameModC    guifg=#ffffff guibg=#232323 gui=italic,underdotted
hi SlFNameModN    guifg=#ffffff guibg=#232323 gui=italic,underdotted
hi SlFTypExtC     guifg=#00cc00 guibg=#232323 gui=bold
hi SlFTypExtN     guifg=#ddd0dd guibg=#151515 gui=bold
hi SlFTypC        guifg=#eeccff guibg=#232323 gui=underline
hi SlFTypN        guifg=#bb99ff guibg=#151515 gui=none
hi link SlFTyp2C  SlHintC
hi link SlFTyp2N  SlHintN
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
hi SlGitC         guifg=#aa00dd guibg=#000000 gui=none
hi SlGitN         guifg=#9900cc guibg=#000000 gui=none
hi SlNotGitC      guifg=#660099               gui=none
hi SlNotGitN      guifg=#550088               gui=none
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

hi link jsonNoQuotesError       ErrorHint
hi link jsonMissingCommaError   ErrorHint


hi cssIdHash         guifg=#ffaa00
hi cssSelectorOp     guifg=#22ffaa gui=bold
hi cssSelectorOp2    guifg=#0800ff gui=bold
hi cssAttrParens     guifg=#ff5500 gui=bold
hi cssAttrComma      guifg=#ffff00 gui=bold
hi cssAttrOp         guifg=#ff00ff

hi link cssAtRule Include
hi link cssAtKeyword PreProc

hi link cssFunctionName Function
hi link cssFunctionComma Function
hi cssCustomProp  guifg=#bf53bc
hi cssNoise       guifg=#bbaf00

hi link cssPropertySyntax String
hi link cssSyntaxType Type
hi link cssPropertyAttr Keyword
hi cssPropertyProp  guifg=#ccccff

hi link cssIdentifier Function
hi link cssClassName Function
" hi cssPseudoClass
hi link cssPseudoClassId PreProc
" hi cssPseudoClassFn
hi link cssPseudoClassLang Constant

" Value types
hi link cssCalcKeyword Constant
hi link cssValueLength Number
hi link cssValueInteger Number
hi link cssValueNumber Number
hi link cssValueAngle Number
hi link cssValueTime Number
hi link cssValueFrequency Number
" unimplemented/vendor
hi cssVendor       guifg=#ffaa00 guibg=NONE gui=italic,strikethrough guisp=#ff0000
hi link cssHyerlinkProp cssVendor
hi link cssIEUIProp cssVendor
" no matches defined
hi link cssLineboxProp cssProp
hi link cssMarqueeProp cssProp
hi link cssPagedMediaProp cssProp
hi link cssPrintProp cssProp
hi link cssRubyProp cssProp
hi link cssSpeechProp cssProp
hi link cssRenderProp cssProp
" Generic/common
hi link cssCascadeProp cssProp
hi link cssCascadeAttr cssAttr
hi link cssCommonAttr cssAttr
" Language content & communication
hi cssCommsProp  guifg=#aabcc7 guibg=NONE    gui=none
hi link cssFontProp cssCommsProp
hi link cssTextProp cssCommsProp
hi link cssAuralProp cssCommsProp
hi link cssGeneratedContentProp cssCommsProp
hi link cssMobileTextProp cssCommsProp
" Color & appearance
hi cssPrettyProp guifg=#55aa77 guibg=NONE    gui=none
hi link cssAnimationProp cssPrettyProp
hi link cssTransitionProp cssPrettyProp
hi link cssBackgroundProp cssPrettyProp
hi link cssColorProp cssPrettyProp
hi link cssListProp cssPrettyProp
hi link cssObjectProp cssPrettyProp
" UI & behaviour
hi cssBehaveProp guifg=#cc6699 guibg=NONE    gui=none
hi link cssBorderProp cssBehaveProp
hi link cssTransformProp cssBehaveProp
hi link cssUIProp cssBehaveProp
hi link cssInteractProp cssBehaveProp
" Layout & structure
hi cssLayoutProp guifg=#2288dd guibg=NONE    gui=none
hi link cssBoxProp cssLayoutProp
hi link cssBoxAttr cssAttr
hi link cssPositioningProp cssLayoutProp
hi link cssPositioningAttr cssAttr
hi link cssDimensionProp cssLayoutProp
hi link cssDimensionAttr cssAttr
hi link cssFlexibleBoxProp cssLayoutProp
hi link cssFlexibleBoxAttr cssAttr
hi link cssGridProp cssLayoutProp
hi link cssMultiColumnProp cssLayoutProp
hi link cssTableProp cssLayoutProp
" Misc
hi cssImportant guifg=#dddd11 guibg=#005400  gui=none

" hi link CocSymbolDefault  hl-MoreMsg
" hi link CocSymbolFile
" hi link CocSymbolFolder
" hi link CocSymbolReference
" hi link CocSymbolSnippet

" hi link CocSymbolUnit
" hi link CocSymbolText
" hi link CocSymbolColor
" hi link CocSymbolVariable
" hi link CocSymbolConstant
" hi link CocSymbolValue
" hi link CocSymbolKeyword
" hi link CocSymbolTypeParameter

" hi link CocSymbolOperator

" hi link CocSymbolEvent
" hi link CocSymbolFunction
" hi link CocSymbolMethod
" hi link CocSymbolProperty
" hi link CocSymbolField

" hi link CocSymbolInterface
" hi link CocSymbolClass
" hi link CocSymbolConstructor
" hi link CocSymbolModule

" hi link CocSymbolEnum
" hi link CocSymbolEnumMember
" hi link CocSymbolStruct

" hi link CocSymbolNamespace
" hi link CocSymbolPackage

" hi link CocSymbolKey
" hi link CocSymbolNull

" hi link CocSymbolBoolean
" hi link CocSymbolNumber
" hi link CocSymbolString
" hi link CocSymbolArray
" hi link CocSymbolObject


" vim:colorcolumn=18,58:nolist:nowrap:wfw:ww=125:wfh:wh=12:
