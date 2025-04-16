if exists("g:mayhem_loaded_toolbar")
  finish
endif
let g:mayhem_loaded_toolbar = 1

" SF icons can be suffixed with:
" :monochrome
" :hierarchical
" :palette
" :multicolor
" :variable-[0 .. 1]
"
"ᖠᖢ
"
" ᖠ􀺸
"   ᖢ
"
"
"􀛪 􀛩 􀺶 􀺸 􀛨 􀢋
"
"
let g:mayhem_warn_commit_seconds = 1800
let g:mayhem_warn_sync_seconds = 1800




"
" For each state a toggle could be in, a command should be given that, when
" executed, moves the toggle on to the 'next' state.
" e.g. If the current state of 'set wrap?' is 'wrap', executing 'set nowrap'
" moves to the next state (and vice-versa).
"
"    (any)╶╌▻ wrap ────╮         example for 'wrap'
"              ∆       ∇
"              ╰── nowrap
"
"    (any)╶╌▻ none ──▷ block ─╮  example for 'virtualedit'
"              ∆              ∇
"              ╰───────── insert
"
" Any states which aren't defined will use the fallback command defined by
" the key '_default'. This command should, when executed, return the toggle
" to a state for which it has a defined next state.
"
let g:mayhem_toolbarToggles = [
    \ #{ name: 'virtualedit',
      \ priority: '1.560',
      \ type: 'set',
      \ states: #{
        \ block: #{
          \ next: '"insert"',
          \ ttip: 'virtualedit: ''block'' (click to set to ''insert'')',
          \ icon: 'cursorarrow.and.square.on.square.dashed'
        \ },
        \ insert: #{
          \ next: '"none"',
          \ ttip: 'virtualedit: ''insert'' (click to set to ''none'')',
          \ icon: 'filemenu.and.cursorarrow'
        \ },
        \ none: #{
          \ next: '"block"',
          \ ttip: 'virtualedit: ''none'' (click to set to ''block'')',
          \ icon: 'dots.and.line.vertical.and.cursorarrow.rectangle'
        \ },
        \ _default: #{
          \ next: '"block"',
          \ ttip: 'virtualedit: ''???'' (click to set to ''block'')',
          \ icon: 'dots.and.line.vertical.and.cursorarrow.rectangle'
        \ },
      \ }
    \ },
    \ #{
      \ name: 'delcombine',
      \ priority: '1.570',
      \ type: 'set',
      \ states: #{
        \ 0: #{
          \ next: 1,
          \ ttip: 'nodelcombine (click toggle on)',
          \ icon: '􀆛'
        \ },
        \ 1: #{
          \ next: 0,
          \ ttip: 'delcombine (click to toggle off)',
          \ icon: '􀆜'
        \ },
        \ _default: #{
          \ next: 1,
          \ ttip: 'no?delcombine (click to toggle on)',
          \ icon: '􀆛'
        \ },
      \ },
    \ },
    \ #{
      \ name: 'autosynstack',
      \ priority: '1.510',
      \ type: 'exec',
      \ current: 'SynStackAutoStatus',
      \ states: #{
        \ 1: #{
          \ next: 'SynStackAuto',
          \ ttip: '􀲴 SynStackAuto: On (click to toggle)',
          \ icon: 'sparkles.rectangle.stack.fill'
        \ },
        \ 0: #{
          \ next: 'SynStackAuto',
          \ ttip: '􀲳 SynStackAuto: Off (click to toggle)',
          \ icon: 'sparkles.rectangle.stack'
        \ },
        \ _default: #{
          \ next: 'SynStackAuto',
          \ ttip: '􀲳 SynStackAuto: ??? (click to toggle)',
          \ icon: 'sparkles.rectangle.stack'
        \ },
      \ },
    \ },
  \ ]


function! s:RemoveDynamicToolBarToggle(name)
  exec 'silent! aunmenu <silent> ToolBar.Toggle\ ' .. a:name
endfunc

" function! s:UpdateToggle(name)
"   exec 'silent! aunmenu <silent> ToolBar.Toggle\ ' .. a:name

"   exec 'let value = &g:' .. a:name
"   let toggles =   get(g:,     'mayhem_toolbarToggles',     {})
"   let toggle =    get(toggles, a:name,                     {})

"   let priority =  get(toggle, 'priority',             '1.555')
"   let states =    get(toggle, 'states',                    {})
"   let state =     get(states,  value,    get(states, '*', {}))
"   let nextvalue = get(state,  'next',                  v:null)
"   let tooltip =   get(state,  'ttip',                      '')
"   let icon =      get(state,  'icon', 'puzzlepiece.extension')

