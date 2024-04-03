
" a === 33
" !==
" " set previewpopup=height:10,width:60

" Jump forward (^O)
" <⌥⃣ ‑a> ▬▶︎ å
nnoremap å           <C-o>
nnoremap <leader>o   <C-o>
" Jump backward (^I)
" <⌥⃣ ‑s> ▬▶︎ ß
nnoremap ß           <C-i>
nnoremap <leader>i   <C-i>
" :w
nnoremap §ww :w<CR>
nnoremap §wW :w!<CR>
nnoremap §wa :wa<CR>

" open
" [:e, :e!] <filename>
" §ee, $eE ⇉ same window
" §es, $eS ⇉ horizontal split
" §ev, §eV ⇉ vertical split
" §er, §eR ⇉ reload
" §ed, §eD ⇉ current directory
" §ec, §eC ⇉ enew
" <- 
nnoremap §ee :e 
nnoremap §eE :e! 
nnoremap §es :sp 
nnoremap §eS :sp! 
nnoremap §ev :vsp 
nnoremap §eV :vsp! 
nnoremap §er :e %<CR>
nnoremap §eR :e! %<CR>
nnoremap §ed :e .<CR>
nnoremap §eD :e .<CR>
nnoremap §ec :enew<CR>
nnoremap §eC :enew!<CR>

nnoremap §1 :CtrlP<CR>
nnoremap <S-tab>     :CtrlP<CR>
nnoremap <leader>p   :CtrlP<CR>

" Splits & windows
nnoremap §ss :sp<CR>
nnoremap §sv :vsp<CR>

nnoremap §<S-i> :so $VIMRUNTIME/syntax/hitest.vim<CR>
nnoremap §i :SynStack<CR>
nnoremap §I :SynStackAuto<CR>

" nnoremap §rf :if &filetype=='vim' && $HOME . '/.vim/ :so<CR>
" Source current saved file
nnoremap §rf :so %<CR>
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


" Prettify
nnoremap §p %!npx prettier --stdin-filepath %<CR>
" nnoremap ?? :CopyPath<CR>
" nnoremap ?? :CopyFilename<CR>
" nnoremap ?? :CopyBranch<CR>

" Remove blank lines
" :g/^$/d

" Extract CSS variable
" name: value;       
" " CSS
"
" * templates
" 
"
" * variables
" Extract, name from property  TODO
" name: value;  ▬▶︎  name: var(--name, value);
"           +yank:  --name: value;
"               
"  --bsize-spell: 40px;
"
"  display: flex;
"  flex-direction: column;
"  flex: 1 1;




" Swap text with following whitespace (right-align)
" (V, pick lines, :)
" %s/^\s*\[\zs\('\w*',\)\(\s*\)/\2\1/g

" Swap around pivot (e.g. AAA,BBB -> BBB,AAA
" vnoremap  <C-S> :s/\%V\(\w\+\)\(\W\+\)\(\w\+\)/\3\2\1<CR>:noh<CR>
"
" Shift {token} back/forward in {container} TODO
" e.g. [ 'a', 'b̲', 'c' ] -> [ 'a', 'c', 'b' ]
"
" Shift line(s) up/down (taking cursor with them) TODO
"

" Quickfix
nnoremap §q :windo lcl\|ccl<CR>

nmap <silent> <C-q> <Plug>(qf_qf_switch)
nmap <silent> <C-§> <Plug>(qf_qf_toggle_stay)
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

"Repeat last edit n times
nnoremap . :<C-u>execute "norm! " . repeat(".", v:count1)<CR>

"
nnoremap <C-g><C-s> :OpenCSS<CR>

" Display line movements, except with count
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'


" === Ack / Search ===

" clear last search highlighting
nnoremap            §c :nohlsearch<CR>
nnoremap <silent> <CR> :nohlsearch<CR><CR>

" Searching
" cnoreabbrev ag :CdProjectRoot <bar> Ack! -Q --
" nnoremap <Leader>a :Ack!<Space>
" <C-r><C-w> - gets word under cursor
" <C-r>/     - gets last search string
" nnoremap • :CdProjectRoot <bar> Ack! -- '<C-r><C-w>'
" nnoremap # :CdProjectRoot <bar> Ack! -- '<C-r><C-w>'
" nnoremap <Leader>' :CdProjectRoot <bar> Ack! <C-r><C-w><CR>
" nnoremap <Leader>" :CdProjectRoot <bar> Ack! <C-r>/<CR>

" ⌥⃝ ⋯⇧⃝ ⋯8⃝ ▬▶︎•⃣  
nnoremap • :CdProjectRoot <bar> AckCurrentWord<CR>
nnoremap # :CdProjectRoot <bar> AckCurrentWord<CR>

cnoreabbrev ag :CdProjectRoot <bar> AckInput<CR>

