"
" Syntax rules for variation selector highlighting
"
" :au BufWritePost <buffer> syn on
"
" Related:       ./pre.vim
"          ../demo/pre.md
"                ./markdown.vim
"        ../plugin/char.vim
"      ../autoload/char.vim
"      ../autoload/charinfo.vim
"

let s:cpo_save = &cpo
set cpo&vim

" Match each of the extended set of variation selectors
for n in range(17, 255)
  exec printf("syn match vs%d +%s+", n, nr2char(n - 17 + 0xE0100))
endfor

" exec range(17,255)
"       \->map({i, n -> printf("vs%d 𐔃%s", n, nr2char(n + 0xE0100))})
"       \->join(' , ')
" ExecAndPut echo range(17,255)->map({_, n -> printf("%4d 𐔃%s%s", n, nr2char(n - 17 + 0xE0100), (n % 10 == 0) ? "\n" : '')})->join('')

hi vs80 guifg=#000000
hi vs81 guifg=#ff0000
"hi vs81 guifg=#ff0000
hi vs82 guifg=#ff8800
hi vs83 guifg=#ffff00
"hi vs83 guifg=#868600
hi vs84 guifg=#88ff00
hi vs85 guifg=#00ff00
"hi vs85 guifg=#00cb00
hi vs86 guifg=#00ff88
hi vs87 guifg=#00ffff
"hi vs87 guifg=#00abab
hi vs88 guifg=#0088ff
hi vs89 guifg=#0000ff
"hi vs89 guifg=#0000ff
hi vs90 guifg=#8800ff
hi vs91 guifg=#ff00ff
"hi vs91 guifg=#ff00ff
hi vs92 guifg=#ff0088
hi vs93 guifg=#ffffff

"
hi vs180 guifg=#222222
hi vs181 guifg=#880000
hi vs183 guifg=#808000
hi vs184 guifg=#008800
hi vs185 guifg=#008888
hi vs186 guifg=#000088
hi vs188 guifg=#880088
hi vs189 guifg=#777777

hi vs191 guifg=#ff0088
hi vs192 guifg=#ff8800
hi vs193 guifg=#ffff44
hi vs194 guifg=#88ff44
hi vs195 guifg=#44ffff
hi vs196 guifg=#0088ff
hi vs197 guifg=#8844ff
hi vs198 guifg=#ff44ff

hi vs211 guifg=#ff6688  guibg=#ff88aa
hi vs212 guifg=#ff8866  guibg=#ffaa88
hi vs213 guifg=#ffff88  guibg=#ffffaa
hi vs214 guifg=#88ff88  guibg=#b9ffb9
hi vs215 guifg=#88ffff  guibg=#bbffff
hi vs216 guifg=#6688ff  guibg=#88aaff
hi vs217 guifg=#8866ff  guibg=#aa88ff
hi vs218 guifg=#ff88ff  guibg=#ffaaff

hi def vs100 guisp=#000000 gui=underline

hi def vs101 guisp=#ff0000 gui=underline
hi def vs102 guisp=#ff8800 gui=underline
hi def vs103 guisp=#ffff00 gui=underline
hi def vs104 guisp=#88ff00 gui=underline
hi def vs105 guisp=#00ff00 gui=underline
hi def vs106 guisp=#00ff88 gui=underline
hi def vs107 guisp=#00ffff gui=underline
hi def vs108 guisp=#0088ff gui=underline
hi def vs109 guisp=#0000ff gui=underline
hi def vs110 guisp=#8800ff gui=underline

hi def vs111 guisp=#ff00ff gui=underline
hi def vs112 guisp=#ff0088 gui=underline
hi def vs113 guisp=#ffffff gui=underline
hi def vs114 guisp=#8844ff gui=underline
hi def vs115 guisp=#ff44ff gui=underline

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


let &cpo = s:cpo_save
unlet s:cpo_save

" vim: nowrap sw=2 sts=2 ts=2 et fdm=marker:


