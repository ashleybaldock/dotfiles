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

function s:ListRuntime() abort
  return split(&rtp, ',')[1:-1]
endfunc

function s:ListScriptnames() abort
  return execute('silent scriptnames')->split('\s*\n\s*')
  " echo execute('silent scriptnames')->split('\s*\n\s*')->map({_,s -> split(s, '\s*:\s*')})
endfunc

function s:ListMessages() abort
  return execute('silent messages')->split("\n")[1:-1]
endfunc


function s:SplitWithList(list) abort
  exec min(20, max(4, len(a:list))) .. 'new'
  call append('$', a:list)
  setlocal filetype=vimmessages buftype=nofile bufhidden=wipe nobuflisted nomodified nomodifiable
  local winid = win_getid(winnr())
  wincmd h
  return winid
endfunc

function s:SplitWithRuntime() abort
  let s:winid_runtime = s:SplitWithList(s:ListRuntime())
endfunc

function s:SplitWithScriptnames() abort
  let s:winid_scriptnames = s:SplitWithList(s:ListScriptnames())
endfunc


command! Scriptnames call s:SplitWithScriptnames()
command! Runtime call s:SplitWithRuntime()

"
" Expand <SNR> in messages output with real file names      TODO
"
function s:ExpandSNR(messages) abort
  return mapnew(a:messages,
        \{i, v -> substitute(v,
        \ '\%(\.\.\(function\|script\)\?\)\?<SNR>\(\d\+\)_\([^.[]\+\)\[\(\d*\)]',
        \   {m -> "  " .. m[3] .. "		" .. m[1] .. getscriptinfo(#{
        \ sid: str2nr(m[2], 10)})[0].name .. ':' .. m[4] .. "\n" }, 'g')->split("\n")})->flatten(1)
  "let replaceHome = map(replaceSNR,
   "     \ {_, p -> substitute(p, expand('$VIMHOME') .. '[]', 'g')
  return replaceSNR
endfunc

function s:WriteListToBuffer(bufnr, list) abort
  call setwinvar(winbufnr(a:bufnr), '&modifiable', 1)
  silent call deletebufline(a:bufnr, 1, '$')
  call appendbufline(a:bufnr, '$', a:list)
  call setwinvar(winbufnr(a:bufnr), '&modifiable', 0)
  call setwinvar(winbufnr(a:bufnr), '&modified', 0)
endfunc

function s:RefreshMessages() abort
  let messages = s:ListMessages()
  let messagesExpanded = s:ExpandSNR(messages)
  " call appendbufline(a:bufnr, '$', '╺┅╸ Messages ╺┅╸')
  " call appendbufline(a:bufnr, '$', '')
  " call appendbufline(a:bufnr, '$', messages)
  " call appendbufline(a:bufnr, '$', '')
  " call appendbufline(a:bufnr, '$', messagesExpanded)
  call s:WriteListToBuffer(s:GetMessagesBuffer(), messages)
  call win_execute(a:winid, ['call cursor(''$'', 0)', 'redraw'])
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

function s:GetMessagesBuffer() abort
  if !exists('s:bufnr_messages') || !bufexists(s:bufnr_messages)
    let s:bufnr_messages = bufadd('')
    call setbufvar(s:bufnr_messages, '&filetype', 'vimmessages')
    call setbufvar(s:bufnr_messages, '&buftype', 'nofile')
    call setbufvar(s:bufnr_messages, '&bufhidden', 'wipe')
  endif
  return s:bufnr_messages
endfunc

"
" Open a split with output of :messages
"
function s:SplitWithMessages() abort

  let msgbufnr = s:GetMessagesBuffer()

  exec msgbufnr .. 'wincmd ^'

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
  let s:popid_messages = popup_create(s:GetMessagesBuffer(), #{
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

  call s:WriteMessagesToBuffer(s:GetMessagesBuffer())

  call winbufnr(s:popid_messages)->setbufvar('&filetype', 'vimmessages')
endfunc

command! MessagesPopup call s:PopupWithMessages()

command! MessagesSplit call s:SplitWithMessages()

command! MessagesClose call s:CloseMessages()

command! MessagesRefresh call s:RefreshMessages()

function s:OnVimEnter()
  call SplitWithMessages()
endfunc

call autocmd_add([
      \#{
      \ event: 'VimEnter', once: v:true,
      \ cmd: 'call s:SplitWithMessages()',
      \ group: 'mayhem_messages_init', replace: v:true,
      \},
      \])

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

