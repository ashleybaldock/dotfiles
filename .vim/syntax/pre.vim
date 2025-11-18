if exists("b:current_syntax")
  finish
endif

"
" Syntax etc. for 'pre'formatted
" quote blocks in markdown files
"
" au BufWritePost <buffer> syn on
"

let s:cpo_save = &cpo
set cpo&vim
syn match preYes +[✔︎✓☑︎☘︎☺︎]+
syn match preMaybe +[¿‽⸮⁈⁉︎⁇†‡]+
syn match preNo +[✘✖︎✗☒⚑☓☹︎‼︎]+
syn match preBigSquare /[\u23a1-\u23a6]\+/ contains=NONE
syn match preBigCurly /[\u23a7-\u23ad]\+/ contains=NONE
syn match preBigParens /[\u239b-\u23a0]\+/ contains=NONE
syn match preBlocks /[\u2580-\u259f]\+/ contains=NONE
syn match preShapes /[\u25a0-\u25ff]\+/ contains=NONE
syn match preBox /[\u2500-\u257f]\+/ contains=NONE


syn match preEscaped /\%(\\\S[^)\u2500-\u257f \\]*\)\+/
syn region preInSquare
      \ matchgroup=preSquare start=/\[/
      \ end=/\]/ oneline contains=preInSquare,preYes,preNo,preMaybe

" syn match TagsUnknown /[\Ue0000\Ue0002-\Ue001f]/
" syn match TagLang /[\Ue0001]/
" syn match TagCancel /[\Ue007f]/
" syn match TagsUpper /[\Ue0020-\Ue0060\Ue007b-\Ue007e]/
" syn match TagsLower /[\Ue0061-\Ue007a]/

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
hi def vs82 guifg=#ffff00
hi def vs83 guifg=#00ff00
hi def vs84 guifg=#00ffff
hi def vs85 guifg=#0000ff
hi def vs86 guifg=#ff00ff
hi def vs87 guifg=#888888

hi def vs88 guifg=#000000
hi def vs89 guifg=#880000
hi def vs8A guifg=#888800
hi def vs8B guifg=#008800
hi def vs8C guifg=#008888
hi def vs8D guifg=#000088
hi def vs8E guifg=#880088
hi def vs8F guifg=#000000
                  
hi def vs90 guifg=#000000
hi def vs91 guifg=#ff0088
hi def vs92 guifg=#ff8800
hi def vs93 guifg=#88ff00
hi def vs94 guifg=#00ff88
hi def vs95 guifg=#0088ff
hi def vs96 guifg=#8800ff
hi def vs97 guifg=#000000

hi def vs98 guifg=#000000
hi def vs99 guifg=#ff8888
hi def vs9A guifg=#ffff88
hi def vs9B guifg=#88ff88
hi def vs9C guifg=#88ffff
hi def vs9D guifg=#8888ff
hi def vs9E guifg=#ff88ff
hi def vs9F guifg=#ffffff

"hi def Tag80 guifg=#000000
"hi def Tag81 guifg=#0000ff
"  hi def Tag82 guifg=  #4444ff
" hi def Tag82 guifg= #0088ff
"  hi def Tag82 guifg=  #44aaff
"hi def Tag83 guifg=#00ffff
" hi def Tag84 guifg=   #44ff88
" hi def Tag84 guifg= #00ff88
"hi def Tag85 guifg=#00ff00
"  hi def Tag86 guifg=  #44ff44
" hi def Tag86 guifg= #88ff00
"  hi def Tag86 guifg= #88ff44
"  hi def Tag86 guifg=  #aaff44
"hi def Tag87 guifg=#ffff00
"  hi def Tag88 guifg=  #ffaa44
" hi def Tag88 guifg= #ff8800
"  hi def Tag88 guifg=  #ff4444
"hi def Tag89 guifg=#ff0000
" hi def Tag8A guifg= #ff0088
"  hi def Tag8A guifg=  #ff44aa
"hi def Tag8B guifg=#ff00ff
"  hi def Tag8C guifg=  #aa44ff
" hi def Tag8C guifg= #8800ff
"  hi def Tag8C guifg=  #4400ff
"  hi def Tag8C guifg=  #0044ff
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

syn match preEqVar /\%(\_^\|\s\)\@1<=[𝝼𝞶𝝂𝜈ʋ𝛼𝛽𝓍𝓎]\+.\{-}\ze\%(\_$\|\s\)/ contains=NONE
" syn match preEqVar /\%(\_^\|\s\)\@1<=\S\{-}[ᵪᵥₓᘁᘁᵥᕽᴴᵂᶹᑋʰˣʸ]\{-}\ze\%(\_$\|\s\)/ contains=NONE

syn match preArrows /[
      \\u2190-\u21ff
      \\u2798-\u27af
      \\u27b1-\u27be
      \\u27f0-\u27ff
      \\u2900-\u297f
      \\u2b00-\u2b11
      \\u2b30-\u2b4f
      \\u2b5a-\u2b73
      \\u2b80-\u2b94
      \\u2b95]\+/ contains=NONE

