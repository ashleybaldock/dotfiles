if exists("g:mayhem_autoloaded_format") || &cp
  finish
endif
let g:mayhem_autoloaded_format = 1

"
" See: ../plugin/format.vim
"

let s:combase = get(g:, 'mayhem_unicode_combine_default', '◌')

let s:f_number = #{
      \ norm:  '0123456789',
      \ vs16:  '0️1️2️3️4️5️6️7️8️9️',
      \ sans:  '𝟢𝟣𝟤𝟥𝟦𝟧𝟨𝟩𝟪𝟫',
      \ sansb: '𝟬𝟭𝟮𝟯𝟰𝟱𝟲𝟳𝟴𝟵',
      \ sup:   '⁰¹²³⁴⁵⁶⁷⁸⁹',
      \ sub:   '₀₁₂₃₄₅₆₇₈₉',
      \ sub16: '₀️₁️₂️₃️₄️₅️₆️₇️₈️₉️',
      \ mono:  '𝟶𝟷𝟸𝟹𝟺𝟻𝟼𝟽𝟾𝟿',
      \ fullw: '０１２３４５６７８９',
      \ circ: '⓪①②③④⑤⑥⑦⑧⑨',
      \ paren: '0⑴⑵⑶⑷⑸⑹⑺⑻⑼',
      \ dot: '0⒈⒉⒊⒋⒌⒍⒎⒏⒐',
      \}
function! format#numbers(str, format = 'sans') abort
  return (a:str .. '')
        \->substitute('[0-9]', { 
        \ m -> get(s:f_number, a:format, '0123456789')
        \      ->strgetchar(m[0]->str2nr())->nr2char()
        \}, 'g')
endfunc

let s:f_session = [[
      \'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      \'𝟶𝟷𝟸𝟹𝟺𝟻𝟼𝟽𝟾𝟿𝙰𝙱𝙲𝙳𝙴𝙵𝙶𝙷𝙸𝙹𝙺𝙻𝙼𝙽𝙾𝙿𝚀𝚁𝚂𝚃𝚄𝚅𝚆𝚇𝚈𝚉', '', ''], [
      \'abcdefghijklmnopqrstuvwxyz',
      \'𝚊𝚋𝚌𝚍𝚎𝚏𝚐𝚑𝚒𝚓𝚔𝚕𝚖𝚗𝚘𝚙𝚚𝚛𝚜𝚝𝚞𝚟𝚠𝚡𝚢𝚣', '', ' '], [
      \' ',
      \' ', '', ' ']]

let s:f_session_lookup = {}
for [j, part] in s:f_session->items()
  let [_from, _to, prefix, suffix] = part
  let to = _to->split('\zs')
  for [i, f] in _from->split('\zs')->items()
    let s:f_session_lookup[f] = prefix .. to[i] .. suffix
  endfor
endfor

"
" Attempt to format input strings so they render in OSX menus as 'monospaced'
"
" [0-9A-Z]: replaced with equivalent math monospaced char   'A' -> '𝙰'
" [a-z]: ditto, plus a hair space                           'a' -> '𝚊 '
" [ ]: replaced with 2 3perem spaces                        ' ' -> '  '
" …anything else: replaced with 
"
function! format#session(str) abort
  return a:str->split('\zs')->map({i, c -> get(s:f_session_lookup, c, '⍰')})->join('')
endfunc


" lowercase (FileName -> filename)
function! format#lowercase(str) abort
  return tolower(a:str)
endfunc

" spaced lowercase ([fiNm, FiNm, Fi Nm, fi_nm, fi-nm] -> fi nm)
function! format#spacedlowercase(str) abort
  return split(a:str, '\([_ .-]\|\ze[A-Z]\)')
        \->map({_, v -> tolower(v)})
        \->join(' ')
endfunc

" UPPERCASE (FileName -> FILENAME)
function! format#uppercase(str) abort
  return toupper(a:str)
endfunc

