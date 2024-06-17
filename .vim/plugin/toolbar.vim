if exists("g:mayhem_loaded_toolbar")
  finish
endif
let g:mayhem_loaded_toolbar = 1

" SF icons can be suffixed with:
" :monochrome
" :hierarchical
" :palette
" :multicolor
" :variable-[0..1]
"
"ᖠᖢ

let g:mayhem_toolbarToggles = {
      \ 'virtualedit': {
        \ 'priority': '1.510',
        \ 'states': {
          \ 'block': {
            \ 'next': '"insert"',
            \ 'ttip': 'virtualedit: insert; click to toggle',
            \ 'icon': 'cursorarrow.and.square.on.square.dashed'
          \ },
          \ 'insert': {
            \ 'next': '"none"',
            \ 'ttip': 'virtualedit: off; click to toggle',
            \ 'icon': 'filemenu.and.cursorarrow'
          \ },
          \ 'none': {
            \ 'next': '"block"',
            \ 'ttip': 'virtualedit: block; click to toggle',
            \ 'icon': 'dots.and.line.vertical.and.cursorarrow.rectangle'
          \ },
          \ '*': {
            \ 'next': '"block"',
            \ 'ttip': 'virtualedit: ???; click to toggle',
            \ 'icon': 'dots.and.line.vertical.and.cursorarrow.rectangle'
          \ },
        \ }
      \},
      \ 'delcombine': {
        \ 'priority': '1.520',
        \ 'states': {
          \ 0: {
            \ 'next': 1,
            \ 'ttip': 'nodelcombine; click to toggle',
            \ 'icon': 'delete.left'
          \ },
          \ 1: {
            \ 'next': 0,
            \ 'ttip': 'delcombine; click to toggle',
            \ 'icon': 'delete.left.fill'
          \ },
          \ '*': {
            \ 'next': 1,
            \ 'ttip': 'delcombine: ???; click to toggle',
            \ 'icon': 'delete.left.fill'
          \ },
        \ },
      \ },
    \ }


function! s:RemoveDynamicToolBarToggle(name)
  exec 'silent! aunmenu <silent> ToolBar.Toggle\ '..a:name
endfunc

function! s:UpdateDynamicToolBarToggle(name)
  exec 'silent! aunmenu <silent> ToolBar.Toggle\ '..a:name

  exec 'let value = &g:'..a:name
  let toggles = get(g:, 'mayhem_toolbarToggles', {})
  let toggle = get(toggles, a:name, {})
  let priority = get(toggle, 'priority', '1.555')
  let states = get(toggle, 'states', {})
  let state = get(states, value, get(states, '*', {}))
  let nextvalue = get(state, 'next', v:null)
  let tooltip = get(state, 'ttip', '')
  let icon = get(state, 'icon', 'puzzlepiece.extension')

  if nextvalue isnot v:null
    exec 'an icon='..icon..' '..priority..' ToolBar.Toggle\ '..a:name..' :let &g:'..a:name..'='..nextvalue..'<CR>'
    exec 'tmenu ToolBar.Toggle\ '..a:name..' '..tooltip
  else
    exec 'an icon=exclamationmark.square '..priority..' ToolBar.Toggle\ '..a:name..' <Nop>'
    exec 'tmenu ToolBar.Toggle\ '..a:name..' UpdateDynamicToolBarToggle:Err: No matching state and fallback missing'
  endif
endfunc

function! s:AddDynamicToolBarToggle(name)
  if exists('+'..a:name)
    augroup DynamicToolBar
      exec 'autocmd OptionSet '..a:name..' exec s:UpdateDynamicToolBarToggle(expand(''<amatch>''))'
      " exec 'autocmd OptionSet '..a:name..' call s:UpdateDynamicToolBar()'
    augroup END

    call s:UpdateDynamicToolBarToggle(a:name)
  else
    let toggles = get(g:, 'mayhem_toolbarToggles', {})
    let toggle = get(toggles, a:name, {})
    let priority = get(toggle, 'priority', '1.555')

    exec 'an icon=questionmark.square.dashed '..priority..' ToolBar.Toggle\ '..a:name..' <Nop>'
    echom 'ToolBarToggle:Err: Setting "'..a:name..'" does not exist'
  endif
endfunc

function! s:RemoveSessionTBStatus()
  silent! aunmenu ToolBar.SessionStatus
endfunc

function! s:UpdateSessionTBStatus()
  silent! aunmenu ToolBar.SessionStatus

  if exists('g:loaded_obsession')
    if exists('g:this_session')
      if exists('g:this_obsession')
        an icon=gear.badge.checkmark:monochrome
              \ 1.110
              \ ToolBar.SessionStatus
              \ :SessionPause<CR>
        exec 'tmenu ToolBar.SessionStatus Obsessing, click to pause. Session:'..v:this_session..')'
      else
        " TODO pause/play icons
        an icon=gear.badge.xmark:multicolor
              \ 1.110
              \ ToolBar.SessionStatus
              \ :SessionResume<CR>
        exec 'tmenu ToolBar.SessionStatus Obsession paused, click to resume  ('..v:this_session..')'
      endif
    else
      an icon=gear.badge.questionmark:multicolor
            \ 1.110
            \ ToolBar.SessionStatus
            \ :SessionCreate<space>
      exec 'tmenu ToolBar.SessionStatus No Session, click to create one'
    endif
  else
    an icon=gear 1.110 ToolBar.SessionStatus <Nop>
    amenu disable ToolBar.SessionStatus
    exec 'tmenu ToolBar.SessionStatus Obsession not loaded.'
  endif
endfunc

