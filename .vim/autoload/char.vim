if exists("g:mayhem_autoloaded_char") || &cp
  finish
endif
let g:mayhem_autoloaded_char = 1

"
" Related:
"      ../plugin/char.vim
"      ../syntax/vsel.vim
"

"
" Default character used to display lonely combining characters
" let g:mayhem_unicode_combine_default = '◌'
"
function char#combase() abort
  return get(g:, 'mayhem_unicode_combine_default', '◌')
endfunc

"
" Text from current cursor position to EoL
"
function char#fromCursor() abort
  return getline('.')[col('.') - 1 : -1]
endfunc

"
" First character in string, including combining characters
"
function char#first(str = char#fromCursor()) abort
  return a:str->strcharpart(0, 1, 1)
endfunc

"
" First character in string, stripped of any combining characters
"
function char#base(str = char#fromCursor()) abort
  return a:str->char2nr()->nr2char()
endfunc

"
" Split string into combining character parts
"
" Reverse this process using char#join() (with default options)
"
" e.g.    char#split('')  ->  []
"        char#split('a')  ->  [['a']]
"        char#split('a⃤')  ->  [['a', '⃤']]
"      char#split('a⃤b̲c⃞')  ->  [['a', '⃤'], ['b', '̲'], ['c', '⃞ ']]
"
function char#split(str) abort
  return split(a:str, '\zs')->map({_,v -> str2list(v, 1)->map({_,vv -> nr2char(vv)})})
endfunc

