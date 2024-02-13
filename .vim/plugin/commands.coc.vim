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

function s:CopyHoverInfo()
  redir @+>|silent echo CocAction('getHover')|redir END
endfunc

:command! CopyDiagnostic :call <SID>CopyDiagnostic()
:command! CopyHoverInfo :call <SID>CopyHoverInfo()


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
" :autocmd User CocDiagnosticChange {command}:

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

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

