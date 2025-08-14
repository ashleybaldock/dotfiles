vim9script
if exists("g:mayhem_loaded_sfsymbols")
  finish
endif
g:mayhem_loaded_sfsymbols = 1

#
# See Also:
#   ../autoload/sfsymbols.vim
#   ../notes/sf-symbols.createlist.md
#   ../demo/
#
#

# Scope: Script
var sfrange_start = 0x100000
var sfrange_end   = 0x103fff
var sfrange_valid = printf('[U%08X-U%08X]', sfrange_start, sfrange_end)

# Set all SF Symbol codepoints to be 2 chars wide
# (the majority of them are at least that wide)
setcellwidths([[sfrange_start, sfrange_end, 2]])

# TODO
# This has to be done as non-overlapping parts of the sequence, bit tedious
# call setcellwidths([[char2nr('􀑹'),char2nr('􀑹'),1]]);
# call setcellwidths([[char2nr('﹪'),char2nr('﹪'),1]]);
#﹪
# if charclass(cs) == 3
#     setline(lnum, '0x' .. printf("%06x", c) .. ' '
#     \ .. charclass(cs) .. ' ' .. strwidth(cs) .. ' |' .. cs .. '| ' )

#
# This is derived from $VIMRUNTIME/tools/emoji_list.vim
# Uses a compiled Vim9 function for speed
#
def GenerateSfSymbolsListing(circled = v:false)
  setline(1, '══︎═︎═══════════════')
  setline(2, circled ?
        \    '  􀣺️⃝  SF Symbols  ' :
        \    '  􀣺  SF Symbols  ')
  setline(3, '══︎═︎═══════════════')
  var lnum = 4
  var modifier = circled ?  '️⃝' : ''
  for c in range(sfrange_start, sfrange_end)
    var cs = nr2char(c) .. modifier
    setline(lnum,
          \ printf("  %s  ⏐%d⏐0x%02x%02x%02x",
          \ cs,
          \ strwidth(cs),
          \ and(c, 0xff0000) >> 16,
          \ and(c, 0xff00) >> 8,
          \ and(c, 0xff)
          \ ))
    lnum += 1
  endfor
enddef

def SymbolsSplit(circled = v:false)
  :19vnew
  setlocal winfixwidth winwidth=19 nowrap
  setlocal colorcolumn=5,8
  setlocal modifiable
  GenerateSfSymbolsListing(circled)
  set nomodified nomodifiable
enddef

command! -bar SfSymbolSplit call SymbolsSplit()
command! -bar SfCircledSymbolSplit call SymbolsSplit(v:true)

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
  # char = matchstr(char, '.')
  if empty(char)
    return 'NUL'
  endif

  return char
enddef

#
# Simple codepoint range check
#
# def g:IsSfSymbol(arg: string): bool
#   var char = NormalisedChar(arg)
#   var codepoint = char2nr(char)
#   echo 'char "' char .. '": ' .. printf('U+%04X', codepoint)

#   return codepoint >= sfrange_start && codepoint <= sfrange_end
# enddef

# SF icons can be suffixed with one of:
# :monochrome|:hierarchical|:palette|:multicolor
# and optionally:
# :variable-0|variable-0.1|variable .. -1]
export class SfSymbol
  # constants
  static const range_start: number = 0x100000
  static const range_end: number   = 0x103fff
  static const match_valid_range: string = printf('[U%08X-U%08X]', sfrange_start, sfrange_end)

  static const suffixes: list<string> = ['monochrome', 'hierarchical', 'palette', 'color']
  static const default_suffix: string = 'monochrome'

  # variables
  var codepoint: number = 0
  var suffix: string = 'monochrome'
  var variable: float = 1.0

  # constructors
  def new(this.codepoint, this.suffix, this.variable)
  enddef

  def newFromString(chars: string)
    this.codepoint = char2nr(NormalisedChar(chars))
  enddef

  def newFromCodepoint(codepoint: number)
    this.codepoint = codepoint
  enddef

  def newFromSymbolName(name: string)
    this.codepoint = char2nr(sfsymbols#fuzzyMatchSymbol(name).symbol)
  enddef

  # static methods
  #
  # Simple codepoint range check
  static def Validate(chars: string): bool
    var codepoint = NormalisedChar(chars)->char2nr()

    return codepoint >= SfSymbol.range_start && codepoint <= SfSymbol.range_end
  enddef

  # setters (chainable)
  def SetSuffix(sfx: string): SfSymbol
    this.suffix = sfx
    return this
  enddef

  def SetVariable(variable: float): SfSymbol
    this.variable = variable
    return this
  enddef

  # getters
  def GetId(): string
    return sfsymbols#getSymbolName(nr2char(this.codepoint))
  enddef

  def GetChar(): string
    return nr2char(this.codepoint)
  enddef

  def GetHex(): string
    return printf('U+%04X', this.codepoint)
  enddef

  # return suffix info, includes leading ':'
  def GetSuffix(): string
    if this.suffix != SfSymbol.default_suffix
      if this.variable < 1
        return $':variable-{printf('%1.1f', this.variable)}:{this.suffix}'
      else
        return $':{this.suffix}'
      endif
    endif
    return ''
  enddef

  # returns string suitable for use in 'amenu' type commands
  def GetIcon(): string
    return $'icon={this.GetId()}{this.GetSuffix()}'
  enddef

  def IsValid(): bool
    return SfSymbol.Validate(this.GetChar())
  enddef

  #
  # Format for Echo-ing
  #
  def ToEchoString(): string
    return $'╱╱ {this.GetChar()} ╱ {this.codepoint} ╱ {this.GetId()} ╱'
  enddef

  def empty(): bool
    return this.IsValid() ? 1 : 0
  enddef

  # TODO: This could be 1 if some symbols are set to be half-width
  def len(): number
    return this.IsValid() ? 2 : 0
  enddef
  
  def string(): string
    if this.IsValid() 
      return $'<{this.GetChar()}>, {this.GetHex()}, {this.GetId()}'
    else
      return $'<{this.GetChar()}>, Not in SF Symbols range'
    endif
  enddef
endclass

#
# Info about SF symbol in arg, or under cursor
#
def g:GetSfSymbolInfo(arg: string): SfSymbol
  return SfSymbol.newFromString(arg)
enddef

#
# Get SfSymbol id for first char in arg
#
def g:SfId(arg: string): string
  return SfSymbol.newFromString(arg).GetId()
enddef

#
# Return icon id formatted for use with a(nore)menu
# e.g. 'icon=hourglass:variable-0.4:monochrome'
#
def g:SfIcon(symbol: string = '', suffix: string = 'monochrome', variable: float = 1.0): string
  return symbol == '' ? 'icon=$VIMHOME/bitmaps/blank24.png' : SfSymbol.newFromString(symbol).SetSuffix(suffix).SetVariable(variable).GetIcon()
enddef

command! -bar -nargs=? SfSymbol echo g:EchoSymbolInfo(<args>)


defcompile

