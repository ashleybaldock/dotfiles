scriptencoding utf-8

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
  " †‡※⁕⁑𑀛•◦ 𐀿𐠩𐠸 𐩯𐩮𐩠𐩪 𐠫𐠃𐠠𐠨 𐱃𐠊𐠒𐠑𐠙 𐠘 ʎ𐝕 𐝕 𑀕 𑀰 𑀏 ⫷ ⧷⧶𝞧 𝞒 𝛹 𝚿 𐩻𐩠𐩮𐩼 ⎇ 
  let l:git = '𑀛'
  let l:notgit = '⁞'
  let l:gitoff = '⸮'
  if exists('g:loaded_fugitive')
    let l:head = FugitiveHead()
    " return empty(l:head) ? '' : '⎇⃝  ⎇⃣ '.l:head . ' '
    " return empty(l:head) ? '' : '⎇ '
    if empty(l:head)
      return printf('%%#StatusNotGit%s#%s%%*', l:hisuffix, l:notgit)
    else
      return printf('%%#StatusGit%s#%s%%*', l:hisuffix, l:git)
    endif
  endif
  return printf('%%#StatusGitOff%s#%s%%*', l:hisuffix, l:gitoff)
endfunc

function! StatuslineMode() abort
  " ^V/^S need to be real, i.e. entered using ctrl+v,ctrl+v/ctrl+s
  return { 'n':'n', 'v':'v', 'V':'v̅', '': 'v̺͆', 's': 's', 'S': 's̅', '': 's̺͆', 'i': 'ɪ', 'R': 'ʀ', 'r': 'ᴚ', 't': 'ʇ', 'c': 'ɔ', '!': 'S', }[mode()]
endfunc

function! ScrollHint() abort
" Top ˥
"     ꜈ 1%-24%
" 25% ˦
"     ꜉ 26%-49%
" 50% ˧
"     ꜋
" 75% ˨
"     ꜌
" Bot ˩
" ꜛꜜꜝꜞꜟ ↓↑ ˥꜈꜉꜊꜋꜌ ꜍꜎꜏꜐꜑꜒꜓꜔꜕꜖˩
" ᵦᵧᵨᵩᵪ₀₁₂₃₄₅₆₇₈₉
" ⣏⢽⣎⣝⣟⢟⢛⢻⢼⢫⢣⡯⡱⢷
endfunc

function! StatuslineEncoding() abort
  if &fileencoding && &fileencoding!= 'utf-8'
    set statusline+= 
  endif
endfunc

set statusline=
" set statusline+=\ 
" Git info
set statusline+=%{%S_fugitive()%}
set statusline+=\ 
set statusline+=%-t
" Truncation point- following items hidden first
set statusline+=%<
set statusline+=\ 
" set statusline+=%#StatusBold#
set statusline+=%{&modified?'+':''}

" Split between <<left and right>>
set statusline+=%=

set statusline+=%{&modifiable?'':'m⃞̸\ '}
set statusline+=%{&readonly?'ʀ⃞\ ':''}
" set statusline+=%{&modified?'⧺':''}
" set statusline+=%{&modified?&modifiable?'-':'+':''}
" set statusline+=%{&help?'𝒾⃟':''}
" set statusline+=%{&help?'𝓲⃝':''}
" set statusline+=%{&help?'𝓲⃞':''}
set statusline+=%#StatusSynErr#
set statusline+=%{&fileformat=='unix'?'':'␌⃞ˣ'}
set statusline+=%{&fileencoding!~'^$\\|utf-8'?'':'∪⃞⃥\ '}
set statusline+=%*

set statusline+=%{&previewwindow?'ᴘ⃞':''}
" reset:StatusBold
" set statusline+=%*
" file info - e.g. .vimrc +
" %t  - file name:so %
" %Hh - help flag     ,HLP/[help]     𝓲⃝ 𝓲⃞ 𝒾⃟ 
" %Ww - preview flag  ,PRV/[Preview]  ᴾ⃞ Ⓟ⃞ ᵖ⃞ Ⓟ⃞  
" %Mm - modified flag ,+  /[+]        f
" %Rr - readonly flag ,RO /[RO]       ʀ⃞ ᴿ͇̅ ʷ⃠ ᴿ̲̅ R⃞ ʀ⃞
" %Yy - filetype      ,VIM/[vim]
set statusline+=%y
set statusline+=\ 

" buffer info - e.g. 1 300,82-85 99%
" %(...%) - item group
" %n - buffer number
" %l - line number
" %c - col number
" %V - virtual col number
" %P - percentage scrolled
" set statusline+=%(%n\ %l,%c%V\ %P%)\ 
set statusline+=%(%P%)\ 
" Errors/warnings from CoC
set statusline+=%{%DiagCoC()%}
" set statusline+=\ 
" set statusline+=%{%StatuslineMode()%}

" Debug
" set statusline+=%{%DebugWinNumber()%}
" set statusline+=\ 
" set statusline+=%{&mod?'+⃞':''}%*\ %-t%<\ %H%W%M%R\ 

