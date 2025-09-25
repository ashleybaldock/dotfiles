if exists("g:mayhem_autoloaded_format") || &cp
  finish
endif
let g:mayhem_autoloaded_format = 1

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
  return substitute(a:str, '[0-9]',
        \ { m -> get(s:f_number, a:format, '0123456789')->strgetchar(
        \  m[0]->str2nr()
        \ )->nr2char()}, 'g')
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
    let s:f_session_lookup[f] = prefix..to[i]..suffix
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

