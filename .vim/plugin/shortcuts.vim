if exists("g:mayhem_loaded_shortcuts")
  finish
endif
let g:mayhem_loaded_shortcuts = 1

" ⌥⃝   ⃝  ◁╮                   
" ╭▷ ⌥⃝  ⇧⃝   ⃝  
"
" ╰▷ ⌥⃝ 𝄑⇧⃝ 𝄑 ⃝           
" ⌥⃝   ⃝  ◁╯
"
" 
" Key Mappings:
"
" (commands/functions are defined elsewhere)
"
"  Option: ⌥⃝  
"            ‣ bound as resulting unicode character
"               e.g. (option + 5) ⌥⃝ 𝄐5⃝  ──▷ ∞
"                :map ∞ <Nop>
"
" Command: ⌘⃝   (<D-x>)
"            ‣ case-sensitive
"               e.g. <D-e> != <D-E> 
"            ‣ must first be un-mapped in ../gvimrc
"               before being redefined
"

" ╭──▷ ⌘⃝ 𝄐E⃝  ────▷ LH Enter
cnoremap <D-e> <CR>
nnoremap <D-e> <CR>
inoremap <D-e> <CR>
xnoremap <D-e> <CR>

" ╭──▷ ⌥⃝ 𝄐1⃝  ────▷ Start a command 
nnoremap ¡ :

" ╭─▷ ⌥⃝ 𝄐⇧⃝ 𝄐1⃝  ──▷ Start a shell command 
nnoremap ⁄ :!

" ╭──▷ ⌥⃝ 𝄐A⃝  ────▷ Jump forward (^O)
nnoremap å           <C-o>
nnoremap <leader>o   <C-o>

" ╭──▷ ⌥⃝ 𝄐S⃝  ────▷ Jump backward (^I/<Tab>)
nnoremap ß           <C-i>
nnoremap <leader>i   <C-i>


"
" Change:
"   Character: (under cursor)
"
" ╭──▷ ⌥⃝ 𝄐0⃝  ────────────▷ C⃝ i⃝ r⃝ c⃝ l⃝ e⃝ 
nnoremap º a⃝ <Cmd>RepeatMove<CR><Esc>
"
" ╭─▷ ⌥⃝ 𝄐⇧⃝ 𝄐0⃝  ──────────▷ S⃞ q⃞ u⃞ a⃞ r⃞ e⃞ 
nnoremap ‚ a⃞ <Cmd>RepeatMove<CR><Esc>
"
" ╭──▷ ⌥⃝ 𝄐-⃝  ────────────▷ U̲n̲d̲e̲r̲l̲i̲n̲e̲
nnoremap – a̲<Cmd>RepeatMove<CR><Esc>
"
" ╭─▷ ⌥⃝ 𝄐⇧⃝ 𝄐-⃝  ──────────▷ O̅v̅e̅r̅l̅i̅n̅e̅
nnoremap — a̅<Cmd>RepeatMove<CR><Esc>
"
" ╭─▷ ⌥⃝ 𝄐⇧⃝ 𝄐E⃝  ──────────▷ Replace with last yanked
nnoremap ‰ s<c-r>0<Cmd>RepeatMove<CR><Esc>
"
"  Word: (Under Cursor)
"


"
" Write: §⃝  w - Save / write
"
nnoremap §ww :w<CR>
nnoremap §wW :w!<CR>
nnoremap §wa :wa<CR>

