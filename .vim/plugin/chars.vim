
function! FoldTextMarker()
  let line = getline(v:foldstart)
  let sub = substitute(trim(line), '<!--\|-->\|/\*\|\*/\|{{{\d\=', '', 'g') 
  let folded = str2nr(v:foldend) - str2nr(v:foldstart)
  return '╴' ..  substitute(v:folddashes, '-', '❰', 'g') .. ' ' ..  sub .. ' ❱╶ ─ ╴❰ ' .. folded .. ' lines folded ❱' 
endfun

function! FoldTextIndent()
  let line = getline(v:foldstart)
  let sub = substitute(line, '<!--\|-->\|/\*\|\*/\|{{{\d\=', '', 'g') 
  let folded = str2nr(v:foldend) - str2nr(v:foldstart)
  return sub[:30] .. ' //╴╴╴╴╴╴╴╴❰ ' .. folded .. ' lines folded ❱'
endfun

" Highlight non-ASCII characters.
" syntax match nonascii [^\x00-\x7F]
" highlight link nonascii ErrorMsg
" autocmd BufEnter * syn match ErrorMsg /[^\x00-\x7F]/


"""""""""""""""""""""""""""""""""""""  None 
" Almost nothing, base for other configs
"
function! s:ListNoneA()
  set showbreak=\\
  set listchars=precedes:<,extends:>,tab:\ \ 
  set fillchars=vert:|,eob:~,lastline:@,foldclose:+,foldopen:-,foldsep:|,fold:-m,diff:-
endfunc
function! s:ListNone8()
  set showbreak=↪︎
  set listchars=precedes:❰,extends:❱
  set fillchars=
  set fillchars+=vert:║
  set fillchars+=eob:~
  set fillchars+=lastline:@
  set fillchars+=foldclose:◎
  set fillchars+=foldopen:◯
  set fillchars+=foldsep:╎
  set fillchars+=fold:╶
endfunc

function! s:HighlightNone() abort
  augroup HighlightOverride
    autocmd!
    autocmd ColorScheme vividmayhem call s:HighlightNone()
  augroup END
  "
  hi EndOfBuffer   guifg=#3a3a3a guibg=#050505
  hi NonText       guifg=#1a1a1a ctermfg=8
  hi SpecialKey    guifg=#1a1a1a ctermfg=8
endfunc

function! s:ListNone()
  if has("multi_byte_encoding") && &encoding == "utf-8"
    call s:ListNone8()
  else
    call s:ListNoneA()
  endif
  " enable autocommand for colour overrides
  call s:HighlightNone()
  " 
  set list
endfunc

:command! ListNone :exec <SID>ListNone()


"""""""""""""""""""""""""""""""""""""  Minimal 
function! s:ListMinimalA()
  call s:ListNoneA()
endfunc
function! s:ListMinimal8()
  call s:ListNone8()
  set listchars+=eol:⌟
  set listchars+=tab:⊩⇀⇀
  " ┄‒┈⫟ ⊢⊢⇀⇀⇀⇀⇁⇁⇁⇁⇢⇉⇶⇛⇏↛↣↠↦⇥⇝⇸⇻⤞⤠→⇾⫞
  " set listchars+=tab:⊪ ⊦⫣ ⫦ ⟛⫣ ⫢⟛⫞⊣
  " ╶⊳ ⊦⊢ ⊧⊨ ⫢ ⊩ ⊪ ⊫ ⊬ ⊭ ⊮ ⊯ 
  "    ⫞⊣  ⫤   ⫣   ⫥         ⫦
  set listchars+=nbsp:⎕
  " set listchars+=multispace:⢀⢀⢀⢠⢀⢀⢀⢠⢀⢀⢀⢠⢀⢀⢀⢠
  set listchars+=multispace:···∙···∙···∙
  " set listchars+=multispace:⁃⁃⁃∙⁃⁃⁃∙⁃⁃⁃∙
  " ⁃⁃⁃•∙
  " ∙∙∙∙•‣ ▬◆ ●▬▬▬▬▬● ▸◆▶︎◖■◄◗▶︎◂ ◀︎▰▰▰▰▶︎ ■▬▬▶︎ ▷◂▪︎▪︎▪︎▶︎
  " ✦✦✦▪︎▪︎▪︎▪︎ ▫︎▫︎▫︎▫︎ ◻︎◻︎◻︎◻︎ ◼︎◼︎◼︎◼︎ ◆◆◆◆ ◁◃◇◇◇◇▹▷ 
  " ➤➣➢‣‣‣▶︎▸❱
  " set listchars+=leadmultispace:├╶
  set listchars+=leadmultispace:│\ 