"
" Join character parts into combined characters
"
" Input is either:
" - a list<list<string>> of character parts (like the output of char#split())
" - a list<string> of character parts or combined characters
"
" Options:
"  flatten: (default: true) 
"           if input is a list<list<string>>, flatten it first
"           - if set to false, each sub-list is processed separately
"             as a self-contained character
"   debase: (default: true) 
"           remove base from any combined characters in input,
"   single: (default: false)
"           produce a single combined character as output
"           - uncombined base characters are skipped
"           - combined characters are skipped if debase is false
"           - if flatten is false, a single character is produced for each
"             sub-list in the input
"
" If the first item in the list does not contain a base character then
"
" If single is true and debase is false, combined characters in input
" are ignored entirely.
"
" e.g.         char#join(['a', '̲'])  ->  'a̲'
"              char#join(['̲' , '⃞'])  ->  '̲⃞'
"          char#join(['̲', 'a', '⃞'])  ->  '̲a⃞'
"         char#join(['a', '◌̲', '⃞'])  ->  'a̲⃞'
"    char#join(['a', '◌̲', 'b', '⃞'])  ->  'a̲b⃞'
"    char#join(['a', '̲' , 'b', '⃞'])  ->  'a̲b⃞'
"
" debase (default)
"            char#join(['a', '◌̲'])  ->  'a̲'
"            char#join(['◌̲', '⃞' ])  ->  '̲⃞'
" no debase
"            char#join(['a', '◌̲'], #{debase:0})  ->  'a◌̲'
"            char#join(['◌̲', '⃞' ], #{debase:0})  ->  '◌̲⃞'
"  char#join(['a', '◌̲', 'b', '⃞' ], #{debase:0})  ->  'a◌̲b⃞'
"
" single
"           char#join(['a', '◌̲'], #{single:1})  ->  'a̲'
"           char#join(['̲' , '⃞' ], #{single:1})  ->  '̲⃞'
"      char#join(['a', '̲' , '⃞' ], #{single:1})  ->  'a̲⃞'
"      char#join(['a', 'b̲', 'c⃞'], #{single:1})  ->  'a̲⃞'
" char#join(['a', '◌̲', 'b', '⃞' ], #{single:1})  ->  'a̲⃞'
"
" single + no debase
"            char#join(['a', '◌̲'])  ->  'a'
"       char#join(['a', 'b̲', '⃞' ], #{single:1,debase:0})  ->  'a⃞'
"       char#join(['a', 'b̲', 'c⃞'], #{single:1,debase:0})  ->  'a'
"  char#join(['a', '◌̲', 'b', '⃞' ], #{single:1,debase:0})  ->  'a⃞'
"
"
function char#join(charparts, options = #{}) abort
  let flatten = get(a:options, 'flatten', v:true)
  let debase = get(a:options, 'debase', v:true)
  let single = get(a:options, 'single', v:false)
  let parts = flatten
        \ ? [flattennew(a:charparts)]
        \ : mapnew(a:charparts, {_, v -> type(v) == v:t_list ? flatten(v) : [v] })
  return map(parts, {_, part -> part
        \->map({_, v -> debase && char#iscomposite(v) ? char#debase(v) : v})
        \->map({i, v -> single && i > 0 && char#isbased(v) ? '' : v})
        \->flatten()
        \->join('')
        \})
        \->join('')
endfunc

"
" Remove all instances of combining character(s)
"
" Those to remove can be supplied as a string or 
" a list of strings, all of which are debased and split.
"
" Note: char#base() can be used to remove all combining characters
"
" e.g.  char#strip('a̲⃝', '̲')  ->  'a⃝'
"       char#strip('a̲̲', '̲')  ->  'a'
"       char#strip('a̲⃝', '̲⃝')  ->  'a'
"  char#strip('a̲⃝', ['̲','⃝'])  ->  'a'
"  char#strip('a̲⃝', ['◌̲','◌⃝'])  ->  'a'
"
function char#strip(str, remove) abort
  let toremove = flattennew([a:toremove])->map({i,v -> char#debase(v)->char#split()[0]})
  return char#split(a:str)
        \->flatten()
        \->filter({i, v -> i == 0 || index(toremove, v) >= 0 })
        \->char#join()
endfunc

"
" Check if a composite character contains a particular part
"
" e.g.  char#contains('a̲', 'a')  ->  true
"       char#contains('a̲', '̲')   ->  true
"       char#contains('̲', '̲')    ->  true
"       char#contains('̲', 'a')   ->  false
"       char#contains('a', '⃞ ')  ->  false
"
function char#contains(str, char) abort
  return char#split(a:str)
        \->flatten()
        \->count(a:char) > 0
endfunc

"
" Check if a character combines with a base to produce a composite character
"
function char#combineswith(base, addition) abort
  return [char#first(a:base)->char2nr(), char#first(a:addition)->str2list()]
        \ ->flatten()
        \ ->list2str()
        \ ->strchars(1) == 1
endfunc

"
" Check if a character is composite
"
" Note: Can be true for characters with no base character,
"       you can check for that using char#isbased()
"
" e.g.  char#iscomposite('a')  ->  false
"       char#iscomposite('̲')   ->  false
"       char#iscomposite('a̲')  ->  true
"       char#iscomposite('̲⃞')   ->  true
"
function char#iscomposite(str) abort
  return char#first(a:str)->str2list()->len() > 1
endfunc

"
" Check if a character has a base, or comprises only combining characters
"
" Note: true for non-composite base characters,
"       you can check for that using char#iscomposite()
"
" e.g.  char#isbased('a')  ->  true
"       char#isbased('a̲')  ->  true
"       char#isbased('̲')   ->  false
"
function char#isbased(str) abort
  return !char#combineswith(char#combase(), a:str)
endfunc

"
" Remove base character (if any) leaving only combining characters
"
" e.g.  char#debase('a')  ->  ''
"       char#debase('a̲')  ->  '̲'
"       char#debase('̲')   ->  '̲'
"
function char#debase(str) abort
  let char = char#first(a:str)
  return char#isbased(char) 
        \ ? char#iscomposite(char)
        \  ? char#split(char)[0][1:-1]->join('')
        \  : ''
        \ : char
endfunc

"
" Replaces the base character in a glyph made up of multiple
" characters (combining diacritics, variation selectors etc.)
"
" Takes two arguments:
" 1. the character to modify
" 2. the replacement base character (defaults to value of g:mayhem_unicode_combine_default)
"
" e.g. char#rebase('B⃝' , 'C')  ▬▶  'C⃝'
"      char#rebase('⃝ ' , 'D')  ▬▶  'D⃝ '
"
function char#rebase(str, newbase = char#combase()) abort
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
        \->char#split()[0]
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
  return char#base(a:str)->char#codes()
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
" let g:mayhem_hi_vsels = [
"       \ ◌󠅀 ︎◌󠅁 ︎◌󠅂 ︎◌󠅃 ︎◌󠅄 ︎◌󠅅 ︎◌󠅆 ︎◌󠅇 ︎◌󠅈 ︎◌󠅉 ︎◌󠅊 ︎◌󠅋 ︎◌󠅌 ︎◌󠅍 ︎◌󠅎 ︎◌󠅏 ︎◌󠅐 ︎◌󠅑 ︎◌󠅒 ︎◌󠅓 ︎◌󠅔 ︎◌󠅕 ︎◌󠅖 ︎◌󠅗 ︎
"       \ ︎◌󠅘 ︎◌󠅙 ︎◌󠅚 ︎◌󠅛 ︎◌󠅜 ︎◌󠅝 ︎◌󠅞 ︎◌󠅟 ︎◌󠅠 ︎◌󠅡 ︎◌󠅢 ︎◌󠅣 ︎◌󠅤 ︎◌󠅥 ︎◌󠅦 ︎◌󠅧 ︎◌󠅨 ︎◌󠅩 ︎◌󠅪 ︎◌󠅫 ︎◌󠅬 ︎◌󠅭 ︎◌󠅮 ︎◌󠅯 ︎
"       \]
"
" Combine character with the variation selector corresponding to number
"
" Notes:
" - Only the first n (= &mco) combining characters affect the shape of the
"   displayed glyph, but all of them can match patterns.
" - Order can change the output, e.g. 'a'‥'◌⃝ '‥'16' = a⃝️   but  'a'‥'16'‥'◌⃝ ' =  a️⃝ 
"  - These combinations and their result are font-dependent.
"
" Variation selectors vs17-vs255 are used for per-character highlighting
"  (see: g:mayhem_hi_vsels). These are placed after any other combining characters.
"
function char#vary(str = char#fromCursor(), vsel = 16) abort
endfunc

" Combine first character of input with every variation selector
function char#variations(str = char#fromCursor()) abort
endfunc

let g:mayhem_unicode_invisible_chars = ['[\Ue0100-\Ue01ef]']
"
" Move invisible character parts after visible ones
"
" - Invisible parts don't affect the glyph shape
"   (e.g. vs17-vs255, when used for per-character highlighting)
" - The relative order of any un-moved parts is preserved.
" - The relative order of moved parts is also preserved.
"
"  e.g.  'a'‥'66'‥'99'‥'◌⃝ '‥'16' =  a󠄱󠅒️⃝      'a'‥'◌⃝ '‥'16'‥'66'‥'99' =  a⃝️󠄱󠅒  
"
function char#sort(str, vsel = 16) abort
endfunc


" First bit of what Characterize does
def char#normalised(arg: string): string
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

let g:mayhem_unicode_display_double = map(['◌⃝','◌⃞','◌⃤','◌⃟','◌⃘','◌͢','◌⃣','◌᷍','◌⃒'], {_,v -> char#debase(v)})
"
" Format combining characters for display
"
" - Add a base for standalone combining characters
"   Default base character set in: g:mayhem_unicode_combine_default
" - Pad wide combined characters so they don't overlap
"   Characters to pad set in: g:mayhem_unicode_display_double
"
" e.g.  char#display('a̲')  ->  'a̲'
"       char#display('̲')   ->  '◌̲'
"       char#display('a⃝')  ->  'a⃝ '
"       char#display('⃝ ')  ->  '◌⃝ '
"
function char#display(str, base = char#combase()) abort
  let first = char#first(a:str)
  return char#isbased(first) ? first : char#rebase(first, a:base)
endfunc

" return a:str->strcharpart(0, 1, 1)->strcharpart(1, 2, 0)->charclass()