let end_l = '◀◀◂◁◃◅'
let end_r = '▶▸►▹▻▷'
let any_s = '╾╼●○◯⦿◉◎■□▩◧◨◩◪◫◰◱◲◳▢▣◍▬▭◑◒◓◔◕◴◵◶◷'
let th_m = '─┈┄╌'
let th_sr = '╴┘┐┤┬┴┼╜╖╢╨╥╫┚┒┨┸┰╂╮╯'
let th_sl = '╶└┌├┬┴┼┖┎┠┸┰╂╙╓╟╨╥╫╰╭'
let th_cr = '┘┐┤┬┴┼╜╖╢╨╥╫┚┒┨┸┰╂╮╯'
let th_cl = '└┌├┬┴┼┖┎┠┸┰╂╙╓╟╨╥╫╰╭'
let wd_m = '━┉┅╍'
let wd_sr = '╸┛┓┫┻┳╋┑┙┥┷┯┿'
let wd_sl = '╺┗┏┣┻┳╋┕┍┝┯┷┿'
let wd_cr = '┛┓┫┻┳╋┑┙┥┷┯┿'
let wd_cl = '┗┏┣┻┳╋┕┍┝┯┷┿'
let db_m = '═'
let db_sr = '╝╗╣╩╦╬╛╕╡╧╤╪'
let db_sl = '╚╔╠╩╦╬╘╒╞╤╧╪'
let db_cr = '╝╗╣╩╦╬╛╕╡╧╤╪'
let db_cl = '╚╔╠╩╦╬╘╒╞╤╧╪'
exec 'syn match preArrows /[' .. end_l .. '][' .. th_m .. ']\+[' .. th_sr .. any_s..  ']\?\Z/ contains=NONE extend'
exec 'syn match preArrows /[' .. any_s .. '][' .. th_m .. ']\+[' .. th_cr ..  ']\Z/ contains=NONE extend'
exec 'syn match preArrows /[' .. end_l .. '][' .. wd_m .. ']\+[' .. wd_sr .. any_s..  ']\?\Z/ contains=NONE extend'
exec 'syn match preArrows /[' .. any_s .. '][' .. wd_m .. ']\+[' .. wd_cr ..  ']\Z/ contains=NONE extend'
exec 'syn match preArrows /[' .. end_l .. '][' .. db_m .. ']\+[' .. db_sr .. any_s..  ']\?\Z/ contains=NONE extend'
exec 'syn match preArrows /[' .. any_s .. '][' .. db_m .. ']\+[' .. db_cr ..  ']\Z/ contains=NONE extend'
exec 'syn match preArrows /[' .. th_sl .. any_s .. ']\?[' .. th_m .. ']\+[' .. end_r .. ']\Z/ contains=NONE extend'
exec 'syn match preArrows /[' .. th_cl .. '][' .. th_m .. ']\+[' .. any_s .. ']\Z/ contains=NONE extend'
exec 'syn match preArrows /[' .. wd_sl .. any_s .. ']\?[' .. wd_m .. ']\+[' .. end_r .. ']\Z/ contains=NONE extend'
exec 'syn match preArrows /[' .. wd_cl .. '][' .. wd_m .. ']\+[' .. any_s .. ']\Z/ contains=NONE extend'
exec 'syn match preArrows /[' .. db_sl .. any_s .. ']\?[' .. db_m .. ']\+[' .. end_r .. ']\Z/ contains=NONE extend'
exec 'syn match preArrows /[' .. db_cl .. '][' .. db_m .. ']\+[' .. any_s .. ']\Z/ contains=NONE extend'
syn match preArrows />\?-\+>/ contains=NONE
syn match preArrows /<-\+<\?/ contains=NONE
syn match preArrows /<-\+>\?/ contains=NONE

syn match preNewline /[⏎⏎️]↩︎/ contains=NONE

hi def preBox       guifg=#eebbee
hi def preBigSquare guifg=#ff9999
hi def preBigCurly  guifg=#00ff99
hi def preBigParens guifg=#9999ff
hi def preShapes    guifg=#99ffbb
hi def preArrows    guifg=#ffff99
hi def preEscaped   guifg=#88eeee
hi def preSquare    guifg=#12cd4d
hi def preInSquare  guifg=#88eead
hi def preYes       guifg=#00ff00
hi def preMaybe     guifg=#ffaa00
hi def preNo        guifg=#ff0000
hi def preNewline   guifg=#ff00ff

hi def preEqVar guifg=#f56cff
hi def Tag81 guifg=#ff00ff

hi def TestInd guifg=#ffaa22

let b:current_syntax = "pre"

let &cpo = s:cpo_save
unlet s:cpo_save


"
" place @ line,col
"
"
"

function! s:TestAddHighlightH3()
call prop_clear(1, line('$'))
silent call prop_type_delete('h3')
silent call prop_type_add('h3', {'highlight':'Delimiter'})
call prop_add(21, 0, {
      \ 'type': 'h3',
      \ 'text': '‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾',
      \ 'text_align': 'below',
      \ 'text_padding_left': 0,
      \ })
call prop_add(21, 0, {
      \ 'type': 'h3',
      \ 'text': '____________________________________________________________',
      \ 'text_align': 'above',
      \ 'text_padding_left': 0,
      \ })
endfunc

      " \ 'text': '‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾',
      " \ 'text': '⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺',
      " \ 'text': '⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻',
      " \ 'text': '⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼',
      " \ 'text': '⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽',
      " \ 'text': '____________________________________________________________',
      " \ 'text': '▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔',
      " \ 'text': '▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀',
      " \ 'text': '████████████████████████████████████████████████████████████',
      " \ 'text': '▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇',
      " \ 'text': '▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆▆',
      " \ 'text': '▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅',
      " \ 'text': '▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄',
      " \ 'text': '▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃',
      " \ 'text': '▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂',
      " \ 'text': '▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁',
      " \ 'text': '▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬',
      "
      " \ 'text': '▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰',
      " \ 'text': '╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍',
      " \ 'text': '┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅',
      " \ 'text': '┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉',
      "
      " \ 'text': '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