endfunc

function! s:HighlightMinimal() abort
  augroup HighlightOverride
    autocmd!
    autocmd ColorScheme vividmayhem call s:HighlightMinimal()
  augroup END
  "
  hi EndOfBuffer   guifg=#3a3a3a guibg=#050505
  hi NonText       guifg=#303030 ctermfg=8
  hi SpecialKey    guifg=#505050 ctermfg=8
endfunc

function! s:ListMinimal()
  if has("multi_byte_encoding") && &encoding == "utf-8"
    call s:ListMinimal8()
  else
    call s:ListMinimalA()
  endif
  " enable autocommand for colour overrides
  call s:HighlightMinimal()
  " 
  set list
endfunc

:command! ListMinimal :exec s:ListMinimal()


"""""""""""""""""""""""""""""""""""""  Diagnostic 
" More obvious
function! s:ListDiagnosticA()
  call s:ListNoneA()
  set listchars+=eol:¬
  set listchars+=tab:>-
  set listchars+=trail:~
  set listchars+=conceal:_
  set listchars+=leadmultispace:\ \ 1\|\ \ 2\|\ \ 3\|\ \ 4\|\ \ 5\|\ \ 6\|\ \ 7\|\ \ 8\|\ \ 9\|\ \ A\|\ \ B\|\ \ C\|\ \ D\|\ \ E\|\ \ F\|
endfunc
function! s:ListDiagnostic8()
  call s:ListNone8()
  set listchars+=eol:｣
  set listchars+=trail:·
  set listchars+=conceal:⍁
  set listchars+=tab:╶╌▷
  set listchars+=nbsp:⌻
  set listchars+=space:⎕
  set listchars+=multispace:⣀⣀⣀⡠
  set listchars+=leadmultispace:˙˙˙¹˙˙˙²˙˙˙³˙˙˙⁴˙˙˙⁵˙˙˙⁶˙˙˙⁷˙˙˙⁸˙˙˙⁹˙˙˙ᵃ˙˙˙ᵇ˙˙˙ᶜ˙˙˙ᵈ˙˙˙ᵉ˙˙˙ᶠ
  " set listchars+=leadmultispace:⣀⣀⣀¹⣀⣀⣀²⣀⣀⣀³⣀⣀⣀⁴⣀⣀⣀⁵⣀⣀⣀⁶⣀⣀⣀⁷⣀⣀⣀⁸⣀⣀⣀⁹⣀⣀⣀ᵃ⣀⣀⣀ᵇ⣀⣀⣀ᶜ⣀⣀⣀ᵈ⣀⣀⣀ᵉ⣀⣀⣀ᶠ
  " set listchars+=leadmultispace:⸐\ ⸏¹⸐\ ⸏²⸐\ ⸏³⸐\ ⸏⁴⸐\ ⸏⁵⸐\ ⸏⁶⸐\ ⸏⁷⸐\ ⸏⁸⸐\ ⸏⁹⸐\ ⸏ᵃ⸐\ ⸏ᵇ⸐\ ⸏ᶜ⸐\ ⸏ᵈ⸐\ ⸏ᵉ⸐\ ⸏ᶠ
  " set listchars+=leadmultispace:⸐¹⸐²⸐³⸐⁴⸐⁵⸐⁶⸐⁷⸐⁸⸐⁹⸐ᵃ⸐ᵇ⸐ᶜ⸐ᵈ⸐ᵉ⸐ᶠ
  " set listchars+=leadmultispace:⸐\ ⸐²⸐\ ⸐⁴⸐\ ⸐⁶⸐\ ⸐⁸⸐\ ⸐ᵃ⸐\ ⸐ᶜ⸐\ ⸐ᵉ⸐\ 
