" - about time I just made a colourscheme (foreshadowing)
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

function! s:hifg(group,guifg,first,second)
    exe "highlight ".a:group." guifg=".a:guifg." ctermfg=".a:first
endfunction
function! s:hibg(group,guibg,first,second)
    exe "highlight ".a:group." guibg=".a:guibg." ctermbg=".a:first
endfunction

hi link javascriptRegexpString  Regexp
hi link javascriptNumber        Number
hi link javascriptNull          Constant

" Attributes (gui=) ignored for Normal
hi Normal     guifg=#DEDEDE guibg=#000000 gui=bold ctermfg=White ctermbg=Black
if &background == "light" || has("gui_running")
    hi Normal ctermbg=Black
else
    hi Normal ctermbg=NONE
endif

" listchars: eol,extends,precedes; 
highlight NonText       guifg=#404040 ctermfg=8
" listchars: tab,nbsp,space,multispace,lead,trail;
highlight SpecialKey    guifg=#404040 ctermfg=8

highlight WildMenu      guifg=#000000 guibg=#FFFF00 gui=bold ctermfg=Black ctermbg=Yellow cterm=bold
highlight Cursor        guifg=#000000 guibg=#FFFFFF gui=bold ctermfg=Black ctermbg=White
highlight CursorLine    guibg=#333333 guifg=NONE
highlight CursorColumn  guibg=#333333 guifg=NONE
highlight Directory     none
high link Directory     Identifier
highlight ErrorMsg      guifg=NONE    guibg=#CE0000 ctermfg=NONE ctermbg=DarkRed
highlight Search        guifg=NONE    guibg=#555555 ctermfg=NONE gui=none cterm=none
call s:hibg("Search"    ,"#555555","Black",81)
highlight IncSearch     guifg=#FEFEFE guibg=Black ctermfg=White ctermbg=Black
highlight MoreMsg       guifg=#00AA00 ctermfg=Green
highlight LineNr        guifg=#DDEEFF guibg=#222222 ctermfg=White
call s:hibg("LineNr"    ,"#222222","DarkBlue",80)
highlight Question      none
high link Question      MoreMsg
highlight Title         guifg=Magenta ctermfg=Magenta
highlight VisualNOS     gui=none cterm=none
call s:hibg("Visual"    ,"#555577","LightBlue",83)
call s:hibg("VisualNOS" ,"#444444","DarkBlue",81)
highlight WarningMsg    guifg=Red ctermfg=Red

highlight Pmenu         guifg=White ctermfg=White gui=bold cterm=bold
highlight PmenuSel      guifg=White ctermfg=White gui=bold cterm=bold
call s:hibg("Pmenu"     ,"#000099","Blue",18)
call s:hibg("PmenuSel"  ,"#5555ff","DarkCyan",39)
highlight PmenuSbar     guibg=Grey ctermbg=Grey
highlight PmenuThumb    guibg=White ctermbg=White

highlight TabLine       gui=underline cterm=underline
call s:hifg("TabLine"   ,"#bbbbbb","LightGrey",85)
call s:hibg("TabLine"   ,"#333333","DarkGrey",80)
highlight TabLineSel    guifg=White guibg=Black ctermfg=White ctermbg=Black
highlight TabLineFill   gui=underline cterm=underline
call s:hifg("TabLineFill","#bbbbbb","LightGrey",85)
call s:hibg("TabLineFill","#808080","Grey",83)

" Inline error formatting
hi ErrorHint         guifg=#FEE3E3 guibg=NONE guisp=#FE0000 gui=undercurl term=reverse ctermbg=12
hi WarningHint       guifg=#EFEEAC guibg=NONE guisp=#FFDD00 gui=undercurl term=reverse ctermbg=12
hi link InfoHint            SpellCap
hi link HintHint            SpellLocal

hi link Error ErrorHint
hi Type      gui=none
hi Statement gui=none
hi Identifier cterm=none

"highlight PreProc       guifg=#EDF8F9
" call s:hifg("Comment"        ,"#9933CB","DarkMagenta",34)
call s:hifg("Constant"       ,"#339999","DarkCyan",21)
call s:hifg("String"         ,"#66FF00","LightGreen",44)
call s:hifg("Identifier"     ,"#FFCC00","Yellow",72)
call s:hifg("Statement"      ,"#FF6600","Brown",68)
call s:hifg("PreProc"        ,"#AAFFFF","LightCyan",47) 

