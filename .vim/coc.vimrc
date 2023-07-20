
let g:coc_node_path = '/opt/homebrew/bin/node'

inoremap <silent><expr> <c-space> coc#refresh()

" nnoremap <C-g><C-G> :YcmCompleter GoTo<CR>                TODO
" nnoremap <C-g><C-r> :YcmCompleter RefactorRename          TODO
" nnoremap <C-g><C-i> :YcmCompleter OrganizeImports<CR>    TODO

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> <C-g><C-v> <Plug>(coc-diagnostic-prev)
nmap <silent> gv <Plug>(coc-diagnostic-prev)
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
    " return l:errors == 0 ? '' : l:errors > 9 ? '‼️ ' : printf('❗️%d', l:errors)
    return l:errors == 0 ? '' : l:errors > 9 ? '‼️ ' : printf('❗️%d', l:errors)
  endif
  return ''
endfunction
function! DiagWarnings()
  if exists('g:did_coc_loaded')
    let l:diaginfo = get(b:, 'coc_diagnostic_info', {})
    let l:errors = get(l:diaginfo, 'error', 0)
    let l:warnings = get(l:diaginfo, 'warning', 0)
    " return l:errors > 0 || l:warnings == 0 ? '' : l:warnings > 9 ? '⚠️ ' : printf('⚡️%d', l:warnings)
    return l:errors > 0 || l:warnings == 0 ? '' : '!⃝ '
  endif
  return ''