endfunc

function! s:HighlightDiagnostic() abort
  augroup HighlightOverride
    autocmd!
    autocmd ColorScheme vividmayhem call s:HighlightDiagnostic()
  augroup END
  "
  hi EndOfBuffer   guifg=#3a3a3a guibg=#050505
  hi NonText       guifg=#606060 ctermfg=8
  hi SpecialKey    guifg=#d70000 ctermfg=8
endfunc

function! s:ListDiagnostic()
  set listchars=
  if has("multi_byte_encoding") && &encoding == "utf-8"
    call s:ListDiagnostic8()
  else
    call s:ListDiagnosticA()
  endif

  " enable autocommand for colour overrides
  call s:HighlightDiagnostic()
  " 
  set list
endfunc

:command! ListDiagnostic :exec s:ListDiagnostic()

" Default list style
function! s:ListDefault()
  if exists('g:default_list_style')
    if default_list_style == 'minimal'
      :ListMinimal
    endif
    if default_list_style == 'none'
      :ListNone
    endif
    if g:default_list_style == 'diagnostic'
      :ListDiagnostic
    endif
  endif
endfunc

:command! ListDefault :exec s:ListDefault()

:ListDefault


" Auto-hide list chars when entering visual mode
function! s:EnterVisual() abort
  let g:list_state_on_last_entering_visual = &list
  if exists('g:hide_list_in_visual') && g:hide_list_in_visual
    set nolist
  endif
endfunc

function! s:LeaveVisual() abort
  if g:list_state_on_last_entering_visual
    set list
  endif
endfunc

augroup VisualEvent
  autocmd!
  " Enter Visual Mode
  autocmd ModeChanged *:[vV\x16]* call s:EnterVisual()
  " Leave Visual Mode
  autocmd Modechanged [vV\x16]*:* call s:LeaveVisual()
augroup END


  " set listchars+=lead:⣄
  "
  " set listchars+=trail:⢠
 
  " set listchars+=nbsp:█
  "
  " set listchars+=multispace:⢀⢀⢀⢠
  " set listchars+=multispace:\ ⣀⣀⣀⢀⣀⣀⣀
  " set listchars+=multispace:⢀⢀⢀⢠
  " set listchars+=multispace:⣀⣀⣀⡠

  " set listchars+=eol:⡟
  " set listchars+=eol:˥
  " set listchars+=eol:⁊
  " set listchars+=eol:␊
  " set listchars+=eol:⍁

  " set listchars+=tab:╶╌▷
  " set listchars+=tab:╶╌⦊
  " set listchars+=tab:╶╌▷


" Symbol substitutions
" if !has('conceal')
"   finish
" endif

" " remove the keywords. we'll re-add them below
" syntax clear javaScriptFunction
" syntax match javaScriptFunction /\<function\>/ nextgroup=javaScriptFuncName skipwhite conceal cchar=𝑓
" syntax match javaScriptFunctionNoParams /function()/ conceal cchar=𝑓

" hi link javaScriptFunctionNoParams javaScriptFunction
" hi! link Conceal javaScriptFunction

" set conceallevel=2
"
    " thin
    " set listchars+=eol:⢹
    " thick
    " set listchars+=eol:｣
    " acsii
    " set listchars+=precedes:<|set listchars+=extends:>
    " thin
    " set listchars+=precedes:⟨|set listchars+=extends:⟩
    " thick
    " set listchars+=precedes:❰|set listchars+=extends:❱

    " set listchars+=tab:╼━◊◦◖❯
