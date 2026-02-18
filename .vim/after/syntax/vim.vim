"
" Add 'wysiwyg' highlight groups for highlight attributes
"
" Also make undercurl etc. not show as errors
"
" au BufWritePost <buffer> syn on
"
" See Also: $VIMRUNTIME/syntax/vim.vim
"           ../syntax/vim.statusline.vim
"           ./common.vim
"

source <script>:p:h/common.vim

if expand('%:p') == expand('$VIMHOME/plugin/statusline.vim')
      \ || expand('%:p') == expand('$VIMHOME/autoload/statusline.vim')
  exec 'so ' .. expand('$VIMHOME/after/syntax/vim.statusline.vim')
endif

" Avoids syntax glitching when a pattern consists only of
" a combining character, variation selector etc.
"  e.g.: /󠅀/  /◌󠅀/ '/'‥'◌󠅀⁸¹'‥'/'
"        /̲/  /◌̲/ '/'‥'◌̲'‥'/'
syn region	vimSynRegPat	contained extend
      \ start="\Z\z([-`~!@#$%^&*_=+;:'",./?]\)"
      \ skip=/\\\\\|\\\z1\|\n\s*\\\|\n\s*"\\ /
      \ end="\Z\z1"
      \ contains=@vimSynRegPatGroup skipwhite
      \ nextgroup=vimSynPatMod,vimSynReg

syn keyword	vimHiAttrib	contained	undercurl underdotted underdouble
syn keyword	vimHiAttrib	contained	underdashed strikethrough

syn match	vimHiAttribList	contained	"\i\+"
      \ contains=vimHiAttrib,vimHiAttrBold,
      \   vimHiAttrUnLine,vimHiAttrUnCurl,
      \   vimHiAttrUnDbl,vimHiAttrUnDot,vimHiAttrUnDash,
      \   vimHiAttrStrike,vimHiAttrItalic,
      \   vimHiAttrInv,vimHiAttrRev,vimHiAttrStand,
      \   vimHiAttrNoCom,vimHiAttrNONE
syn match	vimHiAttribList	contained	"\i\+,"he=e-1
      \	nextgroup=vimHiAttribList
      \ contains=vimHiAttrib,
      \   vimHiAttrBold,vimHiAttrItalic,
      \   vimHiAttrStrike,vimHiAttrUnLine,vimHiAttrUnCurl,
      \   vimHiAttrUnDbl,vimHiAttrUnDot,vimHiAttrUnDash,
      \   vimHiAttrInv,vimHiAttrRev,vimHiAttrStand,
      \   vimHiAttrNoCom,vimHiAttrNONE

" syn keyword vimHiAttrBold   contained bold conceal cchar=􀅓
" syn keyword vimHiAttrUline  contained underline conceal cchar=􀅕
" syn keyword vimHiAttrUcurl  contained undercurl conceal cchar=􁆭
" syn keyword vimHiAttrUdble  contained underdouble conceal cchar=􀃤
" syn keyword vimHiAttrUdot   contained underdotted conceal cchar=􁊓􀍠􁢏
" syn keyword vimHiAttrUdash  contained underdashed conceal cchar=􀓔
" syn keyword vimHiAttrStrike contained strikethrough conceal cchar=􀅖
" syn keyword vimHiAttrItalic contained italic conceal cchar=􀅔
syn keyword vimHiAttrBold   contained bold
syn keyword vimHiAttrUnLine contained underline
syn keyword vimHiAttrUnCurl contained undercurl
syn keyword vimHiAttrUnDbl  contained underdouble
syn keyword vimHiAttrUnDot  contained underdotted
syn keyword vimHiAttrUnDash contained underdashed
syn keyword vimHiAttrStrike contained strikethrough
syn keyword vimHiAttrItalic contained italic
syn keyword vimHiAttrInv    contained inverse
syn keyword vimHiAttrRev    contained reverse
syn keyword vimHiAttrStand  contained standout
syn keyword vimHiAttrNoCom  contained nocombine
syn keyword vimHiAttrNONE   contained NONE

syn match vimHiFgBgSp /fg\|bg\|sp/ contained containedin=vimHiGuiFgBg contains=NONE