function! s:AddSessionTBStatus()
  augroup DynamicToolBar
    " autocmd User Obsession call s:UpdateDynamicToolBar() | redraw!
    " autocmd SessionLoadPost * call s:UpdateDynamicToolBar() | redraw!
    autocmd User Obsession call s:UpdateSessionTBStatus() | redraw!
    autocmd SessionLoadPost * call s:UpdateSessionTBStatus() | redraw!
  augroup END

  call s:UpdateSessionTBStatus()
endfunc

function! s:RemoveDefaultToolBar()
  echom 'removing'
  silent! aunmenu ToolBar.Open
  silent! aunmenu ToolBar.Save
  silent! aunmenu ToolBar.SaveAll
  silent! aunmenu ToolBar.Print
  silent! aunmenu ToolBar.-sep1-
  silent! aunmenu ToolBar.Undo
  silent! aunmenu ToolBar.Redo
  silent! aunmenu ToolBar.-sep2-
  silent! aunmenu ToolBar.Cut
  silent! aunmenu ToolBar.Copy
  silent! aunmenu ToolBar.Paste
  silent! aunmenu ToolBar.LoadSesn
  silent! aunmenu ToolBar.SaveSesn
  silent! aunmenu ToolBar.RunScript
  silent! aunmenu ToolBar.Make
  silent! aunmenu ToolBar.-sep7-
  silent! aunmenu ToolBar.Help

  " an ToolBar.WinClose <Nop>
  " an ToolBar.WinMax <Nop>
  " an ToolBar.WinMin <Nop>
  " an ToolBar.WinSplit <Nop>
  " an ToolBar.WinVSplit <Nop>
  " an ToolBar.WinMaxWidth <Nop>
  " an ToolBar.WinMinWidth <Nop>
endfunc

function! s:AddDynamicToolBar()
  " ---- Status Indicators ------ 100
  call s:AddSessionTBStatus()

  " ------------Sep-------------- 200
  an icon=poweron 1.210 ToolBar.Sep1   <Nop>
  amenu disable ToolBar.Sep1
  " --------- Actions ----------- 300

  an <silent> icon=arrow.rectanglepath 1.310
        \ ToolBar.Reload\ Pane
        \ <Nop>
  tmenu ToolBar.Reload\ Pane Reload current pane

  " an <silent> icon=theatermasks.circle 1.321
  an <silent> icon=theatermasks 1.321
          \ ToolBar.RestartCoc
          \ :CocRestart<CR>
  tmenu ToolBar.RestartCoc Restart Coc
  an <silent> icon=hammer.circle 1.322
          \ ToolBar.PopupClear
          \ call popup_clear()
  tmenu ToolBar.PopupClear Clear Floating Windows
  an <silent> icon=hourglass.circle 1.323
          \ ToolBar.Unused1 <Nop>
  " an <silent> icon=exclamationmark.bubble.circle 1.324
  an <silent> icon=exclamationmark.bubble 1.324
          \ ToolBar.Unused2 <Nop>
  " an <silent> icon=gear.badge.exclamationmark 1.325
  an <silent> icon=gear.badge 1.325
          \ ToolBar.Unused3 <Nop>

  an <silent> icon=gearshape.arrow.triangle.2.circlepath 1.360
        \ ToolBar.ReloadConfig
        \ <Nop>
  tmenu ToolBar.ReloadConfig Reload config

  an <silent> icon=paintpalette 1.370
        \ ToolBar.ReloadColorscheme
        \ :colorscheme vividmayhem
  tmenu ToolBar.ReloadColorscheme Reload Colourscheme

  an <silent> icon=terminal 1.380
        \ ToolBar.Terminal
        \ :terminal
  tmenu ToolBar.Terminal Open Terminal window in split

  nnoremenu icon=folder 1.390
        \ ToolBar.Show\ In\ Finder
        \ <Nop>
  tmenu ToolBar.ShowInFinder Show current file in Finder
  inoremenu icon=questionmark.folder
        \ ToolBar.ShowInFinder
        \ <Nop>

  " ------------Sep-------------- 400
  an icon=poweron 1.410 ToolBar.Sep2   <Nop>
  amenu disable ToolBar.Sep2
  " --------- Toggles ----------- 500

  call s:AddDynamicToolBarToggle('virtualedit')
  call s:AddDynamicToolBarToggle('delcombine')
endfunc

function! s:RemoveDynamicToolBar()
  augroup DynamicToolBar
    autocmd!
  augroup END

  " ---- Status Indicators ------ 100
  call s:RemoveSessionTBStatus()

  " ------------Sep-------------- 200
  silent! aunmenu ToolBar.Sep1
  " --------- Actions ----------- 300

  silent! aunmenu ToolBar.ReloadPane
  silent! aunmenu ToolBar.ReloadConfig
  silent! aunmenu ToolBar.ReloadColorscheme
  silent! aunmenu ToolBar.Terminal

  silent! aunmenu ToolBar.ShowInFinder

  " ------------Sep-------------- 400
  silent! aunmenu ToolBar.Sep2
  " --------- Toggles ----------- 500

  call s:RemoveDynamicToolBarToggle('virtualedit')
  call s:RemoveDynamicToolBarToggle('delcombine')
endfunc

function! s:UpdateDynamicToolBar()
  call s:RemoveDynamicToolBar()
  call s:AddDynamicToolBar()
endfunc

function! s:InitDynamicToolBar()
  if !exists("g:mayhem_did_toolbar_init")
    let g:mayhem_did_toolbar_init = 1

    if has('toolbar')
      call s:RemoveDefaultToolBar()
      call s:AddDynamicToolBar()
    endif
  endif
endfunc

command! DynamicToolBar call <SID>InitDynamicToolBar()

