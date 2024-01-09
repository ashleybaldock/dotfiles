" ^O
nnoremap §z          <C-o>
nnoremap <leader>o   <C-o>
" ^I
nnoremap §x          <C-i>
nnoremap <leader>i   <C-i>

" :w
nnoremap §w :w<CR>
nnoremap §!w :w!<CR>

" :e
nnoremap §e :e .<CR>
nnoremap §!e :e! .<CR>

nnoremap <S-tab>     :CtrlP<CR>
nnoremap <leader>p   :CtrlP<CR>

nnoremap §<S-i> :so $VIMRUNTIME/syntax/hitest.vim<CR>
nnoremap §i :SynStack<CR>

" clear last search highlighting
nnoremap            §c :nohlsearch<CR>
nnoremap <silent> <CR> :nohlsearch<CR><CR>

" Source current file
nnoremap §rf :so %<CR>
" Source current line
nnoremap §rr :.,.so<CR>
" Execute currently selected
vmap §<space> "xy:@x<CR>

" Prettify
nnoremap §p %!npx prettier --stdin-filepath %<CR>
" nnoremap ?? :CopyPath<CR>
" nnoremap ?? :CopyFilename<CR>
" nnoremap ?? :CopyBranch<CR>

" Remove blank lines
" :g/^$/d

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
nnoremap <leader>t   :set guifont=Menlo:h12<CR>
nnoremap <leader>tt  :set guifont=Menlo:h14<CR>
nnoremap <leader>ttt :set guifont=Menlo:h16<CR>

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

:function! AckEscaped(search)
  " The ! avoids jumping to first result automatically
  execute printf('Ack! -Q -- "%s"', substitute(a:search, '\([%"\\]\)', '\\\1', 'g'))
:endfunc

:function! AckClipboard()
  call AckEscaped(@")
:endfunc

:function! AckCurrentWord()
  call AckEscaped(expand("<cword>"))
:endfunc

:function! AckLastSearch()
  call AckEscaped(expand("<cword>"))
:endfunc

:function! AckInput()
  call inputsave()
  let search = input("Ack! ")
  call inputrestore()
  call AckEscaped(search)
:endfunc

:command! AckInput :exec AckInput()
:command! AckClipboard :exec AckClipboard()
:command! AckCurrentWord :exec AckCurrentWord()

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

" Diagnostics
" [[   list
" []   next
" ][   prev
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [[  :<C-u>CocList diagnostics<cr>
nmap <silent> ]]  :<C-u>CocDiagnostics<cr>
nmap <silent> ][ <Plug>(coc-diagnostic-prev)
nmap <silent> [] <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <C-g><C-g> <Plug>(coc-definition)
nmap <silent> <C-g><C-t> <Plug>(coc-type-definition)
nmap <silent> <C-g><C-i> <Plug>(coc-implementation)

nmap <silent> <C-g><C-v> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-g><C-b> <Plug>(coc-diagnostic-next)

" nmap <silent> gi <Plug>(coc-implementation)

nmap <silent> gr <Plug>(coc-references)

" nmap <silent> gf <Plug>(coc-fix-current)
nmap <silent> <C-g><C-f> <Plug>(coc-fix-current)

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

" list commands available in tsserver (and others)
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>

" restart when tsserver gets wonky
nnoremap <silent> <leader>cR  :<C-u>CocRestart<CR>

" manage extensions
nnoremap <silent> <leader>cx  :<C-u>CocList extensions<cr>


