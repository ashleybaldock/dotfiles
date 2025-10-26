if exists("g:mayhem_loaded_unicode")
  finish
endif
let g:mayhem_loaded_unicode = 1

"
" Default character used to display lonely combining characters
" let g:mayhem_unicode_combine_default = '◌'
"
let s:combase = get(g:, 'mayhem_unicode_combine_default', '◌')


" ??
" These all work for a specific character, but not with .
" a\%C a\Z                              a,<any>
" a\%ufe0e                              a,v15
" a\%ufe0f                              a,v16
" a\%(\%ufe0e\|\%ufe0f\)                a,(v16|v15)
" a\%ufe0e\%ufe0f                       a,v15,v16
" a\%ufe0f\%ufe0e                       a,v16,v15
" a\%(\%ufe0e\%ufe0f\|\%ufe0f\%ufe0e\)  a,(v16,v15|v15,v16)
" a\%(\%ufe0f\|\%ufe0e\)\%u20de         a,(v15|v16),enclosing square
" a\%u20de\%(\%ufe0f\|\%ufe0e\)         a,enclosing square,(v15|v16)
" a\%(\%ufe0f\|\%ufe0e\)\%C             a,(v16|v15),<any>

"
" Reveal Variation Selectors:
" See: ../demo/unicode-whitespace
"
function s:ToggleHintVS1516() abort
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

command! VariationSelectorHints call <SID>ToggleHintVS1516()

"
" Reveal Exotic Whitespace:
" See: ../demo/unicode-whitespace
"
" TODO - also,[\Ue0000-\Ue007f]?  \u20f1'⃱⃲⃳⃴⃵⃶⃷⃸⃹⃺⃻⃼⃽⃾⃿'\u20ff
function s:ToggleUnicodeWhitespaceHints() abort
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

command! UnicodeWhitespaceHints call <SID>ToggleUnicodeWhitespaceHints()


"
" Reveal Tags:
" See: ../demo/unicode-whitespace
"
function s:ToggleUnicodeTagHints() abort
  if exists('w:mayhem_match_u8tags')
    call matchdelete(w:mayhem_match_u8tags)
    unlet w:mayhem_match_u8tags
  else
    let w:mayhem_match_u8tags = matchadd('U8Tags', '[\U000e0000-\U000e007f]')
  endif
endfunc

command! UnicodeTagHints call <SID>ToggleUnicodeTagHints()

