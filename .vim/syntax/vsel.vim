if exists("b:current_syntax")
  finish
endif

"
" Syntax etc. for 'vsel' files
"
" :au BufWritePost <buffer> syn on
"
" Related:       ./pre.vim
"        ../plugin/char.vim
"      ../autoload/char.vim
"      ../autoload/charinfo.vim
"

let s:cpo_save = &cpo
set cpo&vim

syn match vs80 +󠄿+
syn match vs81 +󠅀+
syn match vs82 +󠅁+
syn match vs83 +󠅂+
syn match vs84 +󠅃+
syn match vs85 +󠅄+
syn match vs86 +󠅅+
syn match vs87 +󠅆+
syn match vs88 +󠅇+
syn match vs89 +󠅈+
syn match vs8A +󠅉+
syn match vs8B +󠅊+
syn match vs8C +󠅋+
syn match vs8D +󠅌+
syn match vs8E +󠅍+
syn match vs8F +󠅎+

syn match vs90 +󠅏+
syn match vs91 +󠅐+
syn match vs92 +󠅑+
syn match vs93 +󠅒+
syn match vs94 +󠅓+
syn match vs95 +󠅔+
syn match vs96 +󠅕+
syn match vs97 +󠅖+
syn match vs98 +󠅗+
syn match vs99 +󠅘+
syn match vs9A +󠅙+
syn match vs9B +󠅚+
syn match vs9C +󠅛+
syn match vs9D +󠅜+
syn match vs9E +󠅝+
syn match vs9F +󠅞+

hi def vs80 guifg=#000000
hi def vs81 guifg=#ff0000
hi def vs92 guifg=#ff8800
hi def vs82 guifg=#ffff00
hi def vs93 guifg=#88ff00
hi def vs83 guifg=#00ff00
hi def vs94 guifg=#00ff88
hi def vs84 guifg=#00ffff
hi def vs95 guifg=#0088ff
hi def vs85 guifg=#0000ff
hi def vs96 guifg=#8800ff
hi def vs86 guifg=#ff00ff
hi def vs91 guifg=#ff0088
hi def vs87 guifg=#ffffff

hi def vs88 guifg=#222222
hi def vs89 guifg=#880000
" hi def vs89         guifg=#ff0000
hi def vs8A guifg=#808000
" hi def vs8A         guifg=#868600
hi def vs8B guifg=#008800
" hi def vs8B         guifg=#00cb00
hi def vs8C guifg=#008888
" hi def vs8C         guifg=#00abab
hi def vs8D guifg=#000088
" hi def vs8D         guifg=#0000ff
hi def vs8E guifg=#880088
" hi def vs8E         guifg=#ff00ff
hi def vs8F guifg=#777777
                  
hi def vs90 guifg=#ff0088
hi def vs91 guifg=#ff8800
hi def vs92 guifg=#ffff44
hi def vs93 guifg=#88ff44
hi def vs94 guifg=#44ffff
hi def vs95 guifg=#0088ff
hi def vs96 guifg=#8844ff
hi def vs97 guifg=#ff44ff

hi def vs98 guifg=#ff6688  guibg=#ff88aa
hi def vs99 guifg=#ff8866  guibg=#ffaa88
hi def vs9A guifg=#ffff88  guibg=#ffffaa
hi def vs9B guifg=#88ff88  guibg=#b9ffb9
hi def vs9C guifg=#88ffff  guibg=#bbffff
hi def vs9D guifg=#6688ff  guibg=#88aaff
hi def vs9E guifg=#8866ff  guibg=#aa88ff
hi def vs9F guifg=#ff88ff  guibg=#ffaaff

"#000000
"#4400ff
"#0000ff     #6867ff #000088
"#0044ff
"    #4444ff
"  #4488ff
"  #0088ff     #004488
"  #0e95ff     #075588
"    #44aaff
"#00ffff     #008888
"#00acab     #005656
"    #44ff88
"  #00ff88     #008844
"#00ff00     #008800
"#00cc00     #006600
"    #44ff44
"  #88ff00     #448800
"   #88ff44
"    #aaff44
"#ffff00     #888800 #868600
"    #ffaa44
"  #ff8800     #884400
"    #ff4444
" #ff4422
" #ff4400
"#ff0000     #880000
" #ff0044
"  #ff0088     #880044
"   #ff00aa
"    #ff44aa
"  #ff4488
"#ff00ff     #880088
" #ff22ff
"  #ff44ff
"    #aa44ff
"  #8800ff     #440088
"    #4400ff
"    #0044ff
"hi def Tag9A guifg=#ffffff
" hi def Tag8D guifg=#000088  #444488
" hi def Tag8E guifg=#8888ff  #8888aa
" hi def Tag8F guifg=#008888  #448888
" hi def Tag90 guifg=#88ffff  #88aaaa
" hi def Tag91 guifg=#008800  #448844
" hi def Tag92 guifg=#88ff88  #88aa88
" hi def Tag93 guifg=#888800  #888844
" hi def Tag94 guifg=#ffff88  #aaaa88
" hi def Tag95 guifg=#880000  #884444
" hi def Tag96 guifg=#ff8888  #aa8888
" hi def Tag97 guifg=#880088  #884488
" hi def Tag98 guifg=#ff88ff  #aa88aa
" hi def Tag99 guifg=#888888
" hi def Tag9A guifg=#ffffff

syn match vsA0 +󠅠+
syn match vsA1 +󠅡+
syn match vsA2 +󠅢+
syn match vsA3 +󠅣+
syn match vsA4 +󠅤+
syn match vsA5 +󠅥+
syn match vsA6 +󠅦+
syn match vsA7 +󠅧+
syn match vsA8 +󠅨+
syn match vsA9 +󠅩+
syn match vsAA +󠅪+
syn match vsAB +󠅫+
syn match vsAC +󠅬+
syn match vsAD +󠅭+
syn match vsAE +󠅮+
syn match vsAF +󠅯+

hi def vsA0 guisp=#000000 gui=underline
hi def vsA1 guisp=#ff0000 gui=underline
hi def vsA2 guisp=#ff8800 gui=underline
hi def vsA3 guisp=#ffff00 gui=underline
hi def vsA4 guisp=#88ff00 gui=underline
hi def vsA5 guisp=#00ff00 gui=underline
hi def vsA6 guisp=#00ff88 gui=underline
hi def vsA7 guisp=#00ffff gui=underline
hi def vsA8 guisp=#0088ff gui=underline
hi def vsA9 guisp=#0000ff gui=underline
hi def vsAA guisp=#8800ff gui=underline
hi def vsAB guisp=#ff00ff gui=underline
hi def vsAC guisp=#ff0088 gui=underline
hi def vsAD guisp=#ffffff gui=underline
hi def vsAE guisp=#8844ff gui=underline
hi def vsAF guisp=#ff44ff gui=underline


let &cpo = s:cpo_save
unlet s:cpo_save

" vim: nowrap sw=2 sts=2 ts=2 et fdm=marker:


