if exists("g:mayhem_loaded_unicode")
  finish
endif
let g:mayhem_loaded_unicode = 1

"
"
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

