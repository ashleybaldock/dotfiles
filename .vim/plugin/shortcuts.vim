if exists("g:mayhem_loaded_shortcuts")
  finish
endif
let g:mayhem_loaded_shortcuts = 1

"
" Key Mappings: 􀇳
"
" See Also: ./mouse.vim
"          ../gvimrc
"
" (commands/functions are defined elsewhere)
"
"    Option: 􀆕 ⌥️  ⌥ ⌥︎   (<M-x> or <A-x>)
"
"  ‣ bound as resulting unicode character
"   e.g.
"  (option + 5)            􀆕 5  ──▷  ∞    :map ∞ <Nop>
"  (option + shift + 5)  􀆕 ⇧️ 5  ──▷  ﬁ    :map ﬁ <Nop>
"
"   Command: 􀆔 ⌘️  ⌘ ⌘︎   (<D-x>)
"
"  ‣ case-sensitive in mapping definition e.g. <D-e> != <D-E> 
"  ‣ must be un-mapped in ../gvimrc before being redefined
"
"     Shift: 􀆝 ⇧️  ⇧ ⇧︎
"
"      Ctrl: 􀆍 ^️  ^ ^︎
"
" Backspace: 􀆛 ⌫️  ⌫ ⌫︎
"
"     Space: 􁁺 ␣️  ␣ ␣︎
"
 
" ▌️ 􀆔 E ▐️────▷ LH Enter
cnoremap <D-e> <CR>
nnoremap <D-e> <CR>
inoremap <D-e> <CR>
xnoremap <D-e> <CR>

" ▌️ 􀆕 1 ▐️────▷ Start a command 
nnoremap ¡ :

" ▌️􀆝􀆕 1▐️────▷ Start a shell command 
nnoremap ⁄ :!

" ▌️ 􀆕 A️ ▐️────▷ Jump forward (^O)
nnoremap å           <C-o>
nnoremap <leader>o   <C-o>

" ▌️ 􀆕 S️ ▐️────▷ Jump backward (^I/<Tab>)
nnoremap ß           <C-i>
nnoremap <leader>i   <C-i>


" TODO 
"nnoremap <expr> §`i ExecAndPut('hi '..<c-r><c-w>)

" J for visual block mode
" gv"od:put o `[v`]J0"od$dd"oP

"
" Replace: Character under cursor with its escape code
"
nnoremap §u\ "=char#code()Pl