"
" List of characters in a range
"  from: number/string, codepoint at start of range
"         (strings are parsed using str2nr())
"  count: optional, number/string, count of characters to generate
"          defaults to from + 16
"         (strings are parsed using str2nr())
"
function s:CodepointsInRange(
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
function s:CodepointsBetweenChars(
      \ fromchar = char#fromCursor(),
      \ tochar = nr2char(char2nr(a:fromchar) + 16)
      \) abort
  let fromidx = char2nr(a:fromchar)
  let toidx = char2nr(a:tochar)
  let min = min([fromidx, toidx])
  let max = max([fromidx, toidx])

  return s:CodepointsInRange(l:min, l:max - l:min + 1)
endfunc

function s:CodepointsStartingFromChar(
      \ fromchar = char#fromCursor(),
      \ count = 16) abort
  let fromidx = char2nr(a:fromchar)
  return s:CodepointsInRange(fromidx, a:count)
endfunc

function s:RenderCodepointRow(for = char#fromCursor()) abort
  let foridx = type(a:for) == type(0) ? a:for : char2nr(a:for)
  let fromidx = foridx / 16 * 16

  echohl None
  echon printf('%05x ⏐ ', fromidx)
  for char in s:CodepointsInRange(fromidx, 16)
    if char2nr(char) == foridx
      echohl Directory
      echon char
      echohl None
    else
      echon char
    endif
    echon ' '
  endfor

  return printf('%05x ⏐ ', fromidx)..s:CodepointsInRange(fromidx)->map({ i, v -> char2nr(v) == foridx ? ''..v..'' : v})->join(' ')..''
endfunc


"
" Turn array of codepoints into a string
" Gives standalone combining characters something to combine with
"
function s:ToString(codepoints)
  return mapnew(a:codepoints,
        \ {idx, val -> strchars(s:combase..val, 1) == strchars(val, 1)
        \  ? s:combase..val : val})->join(' ︎')
endfunc

"
" Return a string with all chars with codepoints in range
"  defined by a codepoint and a count
" arg1: count (defaults to 16)
" arg2: numeric codepoint (start of range)
"
" e.g. :UnicodepointsCountFromIndex 26 65
" -> 'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z'
"
function s:UnicodepointsCountFromIndex(from, count = 16) abort
  return s:ToString(s:CodepointsInRange(a:from, a:count))
endfunc
command! -bar -nargs=? -count=16 UnicodepointsCountFromIndex
      \ echo <SID>UnicodepointsCountFromIndex(<args>, <count>)
"
" Return a string with all chars with codepoints in range
"  defined by a starting char and a count
" arg1: count (defaults to 16)
" arg2: start of range (defaults to cursor char)
"
" e.g. :UnicodepointsCountFromChar 26 A
" -> 'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z'
"
function s:UnicodepointsCountFromChar(
      \ from = char#fromCursor(), count = 16) abort
  return s:ToString(s:CodepointsStartingFromChar(a:from, a:count))
endfunc
command! -bar -nargs=? -count=16 UnicodepointsCountFromChar
      \ echo <SID>UnicodepointsCountFromChar(<args>, <count>)

"
" Return a string containing all chars with codepoints between
"  the two characters specified (inclusive)
" arg1: one end of range (defaults to cursor char)
" arg2: other end of range (defaults to codepoint of arg1 + 16)
"  (The order of the ends doesn't matter, but the output is
"   always in ascending codepoint order)
"
" e.g. :UnicodepointsBetween Z A
" -> 'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z'
"
" '<,'>s/^\(. .\).*$/\=ExecAndReturn("UnicodepointsBetween " .. submatch(1))/
"  
"
function s:UnicodepointsBetween(
      \ from = char#fromCursor(),
      \ to = nr2char(char2nr(a:from) + 16)) abort
  return s:ToString(s:CodepointsBetweenChars(a:from, a:to))
endfunc
command! -bar -nargs=* UnicodepointsBetween
      \ echo <SID>UnicodepointsBetween(<f-args>)

" TODO
" Shows the unicode block that contains a character
" arg1: character to display (Optional) (defaults to cursor char)
" command! -bar -nargs=? GenerateUnicodeBlock echo <SID>RenderCodepointRow(<f-args>)

" TODO show row(s) before/after in same block
command! -bar -nargs=? ShowUnicodeContext
      \ call <SID>RenderCodepointRow(<f-args>)

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
let s:variation_selectors = [ '', '︀', '︁', '︂', '︃', '︄', '︅', '︆', '︇', '︈', '︉', '︊', '︋', '︌', '︍', '︎', '️']

"
" Combine a char with various diacritical marks
"
function! s:GenerateCombinings(
      \ from = char#fromCursor(),
      \ with = s:combining_diacriticals
      \) abort
  let base = strpart(a:from, 0, 1)
  let combined = mapnew(a:with, {_,val -> base .. val})
  return combined
endfunc

function s:GenerateVariations(from = char#fromCursor()) abort
  return s:GenerateCombinings(a:from, s:variation_selectors)
endfunc

command! -bar -nargs=? GenerateCombinings echo <SID>GenerateCombinings(<f-args>)->join(' ')

command! -bar -nargs=? GenerateVariations echo <SID>GenerateVariations(<f-args>)->join(' ')

"                                                           TODO
function s:SelectCombination() abort
endfunc
"
" Show a popup with possible combinations to pick from
" If no base character supplied, uses character under cursor
"
command! -bar -nargs=? SelectCombination call <SID>SelectCombination(<f-args>)

"                                                           TODO
function s:SelectVariation() abort
endfunc
" Show a popup with possible variations to pick from
" If no base character supplied, uses character under cursor
"
command! -bar -nargs=? SelectVariation call <SID>SelectVariation(<f-args>)

"                                                           TODO
" Cycle through predefined sets of Unicodepoints
"
" A given codepoint may have more than one dimension
" along which it can be cycled
"
" e.g. ┼ ▬▶︎ ├ ▬▶︎ ┌ ▬▶︎ ┬ ▬▶︎ ┐ ▬▶︎ ┤ ▬▶︎ ┘ ▬▶︎ ┴ ▬▶︎ └
" rotation
"      ┘ ▶︎ ╴ ▶︎ ┐ ▶︎ ╷ ▶︎ ┌ ▶︎ ╶ ▶︎ └ ▶︎ ╵   ▮◀︎
"      │ ▶︎ ╱ ▶︎ ─ ▶︎ ╲   ⏮
" style
"      ┘ ▶︎ ┙ ▶︎ ┚ ▶ ┛ ▶ ╛ ▶ ╜ ▶ ╝ ▶ ╯  ▮◀︎◀︎
"     w     w: [╵, ][└,╶][├,][┌,├][┬,┼][┐,┤][,]
"     ╿     
"  a╺─┼─╸d  w: [' ','╵','╹']
"     ╽         ┌ ├ ┞   ┬ ┼ ╀  ╷ │ ╿   ╗ ╣ 
"     s
"           s:  ╿ ┃ ╹   
"
"           q:  ╷ │ ╎ ┆ ┊ ╵ ╷  e: │ ┃ ║
"
let g:mayhem_unicycles = [
      \ ['', '', '╭', '','╮', '','╯','', '╰'],
      \
      \ ['┼','├','┌','┬','┐','┤','┘','┴','└'],
      \
      \ ['┌','┐','┘','└','┐','┤','┘','┴','└'],
      \
      \ ['╷','┐','│','┌',],
      \ ['╴','┘','─','┐',],
      \
      \ ['╋','┣','┏','┳','┓','┫','┛','┻','┗'],
      \ ['╬','╠','╔','╦','╗','╣','╝','╩','╚'],
      \ ['╴','─','╶','╌','┄','┈','╼','╾'],
      \ ['╸','━','╺','╍','┅','┉'],
      \ ['╵','│','╷','╎','┆','┊','╽','╿'],
      \ ['╹','┃','╻','╏','┇','┋'],
      \ ['╱','╲','╳']
      \ ]
function! s:CycleChars(arg) abort
  " find base char
  let parts = s:SplitChar(a:arg)
  " check cycle arrays for combined, and then base
endfunc






" Highlight non-ASCII characters.
" syntax match nonascii [^\x00-\x7F]
" highlight link nonascii ErrorMsg
" autocmd BufEnter * syn match ErrorMsg /[^\x00-\x7F]/
"
"au WinEnter * if !exists("w:custom_hi1") | let w:custom_hi1 = matchadd('ErrorMsg', '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$') | endif
"
"au WinEnter * if !exists("w:custom_hi2") |
"
" let w:custom_hi2 = matchadd('U8Whitespace',
"   \ '[\x0b\x0c\u00a0\u1680\u180e\u2000-\u200a\u2028\u2029\u202f\u205f\u3000\ufeff]', 10, -1, {'conceal': '⌻' })



