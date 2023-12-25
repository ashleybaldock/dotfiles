function! StatusLineHighlights() abort
  hi StatusLine      cterm=bold ctermfg=0 ctermbg=5 gui=none guifg=White guibg=#232323
  hi StatusLineNC    cterm=italic ctermfg=0 gui=italic guifg=#DDDDDD guibg=#151515
  hi VertSplit       term=reverse cterm=reverse gui=none guifg=#666666 guibg=#151515

  " StatusLine syntax errors
  hi StatusSynErr    ctermfg=197 guifg=#FF0000 guibg=#000000
  hi StatusSynErrNC  ctermfg=197 guifg=#AA0000 guibg=#000000
  hi StatusSynWarn   ctermfg=220 guifg=#FFAA00 guibg=#000000
  hi StatusSynWarnNC ctermfg=220 guifg=#CC7700 guibg=#000000
  hi StatusSynOk     ctermfg=LightGreen guifg=#55CC00 guibg=#000000
  hi StatusSynOkNC   ctermfg=LightGreen guifg=#229900 guibg=#000000
  hi StatusSynOff    ctermfg=Cyan guifg=#00FFFF
  hi StatusSynOffNC  ctermfg=Cyan guifg=#00DDDD

  " StatusLine git info
  hi StatusGit       ctermfg=92 guifg=#7D27A8
  hi StatusGitNC     ctermfg=92 guifg=#7D27A8 
endfunction

" set statusline+=%#IsModified#%{&mod?expand('%'):''}%*%#IsNotModified#%{&mod?'':expand('%')}%*
" set statusline+=%#IsModified#%{&mod?'+':''}%*
" set statusline+=%#IsNotModified#%{&mod?'':''}%*

function! DebugWinNumber()
  " :redir @" | echo getwininfo(winnr()) | redir END | vsplit | enew | put | %s/, '/,^M'/g 
  " :redir @" | echo getbufvar(5, '&') | redir END | vsplit | enew | put 
  " g:statusline_winid is set for %!
  " let l:wininfo = getwininfo(g:statusline_winid)
  " let l:winactive = g:statusline_winid == win_getid()
  return printf(' %%#Statement#%w%s:%s%%* ', win_getid(), g:actual_curwin)
endfunction

" function! StatusDiagnostic() abort
"   " Buffer local variable containing diagnostics
"   " :echom get(b:, 'coc_diagnostic_info', {})
"   " e.g. {'information': 19, 'hint': 0, 'lnums': [17, 0, 1, 0], 'warning': 0, 'error': 19}
"   let info = get(b:, 'coc_diagnostic_info', {})
"   if empty(info) | return '' | endif
"   let msgs = []
"   if get(info, 'error', 0)
"     call add(msgs, 'E' . info['error'])
"   endif
"   if get(info, 'warning', 0)
"     call add(msgs, 'W' . info['warning'])
"   endif
"   return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
" endfunction
function! DiagCoC()
  if exists('g:did_coc_loaded')
    " let l:wininfo = getwininfo(g:actual_curwin)
    " let l:winactive = g:actual_curwin == win_getid()
    let l:hisuffix = g:actual_curwin == win_getid() ? '' : 'NC'
    let l:diaginfo = get(b:, 'coc_diagnostic_info', {})
    if has('gui_running')
      let l:numbers = ['', '1⃝ ', '2⃝ ', '3⃝ ', '4⃝ ', '5⃝ ', '6⃝ ', '7⃝ ', '8⃝ ', '9⃝ ' ]
      let l:err  = '⚑⃝ '
      let l:warn = '!⃝ '
      let l:ok   = '✓⃝ '
      let l:off  = '?⃣ '
    else
      let l:numbers = ['', '1', '2', '3', '4', '5', '6', '7', '8', '9']
      let l:err  = '!E'
      let l:warn = '!W'
      let l:ok   = 'ok'
      let l:off  = '??'
    endif

    let l:errors = get(l:diaginfo, 'error', 0)
    if l:errors > 0
      return printf('%%#StatusSynErr%s#%s%%*', l:hisuffix, get(l:numbers, l:errors, l:err))
    endif

    let l:warnings = get(l:diaginfo, 'warning', 0)
    if l:warnings > 0
      return printf('%%#StatusSynWarn%s#%s%%*', l:hisuffix, get(l:numbers, l:warnings, l:warn))
    endif
    return printf('%%#StatusSynOk%s#%s%%*', l:hisuffix, l:ok)
  endif
  return printf('%%#StatusSynOff%s#%s%%*', l:hisuffix, l:off)
endfunction

" Fugitive
function! S_fugitive()
  let l:hisuffix = g:actual_curwin == win_getid() ? '' : 'NC'
  let l:git = '⎇ '
  let l:off = '⎇ ' "??'
  if exists('g:loaded_fugitive')
    let l:head = FugitiveHead()
    " return empty(l:head) ? '' : '⎇⃝  ⎇⃣ '.l:head . ' '
    " return empty(l:head) ? '' : '⎇ '
    if !empty(l:head)
      return printf('%%#StatusGit%s#%s%%*', l:hisuffix, l:git)
    endif
  endif
  return printf('%%#StatusGit%s#%s%%*', l:hisuffix, l:off)
endfunction

set statusline=
set statusline+=\ 
" Git info
set statusline+=%{%S_fugitive()%}
" file info - e.g. .vimrc +
" %t    - file name:so %
" %H/%h - help flag     ,HLP/[help]
" %W/%w - preview flag  ,PRV/[Preview]
" %M/%m - modified flag ,+  /[+]
" %R/%r - readonly flag ,RO /[RO]
" %Y/%y - filetype      ,VIM/[vim]
" set statusline+=%#StatusBold#
set statusline+=%{&mod?'＋⃞⧺⃞\':''}%*\ %-t%<\ %H%W%M%R\ 
" set statusline+=%*
" set statusline+=%{&mod?' ':''}\ %-t%<\ %H%W%M%R\ 
" Sep. between left and right
set statusline+=%=
" buffer info - e.g. 1 300,82-85 99%
" %(...%) - item group
" %n - buffer number
" %l - line number
" %c - col number
" %V - virtual col number
" %P - percentage scrolled
set statusline+=%(%n\ %l,%c%V\ %P%)\ 
" Errors/warnings in statusline (from CoC)
set statusline+=%{%DiagCoC()%}
" Debug
" set statusline+=%{%DebugWinNumber()%}
set statusline+=\ 
