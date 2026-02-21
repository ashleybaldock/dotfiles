if exists("g:mayhem_loaded_messages")
  finish
endif
let g:mayhem_loaded_messages = 1

"
" Highlighting For:
"  Messages:    ../syntax/vimmessages.vim
"  Scriptnames: ../syntax/vimscriptnames.vim
"

" let s:bufnr_messages
" let s:popid_messages
" let s:winid_scriptnames
" let s:winid_runtime

function s:GetRuntimeList() abort
  return split(&rtp, ',')[1:-1]
endfunc

function s:GetScriptnamesList() abort
  return execute('silent scriptnames')->split('\s*\n\s*')
  " echo execute('silent scriptnames')->split('\s*\n\s*')->map({_,s -> split(s, '\s*:\s*')})
endfunc

function s:GetMessagesList() abort
  return s:ExpandMessages(execute('silent messages')->split("\n")[1:-1])
endfunc


function s:SplitWithRuntime() abort
  :8new
  let s:winid_runtime = win_getid(winnr())
  call append('$', s:GetRuntimeList())
  setlocal filetype=vimmessages buftype=nofile bufhidden=wipe nobuflisted nomodified nomodifiable
endfunc

function s:SplitWithScriptnames() abort
  :9new
  let s:winid_scriptnames = win_getid(winnr())
  call append('$', s:GetScriptnamesList())
  setlocal filetype=vimmessages buftype=nofile bufhidden=wipe nobuflisted nomodified nomodifiable
endfunc


command! ListPlugins call s:SplitWithScriptnames()
command! Runtime call s:SplitWithRuntime()

"
" Expand <SNR> in messages output with real file names      TODO
"
function s:ExpandMessages(messages) abort
  let replaceSNR = mapnew(a:messages,
        \{i, v -> substitute(v,
        \ '\%(\.\.\(function\|script\)\?\)\?<SNR>\(\d\+\)_\([^.[]\+\)\[\(\d*\)]',
        \   {m -> "  " .. m[3] .. "		" .. m[1] .. getscriptinfo(#{
        \ sid: str2nr(m[2], 10)})[0].name .. ':' .. m[4] .. "\n" }, 'g')->split("\n")})->flatten(1)
  "let replaceHome = map(replaceSNR,
   "     \ {_, p -> substitute(p, expand('$VIMHOME') .. '[]', 'g')
  return replaceSNR
endfunc

if v:vim_did_enter
  call s:OnVimEnter('direct')

  call autocmd_add([
        \#{
        \ event: 'VimEnter', once: v:true,
        \ cmd: 'call s:OnVimEnter("auto")',
        \ group: 'mayhem_messages_init', replace: v:true,
        \},
        \])
endif

function s:WriteMessagesToBufferInWindow(winid) abort
  let bufnr = winbufnr(a:winid)

  let messages = s:GetMessagesList()
  if win_gettype(a:winid) == 'popup'
    call appendbufline(bufnr, 0, messages)
  else
    silent call deletebufline(bufnr, 1, '$')
    call appendbufline(bufnr, '$', '╺┅╸ Startup Messages ╺┅╸')
    call appendbufline(bufnr, '$', '')
    call appendbufline(bufnr, '$', get(s:, 'startup_messages', []))
    call appendbufline(bufnr, '$', '')
    call appendbufline(bufnr, '$', '╺╱╸ Recent Messages ╺╲╸╺')
    call appendbufline(bufnr, '$', '')
    call appendbufline(bufnr, '$', messages)
    call appendbufline(bufnr, '$', '')
    call appendbufline(bufnr, '$', '╰┄╮ Fin ╟︎⟩︎╳︎⟨︎╢︎')
    call win_execute(a:winid, ['call cursor(''$'', 0)', 'redraw'])
  endif
endfunc

function s:RefreshMessages() abort
  call setbufvar(s:bufnr_messages, '&filetype', 'vimmessages')
  call setbufvar(s:bufnr_messages, '&buftype', 'nofile')
  call setbufvar(s:bufnr_messages, '&bufhidden', 'wipe')
  call setwinvar(winbufnr(s:bufnr_messages), '&modifiable', 1)
  call s:WriteMessagesToBufferInWindow(winbufnr(s:bufnr_messages))
  call setwinvar(winbufnr(s:bufnr_messages), '&modifiable', 0)
  call setwinvar(winbufnr(s:bufnr_messages), '&modified', 0)
