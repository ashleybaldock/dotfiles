vim9script
if exists("g:mayhem_loaded_sfsymbols")
  finish
endif
g:mayhem_loaded_sfsymbols = 1

# Scope: Script
var sfrange_start = 0x100000
var sfrange_end   = 0x103fff

# Set all SF Symbol codepoints to be 2 chars wide
# (the majority of them are at least that wide)
setcellwidths([[sfrange_start, sfrange_end, 2]])

# TODO
# This has to be done as non-overlapping parts of the sequence, bit tedious
# call setcellwidths([[char2nr('􀑹'),char2nr('􀑹'),1]]);
# call setcellwidths([[char2nr('﹪'),char2nr('﹪'),1]]);
#﹪
# if charclass(cs) == 3
#     setline(lnum, '0x' .. printf("%06x", c) .. ' ' .. charclass(cs) .. ' ' .. strwidth(cs) .. ' |' .. cs .. '| ' )

# This is derived from $VIMRUNTIME/tools/emoji_list.vim
# Uses a compiled Vim9 function for speed
def GenSymbols()
  setline(1, '═︎═︎═︎════════════════')
  setline(2, '    SF Symbols     ')
  setline(3, '═︎═︎═︎════════════════')
  var lnum = 4
  for c in range(sfrange_start, sfrange_end)
    var cs = nr2char(c)
    setline(lnum,
            printf("⏐%d⏐  %s  ⏐0x%02x%02x%02x⏐",
            strwidth(cs), cs,
            and(c, 0xff0000) >> 16,
            and(c, 0xff00) >> 8,
            and(c, 0xff)
            ))
    lnum += 1
  endfor
enddef

def SymbolsSplit()
  :19vsplit
  setlocal winfixwidth winwidth=19 nowrap
  enew
  GenSymbols()
  set nomodified nomodifiable
  setlocal colorcolumn=5,8
enddef

command! SymbolCodepoints call SymbolsSplit()

#
# Simple codepoint range check
#
def g:IsSfSymbol(arg: string): bool
  var char = NormalisedChar(arg)

  return char =~# '^[\U00100000-\U00103fff]'
enddef

class SfSymbolInfo
  var isSfSymbol: bool
  var codepoint: number
  var symbol: string
  var code: string
  var name: string

  def new(this.codepoint, this.symbol, this.code, this.name)
  enddef
endclass

#
# Info about SF symbol in arg, or under cursor
#
def GetSfSymbolInfo(arg: string): SfSymbolInfo
  var char = NormalisedChar(arg)

  var nr = char2nr(char)
  var chnr = nr2char(nr)
  return SfSymbolInfo.new(nr, chnr, printf('U+%04X', nr), sfsymbols#getSymbolName(chnr))
enddef

#
# In statusline
#
def EchoSymbolInfo(arg: string): string
  var info = GetSfSymbolInfo(arg)
  return $'╱╱ {info.symbol} ╱ {info.code} ╱ {info.name} ╱'
enddef

command! -bar -nargs=? SfSymbolInfo echo EchoSymbolInfo(<q-args>)

#
# First bit of what Characterize does
def NormalisedChar(arg: string): string
  var char = arg
  var nl_is_null = 0
  if empty(char)
    char = getline('.')[col('.') - 1 : -1]
    nl_is_null = 1
  elseif char =~# '^\\[xuU]\=0\+\x\@!'
    char = "\n"
    nl_is_null = 1
  elseif char =~# '^\\.'
    try
      char = eval('"' .. char .. '"')
    catch
    endtry
  endif
  char = matchstr(char, '.')
  if empty(char)
    return 'NUL'
  endif

  return char
enddef


defcompile



# These could be exceptions?
#
# 􀟖􀟕􁊘a􁊙􀑪􀆊􀯻􀆉􀯶􂦬􀆒􀆓
#
# 􂉏􀖄􂉐􀅍􀅎􀅓􀅔􀅕􀮷􀫌􁷁
#
# 􀳾􂡩􀑹􁍂􁍅􀅖􀨡􀵷􀵿􀅏􀥋􁣣
#
# 􀘽􁣦􀅳􀒆􁹡􀆏􀠑􀠒􂬮􂬮􁏃􀇬
#
# 􁏄􁗅􀝢􀝌􀞋􂃵􀎪􀎠􀎡􀖈􀖉
#