"   if nextvalue isnot v:null
"     exec 'an icon=' .. icon .. ' ' .. priority..
"           \ ' ToolBar.Toggle\ ' .. a:name..
"           \ ' :let &g:' .. a:name .. '=' .. nextvalue .. '<CR>'
"     exec 'tmenu ToolBar.Toggle\ ' .. a:name .. ' ' .. tooltip
"   else
"     exec 'an icon=exclamationmark.square ' .. priority..
"           \ ' ToolBar.Toggle\ ' .. a:name .. ' <Nop>'
"     exec 'tmenu ToolBar.Toggle\ ' .. a:name..
"           \ ' UpdateToggle:Err: No matching state and fallback missing'
"   endif
" endfunc

" function! s:AddSetToggle(toggle)
"   if exists('+' .. a:toggle.name)
"     augroup DynamicToolBar
"       exec 'autocmd OptionSet ' .. a:name..
"             \ ' exec s:UpdateToggle(expand(''<amatch>''))'
"       " exec 'autocmd OptionSet ' .. a:name .. ' call s:UpdateDynamicToolBar()'
"     augroup END

"     call s:UpdateToggle(a:name)
"   else
"     let toggles = get(g:, 'mayhem_toolbarToggles', {})
"     let toggle = get(toggles, a:name, {})
"     let priority = get(toggle, 'priority', '1.555')

"     exec 'an icon=questionmark.square.dashed ' .. priority .. ' ToolBar.Toggle\ ' .. a:name .. ' <Nop>'
"     echom 'ToolBarToggle:Err: Setting \"' .. a:name .. '" does not exist'
"   endif
" endfunc

function! s:Icon(id, modifiers = '')
  return 'icon=' .. SfId(a:id) .. a:modifiers
endfunc

"
"
" List of active/configured toggles
let s:toggles = {}

let s:defaultIcon = '􀥭'
let s:errIcon = '􀃮'

"
"
"
function! s:UpdateToggle(name, priority, states, current)
  let toggleName = ' ToolBar.Toggle\ ' .. a:name

  exec 'silent! aunmenu <silent> ' .. toggleName

  exec 'let curValue = &g:' .. a:name
  let toggle =    get(s:toggles, a:name,         {})

  let priority =  get(toggle, 'priority',   '1.555')
  let _default =  get(states, '_default',        {})
  let states =    get(toggle, 'states',          {})
  let state =     get(states,  curValue,   _default)
  let nextState = get(state,  'next',        v:null)
  let tooltip =   get(state,  'ttip',            '')
  let icon =      get(state,  'icon', s:defaultIcon)

  if nextState isnot v:null
    exec ['an', s:Icon(icon), priority, toggleName,
          \ ':let &g:' .. a:name .. '=' .. nextState .. '<CR>']->join(' ')
    exec ['tmenu', toggleName, s:Icon(icon), tooltip]->join(' ')
  else
    exec ['an ', s:Icon(s:errIcon), priority, toggleName, '<Nop>']->join(' ')
    exec ['tmenu', toggleName, s:Icon(s:errIcon), 
          \ 'Err:UpdateToggle: nextState missing']->join(' ')
  endif
endfunc

