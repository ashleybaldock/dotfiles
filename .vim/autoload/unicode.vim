if exists("g:mayhem_autoloaded_unicode") || &cp
  finish
endif
let g:mayhem_autoloaded_unicode = 1

"
" Related:
"   $VIMHOME/plugin/unicode.vim
"
" Demo:
"   $VIMHOME/demo/unicode-whitespace
"   $VIMHOME/demo/pre.md
"

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
function unicode#pointsToString(codepoints, combiningbase = char#combase(), sep = ' ')
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

"
" Reveal Variation Selectors
"
function unicode#ToggleHintVS1516() abort
  if exists('w:mayhem_match_vs1516')
    call get(w:, 'mayhem_match_vs1516', [])
          \->foreach({_,m -> matchdelete(m)})
    unlet w:mayhem_match_vs1516
  else
    let w:mayhem_match_vs1516 = [
          \ matchadd('VS15', '︎', 1),
          \ matchadd('VS15Sp', ' ︎', 1),
          \ matchadd('VS16', '️', 1),
          \ matchadd('VS16Sp', ' ️', 1),
          \ matchadd('VS1516', '︎️', 1),
          \ matchadd('VS1615', '️︎', 1),
          \ matchadd('SpecialSpace', ' ︎', 1),
          \]
  endif
endfunc

"
" Reveal Exotic Whitespace
"
" TODO - also,[\Ue0000-\Ue007f]?  \u20f1'⃱⃲⃳⃴⃵⃶⃷⃸⃹⃺⃻⃼⃽⃾⃿'\u20ff
"
function unicode#ToggleWhitespaceHints() abort
  if exists('w:mayhem_match_u8only_wsp')
    call matchdelete(w:mayhem_match_u8only_wsp)
    unlet w:mayhem_match_u8only_wsp
  else
    let w:mayhem_match_u8only_wsp = matchadd('U8Whitespace', '[' ..
          \ '\x0b\x0c\u00a0\u00ad\u1680\u180e' ..
          \ '\u2000-\u200a\u2028\u2029\u202f\u205f\u2800' ..
          \ '\u3000\u303f\uff00\uffa0\ufeff\ufff0-\uffff' ..
          \ '\U000e0020]')
  endif
endfunc

"
" Reveal Tags
"
function unicode#ToggleTagHints() abort
  if exists('w:mayhem_match_u8tags')
    call matchdelete(w:mayhem_match_u8tags)
    unlet w:mayhem_match_u8tags
  else
    let w:mayhem_match_u8tags = matchadd('U8Tags', '[\U000e0000-\U000e007f]')
  endif
endfunc


function unicode#codepointRow(for = char#fromCursor()) abort
  let foridx = type(a:for) == type(0) ? a:for : char2nr(a:for)
  let fromidx = foridx / 16 * 16

  echohl None
  echon printf('%05x ⏐ ', fromidx)
  for char in unicode#pointsInRange(fromidx, 16)
    if char2nr(char) == foridx
      echohl Directory
      echon char
      echohl None
    else
      echon char
    endif
    echon ' '
  endfor

  return printf('%05x ⏐ ', fromidx) .. 
        \ unicode#pointsInRange(fromidx)
        \  ->map({ i, v -> char2nr(v) == foridx ? '' .. v .. '' : v})
        \  ->join(' ')
endfunc

let s:combining_diacriticals = [ '',
      \
      \ '̀', '́', '̂', '̃', '̄', '̅', '̆', '̇', '̈', '̉', '̊', '̋', '̌', '̍', '̎', '̏',
      \ '̐', '̑', '̒', '̓', '̔', '̕', '̖', '̗', '̘', '̙', '̚', '̛', '̜', '̝', '̞', '̟',
      \ '̠', '̡', '̢', '̣', '̤', '̥', '̦', '̧', '̨', '̩', '̪', '̫', '̬', '̭', '̮', '̯',
      \ '̰', '̱', '̲', '̳', '̴', '̵', '̶', '̷', '̸', '̹', '̺', '̻', '̼', '̽', '̾', '̿',
      \ '̀', '́', '͂', '̓', '̈́', 'ͅ', '͆', '͇', '͈', '͉', '͊', '͋', '͌', '͍', '͎', '͏',
      \ '͐', '͑', '͒', '͓', '͔', '͕', '͖', '͗', '͘', '͙', '͚', '͛', '͜', '͝', '͞', '͟',
      \ '͠', '͡', '͢', 'ͣ', 'ͤ', 'ͥ', 'ͦ', 'ͧ', 'ͨ', 'ͩ', 'ͪ', 'ͫ', 'ͬ', 'ͭ', 'ͮ', 'ͯ',
      \
      \ '᳐', '᳒', '', '᳗', '᳙', '᳚', '᳜', '᳝', '᳠', '᳴', '᳸', '᳹',
      \
      \ '᷀', '᷁', '᷂', '᷃', '᷄', '᷅', '᷆', '᷇', '᷈', '᷉', '᷊', '᷋', '᷌', '᷍', '᷎', '᷏',
      \ '᷐', '᷑', '᷒', 'ᷓ', 'ᷔ', 'ᷕ', 'ᷖ', 'ᷗ', 'ᷘ', 'ᷙ', 'ᷚ', 'ᷛ', 'ᷜ', 'ᷝ', 'ᷞ', 'ᷟ',
      \ 'ᷠ', 'ᷡ', 'ᷢ', 'ᷣ', 'ᷤ', 'ᷥ', 'ᷦ', 'ᷧ', 'ᷨ', 'ᷩ', 'ᷪ', 'ᷫ', 'ᷬ', 'ᷭ', 'ᷮ', 'ᷯ',
      \ 'ᷰ', 'ᷱ', 'ᷲ', 'ᷳ', 'ᷴ', '᷵', '', '', '', '', '', '᷻', '᷼', '᷽', '᷾', '᷿',
      \
      \ '⃐', '⃑', '⃒', '⃓', '⃔', '⃕', '⃖', '⃗', '⃘', '⃙', '⃚', '⃛', '⃜', '⃝', '⃞', '⃟',
      \ '⃠', '⃡', '⃢', '⃣', '⃤', '⃥', '⃦', '⃧', '⃨', '⃩', '⃪', '⃫', '⃬', '⃭', '⃮', '⃯',
      \ '⃰',
      \
      \ '︠', '︡', '︢', '︣', '︤', '︥', '︦', '︧', '︨', '︩', '︪', '︫', '︬', '︭', '︮', '︯',
      \]
let s:variation_selectors = [
      \ '', '︀', '︁', '︂', '︃', '︄', '︅', '︆', '︇', '︈', '︉', '︊', '︋', '︌', '︍', '︎', '️'
      \]

"
" Combine a char with diacritical marks
"
function! unicode#genCombinings(from = char#first(), with = s:combining_diacriticals) abort
  return mapnew(a:with, {_,v -> char#join([a:from, v])})
endfunc

"
" Combine character with variation selectors
"
function unicode#genVariations(from = char#first()) abort
  return unicode#genCombinings(a:from, s:variation_selectors)
endfunc

"                                                           TODO
function unicode#selectCombination() abort
endfunc
"                                                           TODO
function unicode#selectVariation() abort
endfunc
