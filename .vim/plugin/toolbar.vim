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

let g:mayhem_toolbarToggles = [
    \ { 'name': 'virtualedit',
      \ 'priority': '1.560',
      \ 'type': 'set',
      \ 'states': {
        \ 'block': {
          \ 'next': '"insert"',
          \ 'ttip': 'virtualedit: ''block'' (click to set to ''insert'')',
          \ 'icon': 'cursorarrow.and.square.on.square.dashed'
        \ },
        \ 'insert': {
          \ 'next': '"none"',
          \ 'ttip': 'virtualedit: ''insert'' (click to set to ''none'')',
          \ 'icon': 'filemenu.and.cursorarrow'
        \ },
        \ 'none': {
          \ 'next': '"block"',
          \ 'ttip': 'virtualedit: ''none'' (click to set to ''block'')',
          \ 'icon': 'dots.and.line.vertical.and.cursorarrow.rectangle'
        \ },
        \ '*': {
          \ 'next': '"block"',
          \ 'ttip': 'virtualedit: ''???'' (click to set to ''block'')',
          \ 'icon': 'dots.and.line.vertical.and.cursorarrow.rectangle'
        \ },
      \ }
    \ },
    \ {
      \ 'name': 'delcombine',
      \ 'priority': '1.570',
      \ 'type': 'set',
      \ 'states': {
        \ 0: {
          \ 'next': 1,
          \ 'ttip': '􀆛 nodelcombine (click to toggle)',
          \ 'icon': 'delete.left'
        \ },
        \ 1: {
          \ 'next': 0,
          \ 'ttip': '􀆜 delcombine (click to toggle)',
          \ 'icon': 'delete.left.fill'
        \ },
        \ '*': {
          \ 'next': 1,
          \ 'ttip': '􀆛 no?delcombine (click to toggle)',
          \ 'icon': 'delete.left.fill'
        \ },
      \ },
    \ },
    \ {
      \ 'name': 'autosynstack',
      \ 'priority': '1.510',
      \ 'type': 'exec',
      \ 'current': 'SynStackAutoStatus',
      \ 'states': {
        \ 1: {
          \ 'next': 'SynStackAuto',
          \ 'ttip': '􀲴 SynStackAuto: On (click to toggle)',
          \ 'icon': 'sparkles.rectangle.stack.fill'
        \ },
        \ 0: {
          \ 'next': 'SynStackAuto',
          \ 'ttip': '􀲳 SynStackAuto: Off (click to toggle)',
          \ 'icon': 'sparkles.rectangle.stack'
        \ },
        \ '*': {
          \ 'next': 'SynStackAuto',
          \ 'ttip': '􀲳 SynStackAuto: ??? (click to toggle)',
          \ 'icon': 'sparkles.rectangle.stack'
        \ },
      \ },
    \ },
  \ ]


function! s:RemoveDynamicToolBarToggle(name)
  exec 'silent! aunmenu <silent> ToolBar.Toggle\ '..a:name
endfunc

" function! s:UpdateToggle(name)
"   exec 'silent! aunmenu <silent> ToolBar.Toggle\ '..a:name

"   exec 'let value = &g:'..a:name
"   let toggles =   get(g:,     'mayhem_toolbarToggles',     {})
"   let toggle =    get(toggles, a:name,                     {})

"   let priority =  get(toggle, 'priority',             '1.555')
"   let states =    get(toggle, 'states',                    {})
"   let state =     get(states,  value,    get(states, '*', {}))
"   let nextvalue = get(state,  'next',                  v:null)
"   let tooltip =   get(state,  'ttip',                      '')
"   let icon =      get(state,  'icon', 'puzzlepiece.extension')

"   if nextvalue isnot v:null
"     exec 'an icon='..icon..' '..priority..
"           \ ' ToolBar.Toggle\ '..a:name..
"           \ ' :let &g:'..a:name..'='..nextvalue..'<CR>'
"     exec 'tmenu ToolBar.Toggle\ '..a:name..' '..tooltip
"   else
"     exec 'an icon=exclamationmark.square '..priority..
"           \ ' ToolBar.Toggle\ '..a:name..' <Nop>'
"     exec 'tmenu ToolBar.Toggle\ '..a:name..
"           \ ' UpdateToggle:Err: No matching state and fallback missing'
"   endif
" endfunc

" function! s:AddSetToggle(toggle)
"   if exists('+'..a:toggle.name)
"     augroup DynamicToolBar
"       exec 'autocmd OptionSet '..a:name..
"             \ ' exec s:UpdateToggle(expand(''<amatch>''))'
"       " exec 'autocmd OptionSet '..a:name..' call s:UpdateDynamicToolBar()'
"     augroup END