"
"  Edit: §e       ╭╌╌╌╌╌╸Quick Bookmarks╺╌╌╌╌╌╮
" ╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╭╌╌╌╌╌╌╌╌╌╌╎
" ╎           Default              ┊  Rebind  ╎
" ╎╌╌╌╌╌╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╎╌╌╌╌╌╌╌╌╌╌╎
" ╎ §e1 ┊  $HOME/projects/         ┊   §E1    ╎
" ╎ §e2 ┊  $HOME/.vim/             ┊   §E2    ╎
" ╎ §e3 ┊  $HOME/.vim/plugin/      ┊   §E3    ╎
" ╎ §e4 ┊  $HOME/                  ┊   §E4    ╎
" ╎ §e5 ┊  $HOME/                  ┊   §E5    ╎
" ╎╌╌╌╌╌╯╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯╌╌╌╌╌╌╌╌╌╌╎
" ╎         §e§ :  Select from PUM            ╎
" ╎╌╌╌╌╌╌╌╌╌╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╎
" ╎  :e! ─╮ ┊    Open ..   ┊      in ..       ╎
" ╎╌╌╌╌╌╌╌∇╌╎╌╌╌╌╌╌╌╌╌╌╌╌╌╌╎╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╎
" ╎ §ew $eW ┊ ./<select>   ┊ same window      ╎
" ╎ §es $eS ┊ ./<select>   ┊ horizontal split ╎
" ╎ §ev §eV ┊ ./<select>   ┊ vertical split   ╎
" ╎ §er §eR ┊ current file ┊ same window      ╎
" ╎ §ed §eD ┊ ./ (DIR)     ┊ same window      ╎
" ╎ §ec §eC ┊ <blank>      ┊ same window      ╎
" ╎ §ee     ┊ ./<select>   ┊ exist;same;split ╎
" ╎ §eE     ┊ ./<select>   ┊ same;split       ╎
" ╎╌╌╌╌╌╌╌╌╌╯╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╎
" ╎  §ee ⇉ ╶─?⃞╶┮[ if file is open already ]   ╎
" ╎          ∇ └─▷ jump to existing window    ╎
" ╎  §eE ⇉ ╶─?⃞╶┮[ if window can be reused ]   ╎
" ╎          ┆ └─▷ replace current            ╎
" ╎          ╰─▷ open in split                ╎
" ╵╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╵
nnoremap §ee :e 
nnoremap §ew :e ./
nnoremap §eW :e! ./
nnoremap §es :sp ./
nnoremap §eS :sp! ./
nnoremap §ev :vsp ./
nnoremap §eV :vsp! ./
nnoremap §er :e %<CR>
nnoremap §eR :e! %<CR>
nnoremap §ed :e .<CR>
nnoremap §eD :e .<CR>
nnoremap §ec :enew<CR>
nnoremap §eC :enew!<CR>
nnoremap §e§ :e ~/.vim/
nnoremap <expr> §e1 ':e '..get(g:, 'mayhem_quick1', '~/projects/')..''
nnoremap <expr> §e2 ':e '..get(g:, 'mayhem_quick2', '~/.vim/')..''
nnoremap <expr> §e3 ':e '..get(g:, 'mayhem_quick3', '~/.vim/plugin/')..''
nnoremap <expr> §e4 ':e '..get(g:, 'mayhem_quick4', '~/')..''
nnoremap <expr> §e5 ':e '..get(g:, 'mayhem_quick5', '~/')..''
nnoremap §e2 :e ~/.vim/
nnoremap §e3 :e ~/.vim/plugin/
nnoremap §e4 :e ~/
nnoremap §e5 :e ~/
nnoremap <silent> §E1 :let g:mayhem_quick1=getcwd()..'/'<CR>
nnoremap <silent> §E2 :let g:mayhem_quick2=getcwd()..'/'<CR>
nnoremap <silent> §E3 :let g:mayhem_quick3=getcwd()..'/'<CR>
nnoremap <silent> §E4 :let g:mayhem_quick4=getcwd()..'/'<CR>
nnoremap <silent> §E5 :let g:mayhem_quick5=getcwd()..'/'<CR>

nnoremap <S-tab>     :CtrlP<CR>
nnoremap <leader>p   :CtrlP<CR>

"
"  §w & §s - Windows & Splits
" 
nnoremap §ss :sp<CR>
nnoremap §sv :vsp<CR>


"
" Highlighting
"
" See: ./highlight.vim
nnoremap §<S-i> :so $VIMRUNTIME/syntax/hitest.vim<CR>
nnoremap §i :SynStack<CR>
nnoremap §I :SynStackAuto<CR>


