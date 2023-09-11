" - about time I just made a colourscheme (foreshadowing)
" Based on tpope's vividchalk

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

hi Normal     guifg=#EEEEEE guibg=#000000 gui=bold ctermfg=White ctermbg=Black
if &background == "light" || has("gui_running")
    hi Normal guibg=Black ctermbg=Black
else
    hi Normal guibg=Black ctermbg=NONE
endif

highlight WildMenu      guifg=Black   guibg=#ffff00 gui=bold ctermfg=Black ctermbg=Yellow cterm=bold
highlight Cursor        guifg=Black guibg=White ctermfg=Black ctermbg=White
highlight CursorLine    guibg=#333333 guifg=NONE
highlight CursorColumn  guibg=#333333 guifg=NONE
highlight NonText       guifg=#404040 ctermfg=8
highlight SpecialKey    guifg=#404040 ctermfg=8
highlight Directory     none
high link Directory     Identifier
highlight ErrorMsg      guibg=Red ctermbg=DarkRed guifg=NONE ctermfg=NONE
highlight Search        guifg=NONE guibg=#555555 ctermfg=NONE gui=none cterm=none
call s:hibg("Search"    ,"#555555","Black",81)
highlight IncSearch     guifg=White guibg=Black ctermfg=White ctermbg=Black
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

highlight Folded        guibg=#1100aa ctermbg=DarkBlue
call s:hibg("Folded"    ,"#110077","DarkBlue",17)
call s:hifg("Folded"    ,"#aaddee","LightCyan",63)
highlight FoldColumn    none
high link FoldColumn    Folded

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


hi link javascriptRegexpString  Regexp
hi link javascriptNumber        Number
hi link javascriptNull          Constant


highlight! clear SignColumn
if has('gui_running')
  highlight link SignColumn          Normal
  highlight link CocErrorHighlight   SpellBad
  highlight link CocWarningHighlight SpellRare
  highlight link CocInfoHighlight    SpellCap
  highlight link CocHintHighlight    SpellLocal
else
  highlight SignColumn ctermbg=0
endif
hi GitGutterAdd    guifg=#009900 guibg=#000000 gui=none  ctermfg=2 ctermbg=0 
hi GitGutterChange guifg=#bbbb00 guibg=#000000 gui=none  ctermfg=3 ctermbg=0 
hi GitGutterDelete guifg=#ff2222 guibg=#000000 gui=none  ctermfg=1 ctermbg=0 

hi VertSplit       guifg=#666666 guibg=#151515 gui=none term=reverse cterm=reverse 

hi Conceal         guifg=NONE    guibg=#3333AA ctermfg=NONE
hi Comment         guifg=#CC22DD               gui=none  term=bold ctermfg=DarkMagenta 

" StatusLine
" StatusLine       guifg=Black   guibg=#aabbee gui=bold ctermfg=Black ctermbg=White  cterm=bold
" StatusLineNC     guifg=#444444 guibg=#aaaaaa gui=none ctermfg=Black ctermbg=Grey   cterm=none
hi StatusLine      guifg=#FFFFFF guibg=#232323 gui=none  cterm=bold ctermfg=0 ctermbg=5 
hi StatusLineNC    guifg=#DDDDDD guibg=#151515 gui=none  cterm=none ctermfg=0   
" diagnostics
hi StatusSynErr    guifg=#FF0000 guibg=#000000 gui=none  ctermfg=197 
hi StatusSynErrNC  guifg=#DC0000 guibg=#000000 gui=none  ctermfg=197 
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

