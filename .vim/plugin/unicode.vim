if exists("g:mayhem_loaded_unicode")
  finish
endif
let g:mayhem_loaded_unicode = 1

"
" Related:
"   $VIMHOME/autoload/unicode.vim
"
" Demo:
"   $VIMHOME/demo/unicode-whitespace
"


"
" :UnicodepointsCountFromIndex 26 65
" :26UnicodepointsCountFromIndex 65
" -> 'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z'
"
command! -bar -nargs=? -count=16 UnicodepointsCountFromIndex
      \ echo unicode#pointsCountFromIndex(<args>, <count>)

  "
  "  :UnicodepointsCountFromChar 26 A
  "  :26UnicodepointsCountFromChar A
  " -> 'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z'
  "
command! -bar -nargs=? -count=16 UnicodepointsCountFromChar
      \ echo unicode#pointsCountFromChar(<f-args>, <count>)

  "
  "  :UnicodepointsAround 10 D
  "  :10UnicodepointsAround D
  " -> 'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z'
  "
command! -bar -nargs=? -count=8 UnicodepointsAround
      \ echo unicode#pointsAroundChar(<f-args>, <count>)

  "
  "  :UnicodepointsBetween A Z
  "  :UnicodepointsBetween Z A
  " -> 'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z'
  "
command! -bar -nargs=* UnicodepointsBetween
      \ echo unicode#pointsBetween(<f-args>)

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

command! VariationSelectorHints call unicode#ToggleHintVS1516()

command! UnicodeWhitespaceHints call unicode#ToggleWhitespaceHints()

command! UnicodeTagHints call unicode#ToggleTagHints()

  " TODO
  " Shows the unicode block that contains a character
  " arg1: character to display (Optional) (defaults to cursor char)
  " command! -bar -nargs=? GenerateUnicodeBlock echo <SID>RenderCodepointRow(<f-args>)

  " TODO show row(s) before/after in same block
command! -bar -nargs=? ShowUnicodeContext call unicode#codepointRow(<f-args>)


command! -bar -nargs=? GenerateCombinings echo unicode#genCombinings(<args>)->join(' ')

command! -bar -nargs=? GenerateVariations echo unicode#genVariations(<f-args>)->join(' ')

command! -bar -nargs=? -count=16 Vary echo unicode#genVariations(<f-args>))

  "
  " Show a popup with possible combinations to pick from
  " If no base character supplied, uses character under cursor
  "
command! -bar -nargs=? SelectCombination call unicode#selectCombination(<f-args>)

  " Show a popup with possible variations to pick from
  " If no base character supplied, uses character under cursor
  "
command! -bar -nargs=? SelectVariation call unicode#selectVariation(<f-args>)

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



