" ^O
nnoremap §z          <C-o>
nnoremap <leader>o   <C-o>
" ^I
nnoremap §x          <C-i>
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
"
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
" redir @">|silent echo getbufinfo(bufnr())|redir END|vsp|enew|put|silent %s/'/"/ge|silent %s/\\/\\\\/ge|silent %s/: \zs[^0-9[{",]*\ze,/"\0"/ge|setlocal filetype=json|call CocAction('format')|setlocal nomodified
"
" s/^[[:blank:]"]*\zs.*/
" %s/,\ /,/g


" Prettify
nnoremap §p %!npx prettier --stdin-filepath %<CR>
" nnoremap ?? :CopyPath<CR>
" nnoremap ?? :CopyFilename<CR>
" nnoremap ?? :CopyBranch<CR>

" Remove blank lines
" :g/^$/d

" Swap text with following whitespace (right-align)
" (V, pick lines, :)
" %s/^\s*\[\zs\('\w*',\)\(\s*\)/\2\1/g

" Swap around pivot (e.g. AAA,BBB -> BBB,AAA
" vnoremap  <C-S> :s/\%V\(\w\+\)\(\W\+\)\(\w\+\)/\3\2\1<CR>:noh<CR>
"
" Shift {token} back/forward in {container}
" e.g. [ 'a', 'b̲', 'c' ] -> [ 'a', 'c', 'b' ]
"
" Shift line(s) up/down (taking cursor with them)
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

" Substitute using last search pattern
" :%s//<replacement>/g
" Or this, which uses register '/'
" :%s///<replacement>/g
" :%s/<c-r>///g<Left><Left>

" Substitute using register 'a'
" :%s/a/<replacement>/g
" :%s/<c-r>a//g<Left><Left>

" *E146*
" Instead of the '/' which surrounds the pattern and replacement string, you
" can use any other single-byte character, but not an alphanumeric character,
" '\', '"'' or '|'.  This is useful if you want to include a '/' in the search
" pattern or replacement string.  Example:
"   :s+/+//+


" === Coc ===

" Diagnostics
" [[   list
" []   next
" ][   prev
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [[  :<C-u>CocList diagnostics<cr>
nmap <silent> ]]  :<C-u>CocDiagnostics<cr>
nmap <silent> ][ <Plug>(coc-diagnostic-prev)
nmap <silent> ][ <Plug>(coc-diagnostic-prev-error)
nmap <silent> [] <Plug>(coc-diagnostic-next)
nmap <silent> [] <Plug>(coc-diagnostic-next-error)


" :CocCommand document.jumpToPrevSymbol
" :CocCommand document.jumpToNextSymbol

" GoTo code navigation.
" 
"<Plug>(coc-definition)|
"<Plug>(coc-declaration)|
"<Plug>(coc-implementation)|
"<Plug>(coc-type-definition)|
"<Plug>(coc-references)|
"<Plug>(coc-references-used)|
"
"CocAction('jumpDefinition')| Jump to definition locations.
"CocAction('jumpDeclaration')| Jump to declaration locations.
"CocAction('jumpImplementation')| Jump to implementation locations.
"CocAction('jumpTypeDefinition')| Jump to type definition locations.
"CocAction('jumpReferences')|| Jump to references.
"CocAction('jumpUsed')| Jump to references without declarations.
"CocAction('definitions')| Get definition list.
"CocAction('declarations')| Get declaration list.
"CocAction('implementations')| Get implementation list.
"CocAction('typeDefinitions')| Get type definition list.
"CocAction('references')| Get reference list.
nmap <silent> <C-g><C-g> <Plug>(coc-definition)
nmap <silent> <C-g><C-t> <Plug>(coc-type-definition)
nmap <silent> <C-g><C-i> <Plug>(coc-implementation)

nmap <silent> <C-g><C-v> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-g><C-b> <Plug>(coc-diagnostic-next)
nmap <silent> <C-g><C-v> <Plug>(coc-diagnostic-prev-error)
nmap <silent> <C-g><C-b> <Plug>(coc-diagnostic-next-error)

" nmap <silent> gi <Plug>(coc-implementation)

nmap <silent> gr <Plug>(coc-references)

nmap <silent> <tab> <Plug>(coc-fix-current)
nmap <silent> <C-g><C-f> <Plug>(coc-fix-current)
nnoremap <silent> §2 <Plug>(coc-codeaction-line)
"<Plug>(coc-fix-current)| Invoke quickfix action at current line if any.
"<Plug>(coc-codeaction-cursor)| Choose code actions at cursor position.
"<Plug>(coc-codeaction-line)| Choose code actions at current line.
"<Plug>(coc-codeaction)| Choose code actions of current file.
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

" Symbol renaming.
nmap <silent> <C-g><C-r> <Plug>(coc-rename)
nmap <leader>rn <Plug>(coc-rename)

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
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>

" restart when tsserver gets wonky
nnoremap <silent> <leader>cR  :<C-u>CocRestart<CR>

" manage extensions
nnoremap <silent> <leader>cx  :<C-u>CocList extensions<cr>