"─── Column guides ─────────────────────────────────────
"
" See: ./colorcolumn.vim
nnoremap §\ :AddColorColumn<CR>
nnoremap §] :AlignRightToColorColumn<CR>
nnoremap §} :AlignRightOnColorColumn<CR>
nnoremap §[ :AlignLeftToColorColumn<CR>
nnoremap §{ :AlignLeftOnColorColumn<CR>

inoremap  :AlignRightToColorColumn<CR>

"
" Editing:
"
" Swap:
" word <-> following whitespace ('right align')
" (V, pick lines, :)
nnoremap §ar :s/\s*\zs\(\w*\)\(\s*\)/\2\1/g<CR>:noh<CR>
xnoremap §ar :s/\s*\zs\(\w*\)\(\s*\)/\2\1/g<CR>:noh<CR>

" words around pivot     (AAA,BBB -> BBB,AAA
"  (Swaps the first two words found in selection)
nnoremap §as :s/\%V\(\w\+\)\(\W\+\)\(\w\+\)/\3\2\1<CR>:noh<CR>
xnoremap §as :s/\%V\(\w\+\)\(\W\+\)\(\w\+\)/\3\2\1<CR>:noh<CR>
" words around cursor (AD̲G -> ED̲C | AA, ̲XX -> XX, ̲AA | AB̲C XX -> CB̲A XX)
nnoremap §ac :s/\(\w\+\)\(\W*\%#\W*\)\(\w\+\)/\3\2\1<CR>:noh<CR>
"
"
" Move Token:
"   {token} back/forward in {container}       TODO
"
"  Cursor moves with the shifted item
"  (This is essentially the same as swapping around
"   a pivot, but repeated)
" e.g. [ 'a', 'b̲', 'c' ] -> [ 'a', 'c', 'b' ]

" Move Block:
" Select visual block (<C-v> etc.) 
" x - cut block replacing it with whitespace
xnoremap <expr> x  mode() ==# "\x16" ? "y<ESC>gvr<Space>" : "x"
xnoremap <expr> v  mode() ==# "\x16" ? "y<ESC>1vp" : "v"
" h - move block left by 1
" j - move block down by 1
" k - move block up by 1
" l - move block right by 1
"
"   ⇧⃝ 𝄐⌥⃝   🅆   ⎫     Move line
" ╭─▷    🄰 🅂 🄳 ⎭─▷  V: up/down
" │                   ^V: up/right/down/left              
"   ⇧⃝ 𝄐⌥⃝ 𝄐(🅆 🄰 🅂 🄳 )─▷  V: up/down
"
" Move Lines:
"               Visual (v/V)
"          ╭W⃝  ─▷ Up
" ╭▷ ⇧⃝ 𝄐⌥⃝ 𝄐┴S⃝  ─▷ Down
"
command! MoveBlockUp <Nop>                     "  TODO
command! MoveBlockDown <Nop>                   "  TODO
command! MoveBlockLeft <Nop>                   "  TODO
command! MoveBlockRight <Nop>                  "  TODO
" Shift line(s) up/down (taking cursor with them) TODO
"              ⎧ Visual ╷ v/V ╷ ^V  ⎫
"              │╴╴╴╴╴╴╴╴┤╴╴╴╴╴┤╴╴╴╴╴┤
"        ╭╴W⃝  ──▷ Up    │  y  │  y  │
"        ├╴S⃝  ──▷ Down  │  y  │  y  │
"        ├╴A⃝  ──▷ Left  │     │  y  │
" ╭▷  ⌥⃝ 𝄐┴╴D⃝  ──▷ Right │     │  y  │
xnoremap <expr> ∑  mode() ==# "\x16" ? "MoveBlockUp" : "m -2"
xnoremap <expr> ß  mode() ==# "\x16" ? "MoveBlockDown" : "m +2"
xnoremap <expr> å  mode() ==# "\x16" ? "MoveBlockLeft" : "echo Try with ^V"
xnoremap <expr> ∂  mode() ==# "\x16" ? "MoveBlockRight" : "echo Try with ^V"


" Mouse Mappings:
"
nnoremap <M-LeftMouse> VirtualEditOnClick


"
" Line Drawing                                    TODO
"
" Box Drawing                                     TODO
" - Draw a box around visual block selection
"

" nnoremap §rf :if &filetype=='vim' && $HOME . '/.vim/ :so<CR>
" Source current saved file
nnoremap §rf :UnsetAndReload<CR>
" Save and then Source current file
nnoremap §rs :w :so %<CR>
" Source current buffer (doesn't refresh everything)
nnoremap §re :so<CR>
" Source current line
nnoremap §rr :.,.so<CR>
" Source vimrc
nnoremap §rv :so ~/.vimrc<CR>
" Execute currently selected
vmap §<space> "xy:@x<CR>
" Get result of command in new buffer
" redir @">|silent echo 
"          \ <<command>>
"          \ |redir END|vsp|enew|put
"
" s/^[[:blank:]"]*\zs.*/
" %s/,\ /,/g
"
" %s/\s\+$//e

" Remove blank lines
" :g/^$/d

" Split tab-separated columns into arrays
" %s/^	/    ["/g
" %s/	.*\zs\ze$/"],/g
" %s/	/", "/g
"
" %s/^	/    "/g
" %s/	.*\zs\ze$/",/g
" %s/	/": "/g

" Prettify
nnoremap §p %!npx prettier --stdin-filepath %<CR>

"  §f  - Formatting
" CSS
" See: ./css.vim
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
nnoremap <C-g><C-s> :OpenCSS<CR>



" Y: Copy/Yank
" §y,<⌥⃣ ‑c>
"
nnoremap §y <Nop>
" <⌥⃣ ‑c> ▬▶︎ ç
nnoremap <silent> ç <Nop>



" Quickfix
nnoremap §q :windo lcl\|ccl<CR>

nmap <silent> <leader>q <Plug>(qf_qf_toggle_stay)
nmap <silent> <leader>l <Plug>(qf_loc_toggle)

"
nnoremap <leader>e   :Explore<CR>
nnoremap <leader>es  :Sexplore<CR>
nnoremap <leader>ev  :Vexplore<CR>

"
nnoremap <leader>t   :set guifont=Menlo:h14<CR>
nnoremap <leader>tt  :set guifont=Menlo:h16<CR>
nnoremap <leader>ttt :set guifont=Menlo:h18<CR>

"
nnoremap        §t   :set list!<CR>
nnoremap <leader>L   :set list!<CR>

" Repeat last edit n times
nnoremap . :<C-u>execute "norm! " . repeat(".", v:count1)<CR>




"
" Search:
"  Clear: last search highlighting
nnoremap            §c :nohlsearch<CR>
nnoremap <silent> <CR> :nohlsearch<CR><CR>

" Searching
" cnoreabbrev ag :CdProjectRoot <bar> Ack! -Q --
" nnoremap <Leader>a :Ack!<Space>
" <C-r><C-w> - gets word under cursor
" <C-r>/     - gets last search string
" nnoremap <Leader>' :CdProjectRoot <bar> Ack! <C-r><C-w><CR>
" nnoremap <Leader>" :CdProjectRoot <bar> Ack! <C-r>/<CR>

" Search:
"  Current Project:
"
" ╭─▷ ⌥⃝ 𝄐⇧⃝ 𝄐3⃝  ─╮
" ├─▷ ⌥⃝ 𝄐⇧⃝ 𝄐8⃝  ─┼▷ Word under cursor
" ├─▷    \'    ─╯
nnoremap # :CdProjectRoot <bar> AckCurrentWord<CR>
nnoremap • :CdProjectRoot <bar> AckCurrentWord<CR>
nnoremap <Leader>' :CdProjectRoot <bar> AckCurrentWord<CR>

" ╭─▷    \"    ──▷ Last search
nnoremap <Leader>" :CdProjectRoot <bar> AckLastSearch<CR>

" ╭─▷   :ag    ──▷ Input
cnoreabbrev ag :CdProjectRoot <bar> AckInput<CR>

" Search:
"  Current Buffer:
"
"  Word Under Cursor:
" ┌───────────┬────────────────┬───────────────────┐
" │ highlight │ …and jump to   │ Limit search to   │
" │   only    │ prev ◁╯╰▷ next │                   │
" ├───────────┼────────────────┼───────────────────┤
" │   \\      │   *        #   │ (word boundaries) │
" │   \\\     │  g*       g#   │ (anywhere)        │
" └───────────┴────────────────┴───────────────────┘
"
"  Visual Selection:
"   prev  next
"     *     #  anywhere
"
" Put word under cursor into search register and highlight
" ╭──▷ \\    ────▷ Search
nnoremap <silent> <Leader>\ :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
" vnoremap <silent> <Leader>* :<C-U>
"   \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
"   \gvy:let @/=substitute(
"   \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR>
"   \gV:call setreg('"', old_reg, old_regtype)<CR>:set hls<CR>

" ╭──▷ §s    ────▷ Search
vnoremap §s y<ESC>/<c-r>"<CR> 
" ╭──▷ §r    ────▷ Replace, delimiter: /
xnoremap §r y<ESC>:%s/<c-r>"//g<Left><Left>
" ╭──▷ §R    ────▷ Replace, delimiter: ^
xnoremap §<S-r> y<ESC>:%s^<c-r>"^^g<Left><Left>
" vnoremap §s "xy:%s//

" ╭──▷ ⌥⃝ 𝄐1⃝  ────▷ Start a search
nnoremap € /

" ╭─▷ ⌥⃝ 𝄐⇧⃝ 𝄐1⃝  ──▷ Start substitution w/ last search
nnoremap ™ :%s///g<Left><Left>

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
"    ⌥⃝ 𝄐K⃝    │             │   f text
"            │             │   line o̲
"─────────────────────────────────────────────────────
" ⇧⃝ 𝄐J⃝   J   │ line o̲      │   line o f̲ text
" <S-j>      │ f text      │       
"─────────────────────────────────────────────────────
" ⌥⃝ 𝄐J⃝   ∆   │ line o̲      │   line of̲ text
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

" Visual Mode:
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

" insert/append in visual blockwise
" i = I, a = A, 
xnoremap <expr> i  mode() ==# "\x16" ? "I" : "i"
xnoremap <expr> a  mode() ==# "\x16" ? "A" : "a"
"║     n,v,V         ║        ^V       ║ 
"║  J, linewise      ║  J, blockwise:  ║ 
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
 
" Option Left Click On Focused Window:
"  i⁺₊﹢＋rts visual block selection from click location
"     (as if virtualedit=all)
"
nnoremap <expr> <M-LeftMouse> getmousepos().winid==win_getid() ? '<Cmd>StartVisualBlockToClick<CR>' : '<Cmd>StartVisualBlockFromClick<CR>'
" nnoremap <M-LeftMouse> :StartVisualBlockFromClick<CR>

" Diff:
"
nnoremap §dd :diffthis<CR>
nnoremap §de :diffget<CR>
nnoremap §dt :diffput<CR>
nnoremap §dx :diffoff<CR>
nnoremap §dr :diffupdate<CR>
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





" === Coc ===

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

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

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
nmap <silent> ]] :NextMostImportantDiagnostic<CR>
nmap <D-d> :NextMostImportantDiagnostic<CR>

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
"nnoremap <silent>    :call CocAction('declarations')<CR>
"nnoremap <silent>    :call CocAction('jumpDeclaration')<CR>
"nnoremap <silent>    :call CocAction('implementations')<CR>
"nnoremap <silent>   :call CocAction('jumpImplementation')<CR>
"nnoremap <silent>    :call CocAction('typeDefinitions')<CR>
nnoremap <silent> <C-g><C-t> :call CocAction('jumpTypeDefinition')<CR>
" >⇧⃣ -⌥⃣ ‑R⃣ < ▬▶︎ Â
nnoremap Â :call CocAction('jumpReferences')<CR>
nnoremap <silent>  gr :call CocAction('references')<CR>
"nnoremap <silent>    :call CocAction('jumpReferences')<CR>
"nnoremap <silent>    :call CocAction('jumpUsed')<CR>