"     call s:UpdateToggle(a:name)
"   else
"     let toggles = get(g:, 'mayhem_toolbarToggles', {})
"     let toggle = get(toggles, a:name, {})
"     let priority = get(toggle, 'priority', '1.555')

"     exec 'an icon=questionmark.square.dashed '..priority..' ToolBar.Toggle\ '..a:name..' <Nop>'
"     echom 'ToolBarToggle:Err: Setting "'..a:name..'" does not exist'
"   endif
" endfunc

let s:toggles = {}

function! s:UpdateToggle(name, priority, states, current)
  exec 'silent! aunmenu <silent> ToolBar.Toggle\ '..a:name

  exec 'let value = &g:'..a:name
  " let toggles =   get(g:,     'mayhem_toolbarToggles',     {})
  " let toggle =    get(toggles, a:name,                     {})

  let priority =  get(toggle, 'priority',             '1.555')

  let states =    get(toggle, 'states',                    {})
  let state =     get(states,  value,    get(states, '*', {}))
  let nextvalue = get(state,  'next',                  v:null)
  let tooltip =   get(state,  'ttip',                      '')
  let icon =      get(state,  'icon', 'puzzlepiece.extension')

  if nextvalue isnot v:null
    exec 'an icon='..icon..' '..priority..
          \ ' ToolBar.Toggle\ '..a:name..
          \ ' :let &g:'..a:name..'='..nextvalue..'<CR>'
    exec 'tmenu ToolBar.Toggle\ '..a:name..' '..tooltip
  else
    exec 'an icon=exclamationmark.square '..priority..
          \ ' ToolBar.Toggle\ '..a:name..' <Nop>'
    exec 'tmenu ToolBar.Toggle\ '..a:name..
          \ ' UpdateToggle:Err: No matching state and fallback missing'
  endif
endfunc

" Add a toggle for all enabled entries in g:mayhem_toolbarToggles
function! s:AddToggles()
  " name, type ('set', 'exec'), priority, enable, states
  for toggle in get(g:, 'mayhem_toolbarToggles', [])
    let priority =  get(toggle, 'priority',             '1.555')
    let name =      get(toggle, 'name',                  v:null)
    let type =      get(toggle, 'type',                  'exec')
    let enable =    get(toggle, 'enable',                     1)

    if !enable
      continue
    endif
    if name is v:null
      echom 'AddToggles: Found toggle config entry without a name'
      continue
    endif

    let states =    get(toggle, 'states',                    {})
    
    if type == 'set'
      if exists('+'..name)
        " let Cb = function('s:UpdateToggle', [toggle])

        let toggler = {
              \ 'name': name,
              \ 'states': deepcopy(states),
              \ 'priority': priority,
              \ 'getcurrent': getcurrent,
              \ }
        function toggler.update()
          let name = self['name']
          exec 'silent! aunmenu <silent> ToolBar.Toggle\ '..name
          exec 'let current = &g:'..self['current']
          let states    = get(self,  'states', {}                     )
          let state     = get(states, current, get(states, '*', {})   )
          let nextvalue = get(state,   'next', v:null                 )

          if nextvalue isnot v:null
            let tooltip = get(state,   'ttip', '􀥭'..name..': '..state..' (click to toggle)')
            let icon    = get(state,   'icon', 'puzzlepiece.extension')

            exec 'an icon='..icon..' '..priority..
                  \ ' ToolBar.Toggle\ '..name..' '..nextvalue..'<CR>'
                  " \ ' :let &g:'..name..'='..nextvalue..'<CR>'
            exec 'tmenu ToolBar.Toggle\ '..name..' '..tooltip
          else
            exec 'an icon=exclamationmark.square '..priority..
                  \ ' ToolBar.Toggle\ '..name..' <Nop>'
            exec 'tmenu ToolBar.Toggle\ '..name..
                  \ ' Toggle.update():Err: No matching state and fallback missing'
          endif
        endfunc

        let s:toggles[name] = toggler
        augroup DynamicToolBar
          exec 'autocmd OptionSet '..name..
                \ ' exec s:toggles[expand(''<amatch>'')].update()'
