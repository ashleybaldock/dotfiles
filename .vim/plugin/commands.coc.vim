if exists("g:mayhem_loaded_coc_commands")
  finish
endif
let g:mayhem_loaded_coc_commands = 1


function ToggleOutline() abort
  let winid = coc#window#find('cocViewId', 'OUTLINE')
  if winid == -1
    call CocActionAsync('showOutline', 1)
  else
    call coc#window#close(winid)
  endif
endfunc

" nnoremap <silent><nowait> <space>o  :call ToggleOutline()<CR>



"
" Symbols And Ranges:
"
":CocCommand document.jumpToPrevSymbol
":CocCommand document.jumpToNextSymbol




"
" Diagnostics:
"
function s:WorstDiagnosticSeverity() abort
  let diaginfo = get(b:, 'coc_diagnostic_info', {})
  return get(diaginfo, 'error', 0) > 0 ? 'error' :
       \ get(diaginfo, 'warning', 0) > 0 ? 'warning' :
       \ get(diaginfo, 'hint', 0) > 0 ? 'hint' :
       \ get(diaginfo, 'information', 0) > 0 ? 'information' : ''
endfunc
function s:PrevWorstDiagnostic() abort
  return CocActionAsync('diagnosticPrevious', s:WorstDiagnosticSeverity())
endfunc
function s:NextWorstDiagnostic() abort
  return CocActionAsync('diagnosticNext', s:WorstDiagnosticSeverity())
endfunc

command! WorstDiagnosticSeverity echo <SID>WorstDiagnosticSeverity()
command! PrevWorstDiagnostic call <SID>PrevWorstDiagnostic()
command! NextWorstDiagnostic call <SID>NextWorstDiagnostic()


" TODO
" Special extra documentation for various things
"
let s:docOverrideMap = {
      \ '\(n\|i\|c\|v\|x\|s\|o\|t\|l\)\{-,1}map': 'map-table',
      \ '\(args\|q-args\|nargs\|\)': 'args-table',
      \ '': 'regex',
      \ 'command': '',
      \ }

function s:ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('definitionHover')
    " call CocActionAsync('doHover')
    " call CocActionAsync('getHover')
  endif
  if &filetype == 'vim'
    try
      execute 'h '..expand('<cWORD>')
    catch /^Vim\%((\a\+)\)\=:E149:/
      try
        execute 'h '..expand('<cword>')
      catch /^Vim\%((\a\+)\)\=:E149:/
        echo 'Not helpful'
      endtry
    endtry
  endif
endfunc

command! ShowDocumentation call <SID>ShowDocumentation()

" TODO
" add a cursorhold command to show a small hint if there is
"  a custom help item

"
" Jump to a useful location from current cursor position
"
function s:JumpSomewhere()
  try
    call CocAction('jumpDefinition')
  catch /^Vim\%((\a\+)\)\=:E605:/
    echo "caught " .. v:exception
    
  endtry
endfunc

command! -bar JumpSomewhere call <SID>JumpSomewhere()



"
" Completion:
"

  " • Disable completion for buffer: |b:coc_suggest_disable|
  " • Disable specific sources for buffer: |b:coc_disabled_sources|
  " • Disable words for completion: |b:coc_suggest_blacklist|
  " • Add additional keyword characters: |b:coc_additional_keywords|

" Related functions:~

  " • Trigger completion with options: |coc#start()|.
  " • Trigger completion refresh: |coc#refresh()|.
  " • Select and confirm completion: |coc#_select_confirm()|.
  " • Check if the custom popupmenu is visible: |coc#pum#visible()|.
  " • Select the next completion item: |coc#pum#next()|.
  " • Select the previous completion item: |coc#pum#prev()|.
  " • Cancel completion and reset trigger text: |coc#pum#cancel()|.
  " • Confirm completion: |coc#pum#confirm()|.
  " • Close the popupmenu only: |coc#pum#stop()|.
  " • Get information about the popupmenu: |coc#pum#info()|.
  " • Select specific completion item: |coc#pum#select()|.
  " • Insert word of selected item and finish completion: |coc#pum#insert()|.
  " • Insert one more character from current complete item: |coc#pum#one_more()|.
  " • Scroll popupmenu: |coc#pum#scroll()|.

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




"
" Events And Autocommands:
"

function s:OnCocDiagnosticChange()
  if exists('#User#MayhemEnterVisual')
    doautocmd User MayhemEnterVisual
  endif
endfunc

function s:OnCocLocationsChange() abort
"   new list in: g:coc_jump_locations
   let g:last_coc_jump_locations = g:coc_jump_locations
   " call setloclist(0, g:coc_jump_locations) | lwindow
   CocList --normal -A location
endfunc


