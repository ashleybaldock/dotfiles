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

syn match Tag80 +󠄿+
syn match Tag80 +󠄿+
syn match Tag81 +󠅀+
syn match Tag82 +󠅁+
syn match Tag83 +󠅂+
syn match Tag84 +󠅃+
syn match Tag85 +󠅄+
syn match Tag86 +󠅅+
syn match Tag87 +󠅆+
syn match Tag88 +󠅇+
syn match Tag89 +󠅈+
syn match Tag8A +󠅈+
syn match Tag8B +󠅉+
syn match Tag8C +󠅊+
syn match Tag8D +󠅋+
syn match Tag8E +󠅋+
syn match Tag8F +󠅏+

syn match Tag91 ++
syn match Tag92 ++
syn match Tag93 ++
syn match Tag94 ++
syn match Tag95 ++
syn match Tag96 ++
syn match Tag97 ++
syn match Tag98 ++
syn match Tag99 ++
syn match Tag9A ++
syn match Tag9B ++
syn match Tag9C ++
syn match Tag9D ++
syn match Tag9E ++
syn match Tag9F ++

hi def Tag80 guifg=#000000
hi def Tag81 guifg=#ff0000
hi def Tag82 guifg=#ffff00
hi def Tag83 guifg=#00ff00
hi def Tag84 guifg=#00ffff
hi def Tag85 guifg=#0000ff
hi def Tag86 guifg=#ff00ff
hi def Tag87 guifg=#888888
hi def Tag88 guifg=#880000
hi def Tag89 guifg=#888800
hi def Tag8A guifg=#008800
hi def Tag8B guifg=#008888
hi def Tag8C guifg=#000088
hi def Tag8D guifg=#880088
hi def Tag8E guifg=#ff8888
hi def Tag8F guifg=#ffff88

hi def Tag90 guifg=#88ff88
hi def Tag91 guifg=#8888ff
hi def Tag92 guifg=#88ffff
hi def Tag93 guifg=#ff88ff
hi def Tag94 guifg=#ff0088
hi def Tag95 guifg=#ff8800
hi def Tag96 guifg=#88ff00
hi def Tag97 guifg=#00ff88
hi def Tag98 guifg=#0088ff
hi def Tag99 guifg=#8800ff
hi def Tag9A guifg=#ffffff

" hi def Tag80 guifg=#000000
" hi def Tag81 guifg=#0000ff
" hi def Tag82 guifg=#0088ff
" hi def Tag83 guifg=#00ffff
" hi def Tag84 guifg=#00ff88
" hi def Tag85 guifg=#00ff00
" hi def Tag86 guifg=#88ff00
" hi def Tag87 guifg=#ffff00
" hi def Tag88 guifg=#ff8800
" hi def Tag89 guifg=#ff0000
" hi def Tag8A guifg=#ff0088
" hi def Tag8B guifg=#ff00ff
" hi def Tag8C guifg=#8800ff
" hi def Tag8D guifg=#000088
" hi def Tag8E guifg=#8888ff
" hi def Tag8F guifg=#008888
" hi def Tag90 guifg=#88ffff
" hi def Tag91 guifg=#008800
" hi def Tag92 guifg=#88ff88
" hi def Tag93 guifg=#888800
" hi def Tag94 guifg=#ffff88
" hi def Tag95 guifg=#880000
" hi def Tag96 guifg=#ff8888
" hi def Tag97 guifg=#880088
" hi def Tag98 guifg=#ff88ff
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