"
" Add Combining: 
" ▌️ 􀆕 0 ▐️────▷ C⃝ i⃝ r⃝ c⃝ l⃝ e⃝  + Re̲p̲e̲a̲t̲M̲o̲ve
nnoremap º a⃝ <Esc>h<Cmd>RepeatMove<CR>
xnoremap º :s/\%V\(^"\s*\)\?\S\{-}\zs\S\ze\S\{-}/\0⃝ /g<CR><Cmd>nohlsearch<CR> 
"
" ▌️􀆝􀆕 0▐️────▷ S⃞ q⃞ u⃞ a⃞ r⃞ e⃞  + RepeatMove
nnoremap ‚ a⃞ <Esc>h<Cmd>RepeatMove<CR>
xnoremap ‚ :s/\%V\(^"\s*\)\?\S\{-}\zs\S\ze\S\{-}/\0⃞ /g<CR><Cmd>nohlsearch<CR> 
"
" ▌️ 􀆕 - ▐️────▷ U̲n̲d̲e̲r̲l̲i̲n̲e̲ + RepeatMove
nnoremap – a̲<Esc>h<Cmd>RepeatMove<CR>
" ▌️ 􀆕 - ▐️────▷ U̲n̲d̲e̲r̲l̲i̲n̲e̲ visual selection, skip leading/trailing w̲h̲i̲t̲e̲s̲p̲a̲c̲e̲
" xnoremap – :s/\(\_^\s*"\)\?\s*\%V\S/\0̲/g<CR>
xnoremap – :s/\%V\(^"\s*\)\?\S\{-}\zs\S\ze\S\{-}/\0̲/g<CR><Cmd>nohlsearch<CR> 
"
" ▌️􀆝􀆕 -▐️──▷ O̅v̅e̅r̅l̅i̅n̅e̅ + RepeatMove
nnoremap — a̅<Esc>h<Cmd>RepeatMove<CR>
" ▌️􀆝􀆕 -▐️──▷ Overline visual selection, skip leading/trailing whitespace
xnoremap — :s/\%V\(^"\s*\)\?\S\{-}\zs\S\ze\S\{-}/\0̅/g<CR><Cmd>nohlsearch<CR> 
"<Cmd>nohlsearch<CR> 
" nno̅r̅e̅m̅a̅p <p̅l̅u̅g̅> a꛱<Esc><Cmd>RepeatMove<CR>
" nno̅r̅e̅m̅ap <plug> a꛰<Esc><Cmd>R̲̅̅epeatMove<CR>
"
"
" test
" 1̅3̅ 2̅5̅5̅ 5̅ 9̅
"
"
" Add Variation Selector:
" ▌️􀆕 =︎▐️──▷ ────▷ V️️a️r️i️a️t️i️o️n️ S️e️l️e️c️t️o️r️ 1️6️ + RepeatMove
nnoremap ≠ a️<Esc>h<Cmd>RepeatMove<CR>
" ▌️􀆕 =︎▐️──▷ Add V️️a️r️i️a️t️i️o️n️ S️e️l️e️c️t️o️r️ 1️6️  to all non-whitespace in visual area
xnoremap ≠ :s/\%V\(^"\s*\)\?\S\{-}\zs\S\ze\S\{-}/\0️/g<CR><Cmd>nohlsearch<CR> 
" ▌️􀆝􀆕 =︎▐️──▷ V︎a︎r︎i︎a︎t︎i︎o︎n︎ S︎e︎l︎e︎c︎t︎o︎r︎ 1︎5︎ + RepeatMove
nnoremap ± a︎<Esc>h<Cmd>RepeatMove<CR>
" ▌️􀆝􀆕 =︎▐️──▷ Add V︎a︎r︎i︎a︎t︎i︎o︎n︎ S︎e︎l︎e︎c︎t︎o︎r︎ 1︎5︎ to all non-whitespace in visual area
xnoremap ± :s/\%V\(^"\s*\)\?\S\{-}\zs\S\ze\S\{-}/\0︎/g<CR><Cmd>nohlsearch<CR> 

" Remove Combining:                                                       TODO
" ▌️􀆕 􀆛▐️──▷ Remove first combining (as apposed to last, like x) + RepeatMove
nnoremap <M-BS> <Nop>
" ▌️􀆕 􀆛▐️──▷ Remove first combining from all chars in visual area
xnoremap <M-BS> <Nop>
" ▌️􀆝􀆕 􀆛▐️──▷ Remove all combining chars + RepeatMove
nnoremap <M-BS> <Nop>
" ▌️􀆝􀆕 􀆛▐️──▷ Remove all combining chars from visual area+ RepeatMove
xnoremap <M-S-BS> <Nop>

" Expand Spaces:
" ▌️𝙣=️𝟣❙   􀆕 􁁺 ▐️──▷ Add count 𝙣 space(s) + RepeatMove
nnoremap   <Esc>h<Cmd>RepeatMove<CR>
" ▌️𝙣=️𝟣❙ 􀆝􀆕 􁁺 ▐️──▷ Remove (up to) 𝙣 space(s) + RepeatMove
nnoremap   <Esc>h<Cmd>RepeatMove<CR>
" ▌️𝙣=️𝟣❙   􀆕 􁁺 ▐️──▷ Add 𝙣 space(s) after each group of \W in visual area TODO
xnoremap   <Cmd>s/\%V\(^"\s*\)\?\S\{-}\zs\S\ze\S\{-}/\0️/g<CR><Cmd>nohlsearch<CR> 
" ▌️𝙣=️𝟣❙ 􀆝􀆕 􁁺 ▐️──▷ Remove (up to) 𝙣 space(s) from each \W group in visual area TODO
xnoremap   <Cmd>s/\%V\(^"\s*\)\?\S\{-}\zs\S\ze\S\{-}/\0️/g<CR><Cmd>nohlsearch<CR> 

" ▌️ 􀆕 E ▐️──▷ Replace word with last yanked (e.g. via yiw)
" nnoremap ´ ciw<c-r>0<Esc><Cmd>undojoin | yanked<CR>
" xnoremap ´ <Cmd>exec 'normal viw"0p<CR>' | undojoin | RepeatMove
" nnoremap ´ viw1"0gp
nnoremap §rp caw<c-r><c-r>0 <esc>w
" <bar> RepeatMove<CR>
" ▌️􀆝􀆕 E▐️──▷ Replace character with last yanked
nnoremap ‰ s<c-r>0<Esc><Cmd>RepeatMove<CR>
"
xnoremap <expr> ∑  mode() ==# "\x16" ? "<Cmd>MoveBlockUp<CR>" : "<Cmd>move -2<CR>"

" Move: Next Non-Whitespace
" ▌️ 􀆕 L ▐️────▷ Move to next non-whitespace character
nnoremap ¬ <Cmd>call search('\S', 'W', line('.'))<CR>
" ▌️ 􀆕 H ▐️────▷ Move to previous non-whitespace character
nnoremap ˙ <Cmd>call search('\S', 'bW', line('.'))<CR>
"
"  Word: (Under Cursor)
"Edit: §e       
" ╭️ §e️╮️───╸Quick Bookmarks╺────╮
" ╰️┃️━️┃️╯️──────────╯╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╭╌╌╌╌╌╌╌╌│
" ╰️ ━️━️ ╯️               Default      ┊ Rebind │
" │╌╌╌╌╌╌╌╌╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╎╌╌╌╌╌╌╌╌│
" │  §e1   ┊  $HOME/projects/       ┊  §E1   │
" │  §e2   ┊  $HOME/.vim/           ┊  §E2   │
" │  §e3   ┊  $HOME/.vim/plugin/    ┊  §E3   │
" │  §e4   ┊  $HOME/                ┊  §E4   │
" │  §e5   ┊  $HOME/                ┊  §E5   │
" │────────╯╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯╌╌╌╌╌╌╌╌│
" │         §e§ :  Select from PUM           │
" │╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌│
" │  :e    ⋮ same window     …force ⋮  :e!   │
" │╌╌╌╌╌╌╌╌╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╭╌╌╌╌╌╌╌╌│
" │  §ew   ┊         netrw̲          ┊  $eW   │
" │  §er   ┊    r̲evert to saved     ┊  §eR   │
" │  §ed   ┊   d̲uplicate current    ┊  §eD   │
" │  §ef   ┊       pick f̲ile        ┊  §eF   │
" │  §ec   ┊      c̲reate blank      ┊  §eC   │
" │╌╌╌╌╌╌╌╌╯╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯╌╌╌╌╌╌╌╌│
" │  §ev…  ⋮ vsplit    ╱╱     split ⋮  $es…  │
" │╌╌╌╌╌╌╌╌╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╭╌╌╌╌╌╌╌╌│
" │  §evv  ┊      s̲ame buffer       ┊  §ess  │
" │  §evd  ┊   d̲uplicate current    ┊  §esd  │
" │  §eva  ┊     a̲uto-derived¹      ┊  §esa  │
" │  §evc  ┊     c̲reate blank       ┊  §esc  │
" │  §evb  ┊   clipb̲oard contents   ┊  §esb  │
" │  §evt  ┊      pick t̲emplate     ┊  §est  │
" │  §evw  ┊         netrw̲          ┊  §esw  │
" │  §evf  ┊       pick f̲ile        ┊  §evf  │
" │  §evr  ┊    (r̲e)load saved      ┊  §esr  │
" │╴ ╴ ╴ ╴ ┆╴╴╴ ╴ ╴ ╴ ╴ ╴ ╌╭╌╌╌╌╌╌╌╌╯╴ ╴ ╴ ╴ │
" │  §ee   ┊   ./<select>  ┊  existing² or   │
" │  §eE   ┊   ./<select>  ┊  same or split³ │
" │╌╌╌╌╌╌╌╌╯╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌│
" │²⃝︎  §ee ⇉ ╶─?⃞╶┮[ if file is open already ] ╎
" ╎           ∇ └─▷ jump to existing window  ╎
" ╎³⃝  §eE ⇉ ╶─?⃞╶┮[ if window can be reused ] ╎
" ╎           ┆ └─▷ replace current          ╎
" ╎           ╰─▷ open in split              ╎
" ╎ Notes:                                   ╎
" ╎                                          ╎
" ╎¹⃝  derived: blank, same filetype          ╎
" ╵╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╵
nnoremap §ee :e 
nnoremap §eE :e 
nnoremap §e§ :e ~/.vim/

nnoremap §ew :e ./
nnoremap §eW :e! ./

nnoremap §er <Cmd>e %<CR>
nnoremap §eR <Cmd>e! %<CR>

nnoremap §ef <Cmd>e .<CR>
nnoremap §eF <Cmd>e .<CR>

nnoremap §ec <Cmd>enew<CR>
nnoremap §eC <Cmd>enew!<CR>

nnoremap §ed <Cmd>DuplicateBuffer<CR>
nnoremap §eD <Cmd>DuplicateBuffer!<CR>


" Horizontal
nnoremap §ess <Cmd>sp<CR>
nnoremap §eS :sp! ./
nnoremap §esa :exec ':new +setlocal\ ft='..&l:filetype
nnoremap §esc <Cmd>new<CR>
nnoremap §esz <C-W>v"+gP
nnoremap §esx :InsertTemplate 
nnoremap §esw :sp ./
nnoremap §esd <Cmd>sp .<CR>
nnoremap §esr <Cmd>sp %<CR>

" Vertical
nnoremap §eV :vsp! ./
nnoremap §evv <Cmd>vsp<CR>
nnoremap §evd <Cmd>DuplicateBuffer vnew<CR>
nnoremap §eva :exec ':vnew +setlocal\ ft='..&l:filetype
nnoremap §evc <Cmd>vnew<CR>
nnoremap §evz <C-W>v"+gP
nnoremap §evx :InsertTemplate 
nnoremap §evw <Cmd>vsp ./
nnoremap §evd <Cmd>vsp .<CR>
nnoremap §evr <Cmd>vsp %<CR>


nnoremap <expr> §e1 ':e '..get(g:, 'mayhem_quick1', '~/projects/')..''
nnoremap <expr> §e2 ':e '..get(g:, 'mayhem_quick2', '~/.vim/')..''
nnoremap <expr> §e3 ':e '..get(g:, 'mayhem_quick3', '~/.vim/plugin/')..''
nnoremap <expr> §e4 ':e '..get(g:, 'mayhem_quick4', '~/')..''
nnoremap <expr> §e5 ':e '..get(g:, 'mayhem_quick5', '~/')..''
nnoremap §e2 :e ~/.vim/
nnoremap §e3 :e ~/.vim/plugin/
nnoremap §e4 :e ~/
nnoremap §e5 :e ~/
nnoremap §E1 <Cmd>let g:mayhem_quick1=getcwd()..'/'<CR>
nnoremap §E2 <Cmd>let g:mayhem_quick2=getcwd()..'/'<CR>
nnoremap §E3 <Cmd>let g:mayhem_quick3=getcwd()..'/'<CR>
nnoremap §E4 <Cmd>let g:mayhem_quick4=getcwd()..'/'<CR>
nnoremap §E5 <Cmd>let g:mayhem_quick5=getcwd()..'/'<CR>

nnoremap <S-tab>     :CtrlP<CR>
nnoremap <leader>p   :CtrlP<CR>

"
" Sessions And Splits: §s
" See: ./sessions.vim
"
nnoremap §sq <Cmd>Session info<CR>
nnoremap <expr> §sc ':Session create '..expand('%:p:h')
nnoremap §se :Session load 
" nnoremap §s  :Session pause<CR>
" nnoremap §s  :Session resume<CR>
" nnoremap §s  :Session delete<CR>

"
" Window: §w - Windows & Splits
"
" §§w - open hint popup      􀏇

" §w1 - layout 1 (columns)   􀧈
" §w2 - layout 2 (rows)      􀧊
" §w3 - layout 3 (bitofboth) 􀏝
" §w4 - layout 4 (sideof)    􀱤 􀱥
" §w5 - layout 5 (some)      􀧌
" §w6 - layout 6 None        􀇴
"
" §ww - sWap with window     􁁀
" §wq - close window         􀣤
"
" §wx - eXpand window        􀠹
" §wf - Fix window size      􀢈
"
" layout 1,3,4
"     - promote window (rhs) 􀥟
"     - promote window (lhs) 􀥞
"     layout 3
"     - promote window (top) 􀣾
" layout 4
"  - promote window to main  􀥝
" 
nnoremap §ws <Cmd>sp<CR>
nnoremap §wv <Cmd>vsp<CR>

"
" Write: §w - Write
"
nnoremap §ww <Cmd>w<CR>
nnoremap §wW <Cmd>w!<CR>
nnoremap §wa <Cmd>wa<CR>

"
" Help: §h
"
nnoremap §hr <Cmd>vsplit ~/.vim/notes/regex.md<CR>

nnoremap §hf <Cmd>vsplit ~/.vim/notes/cmdfuncmap.md<CR>

"
" Highlighting
"
" See: ./highlight.vim
nnoremap §<S-i> <Cmd>so $VIMRUNTIME/syntax/hitest.vim<CR>
nnoremap §i <Cmd>SynFo<CR>
" nnoremap <D-i> <Cmd>SynFo<CR>
nnoremap §I <Cmd>SynFoWindowToggle<CR>
" nnoremap <D-I> <Cmd>SynFo<CR>
"
" ▌️ ga ▐️  Info about character under cursor (Characterize)
nmap ga <Plug>(mayhem_charinfo)


"─── Column guides ─────────────────────────────────────
"
" See: ./colcols.vim
"      ../autoload/colcols.vim
" ▌️ § ‥  \ ▐️──▷ 
nnoremap §\ <Plug>(mayhem_colcol_add)
" ▌️ § ‥⌥️ \ ▐️──▷ 
nnoremap §« <Plug>(mayhem_colcol_delete)
" ▌️ § ‥  ]️ ▐️──▷ 
nnoremap §] <Plug>(mayhem_colcol_align_right_to_next)
" ▌️ § ‥⇧️ ]️ ▐️──▷ 
nnoremap §} <Plug>(mayhem_colcol_align_right_on_next)
" ▌️ § ‥  [️ ▐️──▷ 
nnoremap §[ <Plug>(mayhem_colcol_align_left_to_next)
" ▌️ § ‥⇧️ [️ ▐️──▷ 
nnoremap §{ <Plug>(mayhem_colcol_align_left_on_next)
" ▌️ § ‥️⌥️ ]️ ▐️──▷ 
nnoremap §‘ <Plug>(mayhem_colcol_cursor_next)
" ▌️ § ‥⌥️ [️ ▐️──▷ 
nnoremap §“ <Plug>(mayhem_colcol_cursor_prev)
" inoremap  <Cmd>AlignRightToColorColumn<CR>

"    Option: 􀆕 ⌥️  ⌥ ⌥︎   (<M-x> or <A-x>)
"     Shift: 􀆝 ⇧️  ⇧ ⇧︎

"
" Editing:
"
" Swap:
" word <-> following whitespace ('right align')
" (V, pick lines, :)
" TODO make this work with visual block + only swap first/nearest to cursor
nnoremap §ar <Cmd>s/\s*\zs\(\w*\)\(\s*\)/\2\1/g<CR><Cmd>noh<CR>
xnoremap §ar <Cmd>s/\s*\zs\(\w*\)\(\s*\)/\2\1/g<CR><Cmd>noh<CR>

" words around pivot     (AAA,BBB -> BBB,AAA
"  (Swaps the first two words found in selection)
nnoremap §as <Cmd>s/\%V\(\w\+\)\(\W\+\)\(\w\+\)/\3\2\1<CR><Cmd>noh<CR>
xnoremap §as <Cmd>s/\%V\(\w\+\)\(\W\+\)\(\w\+\)/\3\2\1<CR><Cmd>noh<CR>
" words around cursor (AD̲G -> ED̲C | AA, ̲XX -> XX, ̲AA | AB̲C XX -> CB̲A XX)
nnoremap §ac <Cmd>keeppatterns :s/\(\w\+\)\(\W*\%#\W*\)\(\w\+\)/\3\2\1<CR><Cmd>noh<CR>
"
"
" Move Token:
"   {token} back/forward in {container}       TODO
"
"  Cursor moves with the shifted item
" (This is essentially the same as swapping around
"   a pivot, but repeated)
" 󠄀󠄁󠄂e.g. [ 'a', 'b̲', 'c' ] -> [ 'a', 'c', 'b' ]
" Swap to Rightgg
" e.g. [ aaa,󠀨 󠁛b󠁝bb󠀩, ccc ] -> [ aaa, ccc, 󠀨󠁛b󠁝󠀩bb ]
nnoremap §ax :keeppatterns :s/\(\w\+\)\(\W*\%#\W*\)\(\w\+\)/\3\2\1<CR>
" Swap to Left 󠇫󠇬󠇌󠀀󠀕󠀩󠁒󠀼󠁥󠁩󠁽󠅗󠅗󠅗󠄗󠄗󠅃 󠁾󠄀
" e.g. [ a,_b̲_̓ c ] -> [ b, a, c ]
nnoremap §az :keeppatterns :s/\(\w\+\)\(\W*\%#\W*\)\(\w\+\)/\3\2\1<CR>

" Move Block:
" Select visual block (<C-v> etc.) 
" x - cut block replacing it with whitespace
xnoremap <expr> x  mode() ==# "\x16" ? "y<ESC>gvr<Space>" : "x"
xnoremap <expr> v  mode() ==# "\x16" ? "y<ESC>1vp" : "v"
" h 3h - move block left by 1, by 3
" j 3j - move block down by 1, by 3
" k 3k - move block up by 1, by 3
" l 3l - move block right by 1, by 3

"
" Move Lines:
"  Normal:
" 
" ▌️􀆕 􁾲  ▐️────▷ Move line up
nnoremap <M-Up> <Cmd>move -2<CR>
" ▌️􀆕 􁾳  ▐️────▷ Move line down
nnoremap <M-Down> <Cmd>move +1<CR>
" ▌️ 􀆕 w ▐️────▷ Move line up
nnoremap ∑ <Cmd>move -2<CR>
" ▌️⇧️ 􀆕 w▐️────▷ Move line down
nnoremap „ <Cmd>move +1<CR>
"
"  Visual: (v/V)
"          ╭W⃝  ─▷ Up
" ╭▷ ⇧⃝ 𝄐⌥⃝ 𝄐┴S⃝  ─▷ Down
"
command! -range MoveBlockUp <Nop>                     "  TODO
command! -range MoveBlockDown <Nop>                   "  TODO
" command! -range MoveBlockLeft <Nop>                   "  TODO
" command! -range MoveBlockRight <Nop>                  "  TODO
" Shift line(s) up/down (taking cursor with them) TODO
"              ⎧ Visual ╷ v/V ╷ ^V  ⎫
"              │╴╴╴╴╴╴╴╴┤╴╴╴╴╴┤╴╴╴╴╴┤
"        ╭╴W⃝  ──▷ Up    │  y  │  y  │
"        ├╴S⃝  ──▷ Down  │  y  │  y  │
"        ├╴A⃝  ──▷ Left  │     │  y  │
" ╭▷  ⌥⃝ 𝄐┴╴D⃝  ──▷ Right │     │  y  │
" ▌️􀆕 􁾲  ▐️────▷ Move selection  up
xnoremap <expr> <D-Up> mode() ==# "\x16" ? "<Cmd>MoveBlockUp<CR>" : "<Cmd>move -2<CR>"
xnoremap <expr> ∑  mode() ==# "\x16" ? "<Cmd>MoveBlockUp<CR>" : "<Cmd>move -2<CR>"
" ▌️􀆕 􁾳  ▐️────▷ Move selection down
xnoremap <expr> <D-Down> mode() ==# "\x16" ? "<Cmd>MoveBlockDown<CR>" : "<Cmd>move +1<CR>"
xnoremap <expr> „  mode() ==# "\x16" ? "<Cmd>MoveBlockDown<CR>" : "<Cmd>move +1<CR>"
" xnoremap <expr> å  mode() ==# "\x16" ? ":MoveBlockLeft" : ":echo Try with ^V"
" xnoremap <expr> ∂  mode() ==# "\x16" ? ":MoveBlockRight" : ":echo Try with ^V"
"
" Add Lines:
"  Extend 'o'/'O' to keep cursor on current line when count is > 1
nnoremap <expr> o v:count > 0 ? 'm`:<C-u>exe "norm! ' .. v:count .. 'o"<CR>``' : "o"
nnoremap <expr> O v:count > 0 ? 'm`:<C-u>exe "norm! ' .. v:count .. 'O"<CR>``' : "O"

"
" Line Drawing                                    TODO
"
" Box Drawing                                     TODO
" - Draw a box around visual block selection
"

"
" Source: §r
"
" nnoremap §rf :if &filetype=='vim' && $HOME . '/.vim/ :so<CR>
"
" Source Saved Version:
"
nnoremap <expr> §rf  &ft == 'vim' ? "<Cmd>UnsetAndReload<CR>" : "<Cmd>echo Not a vim file (override with §rF)<CR>"
nnoremap §rF <Cmd>UnsetAndReload<CR>
"
" Save Then Source:
"
nnoremap <expr> §rs  &ft == 'vim' ? "<Cmd>w :so %<CR>" : "<Cmd>echo Not a vim file (override with §rS)<CR>"
nnoremap §rS <Cmd>w :so %<CR>
"
" Source Buffer: (doesn't refresh everything)
"
nnoremap <expr> §re  &ft == 'vim' ? "<Cmd>so<CR>" : "<Cmd>echo Not a vim file (override with §rE)<CR>"
nnoremap §rE <Cmd>so<CR>
"
" Execute Visual Selection:
" TODO prompt for confirmation if not in a vim file, or not in ~/.vim/
" TODO skip any comment character at the start of the line
"
" substitute(@", '^[#"]\s*', '', '')
"
xnoremap <expr> §rr  &ft == 'vim' ? '"xy:@x<CR>' : "<Cmd>echo Not a vim file (override with §rR)<CR>"
xmap §rR "xy:@x<CR>
"
" Exec Line:
" :command! -bar -range Exe execute join(getline(<line1>,<line2>),"\n")
" TODO
"
" Exec Contents Of Markdown Code Block:
" TODO if type is vim, source, type is bash, run script etc.
"
" Source Current Line:
" TODO prompt for confirmation if not in a vim file, or not in ~/.vim/
" TODO skip any comment character at the start of the line
" TODO make this work with multi-line commands with line continuation
"
nnoremap <expr> §rr  &ft == 'vim' ? "<Cmd>.,.so<CR>" : "<Cmd>echo Not a vim file (override with §rR)<CR>"
nnoremap §rR <Cmd>.,.so<CR>
"
" Source Vimrc:
"
nnoremap §rv <Cmd>so expand('$VIMHOME/vimrc')<CR>


" nnoremap §rr :^[^\\]*\_$\n\%(\_^\s*\\.*\_$\n\)\+\ze\_^[^\\]*$
" §
" Source current line continuation
" (From first previous non-continued line to last
" subsequent one)
"
" Matches a continuation line
" \%(\_^\s*[\\].*\_$\)
" Matches a line and all subsequent continuated bits
" \_^.*\_.\%(\_^\s*\\.*\_.\)
" ^[^\\]*\_$\%(\_^\s*\\.*\_$\)\+\ze\_^[^\\]*$
"
" Matches a non-continuation line, followed by all
" lines until the next non-continuation line
" ^[^\\]*\_$\n\%(\_^\s*\\.*\_$\n\)\+\ze\_^[^\\]*$
" \(.*\%#\)\@=\(^[^\\]*\_$\n\%(\_^\s*\\.*\_$\n\)\+\ze\_^[^\\]*$\)\@>\(\%#.*\)\@<=
"
" Match current line as a continuation
" /\zs\%(\%.l\_^\s*[^\\].*\_$\)\+/
" 


" s/^[[:blank:]"]*\zs.*/
" %s/,\ /,/g
"
" %s/\s\+$//e

" Remove blank lines
" :g/^$/d


"
" Columns:
"

" Align selected text in columns
"
" %!column -t

" Split tab-separated columns into arrays
" %s/^	/    ["/g
" %s/	.*\zs\ze$/"],/g
" %s/	/", "/g
"
" %s/^	/    "/g
" %s/	.*\zs\ze$/",/g
" %s/	/": "/g


" 
" Formatting: §f §p
"
" Prettify: §p
"
nnoremap §p <Plug>(mayhem_format_buffer)
" nnoremap §p %!npx prettier --stdin-filepath shellescape(expand('%'))<CR>

"

" CSS:
" See also: ./css.vim
"
" Hex codes
" §fH ⇉  To UPPERCASE
" §fh ⇉  To lowercase
" §fX ⇉  Expand  (#F0E ▬▶︎ #FF00EE / #FB3A ▬▶︎ #FFBB33AA)
" §fx ⇉  Compact (#F0E ▬▶︎ #FF00EE / #FB3A ▬▶︎ #FFBB33AA)
nnoremap §fH :UppercaseHex
nnoremap §fh :LowercaseHex
nnoremap §fX :ExpandHex
"
" Variables
" $fv ⇉  Extract                                  TODO
" $fV ⇉  Inline                                   TODO
"   name: value;  ▬▶︎  --name: value;
"                       name: var(--name);
"
"   name: value;  ▬▶︎  name: var(--name, value);
"                     [ +yank:  --name: value; ]
"
"


"
" Copy And Yank: §y,<⌥⃣ ‑c>
"
"
nnoremap §y <Nop>
" <⌥⃣ ‑c> ▬▶︎ ç
nnoremap <silent> ç <Nop>


"
" Quickfix: §q
"
nnoremap §q :windo lcl\|ccl<CR>
"
nmap <silent> <leader>q <Plug>(qf_qf_toggle_stay)
nmap <silent> <leader>l <Plug>(qf_loc_toggle)
"
"
nnoremap <leader>e   :Explore<CR>
nnoremap <leader>es  :Sexplore<CR>
nnoremap <leader>ev  :Vexplore<CR>
"
"
nnoremap <leader>t   :set guifont=Menlo:h14<CR>
nnoremap <leader>tt  :set guifont=Menlo:h16<CR>
nnoremap <leader>ttt :set guifont=Menlo:h18<CR>
"
"
nnoremap        §t   :set list!<CR>
nnoremap <leader>L   :set list!<CR>
"
" Repeat last edit n times
nnoremap . :<C-u>execute "norm! " . repeat(".", v:count1)<CR>




"
" Search:
"
"  Clear: last search highlighting
"
nnoremap            §c :nohlsearch<CR>
nnoremap <silent> <CR> :nohlsearch<CR><CR>

" ▌️ :ag ▐️────▷ Command line abbreviation
cnoreabbrev ag :CdProjectRoot <bar> AckInput<CR>

" Searching
" cnoreabbrev ag :CdProjectRoot <bar> Ack! -Q --
" nnoremap <Leader>a :Ack!<Space>
" <C-r><C-w> - gets word under cursor
" <C-r>/     - gets last search string
" nnoremap <Leader>' :CdProjectRoot <bar> Ack! <C-r><C-w><CR>
" nnoremap <Leader>" :CdProjectRoot <bar> Ack! <C-r>/<CR>

"  Current Buffer:
"
"  Word Under Cursor:
"
" Normal:
" ▌️ ⇧️ 3 ▐️────▷ Seach backward for word under cursor
" ▌️ ⇧️ 8 ▐️────▷ Seach forward for word under cursor
" Visual:
" ▌️ ⇧️ 3 ▐️────▷ Seach backward for visual selection
" ▌️ ⇧️ 8 ▐️────▷ Seach forward for visual selection
"
" ▌️ \\  ▐️────▷ Put word under cursor into search register & highlight
nnoremap <silent> <Leader>\ :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
" ┌───────────┬────────────────┬───────────────────┐
" │ highlight │ …and jump to   │ Limit search to   │
" │   only    │ prev ◁╯╰▷ next │                   │
" ├───────────┼────────────────┼───────────────────┤
" │   \\      │   *        #   │ (word boundaries) │
" │           │  g*       g#   │ (anywhere)        │
" └───────────┴────────────────┴───────────────────┘
"
"  Current Project:
"
"  See: ./search.vim
"       ./projectRoot.vim
"
"  TODO:
"    - way to expand search to next root level up
"    - search without root scoping
"    - include hidden .folders
"    - fuzzy search
"
" Normal:
" ▌️ 􀆕 3 ▐️────▷ Seach for word under cursor
nnoremap # :CdProjectRoot <bar> AckCurrentWord<CR>
" ▌️ 􀆕 8 ▐️────▷ Seach for word under cursor
nnoremap • :CdProjectRoot <bar> AckCurrentWord<CR>
" ▌️ \'  ▐️────▷ Seach for word under cursor
nnoremap <Leader>' :CdProjectRoot <bar> AckCurrentWord<CR>
" ▌️ \"  ▐️────▷ Seach for last internal search term
nnoremap <Leader>" :CdProjectRoot <bar> AckLastSearch<CR>
"
" Visual:
" ▌️ 􀆕 3 ▐️────▷ Seach for visual selection
xnoremap # y<ESC>:CdProjectRoot <bar> AckClipboard<CR>
" ▌️ 􀆕 8 ▐️────▷ Seach for visual selection
xnoremap • y<ESC>:CdProjectRoot <bar> AckClipboard<CR>
"
"
" vnoremap <silent> <Leader>* :<C-U>
"   \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
"   \gvy:let @/=substitute(
"   \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR>
"   \gV:call setreg('"', old_reg, old_regtype)<CR>:set hls<CR>

" ╭──▷       ────▷ Search
" vnoremap §s y<ESC>/<c-r>"<CR> 
" ╭──▷       ────▷ Replace, delimiter: /
" xnoremap §r y<ESC>:%s/<c-r>"//g<Left><Left>
" vnoremap §s "xy:%s//

" ▌️ 􀆕 2 ▐️────▷ Left-hand /
nnoremap € /
xnoremap € <ESC>/

" ▌️􀆕 ⇧️ 2▐️────▷ Start new :substitute (whole buffer)
nnoremap ™ :%s///g<Left><Left>
" ▌️􀆕 ⇧️ 2▐️────▷ Start new :substitute (visual area)
xnoremap ™ :s///g<Left><Left>

" Or this, which uses register '/'
" :%s///<replacement>/g
" :%s/<c-r>///g<Left><Left>

" Substitute using register 'a'
" :%s/a/<replacement>/g
" :%s/<c-r>a//g<Left><Left>

" register does not contain char
" getreg('<reg>') !~ '\S'

" *E146*
" Instead of the '/' which surrounds the pattern and replacement string, you
" can use any other single-byte character, but not an alphanumeric character,
" '\', '"'' or '|'.  This is useful if you want to include a '/' in the search
" pattern or replacement string.  Example:
"   :s+/+//+
" let l:slash = exists('+shellslash')
"     && !&shellslash ? '\' : '/'
" if count(getcwd(), l:slash) > 3
"   

" J:
" ╭──▷    ⌥⃝ 𝄐J⃝   ────▷ join line below to end (with no space between)
" nnoremap ∆ Jx
" ╭──▷ ⇧⃝ 𝄐⌥⃝ 𝄐J⃝   ────▷ reverse of  ⌥⃝ 𝄐J⃝ 
nnoremap Ô i<CR><Esc>k$

" Display line movements, except with count
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" K:
"─────────────────────────────────────────────────────
"            │             │   f text
"  􀆕 K   ˚  │             │   line o̲
"─────────────────────────────────────────────────────
" 􀆝 𝄐J⃝   J   │ line o̲      │   line o f̲ text
" <S-j>      │ f text      │       
"─────────────────────────────────────────────────────
"  𝄐J⃝   ∆   │ line o̲      │   line of̲ text
" <M-j>      │ f text      │       
"─────────────────────────────────────────────────────
" inverse of │ f text      │
" ⇧⃝ 𝄐J⃝       │ line o̲      │   line o f̲ text
"─────────────────────────────────────────────────────
" ⌥⃝ 𝄐K⃝   ˚   │    f text   │          
" <M-k>      │    line o̲   │      line of̲ text
"─────────────────────────────────────────────────────
"            │             │
"            │    line o   │

" ╭──▷    ⌥⃝ 𝄐K⃝   ────▷ join line above to end (with no space between)
nnoremap ˚ :m -2,+<CR><S-j>
" ╭──▷ ⇧⃝ 𝄐⌥⃝ 𝄐K⃝   ────▷ reverse of <S-K>
nnoremap  i<CR><Esc>:m -2<CR>j$

"
" Visual Mode Tweaks:
"
" move to next displayed line in 
" mode v (but not V or )
"  (useful with wrap on)
xnoremap <expr> j  mode() ==# "v" ? "gj" : "j"
xnoremap <expr> gj mode() ==# "v" ? "j"  : "gj"
xnoremap <expr> k  mode() ==# "v" ? "gk" : "k"
xnoremap <expr> gk mode() ==# "v" ? "k"  : "gk"
" Disarm trap
xnoremap u <Nop>

" 
" Selection:
"
" ▌️ gp ▐️  (Re)Select last edited/yanked area
nnoremap <expr> gp '`[' .. getregtype()[0] .. '`]'
" ▌️ gv ▐️  (Re)Select last visual area

" insert/append in visual blockwise
" i = I, a = A, 
xnoremap <expr> i  mode() ==# "\x16" ? "I" : "i"
xnoremap <expr> a  mode() ==# "\x16" ? "A" : "a"
"║      n,v,V        ║        ^V       ║ 
"║    J, linewise    ║  J, blockwise:  ║ 
"║                   ║                 ║                
"║ A B┆C┆  ABCDEFGHI̲ ║  A B┆C┆  ABCJKL ║  A B┆C┆  ABCL  
"║ D E┆F┆  JKL       ║  D E┆F┆  DEFMNO ║  D E┆F┆  DEFO  
"║ G H┆I̲┆  MNO       ║  G H┆I̲┆  GHIPQR̲ ║  G H┆I̲┆  GHIR̲  
"║ J K L   PQR       ║  J K L   ↑      ║  J K L   JK    
"║ M N O   ↑         ║  M N O   ↑      ║  M N O   MN    
"║ P Q R   ↑         ║  P Q R   ↑      ║  P Q R   PQ    
"
 
xnoremap <expr> x  mode() ==# "\x16" ? "y<ESC>gvr<Space>" : "x"
xnoremap <expr> v  mode() ==# "\x16" ? "y<ESC>1vp" : "v"
 


"
" Diff: §d
"
nnoremap §dd :diffthis<CR>
nnoremap §de :diffget<CR>
nnoremap §dt :diffput<CR>
nnoremap §dx :diffoff<CR>
nnoremap §dq :diffoff!<CR>
nnoremap §dr :diffupdate<CR>
nnoremap §df :DiffWithSaved<CR>
nnoremap §dv :DiffWithPaste<CR>


"
" Coc:
"
" ▌️􀆕 r▐️──▷ 
" <⌥⃣ ‑r> ▬▶︎ ®
" nmap <silent> ® <Plug>(coc-range-select)
xmap <silent> ® <Plug>(coc-range-select)

" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" nnoremap <silent><nowait> <space>o  :call ToggleOutline()<CR>

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

"
" See: ./commands.coc.vim
"
" ╔═╾Diagnostics╼═════════╦══════════════════════════╗
" ║           ║ [] ➤ next ║ ]] ➤ next most important ║
" ║ [[ ➤ list ║           ║  ß <⌥⃣ ‑s>                ║
" ║ ¡ (<⌥⃣ +1>)╠═══════════╬══════════════════════════╣
" ║           ║ ][ ➤ prev ║                          ║
" ║           ║ å (<⌥⃣ ‑a>)║                          ║
" ╚═══════════╩═══════════╩══════════════════════════╝
nmap <silent> [[  :<C-u>CocList diagnostics<CR>
nmap <silent> ][ <Plug>(coc-diagnostic-prev)
nmap <silent> [] <Plug>(coc-diagnostic-next)
nmap <silent> ]] :NextWorstDiagnostic<CR>
nmap <D-d> :NextWorstDiagnostic<CR>

" <⌥⃣ ‑[⃣ > ▬▶︎ “
nnoremap “ :CocCommand document.jumpToPrevSymbol<CR>
" <⌥⃝ _]⃝ > ▬▶︎ ‘
nnoremap ‘ :CocCommand document.jumpToNextSymbol<CR>

" Symbol renaming.
" ⌈⌥⃣ ⍚R⃣ > ▬▶︎ ®
nnoremap ® <Plug>(coc-rename)
nnoremap <silent> <C-g><C-r> <Plug>(coc-rename)

" GoTo code navigation.
" ǀ⇧⃣ ǀ⌥⃣ ǀD⃣ ǀ ▬▶︎ Î
nnoremap Î   :call CocAction('definitions')<CR>
" ꜔ ⃣ ː⌥⃣ ːD⃣ ˧ ▬▶︎ ∂
nnoremap ∂   :call CocAction('jumpDefinition')<CR>
" nnoremap ∂   :JumpSomewhere

"nnoremap <silent>   :call CocAction('declarations')<CR>
"nnoremap <silent>   :call CocAction('jumpDeclaration')<CR>
" nnoremap <silent> ‰ :call CocAction('implementations')<CR>
" ▌️􀆝􀆕 E▐️──▷ 
nnoremap <silent> ‰ :call CocAction('jumpImplementation')<CR>
"nnoremap <silent>   :call CocAction('typeDefinitions')<CR>
nnoremap <silent> <C-g><C-t> :call CocAction('jumpTypeDefinition')<CR>
" >⇧⃣ -⌥⃣ ‑R⃣ < ▬▶︎ Â
nnoremap Â :call CocAction('jumpReferences')<CR>
nnoremap <silent>  gr :call CocAction('references')<CR>
"nnoremap <silent>    :call CocAction('jumpReferences')<CR>
"nnoremap <silent>    :call CocAction('jumpUsed')<CR>


" Fixes, Formatting, and Code Actions
"
" <⌥⃣ ‑f> ▬▶︎ ƒ
nnoremap <silent> ƒ <Plug>(coc-fix-current)
"
" Choose Code Actions:
"
" … for current line
nnoremap <silent> §2 <Plug>(coc-codeaction-line)
nnoremap <silent> <D-f> <Plug>(coc-codeaction-line)
"
" … for current selection
vnoremap <silent> <D-f> <Plug>(coc-codeaction-selected)
"
" … for current file
nnoremap <silent> §3 <Plug>(coc-codeaction-source)
nnoremap <silent> <D-F> <Plug>(coc-codeaction-source)
"
nnoremap <leader>cf  <Plug>(coc-format-selected)
vnoremap <leader>cf  <Plug>(coc-format-selected)
nnoremap <leader>ca  <Plug>(coc-codeaction-selected)
vnoremap <leader>ca  <Plug>(coc-codeaction-selected)
"<Plug>(coc-codeaction-refactor)| Choose refactor code action at cursor position.
"<Plug>(coc-codeaction-refactor-selected)| Choose refactor code action with selected code.


" gh - get hint on whatever's under the cursor
nnoremap <silent> gh :ShowDocumentation<CR>

" ctrl-space to refresh suggestions
inoremap <silent><expr> <c-space> coc#refresh()

" list commands available in tsserver (and others)
nnoremap <silent> <leader>cc  :<C-u>CocList commands<CR>

" restart when tsserver gets wonky
nnoremap <silent> <leader>cR  :<C-u>CocRestart<CR>

" manage extensions
nnoremap <silent> <leader>cx  :<C-u>CocList extensions<CR>


" • Disable completion for buffer: |b:coc_suggest_disable|
" • Disable specific sources for buffer: |b:coc_disabled_sources|
" • Disable words for completion: |b:coc_suggest_blacklist|
" • Add additional keyword characters: |b:coc_additional_keywords|
" • |CocAction('codeActions')|
" • |CocAction('organizeImport')|
" • |CocAction('fixAll')|
" • |CocAction('quickfixes')|
" • |CocAction('doCodeAction')|
" • |CocAction('doQuickfix')|
" • |CocAction('codeActionRange')|



"
" GitGutter:
" 
" nmap ]c <Plug>GitGutterNextHunk
" nmap [c <Plug>GitGutterPrevHunk
" nmap <Leader>ha <Plug>GitGutterStageHunk
" nmap <Leader>hu <Plug>GitGutterUndoHunk
" nmap <Leader>hv <Plug>GitGutterPreviewHunk
" omap ih <Plug>GitGutterTextObjectInnerPending
" omap ah <Plug>GitGutterTextObjectOuterPending
" xmap ih <Plug>GitGutterTextObjectInnerVisual
" xmap ah <Plug>GitGutterTextObjectOuterVisual