nnoremap <silent> <C-g><C-f> <Plug>(coc-fix-current)
" <⌥⃣ ‑f> ▬▶︎ ƒ
nnoremap <silent> ƒ <Plug>(coc-fix-current)
nnoremap <silent> <D-f> <Plug>(coc-fix-current)
nnoremap <silent> §2 <Plug>(coc-codeaction-line)
nnoremap <silent> §3 <Plug>(coc-codeaction-source)
"<Plug>(coc-codeaction-line)| Choose code actions at current line.
"<Plug>(coc-codeaction-source)| Choose source code action of current file.
"<Plug>(coc-codeaction-selected)| Choose code actions from selected range.
"<Plug>(coc-codeaction-refactor)| Choose refactor code action at cursor position.
"<Plug>(coc-codeaction-refactor-selected)| Choose refactor code action with selected code.

" Format & fix
nnoremap <leader>cf  <Plug>(coc-format-selected)
vnoremap <leader>cf  <Plug>(coc-format-selected)
nnoremap <leader>ca  <Plug>(coc-codeaction-selected)
vnoremap <leader>ca  <Plug>(coc-codeaction-selected)

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


"   • |CocAction('codeActions')|
"   • |CocAction('organizeImport')|
"   • |CocAction('fixAll')|
"   • |CocAction('quickfixes')|
"   • |CocAction('doCodeAction')|
"   • |CocAction('doQuickfix')|
"   • |CocAction('codeActionRange')|