" Add a toggle for all enabled entries in g:mayhem_toolbarToggles
function s:AddToggles()
  " name, type ('set', 'exec'), priority, enable, states
  for toggle in get(g:, 'mayhem_toolbarToggles', [])
    if !get(toggle, 'enable', v:true)
      continue
    endif

    let name = get(toggle, 'name', v:null)
    if name is v:null
      echom 'AddToggles: Found toggle config entry without a name'
      continue
    endif

    let priority = get(toggle, 'priority', '1.555')
    let type = get(toggle, 'type', 'exec')
    let current = get(toggle, 'current',
          \ (type == 'set' && exists('+' .. name)) ? '&g:' .. name : v:null)

    let states = get(toggle, 'states', {})
    
    let toggler = {
          \ 'name': name,
          \ 'states': deepcopy(states),
          \ 'priority': priority,
          \ 'current': current,
          \ }
    function toggler.update()
      let name = self['name']
      exec 'silent! aunmenu <silent> ToolBar.Toggle\ ' .. self['name']
      exec 'let current = ' .. self['current']
      exec 'let current = &g:' .. self['current']
      let states    = get(self, 'states', {})
      let state     = get(states, current, get(states, '_default', {}))
      let nextvalue = get(state, 'next', v:null )

      exec 'an icon=questionmark.square.dashed ' .. priority ..
            \ ' ToolBar.Toggle\ ' .. self['name'] .. ' <Nop>'
      echom 'ToolBarToggle:Err: Setting "' .. self['name'] .. '" does not exist'

      if nextvalue isnot v:null
        let tooltip = get(state, 'ttip', '􀥭' .. self['name'] .. ': ' .. state .. ' (click to toggle)')
        let icon    = get(state, 'icon', 'puzzlepiece.extension')

        exec 'an icon=' .. icon .. ' ' .. priority..
              \ ' ToolBar.Toggle\ ' .. self['name'] .. ' ' .. nextvalue .. '<CR>'
        exec 'tmenu ToolBar.Toggle\ ' .. self['name'] .. ' ' .. tooltip
      else
        exec 'an icon=exclamationmark.square ' .. priority..
              \ ' ToolBar.Toggle\ ' .. self['name'] .. ' <Nop>'
        exec 'tmenu ToolBar.Toggle\ ' .. self['name']..
              \ ' toggler.update():Err: No matching state and fallback missing'
      endif
    endfunc

    let s:toggles[name] = toggler

    augroup DynamicToolBar
      exec 'autocmd OptionSet ' .. name..
            \ ' exec s:toggles[expand(''<amatch>'')]->update()'
    augroup END
  endfor

  echom DictToJson(s:toggles)
  echom FormatJSON(DictToJson(s:toggles))
endfunc


"
" Status Indicators:
"
"
" Session:
"
function s:RemoveStatus_Session()
  silent! aunmenu ToolBar.Status_Session
endfunc

function s:UpdateStatus_Session(toolbarId)
  let name = 'ToolBar.' .. 'Status_Session'
  let id = a:toolbarId
  silent! aunmenu ToolBar.Status_Session

  if exists('g:loaded_obsession')
    if exists('g:this_session')
      if exists('g:this_obsession')
        " gear.badge.checkmark
        exec ['an icon=' .. SfId('􁅦') .. ':monochrome' ..
              \ ' ' .. a:toolbarId ..
              \ ' ToolBar.Status_Session' ..
              \ ' :SessionPause<CR>'
        exec 'tmenu ToolBar.Status_Session ' .. 
              \'􁅦  Obsessing, click to pause. Session:' ..
              \ v:this_session .. ')'
      else
        " gear.badge.questionmark
        exec 'an icon=' .. SfId('􁅨') .. ':multicolor' ..
              \ ' ' .. a:toolbarId ..
              \ ' ToolBar.Status_Session' ..
              \ ' :SessionResume<CR>'
        exec 'tmenu ToolBar.Status_Session ' ..
              \'􁅨  Obsession paused, click to resume  (' ..
              \ v:this_session .. ')'
      endif
    else
      " gear.badge.xmark
      exec 'an icon=' .. SfId('􁅧') .. ':multicolor' ..
              \ ' ' .. a:toolbarId ..
              \ ' ToolBar.Status_Session' ..
              \ ' :SessionCreate<space>'
      exec 'tmenu ToolBar.Status_Session ' .. 
            \'􁅧  No Session, click to create one'
    endif
  else
    " gear 
    exec 'an icon=' .. SfId('􀍟') ..
              \ ' ' .. a:toolbarId ..
              \ ' ToolBar.Status_Session' ..
              \ ' <Nop>'
    exec 'amenu disable ToolBar.Status_Session'
    exec 'tmenu ToolBar.Status_Session ' ..
          \'􀍟  Obsession not loaded.'
  endif
endfunc

function s:AddStatus_Session()
  let s:Status_SessionId = s:MenuNextItem()
  call autocmd_add([
      \#{
      \ event: 'User', pattern: 'Obsession',
      \ cmd: 'call s:UpdateStatus_Session(s:Status_SessionId) | redraw!',
      \ group: 'mayhem_toolbar_events', replace: v:true,
      \},
      \#{
      \ event: 'SessionLoadPost', pattern: '*',
      \ cmd: 'call s:UpdateStatus_Session(s:Status_SessionId) | redraw!',
      \ group: 'mayhem_toolbar_events', replace: v:true,
      \},
      \])

  call s:UpdateStatus_Session(s:Status_SessionId)
endfunc

"
" Git:
"
function s:RemoveStatus_Git()
  silent! aunmenu ToolBar.Status_Git
