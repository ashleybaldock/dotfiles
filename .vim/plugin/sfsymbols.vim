if exists("g:mayhem_loaded_sfsymbols")
  finish
endif
let g:mayhem_loaded_sfsymbols = 1

" Set all SF Symbol codepoints to be 2 chars wide
" (the majority of them are at least that wide)
call setcellwidths([[0x100000, 0x103fff, 2]])
" These could be exceptions
" '􀟖􀟕􁊘a􁊙􀑪􀆊􀯻􀆉􀯶􂦬􀆒􀆓􂉏􀖄􂉐􀅍􀅎􀅓􀅔􀅕􀮷􀫌􁷁􀳾􂡩􀑹􁍂􁍅􀅖􀨡􀵷􀵿􀅏􀥋􁣣􀘽􁣦􀅳􀒆􁹡􀆏􀠑􀠒􂬮􂬮􁏃􀇬􁏄􁗅􀝢􀝌􀞋􂃵􀎪􀎠􀎡􀖈􀖉'
" call setcellwidths([[char2nr('􀑹'),char2nr('􀑹'),1]]);
"
" if charclass(cs) == 3 
    " setline(lnum, '0x' .. printf("%06x", c) .. ' ' .. charclass(cs) .. ' ' .. strwidth(cs) .. ' |' .. cs .. '| ' )

" This is derived from $VIMRUNTIME/tools/emoji_list.vim
" Uses a compiled Vim9 function for speed
def GenSymbols()
  setline(1, '╔════════════════╗')
	setline(2, '║   SF Symbols   ║')
  setline(3, '╚════════════════╝')
  setline(4, 'codepoint  w  ⎣12⎦')
  setline(5, '╶╴╶╴╶╴╶╴╶╴╶╴╶╴⎟╶╴⎜')
  var lnum = 6
  for c in range(0x100000, 0x102fff)
    var cs = nr2char(c)
    setline(lnum, printf("0x%02x⏐%02x%02x  %d  ⎟%s⎜", and(c, 0xff0000) >> 16, and(c, 0xff00) >> 8, and(c, 0xff), strwidth(cs), cs))
    lnum += 1
  endfor
enddef

function! s:Symbols()
	vsplit
 	enew
  call GenSymbols()
  set nomodified
  set colorcolumn=
endfunc

command! Symbols call <SID>Symbols()

