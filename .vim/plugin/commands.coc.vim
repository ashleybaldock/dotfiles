if exists("g:mayhem_loaded_coc_commands")
  finish
endif
let g:mayhem_loaded_coc_commands = 1


function! ToggleOutline() abort
  let winid = coc#window#find('cocViewId', 'OUTLINE')
  if winid == -1
    call CocActionAsync('showOutline', 1)
  else
    call coc#window#close(winid)
  endif
endfunc

" nnoremap <silent><nowait> <space>o  :call ToggleOutline()<CR>


function s:WorstDiagnosticSeverity()
  let diaginfo = get(b:, 'coc_diagnostic_info', {})
  return get(diaginfo, 'error', 0) > 0 ? 'error' :
       \ get(diaginfo, 'warning', 0) > 0 ? 'warning' :
       \ get(diaginfo, 'hint', 0) > 0 ? 'hint' :
       \ get(diaginfo, 'information', 0) > 0 ? 'information' : ''
endfunc
function s:PrevMostImportantDiagnostic()
  return CocActionAsync('diagnosticPrevious', s:WorstDiagnosticSeverity())
endfunc
function s:NextMostImportantDiagnostic()
  return CocActionAsync('diagnosticNext', s:WorstDiagnosticSeverity())
endfunc

command! WorstDiagnosticSeverity echo <SID>WorstDiagnosticSeverity()
command! PrevMostImportantDiagnostic 
      \ call <SID>PrevMostImportantDiagnostic()
command! NextMostImportantDiagnostic
      \ call <SID>NextMostImportantDiagnostic()


let s:docOverrideMap = {
      \ 'map': 'map-table',
      \ '\(n\|i\|c\|v\|x\|s\|o\|t\|l\)\{-,1}map': 'map-table',
      \ }

function s:ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('definitionHover')
    " call CocActionAsync('doHover')
    " call CocActionAsync('getHover')
    if &filetype == 'vim'
      execute 'h '..expand('<cword>')
    endif
  endif
  if &filetype == 'vim'
    execute 'h '..expand('<cword>')
  endif
endfunc

command! ShowDocumentation call <SID>ShowDocumentation()

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
   " call setloclist(0, g:coc_jump_locations) | lwindow
   CocList --normal -A location
endfunc


function s:OnCocOpenFloat()
  " w:preview_window = 1
  let cocbufnr = get(get(getwininfo(g:coc_last_float_win), 0, {}), 'bufnr', -1)
  let name = get(get(getbufinfo(get(get(getwininfo(g:coc_last_float_win), 0, {}), 'bufnr', -1)), 0, {}), 'name', 'unknown')
  echom name
  let popOpts = popup_getoptions(g:coc_last_float_win)
  let highlight = get(popOpts, 'highlight', 'unknown')

  if highlight == 'HlCocPuHovrBg'
    " Coc hover float
    call popup_setoptions(g:coc_last_float_win, #{
          \ borderchars: [' ','⎥',' ','⎢', '⎛','⎞','⎠','⎝'], 
          \ padding: [0,1,0,1], 
          \ border: [1,1,1,1],
          \ title:'╸━ Coc: Hover ━╺',
          \ })
  elseif highlight == 'HlCocPuSgtrBg'
    " Coc signature float
    call popup_setoptions(g:coc_last_float_win, #{
          \ borderchars: [' ','⎥',' ','⎢', '⎛','⎞','⎠','⎝'], 
          \ padding: [0,1,0,1], 
          \ border: [1,1,1,1],
          \ title:'╸━ Coc: Signature ━╺',
          \ })
  elseif highlight == 'HlCocPuDiagBg'
    " Coc diagnostic float
    call popup_setoptions(g:coc_last_float_win, #{
          \ borderchars: [' ','⎥',' ','⎢', '⎛','⎞','⎠','⎝'], 
          \ padding: [0,1,0,1], 
          \ border: [1,1,1,1],
          \ title:'╸━ Coc: Diagnostic ━╺',
          \ })
  elseif highlight == 'HlCocPuSugsBg'
    " Coc suggestion float
    call popup_setoptions(g:coc_last_float_win, #{
          \ borderchars: [' ','⎥',' ','⎢', '⎛','⎞','⎠','⎝'], 
          \ padding: [0,0,0,0], 
          \ border: [0,0,0,0],
          \ title:'╸━ Coc: Suggestion ━╺',
          \ })
  elseif name =~ '\[List Preview]'
    echom 'preview'
  else
    call popup_setoptions(g:coc_last_float_win, #{
          \ borderchars: [' ','⎥',' ','⎢', '⎛','⎞','⎠','⎝'], 
          \ padding: [0,1,0,1], 
          \ border: [1,1,1,1],
          \ title:'╸━ Coc ━╺',
          \ line: 'cursor+2'
          \ })
  endif
endfunc

augroup CocEvents
  autocmd!
  " Highlight symbol under cursor on CursorHold
  au CursorHold * silent call CocActionAsync('highlight')

  " on startup
  " au User CocNvimInit echom "---CocNvimInit---"

  " On diagnostics changed
  "au User CocStatusChange,CocDiagnosticChange call dostuff()
  " au User CocStatusChange echom "---CocStatusChange---"
  " au User CocDiagnosticChange echom "---CocDiagnosticChange---"
  au User CocStatusChange,CocDiagnosticChange silent call s:OnCocDiagnosticChange()

  "Triggered on jump to placeholder
  " au User CocJumpPlaceholder echom "---CocJumpPlaceholder---"
  au User CocJumpPlaceholder silent call CocActionAsync('showSignatureHelp')

  "Triggered when a floating window is opened.  The window is not
  "focused, use |g:coc_last_float_win| to get window id.
  au User CocOpenFloat silent call s:OnCocOpenFloat()

  "Triggered when terminal shown (e.g. for adjusting window height)
  " au User CocTerminalOpen echom '---CocTerminalOpen---'

  "Triggered on location list change,
  "   new list in: g:coc_jump_locations
  " 'filename': full file path.
  " 'lnum': line number (1 based).
  " 'col': column number(1 based).
  " 'text':  line content of location.
  let g:coc_enable_locationlist = 0
  " au User CocLocationsChange echom '---CocLocationsChange---'
  au User CocLocationsChange silent call s:OnCocLocationsChange()
augroup END
