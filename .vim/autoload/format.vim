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

"
" Runs prettier on the input JSON string
"
function format#JSON(jsonString) abort
  return systemlist('npx prettier --stdin-filepath nameless.json', a:jsonString)
endfunc
"
" Apply code beautification to the contents of a buffer (or part thereof)
"
function format#buffer(bufnr = bufnr()) range abort
  let l:filetype = &filetype ?? 'html'
  let l:filename = expand('%') ?? 'nameless'
  let l:stdinpath = shellescape(l:filename .. '.' .. l:filetype)

  exec a:firstline .. ',' .. a:lastline .. '!npx prettier --stdin-filepath ' .. l:stdinpath
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
