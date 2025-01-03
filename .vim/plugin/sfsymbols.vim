if exists("g:mayhem_loaded_sfsymbols")
  finish
endif
let g:mayhem_loaded_sfsymbols = 1

let s:sfrange_start = 0x100000
let s:sfrange_end   = 0x103fff

" Set all SF Symbol codepoints to be 2 chars wide
" (the majority of them are at least that wide)
call setcellwidths([[s:sfrange_start, s:sfrange_end, 2]])
" These could be exceptions?
" '􀟖􀟕􁊘a􁊙􀑪􀆊􀯻􀆉􀯶􂦬􀆒􀆓􂉏􀖄􂉐􀅍􀅎􀅓􀅔􀅕􀮷􀫌􁷁'
" ' 􀳾􂡩􀑹􁍂􁍅􀅖􀨡􀵷􀵿􀅏􀥋􁣣􀘽􁣦􀅳􀒆􁹡􀆏􀠑􀠒􂬮􂬮􁏃􀇬􁏄􁗅􀝢􀝌􀞋􂃵􀎪􀎠􀎡􀖈􀖉'
" This has to be done as non-overlapping parts of the sequence, bit tedious
" call setcellwidths([[char2nr('􀑹'),char2nr('􀑹'),1]]);
" call setcellwidths([[char2nr('﹪'),char2nr('﹪'),1]]);
"﹪
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
  for c in range(s:sfrange_start, s:sfrange_end)
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

"
" TODO remove hardcoding and set via range vars
"
function! IsSfSymbol(arg)
  let char = NormalisedChar(a:arg)

  return char =~# '^[\U00100000-\U00103fff]'
endfunc

"
" Info about SF symbol in arg, or under cursor
"
function! GetSfSymbolInfo(arg)
  let char = NormalisedChar(a:arg)

  let nr = char2nr(char)
  let chnr = nr2char(nr)
  return {'symbol': chnr, 'code': printf('U+%04X', nr), 'name': sfsymbols#getSymbolName(chnr) }
endfunc

"
" In statusline
"
function! EchoSymbolInfo(arg)
  let info = GetSfSymbolInfo(a:arg)
  return '╱╱ '..chnr..' ╱ '..printf('U+%04X', nr)..' ╱ '..sfsymbols#getSymbolName(chnr)..' ╱'
endfunc

command! -bar -nargs=? SymbolInfo echo EchoSymbolInfo(<q-args>)

"
" First bit of what Characterize does
function! NormalisedChar(arg) abort
  let char = a:arg
  let nl_is_null = 0
  if empty(char)
    let char = getline('.')[col('.')-1:-1]
    let nl_is_null = 1
  elseif char =~# '^\\[xuU]\=0\+\x\@!'
    let char = "\n"
    let nl_is_null = 1
  elseif char =~# '^\\.'
    try
      let char = eval('"' . char . '"')
    catch
    endtry
  endif
  let char = matchstr(char, '.')
  if empty(char)
    return 'NUL'
  endif

  return char
endfunc