" ⪥ ⪥ ⪥ ⪥⪦⪧⪧⪦⪧
    " ⟣⟣⟣⟣⟣⟣⟢⟡⟡⟡⟡⟡⟡⟐ ⟣ ⟢ ⟢ ⦒⟣⧐⧐⧎⧎⧎⧎⧏⧟⧟⧟⧟
    " ⧃⧟⧟⧟⧃ ⧂⧟⧟⟩⧟⧽  ⦘  ⦗  ⦘▷
    " »›⸧〉⧏⟢⭔
    " set listchars+=tab:⟣⦊ ⪽⪾⪫⪧⪤⪡⫘⪾⩺⩹⩵ ⩴⩴⩴⩤⩥⩴⩴⨠ 
    " set listchars+=tab:⫘⫘⪾
    " set listchars+=tab:⧟⧟⧐
    " set listchars+=tab:⧟⧟⦒
    " set listchars+=tab:⮕\ 
    " set listchars+=tab:⦾◇⧟⦒
    " set listchars+=tab:◎⸰⸰
    " set listchars+=tab:⌶⌶⎔
    " set listchars+=tab:⦊⎯⭔
    " set listchars+=tab:⦊⭔
    " set listchars+=tab:⭔⟫⦊
    " set listchars+=tab:⦊⎯⭔
    " set listchars+=tab:◊╌╴
    " set listchars+=tab:▹╌╴
    " set listchars+=tab:⟫╌▹
    " set listchars+=tab:╶╌⧐
    " 8spc tabs
    " set listchars+=leadmultispace:⠤⠤⠤‥⠤⠛⠒⠛⠤⠶⣀⣀⣀․⣀⣤⣀ ⠤⠤․⠤⠤‥⠤⠤⠤⠤𐄙⠤⠤⠤𐄚⠤⠤⠤⠤…⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤𐅡
    " set listchars+=leadmultispace:⣀⣀⸑⣀⣀․⣀⣀⣀⣀⣀⣀․⣀⣀⣀ ⸐ ⣀⣀⣀․⣀⣀⣀ ²⸑₁⸑₂⸑₃⸑₄⸑₅⸑₆⸑₇⸑₈

    " set listchars+=leadmultispace:₁⠤⠤⠤₂⠤⠤⠤₃⠤⠤⠤₄⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤₉⠤⠤⠤⏨⠤⠤⠤
    " set listchars+=leadmultispace:₁⠤⠤⠤₂⠤⠤⠤₃⠤⠤⠤₄⠤⠤⠤₅⠤⠤⠤₆⠤⠤⠤₇⠤⠤⠤₈⠤⠤⠤₉⠤⠤⠤⏨⠤⠤⠤
    " 2spc tabs
    " set listchars+=leadmultispace:⠤⠤₂⠤₃⠤₄⠤₅⠤₆⠤₇⠤₈⠤₉⠤𐅡⠤
    " set listchars+=leadmultispace:⠤⠤₂⠤⠤⠤₄⠤⠤⠤₆⠤⠤⠤₈⠤⠤⠤𐅡⠤
    " set listchars+=leadmultispace:⠤⠤⠤₁⠤⠤⠤₂⠤⠤⠤₃⠤⠤⠤₄⠤⠤⠤₅⠤⠤⠤₆⠤⠤⠤₇⠤⠤⠤₈⠤⠤⠤₉⠤⠤⠤𐅡
    " set listchars+=leadmultispace:‥․‥₁⠤⠤⠤₂⠤⠤⠤₃⠤⠤⠤₄⠤⠤⠤₅⠤⠤⠤₆⠤⠤⠤₇⠤⠤⠤₈⠤⠤⠤₉⠤⠤⠤𐅡
    " set listchars+=leadmultispace:‥․ ₁‥․⠤₂⠤ ⠤₃⠤ ․₄․․․₅․․
    " 4spc tabs
    " set listchars+=leadmultispace:⠤⠤⠤⠤₂⠤⠤⠤⠤⠤⠤⠤₄⠤⠤⠤⠤⠤⠤⠤₆⠤⠤⠤⠤⠤⠤⠤₈⠤⠤⠤⠤⠤⠤⠤𐅡⠤⠤⠤
