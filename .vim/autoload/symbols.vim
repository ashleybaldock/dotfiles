if exists("g:mayhem_autoloaded_symbols") || &cp
  finish
endif
let g:mayhem_autoloaded_symbols = 1

"
" See: ../plugin/symbols.vim
"


function symbols#best() abort
   return has("gui_macvim")
         \ ? get(g:mayhem, 'symbols_S',
         \     get(g:mayhem, 'symbols_8',
         \       get(g:mayhem, 'symbols_A', {})))
         \ : has("multi_byte_encoding") && &encoding == "utf-8"
         \   ? get(g:mayhem, 'symbols_8',
         \       get(g:mayhem, 'symbols_A', {}))
         \   : get(g:mayhem, 'symbols_A', {})
endfunc

let s:symbols = symbols#best()

" TODO extend this to allow symbol lookup with list index e.g. for numbers
function symbols#get(symbolpath, fallback = 'X!') abort
  let lookup = split(a:symbolpath, '\.')->reduce(
        \{ acc, val -> get(acc, val, {})}, s:symbols)
  return empty(lookup) ? a:fallback : l:lookup
endfunc


" AddSymbols('diag.numbers.S', ['', '1⃝ ', '2⃝ ', '3⃝ ', '4⃝ ', '5⃝ ', '6⃝ ', '7⃝ ', '8⃝ ', '9⃝ ' ])
" AddSymbols('diag.error.S'  , '⚑⃝ ')
" AddSymbols('diag.warning.S', '!⃝ ')
" AddSymbols('diag.ok.S'     , '✓⃝ ')
" AddSymbols('diag.off.S'    , '?⃣ ')

" AddSymbols('diag.numbers.8', ['', '1⃝ ', '2⃝ ', '3⃝ ', '4⃝ ', '5⃝ ', '6⃝ ', '7⃝ ', '8⃝ ', '9⃝ ' ])
" AddSymbols('diag.error.8'  , '⚑⃝ ')
" AddSymbols('diag.warning.8', '!⃝ ')
" AddSymbols('diag.ok.8'     , '✓⃝ ')
" AddSymbols('diag.off.8'    , '?⃣ ')

" Sym range def 'numbers.double'
"       \ sf=􀔩􀔪􀔫􀔬􀔭􀔮􀔯􀔰􀔱􀔲􀔳􀔴􀔵􀔶􀔷􀔸􀔹􀔺􀔻􀔼􀔽􀔾􀔿􀕀􀕁􀕂􀕃􀕄􀕅􀕆􀕇􀘢􀚽􀚿􀛁􀛃􀛅􀛇􀛉􀛋􀛍􀛏􀛑􀛓􀛕􀛗􀛙􀛛􀛝􀛟􀛡
"       \ u8=
"       \ as=
" Sym range def 'numbers.wide'
"       \ sf=􀃈􀃊􀃌􀃎􀃐􀃒􀑵􀃖􀃘􀑷􀔳􀔴􀔵􀔶􀔷􀔸􀔹􀔺􀔻􀔼􀔽􀔾􀔿􀕀􀕁􀕂􀕃􀕄􀕅􀕆􀕇􀘢􀚽􀚿􀛁􀛃􀛅􀛇􀛉􀛋􀛍􀛏􀛑􀛓􀛕􀛗􀛙􀛛􀛝􀛟􀛡
"       \ u8=0⃝ 1⃝ 2⃝ 3⃝ 4⃝ 5⃝ 6⃝ 7⃝ 8⃝ 9⃝ ⑩ ⑪ ⑫ ⑬ ⑭ ⑮ ⑯ ⑰ ⑱ ⑲ ⑳
"       \ u8=⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ ⑪ ⑫ ⑬ ⑭ ⑮ ⑯ ⑰ ⑱ ⑲ ⑳
"       \ u8=０⒈ ⒉ ⒊ ⒋ ⒌ ⒍ ⒎ ⒏ ⒐ ⒑ ⒒ ⒓ ⒔ ⒕ ⒖ ⒗ ⒘ ⒙ ⒚ ⒛
"       \ u8=〇⑴ ⑵ ⑶ ⑷ ⑸ ⑹ ⑺ ⑻ ⑼ ⑽ ⑾ ⑿ ⒀ ⒁ ⒂ ⒃ ⒄ ⒅ ⒆ ⒇
"       \ as=０１２３４５６７８９
" ['', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
" Sym def diag.error   sf=􀋊️⃝ u8=⚑⃝  as=E   􀋉️⃝  􀋊️⃝ 􀋉⃝   
" Sym def diag.warning sf=􀢒️⃝ u8=!⃝  as=W  􀋍️⃝  􀋎️⃝  􀋍 􀋎⃤︎
" Sym def diag.ok      sf=􀆅️⃝ u8=✓⃝  as=O  􀤔􀤔⃝ 􀤔️⃝ 􀤔︎⃝  􀤕􀤕⃝ 􀤕️⃝ 􀤕︎⃝  
" Sym def diag.off     sf=􀅍️⃝ u8=?⃣  as=X
"
" 􀆅️⃝  􀁢️⃝ 􀋙️⃝ 􀋝️⃝ 􀋚️⃝ 􀋞️⃝
"
" 􁑣️⃝  􀅍️⃝  􀢒️⃝
"
" AddSymbols('warning' '',
" AddSymbols('ok'      'Ø',
" AddSymbols('off'     '¿',