function s:OnCocOpenFloat() abort
  " w:preview_window = 1
  let cocbufnr = get(get(getwininfo(g:coc_last_float_win), 0, {}), 'bufnr', -1)
  " let name = get(get(getbufinfo(get(get(getwininfo(g:coc_last_float_win), 0, {}), 'bufnr', -1)), 0, {}), 'name', 'unknown')
  let name = getwininfo(g:coc_last_float_win)->get(0, {})->get('bufnr', -1)->getbufinfo()->get(0, {})->get('name', 'unknown')

  let popOpts = popup_getoptions(g:coc_last_float_win)
  let highlight = get(popOpts, 'highlight', 'unknown')

  if highlight == 'HlCocPuHovrBg'
    " Coc hover float
    call popup_setoptions(g:coc_last_float_win, #{
          \ line: "cursor+1",
          \ borderchars: [' ','⎥',' ','⎢', '⎛','⎞','⎠','⎝'], 
          \ padding: [0,1,0,1], 
          \ border: [1,1,1,1],
          \ })
          " \ title:'╸━ Coc: Hover ━╺',
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
          \ })
          " \ title:'╸━ Coc: Diagnostic ━╺',
  elseif highlight == 'HlCocPuSugsBg'
    " Coc suggestion float
    call popup_setoptions(g:coc_last_float_win, #{
          \ borderchars: ['─','⎥','━','⎢', '⎛','⎞','⎠','⎝'], 
          \ padding: [0,0,0,0], 
          \ border: [1,0,0,0],
          \ })
  elseif name =~ '\[List Preview]'
    echom 'preview'
  else
    call popup_setoptions(g:coc_last_float_win, #{
          \ borderchars: [' ','⎥',' ','⎢', '⎛','⎞','⎠','⎝'], 
          \ padding: [0,0,0,0], 
          \ border: [1,1,1,1],
          \ title:'╸━ Coc ━╺',
          \ })
  endif
endfunc

let g:coc_enable_locationlist = 0

let s:modechangemap = [
      \ ['silent DoUserAutocmd MayhemDiagnosticsUpdated',      'CocStatusChange'],
      \ ['silent DoUserAutocmd MayhemDiagnosticsUpdated',  'CocDiagnosticChange'],
      \ ['silent call CocActionAsync("showSignatureHelp")', 'CocJumpPlaceholder'],
      \ ['silent call s:OnCocOpenFloat()',                        'CocOpenFloat'],
      \ ['silent echom "---CocNvimInit---"',                              'CocNvimInit'],
      \ ['silent call s:OnCocLocationsChange()',            'CocLocationsChange'],
      \]

call autocmd_add(mapnew(s:modechangemap, {_, vals -> #{
      \ cmd: vals[0], pattern: vals[1],
      \ event: 'User', replace: v:true,
      \ group: 'mayhem_coc',
      \}}))

call autocmd_add([
      \#{
      \ event: ['CursorHold'],
      \ pattern: '*', cmd: 'silent call CocActionAsync("highlight")',
      \ group: 'mayhem_coc', replace: v:true,
      \},
      \])

      " \#{
      " \ event: 'User', pattern: ['CocStatusChange','CocDiagnosticChange'],
      " \ cmd: 'silent DoUserAutocmd MayhemDiagnosticsUpdated',
      " \ group: 'mayhem_coc', replace: v:true,
      " \},
      " \#{
      " \ event: 'User', pattern: 'CocJumpPlaceholder',
      " \ cmd: 'silent call CocActionAsync("showSignatureHelp")',
      " \ group: 'mayhem_coc', replace: v:true,
      " \},
      " \#{
      " \ event: 'User', pattern: 'CocOpenFloat',
      " \ cmd: 'silent call s:OnCocOpenFloat()',
      " \ group: 'mayhem_coc', replace: v:true,
      " \},
      " \#{
      " \ event: 'User', pattern: 'CocNvimInit',
      " \ cmd: 'echom \"---CocNvimInit---"',
      " \ group: 'mayhem_coc', replace: v:true,
      " \},
      " \#{
      " \ event: 'User', pattern: 'CocLocationsChange',
      " \ cmd: 'silent call s:OnCocLocationsChange()',
      " \ group: 'mayhem_coc', replace: v:true,
      " \},
      " \])

" augroup CocEvents
"   autocmd!
  " Highlight symbol under cursor on CursorHold
  " au CursorHold * silent call CocActionAsync('highlight')

  " on startup
  " au User CocNvimInit echom \"---CocNvimInit---"

  " On diagnostics changed
  "au User CocStatusChange,CocDiagnosticChange call dostuff()
  " au User CocStatusChange echom \"---CocStatusChange---"
  " au User CocDiagnosticChange echom \"---CocDiagnosticChange---"
  " au User CocStatusChange,CocDiagnosticChange silent DoUserAutocmd MayhemDiagnosticsUpdated

  " Triggered on jump to placeholder during snippet completion (in insert mode)
  " au User CocJumpPlaceholder echom \"---CocJumpPlaceholder---"
  " au User CocJumpPlaceholder silent call CocActionAsync('showSignatureHelp')

  "Triggered when a floating window is opened.  The window is not
  "focused, use |g:coc_last_float_win| to get window id.
  " au User CocOpenFloat silent call s:OnCocOpenFloat()
  " au User CocOpenFloatPrompt silent call s:OnCocOpenFloatPrompt()

  "Triggered when terminal shown (e.g. for adjusting window height)
  " au User CocTerminalOpen echom '---CocTerminalOpen---'

  "Triggered on location list change,
  "   new list in: g:coc_jump_locations
  " 'filename': full file path.
  " 'lnum': line number (1 based).
  " 'col': column number(1 based).
  " 'text':  line content of location.
  " let g:coc_enable_locationlist = 0
  " au User CocLocationsChange echom '---CocLocationsChange---'
  " au User CocLocationsChange silent call s:OnCocLocationsChange()
" augroup END
