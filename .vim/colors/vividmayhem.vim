" Based on tpope's vividchalk

set background=dark
hi clear
if exists("syntax_on")
   syntax reset
endif

let g:colors_name = "vividmayhem"

" First two functions adapted from inkpot.vim

" map a urxvt cube number to an xterm-256 cube number
fun! s:M(a)
    return strpart("0245", a:a, 1) + 0
endfun

" map a urxvt colour to an xterm-256 colour
fun! s:X(a)
    if &t_Co == 88
        return a:a
    else
        if a:a == 8
            return 237
        elseif a:a < 16
            return a:a
        elseif a:a > 79
            return 232 + (3 * (a:a - 80))
        else
            let l:b = a:a - 16
            let l:x = l:b % 4
            let l:y = (l:b / 4) % 4
            let l:z = (l:b / 16)
            return 16 + s:M(l:x) + (6 * s:M(l:y)) + (36 * s:M(l:z))
        endif
    endif
endfun

function! E2T(a)
    return s:X(a:a)
endfunction

function! s:choose(mediocre,good)
    if &t_Co != 88 && &t_Co != 256
        return a:mediocre
    else
        return s:X(a:good)
    endif
endfunction

function! s:hifg(group,guifg,first,second,...)
    if a:0 && &t_Co == 256
        let ctermfg = a:1
    else
        let ctermfg = s:choose(a:first,a:second)
    endif
    exe "highlight ".a:group." guifg=".a:guifg." ctermfg=".ctermfg
endfunction

function! s:hibg(group,guibg,first,second)
    let ctermbg = s:choose(a:first,a:second)
    exe "highlight ".a:group." guibg=".a:guibg." ctermbg=".ctermbg
endfunction

hi link javascriptRegexpString  Regexp
hi link javascriptNumber        Number
hi link javascriptNull          Constant

call s:hifg("Normal","#EEEEEE","White",87)
if &background == "light" || has("gui_running")
    hi Normal guibg=Black ctermbg=Black
else
    hi Normal guibg=Black ctermbg=NONE
endif
" highlight StatusLine    guifg=Black   guibg=#aabbee gui=bold ctermfg=Black ctermbg=White  cterm=bold
" highlight StatusLineNC  guifg=#444444 guibg=#aaaaaa gui=none ctermfg=Black ctermbg=Grey   cterm=none
highlight WildMenu      guifg=Black   guibg=#ffff00 gui=bold ctermfg=Black ctermbg=Yellow cterm=bold
highlight Cursor        guifg=Black guibg=White ctermfg=Black ctermbg=White
highlight CursorLine    guibg=#333333 guifg=NONE
highlight CursorColumn  guibg=#333333 guifg=NONE
highlight NonText       guifg=#404040 ctermfg=8
highlight SpecialKey    guifg=#404040 ctermfg=8
highlight Directory     none
high link Directory     Identifier
highlight ErrorMsg      guibg=Red ctermbg=DarkRed guifg=NONE ctermfg=NONE
highlight Search        guifg=NONE ctermfg=NONE gui=none cterm=none
call s:hibg("Search"    ,"#555555","Black",81)
highlight IncSearch     guifg=White guibg=Black ctermfg=White ctermbg=Black
highlight MoreMsg       guifg=#00AA00 ctermfg=Green
highlight LineNr        guifg=#DDEEFF ctermfg=White
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

hi Type gui=none
hi Statement gui=none
if !has("gui_mac")
    " Mac GUI degrades italics to ugly underlining.
    hi Comment gui=italic
    hi railsUserClass  gui=italic
    hi railsUserMethod gui=italic
endif
hi Identifier cterm=none
" Commented numbers at the end are *old* 256 color values
"highlight PreProc       guifg=#EDF8F9
call s:hifg("Comment"        ,"#9933CB","DarkMagenta",34) " 92
" 26 instead?
call s:hifg("Constant"       ,"#339999","DarkCyan",21) " 30
call s:hifg("rubyNumber"     ,"#CCFF33","Yellow",60) " 190
call s:hifg("String"         ,"#66FF00","LightGreen",44,82) " 82
call s:hifg("Identifier"     ,"#FFCC00","Yellow",72) " 220
call s:hifg("Statement"      ,"#FF6600","Brown",68) " 202
call s:hifg("PreProc"        ,"#AAFFFF","LightCyan",47) " 213
call s:hifg("railsUserMethod","#AACCFF","LightCyan",27)
call s:hifg("Type"           ,"#AAAA77","Grey",57) " 101
call s:hifg("railsUserClass" ,"#AAAAAA","Grey",7) " 101
call s:hifg("Special"        ,"#33AA00","DarkGreen",24) " 7
call s:hifg("Regexp"         ,"#44B4CC","DarkCyan",21) " 74
call s:hifg("rubyMethod"     ,"#DDE93D","Yellow",77) " 191


hi link javascriptRegexpString  Regexp
hi link javascriptNumber        Number
hi link javascriptNull          Constant

highlight! clear SignColumn

hi StatusLine      cterm=bold ctermfg=0 ctermbg=5 gui=none guifg=#FFFFFF guibg=#232323
hi StatusLineNC    cterm=none ctermfg=0 gui=none guifg=#DDDDDD guibg=#151515
hi VertSplit       term=reverse cterm=reverse gui=none guifg=#666666 guibg=#151515

hi Conceal ctermfg=NONE guifg=NONE guibg=#3333AA 
hi Comment term=bold ctermfg=92 gui=none guifg=#CC22DD
if has('gui_running')
  highlight link SignColumn Normal
  highlight link CocErrorHighlight SpellBad
  highlight link CocWarningHighlight SpellRare
  highlight link CocInfoHighlight SpellCap
  highlight link CocHintHighlight SpellLocal
else
  highlight SignColumn ctermbg=0
endif
highlight GitGutterAdd    ctermfg=2 ctermbg=0 guifg=#009900 guibg=Black
highlight GitGutterChange ctermfg=3 ctermbg=0 guifg=#bbbb00 guibg=Black
highlight GitGutterDelete ctermfg=1 ctermbg=0 guifg=#ff2222 guibg=Black

" StatusLine syntax errors
hi StatusSynErr    ctermfg=197 guifg=#FF0000 guibg=#000000
hi StatusSynErrNC  ctermfg=197 guifg=#DC0000 guibg=#000000
hi StatusSynWarn   ctermfg=220 guifg=#FFAA00 guibg=#000000
hi StatusSynWarnNC ctermfg=220 guifg=#D08800 guibg=#000000
hi StatusSynOk     ctermfg=LightGreen guifg=#55CC00 guibg=#000000
hi StatusSynOkNC   ctermfg=LightGreen guifg=#229900 guibg=#000000
hi StatusSynOff    ctermfg=Cyan guifg=#00FFFF
hi StatusSynOffNC  ctermfg=Cyan guifg=#00DDDD

" StatusLine git info
hi StatusGitNC     ctermfg=92 gui=none guifg=#D0C4E0 guibg=#660099
hi StatusGit       ctermfg=92 gui=none guifg=#FFEEF0 guibg=#660099