endfunction
function! DiagOk()
  if exists('g:did_coc_loaded')
    let l:diaginfo = get(b:, 'coc_diagnostic_info', {})
    let l:errors = get(l:diaginfo, 'error', 0)
    let l:warnings = get(l:diaginfo, 'warning', 0)
    " return l:errors + l:warnings == 0 ? '✅ 💚🟢  ✔⃣ ' : ''
    " return l:errors + l:warnings == 0 ? '✓⃣  ✔⃣ ' : ''
    return l:errors + l:warnings == 0 ? '✓⃝ ' : ''
  endif
  "  ✓  !  +  =  &  $  %  £  @  §   ☻  ✎  ✏︎  ✐  ⚑ ⚐  ☯︎  ★  ✕  ✖︎  ✗  ✘  ⌥  ⇥  ⇤  ⎇  ⚙︎  ⌀  ⎌  ␦  ⏣  |
  "  ✓  !  +  =  &  $  %  £  @  §   ☻  ✎  ✏︎  ✐  ⚑ ⚐  ☯︎  ★  ✕  ✖︎  ✗  ✘  ⌥  ⇥  ⇤  ⎇  ⚙︎  ⌀  ⎌  ␦  ⏣  |
  "  ✓  !  +  =  &  $  %  £  @  §   ☻  ✎  ✏︎  ✐  ⚑ ⚐  ☯︎  ★  ✕  ✖︎  ✗  ✘  ⌥  ⇥  ⇤  ⎇  ⚙︎  ⌀  ⎌  ␦  ⏣  |
  "
  " ?⃝ `⃝ ~⃝ ,⃝ .⃝ /⃝  <⃝  >⃝  ^⃝  *⃝  (⃝  )⃝  [⃝  ]⃝  {⃝  }⃝  ;⃝  :⃝  \⃝  |⃝  ±⃝  -⃝    !⃝    |
  "
  " ?⃣  `⃣  ~⃣  ,⃣  .⃣  /⃣  <⃣  >⃣  ^⃣  *⃣  (⃣  )⃣  [⃣  ]⃣  {⃣  }⃣  ;⃣  :⃣  \⃣  |⃣  ±⃣  -⃣    !⃣   |
  "
  " ? ` ~ , . / < > ^ * ( ) [ ] { } ; : \ | ± - 
  " ?⃟ `⃟ ~⃟ ,⃟ .⃟ /⃟ <⃟ >⃟ ^⃟ *⃟ (⃟ )⃟ [⃟ ]⃟ {⃟ }⃟ ;⃟ :⃟ \⃟ |⃟ ±⃟ -⃟ 
  " ?⃠ `⃠ ~⃠ ,⃠ .⃠ /⃠ <⃠ >⃠ ^⃠ *⃠ (⃠ )⃠ [⃠ ]⃠ {⃠ }⃠ ;⃠ :⃠ \⃠ |⃠ ±⃠ -⃠ 
  "  ✗⃣  ✘⃣  ⌥⃣  ✓⃣  !⃣  +⃣  =⃣  &⃣  $⃣  %⃣  £⃣  @⃣  §⃣  ☻⃣  ✎⃣     ✐⃣  ⚑⃣  ⚐⃣     ★⃣  ✕⃣     ⇥⃣  ⇤⃣  ⎇⃣     ⌀⃣  ⎌⃣  ␦⃣  ⏣⃣     |
  "  ✓⃤  !⃤  ?⃤  `⃤  ~⃤  ,⃤  .⃤  /⃤  <⃤  >⃤  ^⃤  *⃤  (⃤  )⃤  [⃤  ]⃤  {⃤  }⃤  ;⃤  :⃤  \⃤  |⃤  ±⃤  -⃤  +⃤  &⃤  $⃤  %⃤  £⃤  @⃤  §⃤  ☻⃤  ✎⃤    |
  "  ✐⃤  ⚑⃤  ⚐⃤  ☯︎⃤  ★⃤  ✕⃤  ✖︎⃤  ✗⃤  ✘⃤  ⌥⃤  ⇥⃤  ⇤⃤  ⎇⃤  ⚙︎⃤  ⌀⃤  ⎌⃤  ␦⃤  ⏣⃤  |⃤       |
  "  ✓⃞  !⃞  +⃞  =⃞  &⃞  $⃞  %⃞  £⃞  @⃞  §⃞  ☻⃞  ✎⃞     ✐⃞  ⚑⃞  ⚐⃞     ★⃞  ✕⃞     ✗⃞  ✘⃞  ⌥⃞  ⇥⃞  ⇤⃞  ⎇⃞     ⌀⃞  ⎌⃞  ␦⃞  ⏣⃞  |
  "
  " Menlo
  " ------------------------------------------------------------------------------------------------
  " |+1:|                   f⃝     h⃝          k⃝  l⃝                                              |:+1|
  " | 0:| A⃝  B⃝ b⃝  C⃝  D⃝ d⃝  E⃝  F⃝  G⃝  H⃝  I⃝ i⃝     K⃝  L⃝  M⃝  N⃝  O⃝  P⃝     R⃝  S⃝  T⃝  U⃝  V⃝  W⃝  X⃝  Y⃝  Z⃝   |
  " |-1:|  |       |       |     |                   |  |  |  |     |  |  |  |  |  |  |  |  |  |
  " |   |  |       |       |     |         J⃝         |  |  |  | Q⃝   |  |  t⃝  |  |  |  |  |  |  |
  " |-3:|  a⃝       c⃝       e⃝     |          j⃝        m⃝  n⃝  o⃝  |  |  r⃝  s⃝     u⃝  v⃝  w⃝  x⃝  |  z⃝  |
  " |   |                        |                            |  |                       |     |
  " |-5:|                        |                            p⃝  q⃝                       |     |
  " |-6:|                        g⃝                                                       y⃝         |
  " ------------------------------------------------------------------------------------------------
  " Menlo
  " ---------------------------------------------------------------------------------------------------------
  " |+1:|               f⃝     h⃝        k⃝  l⃝         |+1|!⃝                                                 |:+1|
  " | 0:| A⃝  B⃝  C⃝  D⃝  E⃝  F⃝  G⃝  H⃝  I⃝     K⃝  L⃝  M⃝  N⃝  | 0|!⃝  1⃝  2⃝  3⃝  4⃝  5⃝  6⃝  7⃝  8⃝  9⃝  0⃝                   |: 0|
  " | 0:|     b⃝     d⃝              i⃝                | 0|!⃝                                                 |: 0|
  " | 0:|   O⃝  P⃝     R⃝  S⃝  T⃝  U⃝  V⃝  W⃝  X⃝  Y⃝  Z⃝      | 0|!⃝    ✓⃝  &⃝  £⃝  $⃝  %⃝  ☻⃝  ⚑⃝  ⚐⃝  ★⃝  ✎⃝  ⇥⃝  ⇤⃝  ⎇⃝  ⌥⃝     |: 0|
  " |-1:|                                           |-1|!⃝  ✕⃝  ✘⃝  ⌀⃝  ✐⃝  |⃝  (⃝  )⃝  {⃝  }⃝  [⃝  ]⃝                |:-1|
  " |-2:|         Q⃝        t⃝         J⃝              |-2|!⃝   +⃝  =⃝  ±⃝  -⃝  §⃝  ␦⃝  ✗⃝  ~⃝  /⃝  <⃝  >⃝  \⃝            |:-2|
  " |-3:| a⃝     c⃝     e⃝       u⃝       j⃝       m⃝  n⃝  |-3|!⃝    @⃝  :⃝  ⎌⃝  ⏣⃝                                   |:-3|
  " |-3:|   o⃝        r⃝  s⃝        v⃝  w⃝  x⃝     z⃝      |-3|!⃝                                                 |:-3|
  " |-4:|                                           |-4|!⃝                                                 |:-4|
  " |-5:|      p⃝  q⃝                                 |-5|!⃝  ;⃝                                              |:-5|
  " |-6:|                   g⃝               y⃝       |-6|!⃝                                                 |:-6|
  " ---------------------------------------------------------------------------------------------------------
  "  
  " Monaco
  " ---------------------------------------------------------------------------------------------------------
  " |+1:|    b⃝     d⃝     f⃝     h⃝  i⃝     k⃝  l⃝      |+1| 1⃝  2⃝                          £⃝                  |:+1|
  " | 0:| A⃝  B⃝  C⃝  D⃝  E⃝  F⃝  G⃝  H⃝  I⃝     K⃝  L⃝  M⃝   | 0|       3⃝  4⃝  5⃝  6⃝  7⃝  8⃝  9⃝  0⃝                     |: 0|
  " | 0:|  N⃝  O⃝  P⃝     R⃝  S⃝  T⃝  U⃝  V⃝  W⃝  X⃝  Y⃝  Z⃝  | 0| ✓⃝  !⃝  &⃝  $⃝  %⃝  ☻⃝  ✎⃝  ✐⃝  ⇥⃝  ⇤⃝  ⎇⃝  ⌥⃝               |: 0|
  " |-1:|                    t⃝                    |-1| +⃝  =⃝  §⃝  ⚑⃝  ✘⃝  ⌀⃝  ⎌⃝  ␦⃝  ⏣⃝  |⃝  (⃝  )⃝  {⃝  }⃝  [⃝  ]⃝   |:-1|
  " |-2:| a⃝     c⃝     e⃝              J⃝        m⃝   |-2|                                                  |:-2|
  " |   |  n⃝  o⃝     Q⃝  r⃝  s⃝        v⃝  w⃝  x⃝     z⃝  |-2| ±⃝  -⃝  @⃝  ⚐⃝  ★⃝  ✕⃝  ✗⃝  ~⃝  /⃝  <⃝  >⃝  :⃝  \⃝            |:-2|
  " |-3:|                       u⃝    j⃝            |-3|                                                  |:-3|
  " |-4:|                                         |-4|                                                  |:-4|
  " |-5:|        p⃝  q⃝       g⃝               y⃝     |-5| ;⃝                                                |:-5|
  " ---------------------------------------------------------------------------------------------------------
  "  
  "
  "
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
