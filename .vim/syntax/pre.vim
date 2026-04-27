if exists("b:current_syntax")
  finish
endif

"
" Highlighting for 'pre'formatted plain text
"  (diagrams, tables etc.)
"
" :au BufWritePost <buffer> syn on
"

source <script>:p:h/vsel.vim

let s:cpo_save = &cpo
set cpo&vim

syn match preYes +[✔︎✓☑︎☘︎☺︎]+ display contains=NONE
syn match preMaybe +[¿‽⸮⁈⁉︎⁇†‡]+ display contains=NONE
syn match preNo +[✘✖︎✗☒⚑☓☹︎‼︎]+ display contains=NONE
syn match preBigSquare /[\u23a1-\u23a6]/ display contains=NONE
syn match preBigCurly /[\u23a7-\u23ad]/ display contains=NONE
syn match preBigParens /[\u239b-\u23a0]/ display contains=NONE
syn match preBlocks /[\u2580-\u259f]/ display contains=NONE
syn match preShapes /[\u25a0-\u25ff]/ display contains=NONE
syn match preBox /[\u2500-\u257f]/ display contains=NONE


syn match preEscaped /\%(\\\S[^)\u2500-\u257f \\]*\)\+/ display contains=NONE
syn region preInSquare oneline
      \ matchgroup=preSquare start=/\[/
      \ end=/\]/ contains=preInSquare,preYes,preNo,preMaybe

" syn match TagsUnknown /[\Ue0000\Ue0002-\Ue001f]/ display contains=NONE
" syn match TagLang /[\Ue0001]/ display contains=NONE
" syn match TagCancel /[\Ue007f]/ display contains=NONE
" syn match TagsUpper /[\Ue0020-\Ue0060\Ue007b-\Ue007e]/ display contains=NONE
" syn match TagsLower /[\Ue0061-\Ue007a]/ display contains=NONE


syn match preMathOp /[\u2200-\u22ff]/ display contains=NONE
syn match preMathMiscA /[\u27c0-\u27ef]/ display contains=NONE
syn match preMathMiscB /[\u2980-\u29ff]/ display contains=NONE
syn match preMathSupOp /[\u2980-\u29ff]/ display contains=NONE
syn match preEqVar /\%(\_^\|\s\)\@1<=[𝝼𝞶𝝂𝜈ʋ𝛼𝛽𝓍𝓎]\+.\{-}\ze\%(\_$\|\s\)/ display contains=NONE
syn match preVulFrac /[\u2150-\u215f]/ display contains=NONE
syn match preRomanUC /[\u2160-\u216f]/ display contains=NONE
syn match preRomanLC /[\u2170-\u217f]/ display contains=NONE
" syn match preEqVar /\%(\_^\|\s\)\@1<=\S\{-}[ᵪᵥₓᘁᘁᵥᕽᴴᵂᶹᑋʰˣʸ]\{-}\ze\%(\_$\|\s\)/ contains=NONE

syn match preArrows /[\u2190-\u21ff]/ display contains=NONE
syn match preArrowsSupA /[\u27f0-\u27ff]/ display contains=NONE
syn match preArrowsSupB /[\u2900-\u297f]/ display contains=NONE

syn match preArrows /[
      \\u2798-\u27af
      \\u27b1-\u27be
      \\u2900-\u297f
      \\u2b00-\u2b11
      \\u2b30-\u2b4f
      \\u2b5a-\u2b73
      \\u2b80-\u2b94
      \\u2b95]\+/ display contains=NONE

