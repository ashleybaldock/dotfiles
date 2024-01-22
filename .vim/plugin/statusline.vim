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
endfunc

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
endfunc

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

function! WinType() abort
" (empty) = normal window, 'unknown' = not window
" autocmd command loclist popup preview quickfix
  let wintype = win_gettype()

endfunc

function! SetStatusVars()
  if !exists('b:mayhem')
    let b:mayhem = {}
  endif
  if !exists('b:mayhem.sl')
    let b:mayhem['sl'] = {}
  endif
  if !exists('b:mayhem.f')
    let b:mayhem['f'] = {}
  endif

  let b:mayhem.f.projroot = ProjectRoot()
  " let b:mayhem.f.full = expand('%')
  let b:mayhem.f.tail = expand('%:t')
  let b:mayhem.f.head = expand('%:p:h')
  let b:mayhem.f.ext = expand('%:e')
  let b:mayhem.projname = fnamemodify(b:mayhem.f.projroot,':p:h:t')
  let b:mayhem.f.name = expand('%:p:h')
  let b:mayhem.f.type = getbufvar(bufnr(), '&filetype')
endfunc
" sp|enew|pu=execute('echo getbufvar(bufnr(), "name")')

" Statusline for narrow windows (<16)
" filen….vim
" filen⋯.vim
" filen⋮.vim
" filen…vim
" filen⋯vim
" filen⋮vim
" ຯ❋ ❊⬮⬬ ⬭ ⬯ ◌ 
" filen‥.vim
" filen·.vim
" filen•vim
" filen•.vim
" filen‥vim
" filen·vim
" Statusline for zero height windows

function! NC() abort
  let l:hisuffix = g:actual_curwin == win_getid() ? '' : 'NC'
  return printf('%%#StatusInfo%s#𝓲⃝ %%*', l:hisuffix)
endfunc

" Specific statuslines for special buffers
function! HelpStatus() abort
  let l:hisuffix = g:actual_curwin == win_getid() ? '' : 'NC'

  let b:mayhem['sl']['current'] = ''
        \ .. printf('%%#StatusInfo%s#𝓲⃝ %%*', l:hisuffix)
        \ .. '%*' .. '\ '
        \ .. '%-f'
        \ .. '%<' .. '%='
        \ .. '%(%n\ %l,%c%V\ %P%)\ '

  setlocal statusline=
  setlocal statusline+=%#StatusInfo%{%NC()%}#𝓲⃝\ 
  setlocal statusline+=%*
  setlocal statusline+=\ 
  setlocal statusline+=%-F
  " Truncation point- following items hidden first
  setlocal statusline+=%<
  " Split between <<left and right>>
  setlocal statusline+=%=
  setlocal statusline+=%(%n\ %l,%c%V\ %P%)\ 
endfunc

function! LeftIcon() abort
    let l:hisuffix = g:actual_curwin == win_getid() ? '' : 'NC'
  if &buftype == 'help'
    return printf('%%#StatusInfo%s#𝓲⃝ %%*', l:hisuffix)
    " return printf('%%#StatusInfo%s#𝒾⃟ %%*', l:hisuffix)
  endif
  if &buftype == 'quickfix'
    return printf('%%#StatusInfo%s#ℚ⃞ %%*', l:hisuffix)
    " ' ℺⃞ 🅀 𝒬⃞  ⍰ \ %%*'
  endif
  return S_fugitive() 
endfunc

function! DefaultCustomStatus()
  " ⨕⃞ ⨧⃞ ⨳⃞ ⩆⃞ ➔⃞  ⫸⃞ 
  set statusline=
  " set statusline+=\ 
  " Git info
  set statusline+=%{%S_fugitive()%}
  set statusline+=\ 
  set statusline+=%-f
  set statusline+=%#StatusSynErr#
  " set statusline+=%{%pathshorten(getbufinfo(bufnr())[0].name,3)%}
  set statusline+=%*
  " Truncation point- following items hidden first
  set statusline+=%<
  set statusline+=\ 
  " set statusline+=%#StatusBold#
  set statusline+=%{&modified?'+':''}

  " Split between <<left and right>>
  set statusline+=%=

  set statusline+=%{&modifiable?'':'ᴚ⃞'}
  set statusline+=%{&readonly?'ᴚ⃞ʀ⃞ᴚ⃞':''}
  " set statusline+=%{&modified?'⧺':''}
  " set statusline+=%{&modified?&modifiable?'-':'+':''}
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
endfunc

function! UpdateCustomStatus()
  call SetStatusVars()
  if &buftype == 'help'
    call HelpStatus()
    return 
  endif
  call DefaultCustomStatus()
endfunc

augroup statusline
  autocmd! * <buffer>
  " autocmd BufEfter    <buffer> match ExtraWhitespace /\s\+$/
  " autocmd InsertEnter <buffer> match ExtraWhitespace /\s\+\%#\@<!$/
  " autocmd InsertLeave <buffer> match ExtraWhitespace /\s\+$/

  au BufWinEnter,BufFilePost <buffer> call UpdateCustomStatus()
  " au BufWinEnter,BufFilePost * call UpdateCustomStatus()
  " au BufWinEnter,BufFilePost * silent! call UpdateCustomStatus()
  au User CocDiagnosticChange let b:mayhem.sl.diag = DiagCoc()
augroup END