call s:hifg("Type"           ,"#AAAA77","Grey",57)
call s:hifg("Special"        ,"#33AA00","DarkGreen",24)
call s:hifg("Regexp"         ,"#44B4CC","DarkCyan",21)

hi DiffText        guifg=#FFECEE guibg=#DD2233 gui=none

hi link javascriptRegexpString  Regexp
hi link javascriptNumber        Number
hi link javascriptNull          Constant

hi link CocErrorHighlight   ErrorHint
hi link CocWarningHighlight WarningHint
hi link CocInfoHighlight    InfoHint
hi link CocHintHighlight    HintHint

hi Folded      guifg=#aaddee  guibg=NONE ctermbg=LightCyan ctermbg=DarkBlue
hi FoldColumn    none
" high link FoldColumn   Folded
hi FoldColumn      guifg=#aaddee  guibg=NONE ctermbg=LightCyan ctermbg=DarkBlue

hi! clear FoldColumn
hi! clear SignColumn
if has('gui_running')
  hi link SignColumn          Normal
  hi link FoldColumn          Normal
else
  hi SignColumn ctermbg=0
  hi FoldColumn ctermbg=0
endif
hi GitGutterAdd    guifg=#009900 guibg=#000000 gui=none  ctermfg=2 ctermbg=0 
hi GitGutterChange guifg=#bbbb00 guibg=#000000 gui=none  ctermfg=3 ctermbg=0 
hi GitGutterDelete guifg=#ee2222 guibg=#000000 gui=none  ctermfg=1 ctermbg=0 

hi VertSplit       guifg=#666666 guibg=#151515 gui=none term=reverse cterm=reverse 

hi Conceal         guifg=#6666A2 guibg=#002244 ctermfg=NONE
hi Ignore          guifg=#8888AA guibg=#222244 ctermfg=NONE
hi Comment         guifg=#CC22DD               gui=none  term=bold ctermfg=DarkMagenta 

" StatusLine
" StatusLine       guifg=#000000 guibg=#aabbee gui=bold ctermfg=Black ctermbg=White  cterm=bold
" StatusLineNC     guifg=#444444 guibg=#aaaaaa gui=none ctermfg=Black ctermbg=Grey   cterm=none
hi StatusLine      guifg=#FFFFFF guibg=#232323 gui=none  cterm=bold ctermfg=0 ctermbg=5 
hi StatusBold      gui=bold
hi StatusLineNC    guifg=#DDDDDD guibg=#151515 gui=none  cterm=none ctermfg=0   
" diagnostics
hi StatusSynErr    guifg=#FC0000 guibg=#000000 gui=none  ctermfg=197 
hi StatusSynErrNC  guifg=#CC0000 guibg=#000000 gui=none  ctermfg=197 
hi StatusSynWarn   guifg=#FFAA00 guibg=#000000 gui=none  ctermfg=220 
hi StatusSynWarnNC guifg=#D08800 guibg=#000000 gui=none  ctermfg=220 
hi StatusSynOk     guifg=#55CC00 guibg=#000000 gui=none  ctermfg=LightGreen   
hi StatusSynOkNC   guifg=#229900 guibg=#000000 gui=none  ctermfg=LightGreen   
hi StatusSynOff    guifg=#00FFFF guibg=#000000 gui=none  ctermfg=Cyan
hi StatusSynOffNC  guifg=#00DDDD guibg=#000000 gui=none  ctermfg=Cyan
" git
hi StatusGitNC     guifg=#D0C4E0 guibg=#660099 gui=none  ctermfg=92  
hi StatusGit       guifg=#FFEEF0 guibg=#660099 gui=none  ctermfg=92  


" call s:hifg("rubyNumber"     ,"#CCFF33","Yellow",60)
" call s:hifg("railsUserMethod","#AACCFF","LightCyan",27)
" call s:hifg("railsUserClass" ,"#AAAAAA","Grey",7)
" call s:hifg("rubyMethod"     ,"#DDE93D","Yellow",77)

hi link jsonNoQuotesError SpellBad
hi link jsonMissingCommaError SpellBad