endfunc

function! GetGitInfo()
  " TODO get real git info
  return #{
        \ lastSynced: localtime(),
        \ unsynced: 1,
        \ uncommitted: 1,
        \ lastCommitted: localtime(),
        \}
endfunc

 " 􀣔 􀱨
function s:UpdateStatus_Git(toolbarId)
  silent! aunmenu ToolBar.Status_Git

  let gitinfo = GetGitInfo()
  if (gitinfo['unsynced'])
        \ && (localtime() > gitinfo['lastSynced'] + g:mayhem_warn_sync_seconds)
    " 􀱨
    an icon=exclamationmark.arrow.trianglehead.2.clockwise.rotate.90:multicolor
          \ 1.110 ToolBar.Status_Git <Nop>
    exec 'tmenu ToolBar.Status_Git 􀯛 ' ..
          \ gitinfo['unsynced'] ' unsynched change'
          \ .. gitinfo['unsynced'] == 1 ? '' : 's'
  elseif (gitinfo['uncommitted'])
        \ && (localtime() > gitinfo['lastCommitted'] + g:mayhem_warn_commit_seconds)
    " 􀱨
    an icon=exclamationmark.arrow.trianglehead.2.clockwise.rotate.90:multicolor
          \ 1.110 ToolBar.Status_Git <Nop>
    exec 'tmenu ToolBar.Status_Git 􀢤 Changes to commit'
  endif
endfunc

function s:AddStatus_Git()
  let s:Status_GitId = s:MenuNextItem()
  call autocmd_add([
        \#{
        \ event: 'User', pattern: 'GitStatusChange',
        \ cmd: 'call s:UpdateStatus_Git(s:Status_GitId) | redraw!',
        \ group: 'mayhem_toolbar_events', replace: v:true,
        \},
        \#{
        \ event: 'SessionLoadPost', pattern: '*',
        \ cmd: 'call s:UpdateStatus_Git(s:Status_GitId) | redraw!',
        \ group: 'mayhem_toolbar_events', replace: v:true,
        \},
        \])
endfunc

function s:RemoveDefaultToolBar()
  echom 'removing default toolbar'
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
  " an ToolBar.WinMinWidth <Nop>  􀙱􀜞􀙲 􀙱􀝎􀙲 
 
endfunc

function! s:MenuBegin(menuname)
  let s:menuname = a:menuname
  "   ┌section
  " 1̲̭.1̅̌1̲̲0̲̭̭…̲    
  " └id └item 
  let s:menuid = 1
  let s:menusection = 1
  let s:menuitem = 10
endfunc

function! s:MenuSeparator(menuname, id = s:MenuNextItem())
  let sepname = a:menuname .. '.Sep' .. s:menusection
  exec 'an icon=' .. SfId('􀥤') .. ' ' .. a:id ..
        \ ' ' .. sepname .. ' <Nop>'
  exec 'amenu disable ' .. sepname

  let s:menusection = s:menusection + 1
  let s:menuitem = 100
endfunc

function! s:MenuNextItem()
  let s:menuitem = s:menuitem + 5
  return 
endfunc