"         exec 'autocmd OptionSet '..name..
"               \ ' call s:UpdateDynamicToolBar()'
        augroup END

        call s:UpdateToggle(name)
      else
        exec 'an icon=questionmark.square.dashed '..priority..' ToolBar.Toggle\ '..name..' <Nop>'
        echom 'ToolBarToggle:Err: Setting "'..name..'" does not exist'
      endif
  endfor

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
        an icon=gear.badge.questionmark:multicolor
              \ 1.110
              \ ToolBar.SessionStatus
              \ :SessionResume<CR>
        exec 'tmenu ToolBar.SessionStatus Obsession paused, click to resume  ('..v:this_session..')'
      endif
    else
      an icon=gear.badge.xmark:multicolor
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
  "  􀍟 gear 􁓹.badge 􁅦.badge.checkmark 􁅧.badge.xmark
  "                   􁅨.badge.questionmark
  call s:AddSessionTBStatus()

  " ------------Sep-------------- 200
  " 􀥤poweron
  " 􁆭 alternatingcurrent
  " 􀍠 ellipsis
  " 􀆉􀆊chevron.left,right  􀆒􀆓chevron.compact.left,right
  " 
  an icon=poweron 1.210 ToolBar.Sep1   <Nop>
  amenu disable ToolBar.Sep1
  " --------- Actions ----------- 300

  "     Reload Pane
  " an <silent> icon=arrow.rectanglepath 1.310
  "       \ ToolBar.Reload\ Pane
  "       \ <Nop>
  " tmenu ToolBar.Reload\ Pane Reload current pane

  " CocRestart:
  " 􀺧 theatermasks 􀺨 .fill
  " 􁔘 theatermask.and.paintbrush 􁕒.fill
  an <silent> icon=theatermasks 1.321
          \ ToolBar.RestartCoc
          \ :CocRestart<CR>
  tmenu ToolBar.RestartCoc Restart Coc

  " PopupClear:
  " 􀠳 pip 􀠴 .fill 
  "        􀭲 .remove 􀭱 .swap 􀑧 .exit 􀑨 .enter
  an <silent> icon=pip.remove 1.322
          \ ToolBar.PopupClear
          \ call popup_clear()
  tmenu ToolBar.PopupClear 􀭲 Clear Floating Windows

  " Unused:
  " 􀖇hourglass 􀖈.bottomhalf.filled 􀖉.tophalf.filled
  "             􁇛.circle 􁇜.circle.fill
  an <silent> icon=hourglass.circle 1.323
          \ ToolBar.Unused1 <Nop>

  " Unused:
  " 􀌬 exclamationmark.bubble 􀌭.fill
  " 􁃒 bubble.left.and.exclamationmark.bubble.right 􁃓 .fill
  an <silent> icon=exclamationmark.bubble 1.324
          \ ToolBar.Unused2 <Nop>
  " an <silent> icon=gear.badge.exclamationmark 1.325
  an <silent> icon=gear.badge 1.325
          \ ToolBar.Unused3 <Nop>
  " 􀣋 gearshape 􀣌.fill 􀥎 .2  􀥏 .2.fill 􀺼.circle
  "           􁐂.arrow.triangle.2.circlepath  
  an <silent> icon=gearshape.arrow.triangle.2.circlepath 1.360
        \ ToolBar.ReloadConfig
        \ <Nop>
  tmenu ToolBar.ReloadConfig 􁐂 Reload config

  " 􀝥 paintpalette 􀝦.fill
  " 􀎑 paintbrush 􀎒.fill
  " 􀣶 paintbrush.pointed 􀣷.fill
  " 􁙧 swatchpalette 􁙨.fill
  an <silent> icon=paintpalette 1.370
        \ ToolBar.ReloadColorscheme
        \ :colorscheme vividmayhem
  tmenu ToolBar.ReloadColorscheme 􀝥 Reload Colourscheme

  " 􀩼 terminal 􀪏.fill 􂝕 .circle 􂝖.circle.fill
  " 􁹛  apple.terminal.on.rectangle 􁹜  .fill
  an <silent> icon=terminal 1.380
        \ ToolBar.Terminal
        \ :terminal
  tmenu ToolBar.Terminal 􀩼 Open Terminal window in split

  " 􀈕 folder 􀈖.fill
  " 􀬔 questionmark.folder
  nnoremenu icon=folder 1.390
        \ ToolBar.ShowInFinder
        \ <Nop>
  inoremenu icon=questionmark.folder
        \ ToolBar.ShowInFinder
        \ <Nop>
  tmenu ToolBar.ShowInFinder 􀈕 Show current file in Finder

  " ------------Sep-------------- 400
  an icon=poweron 1.410 ToolBar.Sep2   <Nop>
  amenu disable ToolBar.Sep2
  " --------- Toggles ----------- 500

  call s:AddToggles()
  " call s:AddToggle('virtualedit')
  " call s:AddToggle('delcombine')
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

  call s:RemoveToggles()
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

