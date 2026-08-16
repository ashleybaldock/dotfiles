if exists("g:mayhem_autoloaded_unicode") || &cp
  finish
endif
let g:mayhem_autoloaded_unicode = 1

"
" See: ../plugin/unicode.vim
"

function! unicode#myNewFunction(...) abort
"
" List of characters in a range
"  from: number/string, codepoint at start of range
"         (strings are parsed using str2nr())
"  count: optional, number/string, count of characters to generate
"          defaults to from + 16
"         (strings are parsed using str2nr())
"
function unicode#pointsInRange(
      \ start,
      \ count = 16) abort
  let l:startidx = type(a:start) == type(0) ? a:start : str2nr(a:start)
  let l:count = type(a:count) == type(0) ? a:count : str2nr(a:count)

  return range(l:startidx, l:startidx + l:count - 1)->map({ _, val -> nr2char(val)})
endfunc
"
" List of characters with codepoints between
" the two characters given as arguments
" fromchar: optional, string (only first character is used),
"            defaults to char under cursor
" tochar: optional, string (only first character is used),
"            defaults to fromchar codepoint + 16
"
function unicode#pointsBetweenChars(
      \ fromchar = char#fromCursor(),
      \ tochar = nr2char(char2nr(a:fromchar) + 16)
      \) abort
  let fromidx = char2nr(a:fromchar)
  let toidx = char2nr(a:tochar)
  let min = min([fromidx, toidx])
  let max = max([fromidx, toidx])

  return unicode#pointsInRange(l:min, l:max - l:min + 1)
endfunc


function unicode#pointsStartingFromChar(
      \ fromchar = char#fromCursor(),
      \ count = 16) abort
  let fromidx = char2nr(a:fromchar)
  return unicode#pointsInRange(fromidx, a:count)
endfunc

"
" Format list of codepoints for display
" a:1  List of codepoints
" a:2  Base for combining characters (default: ◌ (g:mayhem_unicode_combine_default))
" a:3  Separator (default ' ') 
" Gives standalone combining characters something to combine with
"
function unicode#pointsToString(codepoints, combiningbase = s:combase, sep = ' ')
  return mapnew(a:codepoints, {idx, val -> char#display(val, a:combiningbase)})
        \->join(a:sep)
endfunc

"
" Return a string with all chars with codepoints in range
"  defined by a codepoint and a count
" arg1: count (defaults to 16)
" arg2: numeric codepoint (start of range)
" a:1  start (defaults to cursor char)
" a:2  count (defaults to 16)
"
function unicode#pointsCountFromIndex(from, count = 16) abort
  return unicode#pointsToString(unicode#pointsInRange(a:from, a:count))
endfunc

"
" Print character and N-1 codepoints after it
" a:1  start (defaults to cursor char)
" a:2  count (defaults to 16)
"
function unicode#pointsCountFromChar(
      \ from = char#fromCursor(), count = 16) abort
  return unicode#pointsToString(unicode#pointsStartingFromChar(a:from, a:count))
endfunc

"
" Print character and N codepoints before/after it
" a:1  start (defaults to cursor char)
" a:2  count (defaults to 8)
"
function unicode#pointsAroundChar(
      \ around = char#fromCursor(), count = 8) abort
  return unicode#pointsToString(unicode#pointsInRange(max([1, char2nr(a:around) - a:count]), a:count * 2 + 1))
endfunc

"
" Return a string containing all chars with codepoints between
"  the two characters specified (inclusive)
" Print codepoints between two characters
"
" a:1  one end of range (defaults to cursor char)
" a:2  other end of range (defaults to codepoint of a:1 + 16)
"  (The order of the ends doesn't matter, but the output is
"   always in ascending codepoint order)
"
" '<,'>s/^\(. .\).*$/\=ExecAndReturn("UnicodepointsBetween " .. submatch(1))/
"
function unicode#pointsBetween(
      \ from = char#fromCursor(),
      \ to = nr2char(char2nr(a:from) + 16)) abort
  return unicode#pointsToString(unicode#pointsBetweenChars(a:from, a:to))
endfunc
