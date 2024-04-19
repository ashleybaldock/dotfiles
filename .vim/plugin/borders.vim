
if exists("g:mayhem_loaded_borders")
  finish
endif
let g:mayhem_loaded_borders = 1

let g:mayhem = get(g:, 'mayhem', {})

"  ⎧ Title ╴╴⎫
"  ╎ item 1  ╎
"  ⎩         ⎭
let g:mayhem.borders_n1 = ['╴','╎',' ','╎', '⎧','⎫','⎭','⎩']

"  ⎫ Title ╴╴⎧
"  ╎ item 1  ╎
"  ⎭         ⎩
let g:mayhem.borders_n2 = ['╴','╎',' ','╎', '⎫','⎧','⎩','⎭']

"  ⎛ Title  ⎞⎫  ⎡  ⎤  ⎛  ⎞   ⎛  ⎞  
"  ⎢ item 1 ⎥⎨  ⎢  ⎥  ⎢  ⎥   ⎡  ⎤  ⎢  ⎥  
"  ⎝ item 2 ⎠⎭  ⎝  ⎠  ⎣  ⎦   ⎝  ⎠  ⎣  ⎦  
let g:mayhem.borders_bracket = [' ','⎥',' ','⎢', '⎛','⎞','⎠','⎝']

"  ⎞ Title  ⎛
"  ⎥ item 1 ⎢
"  ⎠ item 2 ⎝
let g:mayhem.borders_invbracket = ['╴','⎢',' ','⎥', '⎞','⎛','⎝','⎠']

"  ╭ Title  ╮    ⎧ Title  ⎫  ⎫ ⎧  ⎧  ⎫ ╭╴ Title  ╶╮
"  ⎩ item 1 ⎬╶──╴⎨ item 1 ⎪  ⎭ ⸢  ⎧  ⎫ ┟  item 1  ┧
"  ⎩ item 2 ⎭    ⎩ item 2 ⎭  ⎭ ⸤  ⎪  ⎪ ┠  item 2  ┨
"  ⎩ item 2 ⎭    ⎩ item 2 ⎭  ⎭ ⎩  ⎩  ⎭ ┗━━━━━━━━━━┛


let g:mayhem.borders_cocdefault = ['─', '│', '─', '│', '┌', '┐', '┘', '└']
let g:mayhem.borders_cocdefjoinchars = ['┬', '┤', '┴', '├']



" ┌┬┐┏┳┓┍┯┑┎┰┒╒╤╕╔╦╗╓╥╖
" ├┼┤┣╋┫┝┿┥┠╂┨╞╪╡╠╬╣╟╫╢║
" └┴┘┗┻┛┕┷┙┖┸┚╘╧╛╚╩╝╙╨╜═