hi def vimHiAttrBold   guifg=ywnormf gui=bold
hi def vimHiAttrUnLine guifg=#009999 gui=underline     guisp=ywnormf
hi def vimHiAttrUnCurl guifg=#009999 gui=undercurl     guisp=ywnormf
hi def vimHiAttrUnDbl  guifg=#009999 gui=underdouble   guisp=ywnormf
hi def vimHiAttrUnDot  guifg=#009999 gui=underdotted   guisp=ywnormf
hi def vimHiAttrUnDash guifg=#009999 gui=underdashed   guisp=ywnormf
hi def vimHiAttrStrike guifg=#009999 gui=strikethrough guisp=ywnormf
hi def vimHiAttrItalic guifg=ywnormf gui=italic
hi def vimHiAttrInv    guifg=ywnormf gui=inverse
hi def vimHiAttrRev    guifg=ywnormf gui=reverse
hi def vimHiAttrStand  guifg=ywnormf gui=standout
hi def vimHiAttrNoCom  guifg=ywnormf gui=nocombine
hi def vimHiAttrNONE   guifg=#009999 gui=none

syn keyword vimCommand macm[enu] skipwhite nextgroup=@vimMenuList

syn keyword vimCommand maca[ction]

"
" Escaped Variation Selectors
"
" var vs01  = "\ufe00  \Ufe00  \UFE00  \U0000FE00"
" var vs16  = "\ufe0f  \Ufe0f  \UFE0F  \U0000FE0F"
" var vs17  = "\Ue0100 \Ue0100 \UE0100 \U000E0100"
" var vs256 = "\Ue01ff \Ue01ff \UE01FF \U000E01FF"
"
syn match VSel /\\u[Ff][Ee]0\x\|\\U0\{0,4}[Ff][Ee]0\x\|\\U0\{0,3}[eE]01\x\x/
      \ contained containedin=vimString
hi VSel guifg=#33aa00 guisp=#ffff00 gui=underdotted

"
" Within Comments
"
"▌️❮️􀆔＋E❯️▐️  
"
"▌️􀆁􀆔＋E 􀆂▐️  
"
"▌️᎗b ಄ ౼   ヿーᐸムマ〱􀆔＋Eᐳ▐️  
"
"▌️<􀆔> <️􀆔+E›︎▐️  
"
"▌️<️􀆔>️ + ‹︎E›️️▐️  
"
"▌️<️〈􀆔〉>️ + ⼕〱‹︎❰̶̶ ❰̵̶ ❱̵̶ ❱̶ ❰️̶❰️̶❰️̶E❱️̶❱️̶❱️̶❱️❱️❱️❱️❱️❱️❱️›️️▐️  
"
"┇️  􀆂⬥ ⬧ ⬨ ⬩ ⬪⬫⬮⬯ⵈⴳⵈⴴⵈⵃⵈⴵⵈⵝⵈ ⵗⵧⵂⵓⵧⵌ   ⵑ⵿᎗⵰ⵦ   «»⟨⟩❬❭⟪⟫❮❮︎❮️ ❯❯︎❯️ᖿᖾ ◢◣◤ ᐸᐳᐳᐸ   ⟨︎⟩︎❬︎❭︎⟪︎⟫︎❯︎‹️›️«️»️⟨️⟩️❬️❭️⟪️⟫️❮️❯️ ┇️
"┇️   ᒥᒧ ᒪᒣ ᒐᒉ ᒐᔐᒉ ᒐᒉ ᒋᒍ ᒋᔑᒍ ᔐᔐ  ᘂᔐᒉ ᔑᘃ ┇️
"┇️ ᘇᏁᏗᘄ  Ꮊᑀ ᘂᘃ ᗭᑐ ┇️
"┇️  ᑕᑐ ᑕᘄ ᘍᗉᗆᗕᗒ ᕮ ᐸᑀ ᑅᑀ ᕮᗒᕼᗕᕭ ᑪᕭ ᑢᕭᕮᑝ ᕮᕭ ᕳᕲ ᑪᑐ ᑕᑓ  ᗡᗞ ᗴᗱ ᗺᗱ ᗺᗷ ᗴᗷ ᙀ ᙁ ᘧᓗ ᖠᖢ ᖤ  ᘈᔈᕈ ᘃ  Ꮣᘉ  Ᏸ┇️
"┇️ ᘂ ᒐᒍ ᘃ ꭾꮅᏂ Ꮐ ᎵᎩYꭹy ᏓᏃᎯ Ꭻ ᓚᓗ ᓕᓓ ᓕᓗ ᓚᓓ ᓔᓓ  ᓏᓙ 𐑿           ᓇᓗ ᓚᓄ ᓕᓀ ᓂᓓ  ᓱᓕᓴᓱᓪᓓ   ᘇᘤ ᘇᘋ ᘳ ᘰ ᙅ ᙂ ᘓᘤ      ┇️
"┇️ ꭺ  ꭰ   ꮋꮖ   ꮮꮇ  ꮲ ꭱꮪ   ꮩꮃ  ꮓꮎꮾ Ꮻ ᎰᏆꮩꮑꭹ ᏓꭻᎱᏤᏞᏗ  ┇️
""
syn region KeyCombo contained containedin=vimLineComment oneline
      \ matchgroup=KeyComboEnds start="▌️"
      \ matchgroup=KeyComboEnds end="▐️"
      \ contains=KeyCombiner
