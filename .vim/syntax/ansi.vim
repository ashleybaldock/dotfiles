
  " suppress escaped sequences that don't involve colors (which may or may not be ansi-compliant)
  if has("conceal")
   syn match ansiSuppress	conceal	'\e\[[0-9;]*[^m]'
   syn match ansiSuppress	conceal	'\e\[?\d*[^m]'
   syn match ansiSuppress	conceal	'\b'
  else
   syn match ansiSuppress		'\e\[[0-9;]*[^m]'
   syn match ansiSuppress	conceal	'\e\[?\d*[^m]'
   syn match ansiSuppress		'\b'
  endif

syn region ansiNone		start="\e\[[01;]m"  end="\e\["me=e-2 contains=ansiConceal
syn region ansiNone		start="\e\[m"       end="\e\["me=e-2 contains=ansiConceal

syn region ansiBlack		start="\e\[;\=0\{0,2};\=30m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRed		start="\e\[;\=0\{0,2};\=31m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiGreen		start="\e\[;\=0\{0,2};\=32m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiYellow		start="\e\[;\=0\{0,2};\=33m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBlue		start="\e\[;\=0\{0,2};\=34m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiMagenta	start="\e\[;\=0\{0,2};\=35m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiCyan		start="\e\[;\=0\{0,2};\=36m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiWhite		start="\e\[;\=0\{0,2};\=37m" end="\e\["me=e-2 contains=ansiConceal

syn region ansiBlackBg	start="\e\[;\=0\{0,2};\=\%(1;\)\=40\%(1;\)\=m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRedBg		start="\e\[;\=0\{0,2};\=\%(1;\)\=41\%(1;\)\=m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiGreenBg	start="\e\[;\=0\{0,2};\=\%(1;\)\=42\%(1;\)\=m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiYellowBg	start="\e\[;\=0\{0,2};\=\%(1;\)\=43\%(1;\)\=m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBlueBg		start="\e\[;\=0\{0,2};\=\%(1;\)\=44\%(1;\)\=m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiMagentaBg	start="\e\[;\=0\{0,2};\=\%(1;\)\=45\%(1;\)\=m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiCyanBg		start="\e\[;\=0\{0,2};\=\%(1;\)\=46\%(1;\)\=m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiWhiteBg	start="\e\[;\=0\{0,2};\=\%(1;\)\=47\%(1;\)\=m" end="\e\["me=e-2 contains=ansiConceal

syn region ansiBoldBlack	 start="\e\[;\=0\{0,2};\=\%(1;30\|30;1\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBoldRed	 start="\e\[;\=0\{0,2};\=\%(1;31\|31;1\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBoldGreen	 start="\e\[;\=0\{0,2};\=\%(1;32\|32;1\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBoldYellow	 start="\e\[;\=0\{0,2};\=\%(1;33\|33;1\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBoldBlue	 start="\e\[;\=0\{0,2};\=\%(1;34\|34;1\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBoldMagenta	 start="\e\[;\=0\{0,2};\=\%(1;35\|35;1\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBoldCyan	 start="\e\[;\=0\{0,2};\=\%(1;36\|36;1\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBoldWhite	 start="\e\[;\=0\{0,2};\=\%(1;37\|37;1\)m" end="\e\["me=e-2 contains=ansiConceal

syn region ansiStandoutBlack	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;30\|30;3\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiStandoutRed	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;31\|31;3\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiStandoutGreen	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;32\|32;3\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiStandoutYellow	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;33\|33;3\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiStandoutBlue	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;34\|34;3\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiStandoutMagenta	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;35\|35;3\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiStandoutCyan	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;36\|36;3\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiStandoutWhite	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;37\|37;3\)m" end="\e\["me=e-2 contains=ansiConceal

syn region ansiItalicBlack	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;30\|30;2\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiItalicRed	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;31\|31;2\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiItalicGreen	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;32\|32;2\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiItalicYellow	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;33\|33;2\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiItalicBlue	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;34\|34;2\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiItalicMagenta	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;35\|35;2\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiItalicCyan	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;36\|36;2\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiItalicWhite	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;37\|37;2\)m" end="\e\["me=e-2 contains=ansiConceal

syn region ansiUnderlineBlack	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;30\|30;4\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiUnderlineRed	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;31\|31;4\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiUnderlineGreen	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;32\|32;4\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiUnderlineYellow	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;33\|33;4\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiUnderlineBlue	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;34\|34;4\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiUnderlineMagenta	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;35\|35;4\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiUnderlineCyan	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;36\|36;4\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiUnderlineWhite	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;37\|37;4\)m" end="\e\["me=e-2 contains=ansiConceal

syn region ansiBlinkBlack	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;30\|30;5\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBlinkRed	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;31\|31;5\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBlinkGreen	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;32\|32;5\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBlinkYellow	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;33\|33;5\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBlinkBlue	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;34\|34;5\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBlinkMagenta	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;35\|35;5\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBlinkCyan	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;36\|36;5\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiBlinkWhite	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;37\|37;5\)m" end="\e\["me=e-2 contains=ansiConceal

syn region ansiRapidBlinkBlack	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;30\|30;6\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRapidBlinkRed	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;31\|31;6\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRapidBlinkGreen	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;32\|32;6\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRapidBlinkYellow	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;33\|33;6\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRapidBlinkBlue	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;34\|34;6\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRapidBlinkMagenta	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;35\|35;6\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRapidBlinkCyan	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;36\|36;6\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRapidBlinkWhite	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;37\|37;6\)m" end="\e\["me=e-2 contains=ansiConceal

syn region ansiRVBlack	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;30\|30;7\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRVRed		 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;31\|31;7\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRVGreen	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;32\|32;7\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRVYellow	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;33\|33;7\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRVBlue		 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;34\|34;7\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRVMagenta	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;35\|35;7\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRVCyan		 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;36\|36;7\)m" end="\e\["me=e-2 contains=ansiConceal
syn region ansiRVWhite	 start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;37\|37;7\)m" end="\e\["me=e-2 contains=ansiConceal

syn match ansiExtended	 "\e\[;\=\(0;\)\=[34]8;\(\d*;\)*\d*m"   contains=ansiConceal

if has("conceal")
 syn match ansiConceal		contained conceal	"\e\[\(\d*;\)*\d*m"
else
 syn match ansiConceal		contained		"\e\[\(\d*;\)*\d*m"
endif


if has("conceal")
 syn match ansiStop		conceal "\e\[;\=0\{1,2}m"
 syn match ansiStop		conceal "\e\[K"
 syn match ansiStop		conceal "\e\[H"
 syn match ansiStop		conceal "\e\[2J"
else
 syn match ansiStop		"\e\[;\=0\{0,2}m"
 syn match ansiStop		"\e\[K"
 syn match ansiStop		"\e\[H"
 syn match ansiStop		"\e\[2J"
endif

"syn match ansiIgnore		conceal "\e\[\([56];3[0-9]\|3[0-9];[56]\)m"
"syn match ansiIgnore		conceal "\e\[\([0-9]\+;\)\{2,}[0-9]\+m"

hi ansiNone	cterm=NONE gui=NONE

hi ansiBlack             ctermfg=black      guifg=#e1e1e1                                       cterm=none         gui=none
hi ansiRed               ctermfg=red        guifg=red                                          cterm=none         gui=none
hi ansiGreen             ctermfg=green      guifg=green                                        cterm=none         gui=none
hi ansiYellow            ctermfg=yellow     guifg=#eeee00                                      cterm=none         gui=none
hi ansiBlue              ctermfg=blue       guifg=#2266ff                                      cterm=none         gui=none
hi ansiMagenta           ctermfg=magenta    guifg=magenta                                      cterm=none         gui=none
hi ansiCyan              ctermfg=cyan       guifg=cyan                                         cterm=none         gui=none
hi ansiWhite             ctermfg=white      guifg=#ffffff                                        cterm=none         gui=none

hi ansiBlackBg           ctermbg=black      guibg=black                                        cterm=none         gui=none
hi ansiRedBg             ctermbg=red        guibg=red                                          cterm=none         gui=none
hi ansiGreenBg           ctermbg=green      guibg=green                                        cterm=none         gui=none
hi ansiYellowBg          ctermbg=yellow     guibg=yellow                                       cterm=none         gui=none
hi ansiBlueBg            ctermbg=blue       guibg=blue                                         cterm=none         gui=none
hi ansiMagentaBg         ctermbg=magenta    guibg=magenta                                      cterm=none         gui=none
hi ansiCyanBg            ctermbg=cyan       guibg=cyan                                         cterm=none         gui=none
hi ansiWhiteBg           ctermbg=white      guibg=white                                        cterm=none         gui=none

hi ansiBoldBlack         ctermfg=black      guifg=black                                        cterm=bold         gui=bold
hi ansiBoldRed           ctermfg=red        guifg=red                                          cterm=bold         gui=bold
hi ansiBoldGreen         ctermfg=green      guifg=green                                        cterm=bold         gui=bold
hi ansiBoldYellow        ctermfg=yellow     guifg=yellow                                       cterm=bold         gui=bold
hi ansiBoldBlue          ctermfg=blue       guifg=blue                                         cterm=bold         gui=bold
hi ansiBoldMagenta       ctermfg=magenta    guifg=magenta                                      cterm=bold         gui=bold
hi ansiBoldCyan          ctermfg=cyan       guifg=cyan                                         cterm=bold         gui=bold
hi ansiBoldWhite         ctermfg=white      guifg=white                                        cterm=bold         gui=bold

hi ansiStandoutBlack     ctermfg=black      guifg=black                                        cterm=standout     gui=standout
hi ansiStandoutRed       ctermfg=red        guifg=red                                          cterm=standout     gui=standout
hi ansiStandoutGreen     ctermfg=green      guifg=green                                        cterm=standout     gui=standout
hi ansiStandoutYellow    ctermfg=yellow     guifg=yellow                                       cterm=standout     gui=standout
hi ansiStandoutBlue      ctermfg=blue       guifg=blue                                         cterm=standout     gui=standout
hi ansiStandoutMagenta   ctermfg=magenta    guifg=magenta                                      cterm=standout     gui=standout
hi ansiStandoutCyan      ctermfg=cyan       guifg=cyan                                         cterm=standout     gui=standout
hi ansiStandoutWhite     ctermfg=white      guifg=white                                        cterm=standout     gui=standout

hi ansiItalicBlack       ctermfg=black      guifg=black                                        cterm=italic       gui=italic
hi ansiItalicRed         ctermfg=red        guifg=red                                          cterm=italic       gui=italic
hi ansiItalicGreen       ctermfg=green      guifg=green                                        cterm=italic       gui=italic
hi ansiItalicYellow      ctermfg=yellow     guifg=yellow                                       cterm=italic       gui=italic
hi ansiItalicBlue        ctermfg=blue       guifg=blue                                         cterm=italic       gui=italic
hi ansiItalicMagenta     ctermfg=magenta    guifg=magenta                                      cterm=italic       gui=italic
hi ansiItalicCyan        ctermfg=cyan       guifg=cyan                                         cterm=italic       gui=italic
hi ansiItalicWhite       ctermfg=white      guifg=white                                        cterm=italic       gui=italic

hi ansiUnderlineBlack    ctermfg=black      guifg=black                                        cterm=underline    gui=underline
hi ansiUnderlineRed      ctermfg=red        guifg=red                                          cterm=underline    gui=underline
hi ansiUnderlineGreen    ctermfg=green      guifg=green                                        cterm=underline    gui=underline
hi ansiUnderlineYellow   ctermfg=yellow     guifg=yellow                                       cterm=underline    gui=underline
hi ansiUnderlineBlue     ctermfg=blue       guifg=blue                                         cterm=underline    gui=underline
hi ansiUnderlineMagenta  ctermfg=magenta    guifg=magenta                                      cterm=underline    gui=underline
hi ansiUnderlineCyan     ctermfg=cyan       guifg=cyan                                         cterm=underline    gui=underline
hi ansiUnderlineWhite    ctermfg=white      guifg=white                                        cterm=underline    gui=underline

hi ansiBlinkBlack        ctermfg=black      guifg=black                                        cterm=standout     gui=undercurl
hi ansiBlinkRed          ctermfg=red        guifg=red                                          cterm=standout     gui=undercurl
hi ansiBlinkGreen        ctermfg=green      guifg=green                                        cterm=standout     gui=undercurl
hi ansiBlinkYellow       ctermfg=yellow     guifg=yellow                                       cterm=standout     gui=undercurl
hi ansiBlinkBlue         ctermfg=blue       guifg=blue                                         cterm=standout     gui=undercurl
hi ansiBlinkMagenta      ctermfg=magenta    guifg=magenta                                      cterm=standout     gui=undercurl
hi ansiBlinkCyan         ctermfg=cyan       guifg=cyan                                         cterm=standout     gui=undercurl
hi ansiBlinkWhite        ctermfg=white      guifg=white                                        cterm=standout     gui=undercurl

hi ansiRapidBlinkBlack   ctermfg=black      guifg=black                                        cterm=standout     gui=undercurl
hi ansiRapidBlinkRed     ctermfg=red        guifg=red                                          cterm=standout     gui=undercurl
hi ansiRapidBlinkGreen   ctermfg=green      guifg=green                                        cterm=standout     gui=undercurl
hi ansiRapidBlinkYellow  ctermfg=yellow     guifg=yellow                                       cterm=standout     gui=undercurl
hi ansiRapidBlinkBlue    ctermfg=blue       guifg=blue                                         cterm=standout     gui=undercurl
hi ansiRapidBlinkMagenta ctermfg=magenta    guifg=magenta                                      cterm=standout     gui=undercurl
hi ansiRapidBlinkCyan    ctermfg=cyan       guifg=cyan                                         cterm=standout     gui=undercurl
hi ansiRapidBlinkWhite   ctermfg=white      guifg=white                                        cterm=standout     gui=undercurl

hi ansiRVBlack           ctermfg=black      guifg=black                                        cterm=reverse      gui=reverse
hi ansiRVRed             ctermfg=red        guifg=red                                          cterm=reverse      gui=reverse
hi ansiRVGreen           ctermfg=green      guifg=green                                        cterm=reverse      gui=reverse
hi ansiRVYellow          ctermfg=yellow     guifg=yellow                                       cterm=reverse      gui=reverse
hi ansiRVBlue            ctermfg=blue       guifg=blue                                         cterm=reverse      gui=reverse
hi ansiRVMagenta         ctermfg=magenta    guifg=magenta                                      cterm=reverse      gui=reverse
hi ansiRVCyan            ctermfg=cyan       guifg=cyan                                         cterm=reverse      gui=reverse
hi ansiRVWhite           ctermfg=white      guifg=white                                        cterm=reverse      gui=reverse


