
let g:coc_node_path = '/opt/homebrew/bin/node'

inoremap <silent><expr> <c-space> coc#refresh()

" nnoremap <C-g><C-G> :YcmCompleter GoTo<CR>                TODO
" nnoremap <C-g><C-r> :YcmCompleter RefactorRename          TODO
" nnoremap <C-g><C-i> :YcmCompleter OrganizeImports<CR>    TODO

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <C-g><C-d> <Plug>(coc-definition)
nmap <silent> <C-g><C-g> <Plug>(coc-definition)
nmap <silent> gd <Plug>(coc-definition)

nmap <silent> gy <Plug>(coc-type-definition)
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
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>

" List errors
nnoremap <silent> <leader>cl  :<C-u>CocList locationlist<cr>

" list commands available in tsserver (and others)
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>

" restart when tsserver gets wonky
nnoremap <silent> <leader>cR  :<C-u>CocRestart<CR>

" view all errors
nnoremap <silent> <leader>cl  :<C-u>CocList locationlist<CR>

" manage extensions
nnoremap <silent> <leader>cx  :<C-u>CocList extensions<cr>

" rename the current word in the cursor
nmap <leader>cr  <Plug>(coc-rename)
nmap <leader>cf  <Plug>(coc-format-selected)
vmap <leader>cf  <Plug>(coc-format-selected)

" run code actions
vmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>ca  <Plug>(coc-codeaction-selected)

" Status line messages
function! DiagErrors()
  if exists('g:did_coc_loaded')
    let l:diaginfo = get(b:, 'coc_diagnostic_info', {})
    let l:errors = get(l:diaginfo, 'error', 0)
    return l:errors == 0 ? '' : printf(' ‡%d ', l:errors)
  endif
  return ''
endfunction
function! DiagWarnings()
  if exists('g:did_coc_loaded')
    let l:diaginfo = get(b:, 'coc_diagnostic_info', {})
    let l:warnings = get(l:diaginfo, 'warning', 0)
    return l:warnings == 0 ? '' : printf(' •%d ', l:warnings)
  endif
  return ''
endfunction
function! DiagOk()
  if exists('g:did_coc_loaded')
    let l:diaginfo = get(b:, 'coc_diagnostic_info', {})
    let l:errors = get(l:diaginfo, 'error', 0)
    let l:warnings = get(l:diaginfo, 'warning', 0)
    return l:errors + l:warnings == 0 ? ' ok ' : ''
  endif
  return ''
endfunction

function! StatusDiagnostic() abort
  " Buffer local variable containing diagnostics
  " :echom get(b:, 'coc_diagnostic_info', {})
  " e.g. {'information': 19, 'hint': 0, 'lnums': [17, 0, 1, 0], 'warning': 0, 'error': 19}
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
endfunction