syn region KeyCombo contained containedin=vimLineComment oneline
      \ matchgroup=KeyComboEnds start="┇️"
      \ matchgroup=KeyComboEnds end="┇️"
      \ contains=KeyCombiner
syn region KeyCombo contained containedin=vimLineComment oneline
      \ matchgroup=KeyComboEnds start="︙"
      \ matchgroup=KeyComboEnds end="︙"
      \ contains=KeyCombiner
syn match KeyCombiner /\Z[◥+＋<>ᐸᐳ􀆁􀆂ᖼᖽᖾᖿᒐᒉᘂᘃᒋᒍᒣᒪᒧᒥᗭᗪᑉ‹›«»⟨⟩❬❭⟪⟫❮❯◢◣◤]/ contained contains=NONE

syn region DemoCursorRange contained containedin=vimLineComment
      \ concealends
      \ matchgroup=Conceal start="󠀨"
      \ end="󠀩"

syn region DemoCursor contained containedin=DemoCursorRange
      \ concealends
      \ matchgroup=Conceal start="󠁛"
      \ end="󠁝"

hi def KeyCombo         guifg=#f9f9f9 guibg=#2255cc
hi def KeyComboEnds     guifg=bg      guibg=#2255cc
hi def KeyCombiner      guifg=#001199 guibg=#2255cc
hi def DemoCursorRange  guifg=#cc22dd guibg=#333333 guisp=#cc22dd gui=underline
" hi def link DemoCursor Cursor
hi def DemoCursor       guifg=#000000 guibg=#cc22dd

syn region CommentOptional
      \ matchgroup=CommentOptEnds start=/\%u005b\%ufe0f/
      \ matchgroup=CommentOptEnds end=/\%u005d\%ufe0f/
      \ contained containedin=Comment,vimLineComment
      \ extend keepend oneline contains=CommentOptional

hi def CommentOptional guifg=#af18df gui=italic
hi def CommentOptEnds  guifg=#8f18bf

" syn match CommentStart /^\s*\zs"/ contained contains=NONE containedin=Comment,vimLineComment
 " syn match CommentStart /^\s*\zs"/ contained containedin=Comment,vimLineComment contains=NONE conceal cchar=⎢
syn match CommentStart /^\s*\zs"/ contained containedin=Comment,vimLineComment contains=NONE conceal cchar=│

hi def CommentStart guifg=#cf28df guibg=#cf28df gui=none

syn match Modeline contained /\(^["#]\)\@<=\s\+vim:.*$/ containedin=Comment,vimLineComment

hi def link Modeline CommentHidden

" echo matchadd('Conceal', '^\s*".*\n\s*\zs"\ze.*\n\s*"', 10, -1, #{conceal: ''})
let s:multi_comment_matchids = []
let g:mayhem_conceal_comment = [
      \'┳',
      \'┃',
      \'┗',
      \'❙',
      \]
let g:mayhem_conceal_comment = [
      \'⍋',
      \'║',
      \'⍒',
      \'',
      \]
function! MultiComments() abort
  call foreach(s:multi_comment_matchids, {i, id -> matchdelete(id)})
  let s:multi_comment_matchids = [
        \matchadd('Conceal', '^\s*".*\n\s*\zs"\ze.*\n\s*"', 10, -1, #{conceal: '║'}),
        \matchadd('Conceal', '^\s*\%([^"]\|$\).*\n\s*\zs"\ze.*\n\s*\%([^"]\|$\)', 10, -1, #{conceal: '⎢'}),
        \matchadd('Conceal', '^\s*\%([^"]\|$\).*\n\s*\zs"\ze.*\n\s*"', 10, -1, #{conceal: '⍋'}),
        \matchadd('Conceal', '^\s*".*\n\s*\zs"\ze.*\n\s*\%([^"]\|$\)', 10, -1, #{conceal: '⍒'}),
        \]
endfunc
