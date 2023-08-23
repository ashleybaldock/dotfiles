
let g:coc_node_path = '/opt/homebrew/bin/node'

inoremap <silent><expr> <c-space> coc#refresh()

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"


inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" nnoremap <C-g><C-G> :YcmCompleter GoTo<CR>                TODO
" nnoremap <C-g><C-r> :YcmCompleter RefactorRename          TODO
" nnoremap <C-g><C-i> :YcmCompleter OrganizeImports<CR>    TODO

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [[  :<C-u>CocList diagnostics<cr>
nmap <silent> ]]  :<C-u>CocDiagnostics<cr>

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ][ <Plug>(coc-diagnostic-prev)
nmap <silent> <C-g><C-v> <Plug>(coc-diagnostic-prev)
nmap <silent> gv <Plug>(coc-diagnostic-prev)

nmap <silent> [] <Plug>(coc-diagnostic-next)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> <C-g><C-b> <Plug>(coc-diagnostic-next)
nmap <silent> gb <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <C-g><C-g> <Plug>(coc-definition)

nmap <silent> <C-g><C-t> <Plug>(coc-type-definition)

nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> <C-g><C-i> <Plug>(coc-implementation)

nmap <silent> gr <Plug>(coc-references)
nmap <silent> <C-g><C-r> <Plug>(coc-references)

" nmap <silent> gf <Plug>(coc-fix-current)
nmap <silent> <C-g><C-f> <Plug>(coc-fix-current)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" gh - get hint on whatever's under the cursor
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> gh :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    if &filetype == 'vim'
      execute 'h '.expand('<cword>')
    endif
  endif
endfunction

" autocmd CursorHold * silent call CocActionAsync('doHover')

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>

" List errors
nnoremap <silent> <leader>cl  :<C-u>CocList locationlist<CR>


" list commands available in tsserver (and others)
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>

" restart when tsserver gets wonky
nnoremap <silent> <leader>cR  :<C-u>CocRestart<CR>

" manage extensions
nnoremap <silent> <leader>cx  :<C-u>CocList extensions<cr>

" rename the current word in the cursor
nmap <leader>cr  <Plug>(coc-rename)
nmap <leader>cf  <Plug>(coc-format-selected)
vmap <leader>cf  <Plug>(coc-format-selected)

" run code actions
vmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>ca  <Plug>(coc-codeaction-selected)

