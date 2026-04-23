if exists("g:mayhem_loaded_coc_commands")
  finish
endif
let g:mayhem_loaded_coc_commands = 1

"
" Related: ../autoload/colcol.vim
"                    ./signs.vim
"

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
  if CocHasProvider('definition') 
    try
      call CocAction('jumpDefinition')
      " call CocAction('jumpDeclaration')
      " call CocAction('jumpImplementation')
      " call CocAction('jumpTypeDefinition')
      " call CocAction('jumpReferences')
      " call CocAction('jumpUsed')
    catch /.*/
      if v:exception =~# 'E605'
        echom "caught E605 : " .. v:exception
      else
        echom "caught : " .. v:exception
      endif
    endtry
  else
    if expand('<cfile>')
      exec "normal gF" 
    endif
  endif
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

"   new list in: g:coc_jump_locations
function s:OnCocLocationsChange() abort
   let g:last_coc_jump_locations = g:coc_jump_locations
   " call setloclist(0, g:coc_jump_locations) | lwindow
   CocList --normal -A location
endfunc


" Highlight groups for different diagnostic severity
let s:severity_to = #{
      \ E: #{ desc: '􀋊 Error',
      \ highlight: 'PopDiagErr', 
      \ borderhighlight: ['PopDiagErrBd'],
      \ scrollbarhighlight: 'PopDiagErrSb',
      \ thumbhighlight: 'PopDiagErrTb',
      \ },
      \ W: #{ desc: '􀅎️⃤ Warning',
      \ highlight: 'PopDiagWarn',
      \ borderhighlight: ['PopDiagWarnBd'],
      \ scrollbarhighlight: 'PopDiagWarnSb',
      \ thumbhighlight: 'PopDiagWarnTb',
      \ },
      \ I: #{ desc: '􀅳️⃝ Info',
      \ highlight: 'PopDiagInfo',
      \ borderhighlight: ['PopDiagInfoBd'],
      \ scrollbarhighlight: 'PopDiagInfoSb',
      \ thumbhighlight: 'PopDiagInfoTb',
      \ },
      \ H: #{ desc: 'Hint',
      \ highlight: 'PopDiagHint',
      \ borderhighlight: ['PopDiagHintBd'],
      \ scrollbarhighlight: 'PopDiagHintSb',
      \ thumbhighlight: 'PopDiagHintTb',
      \ },
      \}

function s:OnCocOpenFloat() abort
  " w:preview_window = 1
  let cocbufnr = getwininfo(g:coc_last_float_win)
        \->get(0, {})
        \->get('bufnr', -1)

  let name = getbufinfo(cocbufnr)
        \->get(0, {})
        \->get('name', 'unknown')

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

  " Coc float for diagnostic messages
  elseif highlight == 'HlCocPuDiagBg'
    let cocbufnr = winbufnr(g:coc_last_float_win)
    let [lspname, severity, errcode; rest] = getbufline(cocbufnr, '$', '$')
          \->get(0, '(unknown E 000)')
          \->matchlist('❯❯\s*\(\S\+\)\s*❯\s*\([EWIH]\)\?❯\s*\(\S\+\)\?\s*$')[1:3]

    let theme = get(s:severity_to, severity, get(s:severity_to, 'E'))

    call popup_setoptions(g:coc_last_float_win, #{
          \ borderchars: [' ','⎥',' ','⎢', '⎛','⎞','⎠','⎝'], 
          \ highlight: theme.highlight,
          \ borderhighlight: theme.borderhighlight,
          \ scrollbarhighlight: theme.scrollbarhighlight,
          \ thumbhighlight: theme.thumbhighlight,
          \ padding: [0,1,0,1], 
          \ border: [1,1,1,1],
          \ title: '╸━ ' .. theme.desc .. ' (' .. lspname .. ' ' .. errcode .. ') ━╺',
          \ })

    call setbufvar(cocbufnr, "&ft", lspname)
    call setwinvar(g:coc_last_float_win, "&conceallevel", 2)
    call setwinvar(g:coc_last_float_win, "&breakindent", 2)
    call setbufvar(g:coc_last_float_win, "&l:wincolor", 2)

  elseif highlight == 'HlCocPuSugsBg'
    echom popup_getoptions(g:coc_last_float_win)
    echom popup_getpos(g:coc_last_float_win)

    " WinfoLastCocFloat

    " Coc suggestion float
    call popup_setoptions(g:coc_last_float_win, #{
          \ borderchars: ['{','|','━','╰', '⎧','⎞','⎠','⎝'],
          \ padding: [1,0,0,0],
          \ border: [1,0,0,1],
          \ mask: [[2,-1,1,1]],
          \ })
    call popup_move(g:coc_last_float_win, #{
          \ fixed: v:false,
          \ line: 'cursor',
          \ col: 'cursor',
          \ posinvert: v:false,
          \ pos: 'topright',
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

let s:autocmdmap = [
      \ ['DoUserAutocmd MayhemDiagnosticsNeedUpdate',       'CocStatusChange'],
      \ ['DoUserAutocmd MayhemDiagnosticsNeedUpdate',   'CocDiagnosticChange'],
      \ ['call CocActionAsync("showSignatureHelp")',     'CocJumpPlaceholder'],
      \ ['call s:OnCocOpenFloat()',                            'CocOpenFloat'],
      \ ['call s:OnCocTerminalOpen()',                      'CocTerminalOpen'],
      \ ['echom "---CocNvimInit---"',                           'CocNvimInit'],
      \ ['call s:OnCocLocationsChange()',                'CocLocationsChange'],
      \]

call autocmd_add(mapnew(s:autocmdmap, {_, vals -> #{
      \ cmd: 'silent ' .. vals[0], pattern: vals[1],
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