" SPACED UPPERCASE ([fiNm, FiNm, Fi Nm, fi_nm, fi-nm] -> FI NM)
function! format#spaceduppercase(str) abort
  return split(a:str,'\([_ .-]\|\ze[A-Z]\)')->map(
        \  {_, v -> toupper(v)})->join(' ')
endfunc

" TitleCase (fn -> Fn, [fiNm, Fi Nm] -> FiNm)
function! format#titlecase(str) abort
  return split(a:str, '\([_ .-]\|\ze[A-Z]\)')
        \->map({_, v -> substitute(v,'\(.\)\(.*\)', '\u\1\2', 'g')})
        \->join('')
endfunc

" Spaced Title Case (fn -> Fn, [fiNm, Fi Nm] -> Fi Nm)
function! format#spacedtitlecase(str) abort
  return split(a:str, '\([_ .-]\|\ze[A-Z]\)')
        \->map({_, v -> substitute(v,'\(.\)\(.*\)', '\u\1\2', 'g')})
        \->join(' ')
endfunc

" snake_case (fn -> fn, [fiNm, Fi Nm] -> fi_nm)
function! format#snakecase(str) abort
  return split(a:str, '\([_ .-]\|\ze[A-Z]\)')
        \->map({_, v -> tolower(v)})
        \->join('_')
endfunc

" SCREAMING_SNAKE_CASE (fn -> FN, [fiNm, Fi Nm] -> FI_NM)
function! format#screamingsnakecase(str) abort
  return split(a:str, '\([_ .-]\|\ze[A-Z]\)')
        \->map({_, v -> toupper(v)})
        \->join('_')
endfunc

" kebab-case (fn -> fn, [fiNm, Fi Nm] -> fi-nm)
function! format#kebabcase(str) abort
  return split(a:str, '\([_ .-]\|\ze[A-Z]\)')
        \->map({_, v -> tolower(v)})
        \->join('-')
endfunc

" camelCase ([FiNm, fi nm] -> fiNm)
function! format#camelcase(str) abort
  return split(a:str,  '\([_ .-]\|\ze[A-Z]\)')
        \->map({i, v -> substitute(v,'\(.\)\(.*\)', i == 0 ? '\l\1\2' : '\u\1\2', 'g')})
        \->join('')
endfunc

" PascalCase ([fiNm, fi nm] -> FiNm)
function! format#pascalcase(str) abort
  return split(a:str, '\([_ .-]\|\ze[A-Z]\)')
        \->map({_, v -> substitute(v,'\(.\)\(.*\)', '\u\1\2', 'g')})
        \->join('')
endfunc


" Used by DictToJson below
let s:replace = {_, v -> '['..typename(v)..']'}
let s:identity = {_, v -> v}
let s:typemap = {
      \  string(v:t_number): s:identity
      \, string(v:t_string): {_, v -> substitute(v, '\n', '\\n', 'g')}
      \, string(v:t_func): s:replace
      \, string(v:t_list): {_, v -> v->map(s:lookup)}
      \, string(v:t_dict): {_, v -> v->map(s:lookup)}
      \, string(v:t_float): s:identity
      \, string(v:t_bool): s:identity
      \, string(v:t_none): {_, v -> 'null'}
      \, string(v:t_job): s:replace
      \, string(v:t_channel): s:replace
      \, string(v:t_blob): s:replace
      \, string(v:t_class): s:replace
      \, string(v:t_object): s:replace
      \, string(v:t_typealias): s:replace
      \, string(v:t_enum): s:replace
      \, string(v:t_enumvalue): s:replace
      \ }
function s:Lookup(key, val)
  return get(s:typemap, string(type(a:val)), s:replace)(a:key, a:val)
endfunc
let s:lookup = function('s:Lookup')

"
" Turn a Vim dict into a JSON, taking care of any pesky Funcrefs
"
function s:DictToJson(someDict) abort
  return deepcopy(a:someDict)->map(s:lookup)->json_encode()
endfunc
"
" Runs prettier on the input JSON string
"
function format#json(jsonString) abort
  return systemlist('npx prettier --stdin-filepath nameless.json', a:jsonString)
