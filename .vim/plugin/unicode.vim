if exists("g:mayhem_loaded_unicode")
  finish
endif
let g:mayhem_loaded_unicode = 1





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
function! s:HintMatchVS15and16() abort
  let v15 = matchadd('VS15', '︎', 1)
  let v16 = matchadd('VS16', '️', 1)
  let v1516 = matchadd('VS1516', '︎️', 1)
  let v1615 = matchadd('VS1615', '️︎', 1)
  let spspace = matchadd('SpecialSpace', ' ︎', 1)
endfunc

command! VariationSelectorHints call <SID>HintMatchVS15and16()

  "
  " let w:mayhem_match_u8whitespace2 = matchadd('U8Whitespace', '[\x0b\x0c\u00a0\u1680\u180e\u2000-\u200a\u2028\u2029\u202f\u205f\u3000\ufeff]', 10, -1, {'conceal': '⌻' })

function! s:HideUnicodeWhitespaceHints() abort
  if exists("w:mayhem_match_u8only_wsp")
    call matchdelete(w:mayhem_match_u8only_wsp)
    unlet w:mayhem_match_u8only_wsp
  endif
endfunc

" [\Ue0100-\Ue01ef]
" [\Ue0000-\Ue007f]
function! s:ShowUnicodeWhitespaceHints() abort
  call s:HideUnicodeWhitespaceHints()
  let w:mayhem_match_u8only_wsp = matchadd('U8Whitespace', '[\x0b\x0c\u00a0\u1680\u180e\u2000-\u200a\u2028\u2029\u202f\u205f\u2800\u3000\u303f\uff00\uffa0\ufeff\ufff0-\uffff\U000e0020]', 10, -1, {'conceal': '⌻' })
endfunc

function! s:ToggleUnicodeWhitespaceHints() abort
  if exists("w:mayhem_match_u8only_wsp")
    call s:HideUnicodeWhitespaceHints()
  else
    call s:ShowUnicodeWhitespaceHints()
  endif
endfunc

command! UnicodeWhitespaceHints call <SID>ToggleUnicodeWhitespaceHints()



"
function! s:GetCursorChar() abort
  return getline('.')[col('.')-1:-1]
endfunc

" Replaces the base character in a glyph made up of
" multiple characters (combining diacritics, 
" variation selectors etc.)
"
" Takes two arguments:
" 1. the replacement base character
" 2. (optional) the character to modify
"     - defaults to the character under the cursor
"       (this method doesn't change it)
"
" e.g. (B⃝ , C)  ▬▶︎ C⃝  
"
" No cleverness here, it just swaps the first character,
" will probably not work for some inputs
" 
function! s:ReplaceBaseChar(replacement, char = s:GetCursorChar()) abort
  return a:replacement..strpart(a:char, 1)
endfunc

    " s/\zs\(\%#\)\ze/\=s:ReplaceBaseChar(submatch(0))/n
command! -bar -nargs=+ ReplaceBaseCharWith echo <SID>ReplaceBaseChar(<q-args>)

" 
command! -bar -nargs=+ CombineWithDiacritic echo <SID>CombineWith(<q-args>)


let g:mayhem_combining_diacriticals = [ ['\u20d0'] ]
"                                                           TODO
" Combine a char with various diacritical marks
" Shows a popup with the results
"
function! s:GenerateCombinings(arg) abort
  let parts = s:SplitChar(a:arg)
  let base = parts[0]
  echom s:SplitChar(a:arg)
endfunc

command! -bar -nargs=? GenerateCombinings call <SID>GenerateCombinings(<q-args>)



function s:SelectVariation()
  " Get character under cursor
endfunc

command! SelectVariation call <SID>SelectVariation()

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
"      
"
let g:mayhem_unicycles = [
      \ ['', '', '╭', '','╮', '','╯','', '╰'],
      \ ['┼','├','┌','┬','┐','┤','┘','┴','└'],
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