endfunc

function s:CloseMessages() abort
  call s:CloseMessagesPopup()
  
  if exists('s:bufnr_messages')
    if bufexists(s:bufnr_messages)
      if exists(winbufnr(s:bufnr_messages))
        call win_execute(winbufnr(s:bufnr_messages), 'close')
      endif
    endif
    unlet s:bufnr_messages
  endif
endfunc

"
" Open a split with output of :messages
"
function s:SplitWithMessages() abort
  if !exists('s:bufnr_messages') || !bufexists(s:bufnr_messages)
    vnew
    let s:bufnr_messages = bufnr()
  endif

  exec s:bufnr_messages .. 'wincmd ^'

  call s:RefreshMessages()

  nnoremap <buffer> <nowait> r <ScriptCmd>call s:RefreshMessages()<CR>
  nnoremap <buffer> <nowait> p <ScriptCmd>call s:SplitWithScriptnames()<CR>
  nnoremap <buffer> <nowait> t <ScriptCmd>call s:SplitWithRuntime()<CR>
  wincmd h
endfunc

function s:CloseMessagesPopup() abort
  if exists('s:popid_messages')
    call popup_close(s:popid_messages)
    unlet s:popid_messages
  endif
endfunc

"
" Key events intercepted by open popup
"
function s:MessagesPopupFilter(winid, key) abort
  if a:key == 'x'
    call s:CloseMessagesPopup()
    return 1
  endif
  return 0
endfunc

"
" Open a popup with recent output of :messages
"
function s:PopupWithMessages() abort
  let s:popid_messages = popup_create('', #{
        \ title: 'Messages',
        \ pos: 'topleft',
        \ minwidth: 40,
        \ maxwidth: 80,
        \ minheight: 6,
        \ padding: [0,1,0,1],
        \ border: [1,1,1,1],
        \ highlight: 'HlPop01Bg',
        \ borderhighlight: ['HlPop01T','HlPop01R','HlPop01B','HlPop01L'],
        \ borderchars: [' ','⎥',' ','⎢', '⎛','⎞','⎠','⎝'],
        \ line: 'cursor',
        \ col: 'cursor',
        \ moved: 'any',
        \ filter: 's:MessagesPopupFilter',
        \ filtermode: 'n'
        \ })

  call s:WriteMessagesToBufferInWindow(s:popid_messages)

  call setbufvar(winbufnr(s:popid_messages), '&filetype', 'vimmessages')
endfunc

command! MessagesPopup call s:PopupWithMessages()

command! MessagesSplit call s:SplitWithMessages()

command! MessagesClose call s:CloseMessages()

command! MessagesRefresh call s:RefreshMessages()

"
" :Mess(ages) [show/hide/toggle] reload [auto/no]
command! Messages call s:SplitWithMessages()

"
" (Crudely) Formatted echo commands
"
" e.g. :EcN 'normal ' | EcB 'bold ' | EcI 'italic ' | EcN 'back to normal'
"
" - Resets hl group at the end of each command
" - Formatting isn't additive, one hl group at a time
" - Spaces at the end of each command aren't preserved
"
"   EcN hello | EcN world!     ->  helloworld! 
"   EcN hello ' ' | EcN world!  ->  hello world!
"
" command! -nargs=1 EcN echoh EchoText | echon <q-args> | echoh None
" command! -nargs=1 EcI echoh EchoItalic | echon <q-args> | echoh None
command! -bar -nargs=1 EcN exec 'echoh EchoText | echon ''' .. <q-args> .. ''' | echoh None'
command! -bar -nargs=1 EcB exec 'echoh HlBold | echon ''' .. <q-args> .. ''' | echoh None'
command! -bar -nargs=1 EcI exec 'echoh HlItalic | echon ''' .. <q-args> .. ''' | echoh None'
command! -bar -nargs=1 EcBI exec 'echoh HlBoldItalic | echon ''' .. <q-args> .. ''' | echoh None'

"
" Echo a highlight group name in its own highlighting
"
" e.g. :EcN See hl group | EcH Constant | EcN for info
"
command! -bar -nargs=1 EcH exec 'echoh ' .. <q-args> .. ' | echon ''' .. <q-args> .. ''' | echoh None'