let s:end_l = '◀◀◂◁◃◅'
let s:end_r = '▶▸►▹▻▷'
let s:any_s = '╾╼●○◯⦿◉◎■□▩◧◨◩◪◫◰◱◲◳▢▣◍▬▭◑◒◓◔◕◴◵◶◷'
let s:th_m = '─┈┄╌'
let s:th_sr = '╴┘┐┤┬┴┼╜╖╢╨╥╫┚┒┨┸┰╂╮╯'
let s:th_sl = '╶└┌├┬┴┼┖┎┠┸┰╂╙╓╟╨╥╫╰╭'
let s:th_cr = '┘┐┤┬┴┼╜╖╢╨╥╫┚┒┨┸┰╂╮╯'
let s:th_cl = '└┌├┬┴┼┖┎┠┸┰╂╙╓╟╨╥╫╰╭'
let s:wd_m = '━┉┅╍'
let s:wd_sr = '╸┛┓┫┻┳╋┑┙┥┷┯┿'
let s:wd_sl = '╺┗┏┣┻┳╋┕┍┝┯┷┿'
let s:wd_cr = '┛┓┫┻┳╋┑┙┥┷┯┿'
let s:wd_cl = '┗┏┣┻┳╋┕┍┝┯┷┿'
let s:db_m = '═'
let s:db_sr = '╝╗╣╩╦╬╛╕╡╧╤╪'
let s:db_sl = '╚╔╠╩╦╬╘╒╞╤╧╪'
let s:db_cr = '╝╗╣╩╦╬╛╕╡╧╤╪'
let s:db_cl = '╚╔╠╩╦╬╘╒╞╤╧╪'
let s:prefix = 'syn match preMultiArrows'
let s:suffix = 'display contains=NONE extend'
" ◀─╯◁─╯  ◀─╯◂─╯◃─╯◅─╯◀─╯ ◀─●
exec s:prefix '/[' .. s:end_l .. '][' .. s:th_m .. ']\+[' .. s:th_sr .. s:any_s .. ']\?\Z/' s:suffix
" ◀━┛◀━┛◀━┛◂━┛◁━┛◃━┛◅━┛ ◀━●
exec s:prefix '/[' .. s:end_l .. '][' .. s:wd_m .. ']\+[' .. s:wd_sr .. s:any_s .. ']\?\Z/' s:suffix
" ◀═╝ ◀═●
exec s:prefix '/[' .. s:end_l .. '][' .. s:db_m .. ']\+[' .. s:db_sr .. s:any_s .. ']\?\Z/' s:suffix
" ●️─︎╮ ╾  ╼─︎⦿─︎◉─︎◎─︎■─︎□─︎▩─︎◧─︎◨─︎◩─︎◪─︎◫─︎◰─︎◱─︎◲─︎◳─︎▢─︎▣─︎◍─︎▬─︎▭─︎◑─︎◒─︎◓─︎◔─︎◕─︎◴─︎◵─︎◶─︎◷  
" ╾️╼️●️─︎○️─︎ ─︎⦿️─︎    ■️─︎□️─︎  ◧️─︎◨️─︎◩️─︎◪️─︎◫️─︎◰️─︎◱️─︎◲️─︎◳️─︎▢️ ▣️─︎◍️─︎▬️─︎▭️─︎◑️─︎◒️─︎◓️─︎◔️─︎◕️─︎◴️─︎◵️─︎─︎◶️─︎◷️
exec s:prefix '/[' .. s:any_s .. '][' .. s:th_m .. ']\+[' .. s:th_cr .. ']\Z/' s:suffix
" ●️━┓
exec s:prefix '/[' .. s:any_s .. '][' .. s:wd_m .. ']\+[' .. s:wd_cr .. ']\Z/' s:suffix
" ●️═╗
exec s:prefix '/[' .. s:any_s .. '][' .. s:db_m .. ']\+[' .. s:db_cr .. ']\Z/' s:suffix
exec s:prefix '/[' .. s:th_sl .. s:any_s .. ']\?[' .. s:th_m .. ']\+[' .. s:end_r .. ']\Z/' s:suffix
exec s:prefix '/[' .. s:th_cl .. '][' .. s:th_m .. ']\+[' .. s:any_s .. ']\Z/' s:suffix
exec s:prefix '/[' .. s:wd_sl .. s:any_s .. ']\?[' .. s:wd_m .. ']\+[' .. s:end_r .. ']\Z/' s:suffix
exec s:prefix '/[' .. s:wd_cl .. '][' .. s:wd_m .. ']\+[' .. s:any_s .. ']\Z/' s:suffix
exec s:prefix '/[' .. s:db_sl .. s:any_s .. ']\?[' .. s:db_m .. ']\+[' .. s:end_r .. ']\Z/' s:suffix
exec s:prefix '/[' .. s:db_cl .. '][' .. s:db_m .. ']\+[' .. s:any_s .. ']\Z/' s:suffix
syn match preAsciiArrows />\?-\+>/ display contains=NONE
syn match preAsciiArrows /<-\+<\?/ display contains=NONE
syn match preAsciiArrows /<-\+>\?/ display contains=NONE

syn match preNewline /[⏎↩]/ display contains=NONE

hi def preBox       guifg=#ffccff
hi def preBigSquare guifg=#ffbbbb
hi def preBigCurly  guifg=#00ff88
hi def preBigParens guifg=#bbbbff
hi def preShapes    guifg=#99ff99
hi def preArrows    guifg=#ffff88
hi def preEscaped   guifg=#88eeee
hi def preSquare    guifg=#12cd4d
hi def preInSquare  guifg=#88eead
hi def preYes       guifg=#00ff00
hi def preMaybe     guifg=#ffaa00
hi def preNo        guifg=#ff0000
hi def preNewline   guifg=#ff00ff

hi def preEqVar     guifg=#f56cff

hi def TestInd      guifg=#ffaa22

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
