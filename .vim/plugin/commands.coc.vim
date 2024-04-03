function! ToggleOutline() abort
  let winid = coc#window#find('cocViewId', 'OUTLINE')
  if winid == -1
    call CocActionAsync('showOutline', 1)
  else
    call coc#window#close(winid)
  endif
endfunc

" nnoremap <silent><nowait> <space>o  :call ToggleOutline()<CR>

function s:CopyDiagnostic()
  redir @+>|silent echo CocAction('diagnosticInfo', 'echo')|redir END
endfunc
:command! CopyDiagnostic :call <SID>CopyDiagnostic()

function s:CopyHoverInfo()
  redir @+>|silent echo CocAction('getHover')|redir END
endfunc
:command! CopyHoverInfo :call <SID>CopyHoverInfo()

:command! CopyJumpList :let @+=get(g:last_coc_jump_locations)


function s:WorstDiagnosticSeverity()
  let diaginfo = get(b:, 'coc_diagnostic_info', {})
  return get(diaginfo, 'error', 0) > 0 ? 'error' :
       \ get(diaginfo, 'warning', 0) > 0 ? 'warning' :
       \ get(diaginfo, 'hint', 0) > 0 ? 'hint' :
       \ get(diaginfo, 'information', 0) > 0 ? 'information' : ''
endfunc
function s:PrevMostImportantDiagnostic()
  return CocActionAsync('diagnosticPrevious', <SID>WorstDiagnosticSeverity())
endfunc
function s:NextMostImportantDiagnostic()
  return CocActionAsync('diagnosticNext', <SID>WorstDiagnosticSeverity())
endfunc

:command! WorstDiagnosticSeverity :call <SID>WorstDiagnosticSeverity()
:command! PrevMostImportantDiagnostic :call <SID>PrevMostImportantDiagnostic()
:command! NextMostImportantDiagnostic :call <SID>NextMostImportantDiagnostic()

function s:ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('definitionHover')
    " call CocActionAsync('doHover')
  else
    if &filetype == 'vim'
      execute 'h '..expand('<cword>')
    endif
  endif
endfunc

:command! ShowDocumentation :call <SID>ShowDocumentation()

" Tab autocomplete for popup menu
function! s:CocCheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunc
" Set '"suggest.noselect": true' in config to tab-select first result
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>CocCheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR>
      \ coc#pum#visible() ? coc#pum#confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function s:OnCocDiagnosticChange()
  UpdateSlCachedDiagnostics
endfunc

function s:OnCocLocationsChange()
"   new list in: g:coc_jump_locations
   let g:last_coc_jump_locations = g:coc_jump_locations
endfunc

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" on startup
" autocmd User CocNvimInit echom "---CocNvimInit---"

" On diagnostics changed
"autocmd User CocStatusChange,CocDiagnosticChange call dostuff()
" autocmd User CocStatusChange echom "---CocStatusChange---"
" autocmd User CocDiagnosticChange echom "---CocDiagnosticChange---"
autocmd User CocStatusChange,CocDiagnosticChange silent call s:OnCocDiagnosticChange()

"Triggered on jump to placeholder
" autocmd User CocJumpPlaceholder echom "---CocJumpPlaceholder---"
autocmd User CocJumpPlaceholder silent call CocActionAsync('showSignatureHelp')

"Triggered when a floating window is opened.  The window is not
"focused, use |g:coc_last_float_win| to get window id.
" autocmd User CocOpenFloat echom "---CocOpenFloat---"

"Triggered when terminal shown (e.g. for adjusting window height)
" autocmd User CocTerminalOpen echom "---CocTerminalOpen---"

"Triggered on location list change,
"   new list in: g:coc_jump_locations
" 'filename': full file path.
" 'lnum': line number (1 based).
" 'col': column number(1 based).
" 'text':  line content of location.
let g:coc_enable_locationlist = 0
" autocmd User CocLocationsChange echom "---CocLocationsChange---"
autocmd User CocLocationsChange silent call s:OnCocLocationsChange()