"
function! s:AddDynamicToolBar()
  echom 'adding dynamic toolbar'
  call s:MenuBegin('ToolBar')
  " ---- Status Indicators ------ 100

  "  Session:   􀍟 gear 􁓹.badge
  "   Named : 􁅦.badge.checkmark    
  "    None : 􁅧.badge.xmark        
  "    Auto : 􁅨.badge.questionmark 
  call s:AddStatus_Session()

  " Last Synced: 􀢤
  "  Git has changes and sync > 3 days ago
  "  Git has more than N unsynced changes 
  call s:AddStatus_Git()

  " ------------Sep-------------- 200
  " 􀥤poweron
  " 􁆭 alternatingcurrent
  " 􀍠 ellipsis
  " 􀆉􀆊chevron.left,right
  " 􀆒􀆓chevron.compact.left,right
  " 
  call s:MenuSeparator('ToolBar')
  " an icon=poweron 1.210 ToolBar.Sep1   <Nop>
  " amenu disable ToolBar.Sep1
  " --------- Actions ----------- 300

  "     Reload Pane
  " an <silent> icon=arrow.rectanglepath 1.310
  "       \ ToolBar.Reload\ Pane
  "       \ <Nop>
  " tmenu ToolBar.Reload\ Pane Reload current pane

  " CocRestart:
  " 􀺧 theatermasks 􀺨 .fill
  " 􁔘 theatermask.and.paintbrush 􁕒.fill
  exec 'an <silent> icon=' .. SfId('􀺧') .. ' ' .. s:MenuNextItem() .. 
          \ ' ToolBar.RestartCoc'
          \ ' :CocRestart<CR>'
  tmenu ToolBar.RestartCoc 􀺧  Restart Coc

  " PopupClear:
  " 􀠳 pip 􀠴 .fill 
  "        􀭲 .remove 􀭱 .swap 􀑧 .exit 􀑨 .enter
  exec 'an <silent> icon=' .. SfId('􀭲') .. ' ' .. s:MenuNextItem() ..
          \ ' ToolBar.PopupClear' .. 
          \ ' call popup_clear()'
  tmenu ToolBar.PopupClear 􀭲 Clear Floating Windows

  " Unused:
  " 􀖇hourglass 􀖈.bottomhalf.filled 􀖉.tophalf.filled
  "             􁇛.circle 􁇜.circle.fill
  " an <silent> icon=hourglass.circle 1.323
  "         \ ToolBar.Unused1 <Nop>

  " Unused:
  " 􀌬 exclamationmark.bubble 􀌭.fill
  " 􁃒 bubble.left.and.exclamationmark.bubble.right 􁃓 .fill
  " an <silent> icon=exclamationmark.bubble 1.324
  "         \ ToolBar.Unused2 <Nop>
  " an <silent> icon=gear.badge.exclamationmark 1.325
  " an <silent> icon=gear.badge 1.325
  "         \ ToolBar.Unused3 <Nop>
  " 􀣋 gearshape 􀣌.fill 􀥎 .2  􀥏 .2.fill 􀺼.circle
  "           􁐂.arrow.triangle.2.circlepath  
  " 􁐑 􁐑️⃞  􁐑️⃝ 
  " icon=gearshape.arrow.triangle.2.circlepath 1.360
  " gearshape.arrow.trianglehead.2.clockwise.rotate.90
  exec 'an icon=' .. SfId('􀣋') .. ' ' .. s:MenuNextItem() ..
        \ ' 1.360 ToolBar.ReloadConfig <Nop>'
  tmenu ToolBar.ReloadConfig 􀣋 Reload config

  " 􀝥 􀝦 􀎑 􀎒 􀣶 􀣷 􁙧 􁙨
  exec 'an <silent> icon=' .. SfId('􀝥') .. ' ' .. s:MenuNextItem() ..
        \ ' 1.370 ToolBar.ReloadColorscheme' ..
        \ ' :colorscheme vividmayhem'
  tmenu ToolBar.ReloadColorscheme 􀝥 Reload Colourscheme

  " 􀩼 􀪏 􁹛  􁹜 
  exec 'an <silent> icon=' .. SfId('􀩼') .. ' ' .. s:MenuNextItem() ..
        \ ' 1.380 ToolBar.Terminal :terminal<CR>'
  tmenu ToolBar.Terminal 􀩼 Open Terminal window in split

  " 􀈕 􀈖 􀬔
  exec 'nnoremenu icon=' .. SfId('􀈕') ..  ' ' .. s:MenuNextItem() ..
        \ ' 1.390 ToolBar.ShowInFinder' ..
        \ ' :silent exec "silent !open -R " .. shellescape(expand("%"))<CR>'
  exec 'inoremenu icon=' .. SfId('􀬔') ..  ' ' .. s:MenuNextItem() ..
        \ ' ToolBar.ShowInFinder'
        \ ' silent exec "silent !open -R " .. shellescape(expand("%"))<CR>'
  tmenu ToolBar.ShowInFinder 􀈕 Show current file in Finder

  " ------------Sep-------------- 400
  call s:MenuSeparator('ToolBar')
  " exec 'an icon=' SfId('􀥤') .. ' 1.410 ToolBar.Sep2 <Nop>'
  " amenu disable ToolBar.Sep2
  " --------- Toggles ----------- 500

  call s:AddToggles()
  " call s:AddToggle('virtualedit')
  " call s:AddToggle('delcombine')
endfunc

function! s:RemoveDynamicToolBar()
  call autocmd_delete([
      \#{
      \ event: '*', group: 'mayhem_toolbar_events',
      \},
      \])

  " ---- Status Indicators ------ 100
  call s:RemoveStatus_Session()

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
  " call s:RemoveDynamicToolBarToggle('virtualedit')
  " call s:RemoveDynamicToolBarToggle('delcombine')
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

