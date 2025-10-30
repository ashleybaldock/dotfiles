if exists("g:mayhem_autoloaded_char") || &cp
  finish
endif
let g:mayhem_autoloaded_char = 1

"
" See: ../plugin/char.vim
"

"
" Default character used to display lonely combining characters
" let g:mayhem_unicode_combine_default = '◌'
"
let s:combase = get(g:, 'mayhem_unicode_combine_default', '◌')

"
" Text from current cursor position to EoL
"
function char#fromCursor() abort
  return getline('.')[col('.') - 1 : -1]
endfunc

"
" First character in string, including combining characters
"
function char#first(str) abort
  return a:str->strcharpart(0, 1, 1)
endfunc

"
" First character in string, stripped of any combining characters
"
function char#base(str = char#fromCursor()) abort
  return a:str->char2nr()->nr2char()
endfunc

"
" Split (combined) character into parts
"
function char#split(str = char#fromCursor()) abort
  " return a:str->strcharpart(0, 1, 1)->strcharpart(1, 2, 0)->charclass()
  return strcharpart(a:str, 0, 1, 1)
        \->str2list(1)
        \->map({i, v -> nr2char(v)})
endfunc

"
" Join character parts into a single combined character
"
" Base character comes from the first item
"
" e.g.  char#join(['a', '̲'])  ->  a̲   
"        char#join(['a', '◌̲'])  ->  a̲   
"          char#join(['a̅', '◌̲'])  ->  a̲̅
"       char#join(['a', '◌̅', '◌̲'])  ->  a̲̅
"
function char#join(list) abort
  return a:list->mapnew({i, v -> i == 0
        \ ? str2list(v, 1)
        \ : strpart(v, 1, 1, 1)->str2list(1)
        \})->flatten()->list2str()
endfunc

"
" Remove combining character
"
function char#strip(remove, str = char#fromCursor()) abort
  return char#split(str)->filter({i, v -> i == 0 || v != a:remove })->char#join()
endfunc

"
" Check if character comprises only combining characters
"
function char#hasBase(str = char#fromCursor()) abort
  return [char2nr(s:combase),char#first(a:str)->str2list()]
        \ ->flatten()
        \ ->list2str()
        \ ->strchars(1) == 1
endfunc

"
" Remove base character (if any) leaving only combining characters
"
function char#debase(str = char#fromCursor()) abort
  return char#hasBase(a:str) 
        \ ? char#first(a:str)
        \ : char#first(a:str)->strpart(1, 1, 1)
endfunc

"
" Replaces the base character in a glyph made up of multiple
" characters (combining diacritics, variation selectors etc.)
"
" Takes two arguments:
" 1. the replacement base character
" 2. the character to modify (defaults to the character under the cursor)
"
" e.g. char#rebase(B⃝ , C)  ▬▶  C⃝
"
function char#rebase(newbase = s:combase, str = char#fromCursor()) abort
  return a:newbase .. char#debase(a:str)
endfunc

"
" Character class (defaults to char under cursor)
"
function char#class(str = char#fromCursor()) abort
  return charclass(a:str)
endfunc

"
" Escape code sequence for (combined) character
"
" e.g.     char#code('B') -> \u42
"          char#code('B⃝') -> \u42\u20dd
"          char#code('Ⲃ⃝') -> \u2c82\u20dd
"          char#code('𑫄⃝') -> \U11ac1\U20dd
"
function char#codes(str = char#fromCursor()) abort
  return char#first(a:str)
        \->char#split()
        \->map({i, v -> char2nr(v)})
        \->map({i, n -> 
        \ n < 0xff ? printf('\u%02x', n)
        \ : n < 0xffff ? printf('\u%04x', n)
        \   : printf('\U%x', n)
        \})->join('')
endfunc

"
" Escape code for (base) character
"
" e.g.     char#code('B⃝') -> \u42
"          char#code('Ⲃ⃝') -> \u2c82
"          char#code('𑫄⃝') -> \U11ac1
"
function char#code(str = char#fromCursor()) abort
  return char#base(a:str)->char#code()
endfunc

"
" Convert character into escaped form for use in regex
" e.g.    char#match(b) -> \%u62
"      char#match(b, 1) -> \u62
"
function char#match(str = char#fromCursor(), collection = 0) abort
  let n = char2nr(a:str)
  return printf('\%s%s%x', a:collection ? '%' : '', n < 0xffff ? 'u' : 'U', n)
endfunc

" 81-104, 105-128
let g:mayhem_hi_vsels = [
      \ ◌󠅀 ︎◌󠅁 ︎◌󠅂 ︎◌󠅃 ︎◌󠅄 ︎◌󠅅 ︎◌󠅆 ︎◌󠅇 ︎◌󠅈 ︎◌󠅉 ︎◌󠅊 ︎◌󠅋 ︎◌󠅌 ︎◌󠅍 ︎◌󠅎 ︎◌󠅏 ︎◌󠅐 ︎◌󠅑 ︎◌󠅒 ︎◌󠅓 ︎◌󠅔 ︎◌󠅕 ︎◌󠅖 ︎◌󠅗 ︎
      \ ︎◌󠅘 ︎◌󠅙 ︎◌󠅚 ︎◌󠅛 ︎◌󠅜 ︎◌󠅝 ︎◌󠅞 ︎◌󠅟 ︎◌󠅠 ︎◌󠅡 ︎◌󠅢 ︎◌󠅣 ︎◌󠅤 ︎◌󠅥 ︎◌󠅦 ︎◌󠅧 ︎◌󠅨 ︎◌󠅩 ︎◌󠅪 ︎◌󠅫 ︎◌󠅬 ︎◌󠅭 ︎◌󠅮 ︎◌󠅯 ︎
      \]
"
" Combine character with the variation selector corresponding to number
"
" Notes:
" - Only the first n (= &mco) combining characters affect the displayed charcter
"  - However, subsequent characters can still match patterns.
" - Order can change the output, e.g. 'a'‥'◌⃝ '‥'16' = a⃝️   'a'‥'◌⃝ '‥'16' =  a️⃝ 
"
" Some variation selectors (see: g:mayhem_hi_vsels) are used for character-wise
" highlighting. These are placed after any other combining characters.
"
function char#vary(str = char#fromCursor(), vsel = 16) abort
endfunc

"
" Move combining characters in g:mayhem_hi_vsels after any others
"
function char#sort(str = char#fromCursor(), vsel = 16) abort
endfunc