endfunc
"
" Turn dict into JSON and then prettier it
"
function format#dict2json(dict) abort
  return format#json(s:DictToJson(a:dict))
endfunc
"
" Apply code beautification to the contents of a buffer (or part thereof)
"
let s:filetypemap = #{
      \ typescriptreact: 'tsx',
      \}
function format#buffer(bufnr = bufnr(), filetype = get(&l, 'filetype', 'html')) range abort
  let filetypeext = get(g:mayhem_type_ext_map, a:filetype, a:filetype)
  let filename = expand('%') ?? 'nameless'
  let stdinpath = shellescape(filename .. '.' .. filetypeext)

  exec a:firstline .. ',' .. a:lastline .. '!npx prettier --stdin-filepath ' .. stdinpath
endfunc

function format#list(text, filetype = 'html') abort
  let joined = type(a:text) == type([]) ? join(a:text, "\n") : a:text
  let filetypeext = get(g:mayhem_type_ext_map, a:filetype, a:filetype)

  return systemlist('npx prettier --stdin-filepath nameless.' .. filetypeext, joined)
endfunc

function format#FixedWidthFont(text)
  " '<,'>s/\u/\=nr2char(char2nr(submatch(0)) + 0x1D62F)/g
  " '<,'>s/\l/\=nr2char(char2nr(submatch(0)) + 0x1D629)/g
  return substitute(a:text,
        \ '\u', '\=char#base(submatch(0)) + 0x1D62F)', 'g')
        \->substitute(
        \ '\l', '\=char#base(submatch(0)) + 0x1D629)', 'g')
endfunc

function format#timeSince(eventtime)
  let ds = localtime() - a:eventtime
  if ds < 1
    return 'the future'
  endif
  if ds < 60
    return 'the last minute'
  endif
  if ds < 3600
    return 'the last hour'
  endif
  if ds < 86400
    return 'the last day'
  endif
  if ds < 604800
    return 'the last week'
  endif
  if ds < 2629743
    return 'the last month'
  endif
  if ds < 31556926
    return 'the last year'
  endif
  return 'over a year ago'
endfunc

"
" Format numbers with SI prefixes in a way that is pleasing to humans
"
function format#SIPrefixDecimal(n) abort
  let prefixes = ['', 'k', 'M', 'G', 'T']
  let cur = a:n
  let i = 0
  while cur > 1000 && i < len(prefixes) - 1
    let cur = cur / 1000.0
    let i = i + 1
  endwhile

  return printf("%4.1f%s", cur, prefixes[i])
endfunc

"
" Format (combined) character for display, showing
" sequence of base and combining characters
"
" e.g. format#charSplit('a̲')  ->  a ◌̲   
"
" Uses base display character defined in: g:mayhem_unicode_combine_default
"
function format#splitChar(str) abort
  return char#split(a:str)
        \->map({i, v -> i == 0 ? char2nr(v) : [char2nr(s:combase), char2nr(v)]})
        \->flatten()
        \->list2str()
endfunc 

"
" Return an array with two statusline format strings
"
"  e.g. [(C)urrent, (N)ot-current]
"
" - Input: a single string or object, or an array of strings and/or objects
"  - If an input is an object, the value of keys 'N' and 'C' are used
" - Any instances of the subsitution token are replaced with 'N' or 'C'
"  - Default is '⸮', defined in g:mayhem_format_CN_token_default
" 
function format#CN(partorparts, sub = get(g:, 'mayhem_format_CN_token_default', '⸮')) abort
  let parts = (type(a:partorparts) == type([])) ? a:partorparts : [partorparts]
  return [
        \ mapnew(parts, {i,v -> (type(v) == type({})? get(v, 'C', get(v, 'N', 'C!')) : v)})
        \  ->map(parts, {i,v -> substitute(v, '⸮', 'C', 'g')})
        \  ->join(''),
        \ mapnew(parts, {i,v -> (type(v) == type({})? get(v, 'N', get(v, 'C', 'N!')) : v)})
        \  ->map(parts, {i,v -> substitute(v, '⸮', 'N', 'g')})
        \  ->join(''),
        \]
endfunc

