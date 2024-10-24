" Terminal optimised colourscheme
"
" so $VIMRUNTIME/syntax/hitest.vim
" 

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "termayhem"

"══════════════════════════════════════════════════════╡ Window ╞══════════
" 𝓲⃞  [gui=] ignored for 'Normal' highlight
hi Normal        ctermfg=White ctermbg=NONE
" Used to change Normal colours per window based on buffer type
hi WinNormal     ctermfg=White ctermbg=NONE
hi WinReadonly   ctermfg=White ctermbg=NONE
hi WinNoModify   ctermfg=White ctermbg=NONE
hi WinPreview    ctermfg=White ctermbg=NONE
hi WinHelp       ctermfg=White ctermbg=NONE

"══════════════════════════════════════════════════════╡ Lines & Cursor ╞══════════
"
hi LineNr        ctermfg=White ctermbg=DarkBlue
"hi LineNrAbove
"hi LineNrBelow

hi Cursor        ctermfg=Black ctermbg=White
hi CursorLine    
"hi CursorLineNr  (w/ relativenumber)
"hi CursorLineFold (in folds column)
"hi CursorLineSign (in signs column)
hi CursorColumn  

"══════════════════════════════════════════════════════╡ Search ╞══════════
hi Search        ctermfg=NONE  ctermbg=Black     cterm=none
hi IncSearch     ctermfg=White ctermbg=Black
hi link CurSearch Search

hi Visual none | hi Visual     ctermfg=none      cterm=none

hi MoreMsg       ctermfg=Green
hi ErrorMsg      ctermfg=NONE  ctermbg=DarkRed
hi WarningMsg    ctermfg=Red

hi Question none | hi link Question MoreMsg

hi Title         ctermfg=Magenta

hi WildMenu      ctermfg=Black ctermbg=Yellow    cterm=bold

hi Directory none | hi link Directory Identifier

"══════════════════════════════════════════════════════╡ Invisible(ish) ╞══════════
"
hi Conceal       ctermfg=NONE
hi Ignore        ctermfg=NONE
" Diagnostics related
hi link CocFadeOut             Conceal
hi link CocDeprecatedHighlight CocStrikeThrough
hi link CocUnusedHighlight     CocFadeOut

" Used for: fillchars: eob
hi EndOfBuffer   
" Used for: listchars: eol,extends,precedes;
hi NonText       ctermfg=8
" Used for: listchars: tab,nbsp,space,multispace,lead,trail;
" e.g.:    			   
hi SpecialKey    ctermfg=8
hi U8Whitespace  

"══════════════════════════════════════════════════════╡ Menu Popups ╞══════════
"
" Popup menu (e.g. tab completion)
hi Pmenu         ctermfg=15 ctermbg=9 cterm=bold 
hi PmenuSel      ctermfg=15 ctermbg=3 cterm=bold 
" e.g. K in: |match   K [TSC]|
hi PmenuKind     ctermfg=15 ctermbg=9 cterm=bold 
hi PmenuKindSel  ctermfg=15 ctermbg=3 cterm=bold 
" e.g. [TSC] in: |match   K [TSC]|
hi PmenuExtra    ctermfg=15 ctermbg=9 cterm=bold 
hi PmenuExtraSel ctermfg=15 ctermbg=9 cterm=bold 
hi PmenuSbar                ctermbg=Grey
hi PmenuThumb               ctermbg=White
hi link CocPum Pmenu
" hi CocSymbol
hi link CocMenuSel PmenuSel

"══════════════════════════════════════════════════════╡ Vertical ╞══════════
" (signs, folds etc.)
hi VertSplit       term=reverse cterm=reverse 

hi Folded          ctermfg=11 ctermbg=DarkBlue
hi FoldColumn      
hi SignColumn      

hi GitGutterAdd    ctermfg=2 ctermbg=0 
hi GitGutterChange ctermfg=3 ctermbg=0 
hi GitGutterDelete ctermfg=1 ctermbg=0 

" Signs & sign column
hi CocErrorSign    
hi CocErrorLine    
hi CocWarningSign  
" hi CocWarningLine                
hi CocInfoSign     
" hi CocInfoLine
hi CocHintSign     
" hi CocHintLine
"
"══════════════════════════════════════════════════════╡  Horizontal   ╞══════════
"
hi TabLine       ctermfg=7  ctermbg=8 cterm=underline 
hi TabLineSel    ctermfg=15 ctermbg=0
hi TabLineFill   ctermfg=7  ctermbg=7 cterm=underline

hi ToolbarLine   
hi ToolbarButton 
"══════════════════════════════════════════════════════╡ Inline Errors ╞══════════
"
hi ErrorHint     term=reverse ctermbg=12
hi link Error ErrorHint
hi WarningHint   term=reverse ctermbg=12
hi link InfoHint  SpellCap
hi link HintHint  SpellLocal

"══════════════════════════════════════════════════════╡ Code Sections ╞══════════
"
hi Type          ctermfg=Grey
hi Statement     ctermfg=Brown
hi Identifier    ctermfg=Yellow      cterm=none
hi Constant      ctermfg=DarkCyan    cterm=none
hi String        ctermfg=LightGreen  cterm=none
hi PreProc       ctermfg=LightCyan

hi Special                          ctermbg=DarkGreen
hi Regexp                           ctermbg=DarkCyan

"══════════════════════════════════════════════════════╡ Diffs ╞══════════
"
hi DiffText      
hi DiffDelete    

"══════════════════════════════════════════════════════╡ Comments ╞══════════
"
hi Comment       term=bold ctermfg=DarkMagenta 
hi CommentBright term=bold ctermfg=DarkMagenta 
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
hi StatusLine      cterm=bold ctermfg=0 ctermbg=5 
hi StatusLineNC    cterm=none ctermfg=0 
hi SlInfoC         ctermfg=Cyan
hi SlInfoN         ctermfg=Cyan
hi SlDirC          ctermfg=Cyan
hi SlDirN          ctermfg=Cyan
hi SlPrevC         ctermfg=Cyan
hi SlPrevN         ctermfg=Cyan
" for the < collapsed separator
hi SlSepC          
hi SlSepN          
"
hi SlB             
hi SlI             
hi SlU             
hi SlHintC         
hi SlHintN         
" filename
hi SlFNameC        
hi SlFNameN        
hi SlFNoNameC      
hi SlFNoNameN      
hi SlFNameSvdC     
hi SlFNameSvdN     
hi SlFNameModC     
hi SlFNameModN     
hi SlFTypExtC      
hi SlFTypExtN      
hi SlFTypC         line
hi SlFTypN         
hi link SlFTyp2C   SLHintC
hi link SlFTyp2N   SLHintN
" file & buffer warning flags
hi SlFlagC         ctermfg=197
hi SlFlagN         ctermfg=197
" diagnostics
hi SlSynErrC       ctermfg=197
hi SlSynErrN       ctermfg=197
hi SlSynWarnC      ctermfg=220
hi SlSynWarnN      ctermfg=220
hi SlSynOkC        ctermfg=LightGreen
hi SlSynOkN        ctermfg=LightGreen
hi SlSynOffC       ctermfg=Cyan
hi SlSynOffN       ctermfg=Cyan
" git
hi SlGitC          ctermfg=92
hi SlGitN          ctermfg=92
hi SlNotGitC       
hi SlNotGitN       ctermfg=92
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
