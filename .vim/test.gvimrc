"
"{{{1 Test menu, please ignore
"
exec 'an 200.101.100 Test.Test1.' .. format#session(printf("%14S", '0123456789')) .. '⏐ <Nop>'
exec 'an 200.101.110 Test.Test1.' .. format#session(printf("%14S", 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')) .. '⏐ <Nop>'
exec 'an 200.101.120 Test.Test1.a️b️c️d️e️f️g️h️i️j️k️l️m️n️o️p️q️r️s️t️u️v️w️xy️z️⏐ <Nop>'
exec 'an 200.101.130 Test.Test1.' .. format#session(printf("%14S", 'No Session')) .. '⏐ <Nop>'
exec 'an 200.101.140 Test.Test1.' .. format#session(printf("%14S", 'no session')) .. '⏐ <Nop>'
exec 'an 200.101.150 Test.Test1.1︎a︎2︎b︎i︎j︎3︎c︎4︎d︎5︎e︎6f︎⏐ <Nop>'
exec 'an 200.101.160 Test.Test1.' .. format#session(printf("%14S", 'A0B0C0    ZZ')) .. '⏐ <Nop>'
exec 'an 200.101.170 Test.Test1.ＡＢＣＤＥＦZZ⏐ <Nop>'

let s:g = '𝚐'
let s:gh = '𝚐 '
let s:gt = '𝚐 '
let s:G = '𝙶'
let s:Gh = '𝙶 '
let s:tab = "\\	\\	"

" let s:tests = [
"       \ s:gh->repeat(1)
"       \ s:gh->repeat(2)
"       \ s:gh->repeat(3)
"       \ s:gh->repeat(4)
"       \ s:gh->repeat(5)
"       \ s:gh->repeat(6)
"       \]
let s:r = 14
let s:GN = s:G->repeat(s:r)..s:Gh
let s:Gn = s:G->repeat(s:r + 1)
let s:gN = s:gh->repeat(s:r + 1)
let s:gn = s:gh->repeat(s:r)..s:g
for [i, t] in [
      \ s:GN->repeat(1), s:gN->repeat(1),
      \ s:GN->repeat(2), s:gN->repeat(2),
      \ s:GN->repeat(3), s:gN->repeat(3),
      \ s:GN->repeat(4), s:gN->repeat(4),
      \ s:GN->repeat(5), s:gN->repeat(5),
      \ s:Gn->repeat(1), s:gn->repeat(1),
      \ s:Gn->repeat(2), s:gn->repeat(2),
      \ s:Gn->repeat(3), s:gn->repeat(3),
      \ s:Gn->repeat(4), s:gn->repeat(4),
      \ s:Gn->repeat(5), s:gn->repeat(5),
      \]->items()
  exec printf("an 200.102.%03S ", i + 100) .. 'Test.Test2' .. t .. '\ ⏐ <Nop>'
endfor

for [i, t] in [
      \ s:G->repeat(1),  s:gh->repeat(1),
      \ s:G->repeat(2),  s:gh->repeat(2),
      \ s:G->repeat(3),  s:gh->repeat(3), 
      \ s:G->repeat(4),  s:gh->repeat(4), 
      \ s:G->repeat(5),  s:gh->repeat(5), 
      \ s:G->repeat(6),  s:gh->repeat(6), 
      \ s:G->repeat(7),  s:gh->repeat(7), 
      \ s:G->repeat(8),  s:gh->repeat(8), 
      \ s:G->repeat(9),  s:gh->repeat(9), 
      \ s:G->repeat(10), s:gh->repeat(10),
      \ s:G->repeat(11), s:gh->repeat(11),
      \ s:G->repeat(12), s:gh->repeat(12),
      \ s:G->repeat(13), s:gh->repeat(13),
      \ s:G->repeat(14), s:gh->repeat(14),
      \]->items()
  exec printf("an 200.203.%03S ", i + 100) .. 'Test.Test3.' .. t .. '\ ⏐ <Nop>'
endfor
for [i, t] in [
      \ s:G->repeat(2),  s:G..s:gh->repeat(1),  s:gh->repeat(2),
      \ s:G->repeat(3),  s:G..s:gh->repeat(2),  s:gh->repeat(3), 
      \ s:G->repeat(4),  s:G..s:gh->repeat(3),  s:gh->repeat(4), 
      \ s:G->repeat(5),  s:G..s:gh->repeat(4),  s:gh->repeat(5), 
      \ s:G->repeat(6),  s:G..s:gh->repeat(5),  s:gh->repeat(6), 
      \ s:G->repeat(7),  s:G..s:gh->repeat(6),  s:gh->repeat(7), 
      \ s:G->repeat(8),  s:G..s:gh->repeat(7),  s:gh->repeat(8), 
      \ s:G->repeat(9),  s:G..s:gh->repeat(8),  s:gh->repeat(9), 
      \ s:G->repeat(10), s:G..s:gh->repeat(9),  s:gh->repeat(10),
      \ s:G->repeat(11), s:G..s:gh->repeat(10), s:gh->repeat(11),
      \ s:G->repeat(12), s:G..s:gh->repeat(11), s:gh->repeat(12),
      \ s:G->repeat(13), s:G..s:gh->repeat(12), s:gh->repeat(13),
      \ s:G->repeat(14), s:G..s:gh->repeat(13), s:gh->repeat(14),
      \]->items()
  exec printf("an 200.204.%03S ", i + 100) .. 'Test.Test4.' .. t .. '\ ⏐ <Nop>'
endfor