nnoremap <Leader>' :CdProjectRoot <bar> AckCurrentWord<CR>
nnoremap <Leader>" :CdProjectRoot <bar> AckLastSearch<CR>
" Seach current buffer
" word under cursor
"   hl    +prev  +next
"   \\       *      #   (word boundaries)
"   \\\     g*     g#   (anywhere)
" visual selection:
"   prev  next
"     *     #  anywhere
" Put word under cursor into search register and highlight
nnoremap <silent> <Leader>\ :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
" vnoremap <silent> <Leader>* :<C-U>
"   \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
"   \gvy:let @/=substitute(
"   \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR>
"   \gV:call setreg('"', old_reg, old_regtype)<CR>:set hls<CR>

" Search(+Replace) for visual selection
" vnoremap §s "xy:%s//
vnoremap §s y<ESC>/<c-r>"<CR> 
vnoremap §r y<ESC>:%s/<c-r>"//g<Left><Left>
vnoremap §<S-r> y<ESC>:%s^<c-r>"^^g<Left><Left>

" Substitute using last search pattern
" :%s//<replacement>/g
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


" Visual mode
" move to next displayed line in mode v (but not V or )
"  (useful with wrap on)
xnoremap <expr> j  mode() ==# "v" ? "gj" : "j"
xnoremap <expr> gj mode() ==# "v" ? "j"  : "gj"
xnoremap <expr> k  mode() ==# "v" ? "gk" : "k"
xnoremap <expr> gk mode() ==# "v" ? "k"  : "gk"
" Select visual block (<C-v> etc.) 
" in visual mode:
" x - cut block replacing it with whitespace
vnoremap x y<ESC>gvr 
vnoremap v y<ESC>1vp
xnoremap <expr> x  mode() ==# "" ? "y<ESC>gvr" : "x"
xnoremap <expr> v  mode() ==# "" ? "y<ESC>1vp" : "v"
" h - move block left by 1
" j - move block down by 1
" k - move block up by 1
" l - move block right by 1


" === Coc ===

" <⌥⃣ ‑r> ▬▶︎ ®
nmap <silent> ® <Plug>(coc-range-select)
xmap <silent> ® <Plug>(coc-range-select)

xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)

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

" <⌥⃣ ‑[> ▬▶︎ “
nnoremap “ :CocCommand document.jumpToPrevSymbol<CR>
" <⌥⃣ ‑]> ▬▶︎ ‘
nnoremap ‘ :CocCommand document.jumpToNextSymbol<CR>

" Symbol renaming.
nnoremap ® <Plug>(coc-rename)
nnoremap <silent> <C-g><C-r> <Plug>(coc-rename)

" GoTo code navigation.
" <⇧⃣ -⌥⃣ ‑d> ▬▶︎ Î
nnoremap Î   :call CocAction('definitions')<CR>
" <⌥⃣ ‑d> ▬▶︎ ∂
nnoremap ∂   :call CocAction('jumpDefinition')<CR>
"nnoremap <silent>    :call CocAction('declarations')<CR>
"nnoremap <silent>    :call CocAction('jumpDeclaration')<CR>
"nnoremap <silent>    :call CocAction('implementations')<CR>
"nnoremap <silent>   :call CocAction('jumpImplementation')<CR>
"nnoremap <silent>    :call CocAction('typeDefinitions')<CR>
nnoremap <silent> <C-g><C-t> :call CocAction('jumpTypeDefinition')<CR>
" <⇧⃣ -⌥⃣ ‑r> ▬▶︎ Â
nnoremap Â :call CocAction('jumpReferences')<CR>
nnoremap <silent>  gr :call CocAction('references')<CR>
"nnoremap <silent>    :call CocAction('jumpReferences')<CR>
"nnoremap <silent>    :call CocAction('jumpUsed')<CR>

nnoremap <silent> <C-g><C-f> <Plug>(coc-fix-current)
" <⌥⃣ ‑f> ▬▶︎ ƒ
nnoremap <silent> ƒ <Plug>(coc-fix-current)
nnoremap <silent> §2 <Plug>(coc-codeaction-line)
nnoremap <silent> §3 <Plug>(coc-codeaction-source)
" <⌥⃣ ‑c> ▬▶︎ ç
nnoremap <silent> ç <Plug>(coc-fix-current)
"<Plug>(coc-codeaction-line)| Choose code actions at current line.
"<Plug>(coc-codeaction-source)| Choose source code action of current file.
"<Plug>(coc-codeaction-selected)| Choose code actions from selected range.
"<Plug>(coc-codeaction-refactor)| Choose refactor code action at cursor position.
"<Plug>(coc-codeaction-refactor-selected)| Choose refactor code action with selected code.
"CocAction('codeActions')|
"CocAction('organizeImport')|
"CocAction('fixAll')|
"CocAction('quickfixes')|
"CocAction('doCodeAction')|
"CocAction('doQuickfix')|
"CocAction('codeActionRange')|

" Format & fix
nmap <leader>cf  <Plug>(coc-format-selected)
vmap <leader>cf  <Plug>(coc-format-selected)
vmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>ca  <Plug>(coc-codeaction-selected)

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



