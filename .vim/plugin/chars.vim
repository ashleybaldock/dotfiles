if exists("g:mayhem_loaded_chars")
  finish
endif
let g:mayhem_loaded_chars = 1

"""""""""""""""""""""""""""""""""""""  None 
" Almost nothing, base for other configs
"
function s:ListNoneA()
  set showbreak=\\
  set listchars=
  set listchars+=precedes:<,extends:>,tab:\ \ 
  set fillchars=
  set fillchars+=vert:|
  set fillchars+=eob:~
  set fillchars+=lastline:@
  set fillchars+=foldclose:+
  set fillchars+=foldopen:-
  set fillchars+=foldsep:|
  set fillchars+=fold:-m
  set fillchars+=diff:-
endfunc
function s:ListNone8()
  set showbreak=↪︎
  set listchars=
  set listchars+=precedes:❰,extends:❱,tab:\ \ 
  set fillchars=
  set fillchars+=vert:┃
  set fillchars+=eob:~
  set fillchars+=lastline:@
  set fillchars+=foldclose:𑁌
  set fillchars+=foldopen:⎞
  set fillchars+=foldsep:⎟
  set fillchars+=fold:═
  set fillchars+=diff:╱
endfunc

function s:HighlightNone() abort
  augroup HighlightOverride
    autocmd!
    autocmd ColorScheme vividmayhem call s:HighlightNone()
  augroup END
  "
  hi link EndOfBuffer EndOfBuNone
  hi link NonText     NonTextNone
  hi link SpecialKey  SpecialNone
endfunc

function! s:ListNone()
  if has("multi_byte_encoding") && &encoding == "utf-8"
    call s:ListNone8()
  else
    call s:ListNoneA()
  endif
  " enable autocommand for colour overrides
  call s:HighlightNone()
  set list

  DoUserAutocmd MayhemList
endfunc

:command! CharsNone call <SID>ListNone()


"""""""""""""""""""""""""""""""""""""  Minimal 
function! s:ListMinimalA()
  call s:ListNoneA()
endfunc
function! s:ListMinimal8()
  call s:ListNone8()
  set listchars+=eol:⌟
  set listchars+=tab:⊩⇀⇀
  set listchars+=nbsp:⍽
  set listchars+=multispace:···∙···∙···∙
  set listchars+=leadmultispace:\ ⢀\ ⢠
  set listchars+=leadmultispace:\ ⢀\ ⢠
endfunc

function! s:HighlightMinimal() abort
  augroup HighlightOverride
    autocmd!
    autocmd ColorScheme vividmayhem call s:HighlightMinimal()
  augroup END
  "
  hi link EndOfBuffer EndOfBuMini
  hi link NonText     NonTextMini
  hi link SpecialKey  SpecialMini
endfunc

function! s:ListMinimal()
  if has("multi_byte_encoding") && &encoding == "utf-8"
    call s:ListMinimal8()
  else
    call s:ListMinimalA()
  endif
  " enable autocommand for colour overrides
  call s:HighlightMinimal()
  set list

  DoUserAutocmd MayhemList
endfunc

command! CharsMinimal call <SID>ListMinimal()


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
  set listchars+=tab:┈═⌲
  set listchars+=nbsp:⍽
  set listchars+=space:˳
  set listchars+=multispace:ˍˍ
  set listchars+=leadmultispace:˙˙˙¹˙˙˙²˙˙˙³˙˙˙⁴˙˙˙⁵˙˙˙⁶˙˙˙⁷˙˙˙⁸˙˙˙⁹˙˙˙ᵃ˙˙˙ᵇ˙˙˙ᶜ˙˙˙ᵈ˙˙˙ᵉ˙˙˙ᶠ
endfunc


function! s:HighlightDiagnostic() abort
  augroup HighlightOverride
    autocmd!
    autocmd ColorScheme vividmayhem call s:HighlightDiagnostic()
  augroup END
  "
  hi link EndOfBuffer EndOfBuDiag
  hi link NonText     NonTextDiag
  hi link SpecialKey  SpecialDiag
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
  set list

  DoUserAutocmd MayhemList
endfunc

command! CharsDiagnostic call <SID>ListDiagnostic()

" Default list style
function s:ListDefault()
  if exists('g:mayhem_default_list_style')
    if g:mayhem_default_list_style == 'minimal'
      call s:ListMinimal()
    endif
    if g:mayhem_default_list_style == 'none'
      call s:ListNone()
    endif
    if g:mayhem_default_list_style == 'diagnostic'
      call s:ListDiagnostic()
    endif
  endif
endfunc

command! CharsDefault call <SID>ListDefault()

CharsDefault







  " ⁃⁃⁃•∙
  " ∙∙∙∙•‣ ▬◆ ●▬▬▬▬▬● ▸◆▶︎◖■◄◗▶︎◂ ◀︎▰▰▰▰▶︎ ■▬▬▶︎ ▷◂▪︎▪︎▪︎▶︎
  " ✦✦✦▪︎▪︎▪︎▪︎ ▫︎▫︎▫︎▫︎ ◻︎◻︎◻︎◻︎ ◼︎◼︎◼︎◼︎ ◆◆◆◆ ◁◃◇◇◇◇▹▷ 
  " ➤➣➢‣‣‣▶︎▸❱
  "
  " ⠀
  " set listchars+=lead:⣄
  "
  "
  " set listchars+=leadmultispace:⣀⣀⣀¹⣀⣀⣀²⣀⣀⣀³⣀⣀⣀⁴⣀⣀⣀⁵⣀⣀⣀⁶⣀⣀⣀⁷⣀⣀⣀⁸⣀⣀⣀⁹⣀⣀⣀ᵃ⣀⣀⣀ᵇ⣀⣀⣀ᶜ⣀⣀⣀ᵈ⣀⣀⣀ᵉ⣀⣀⣀ᶠ
  " set listchars+=leadmultispace:⸐\ ⸏¹⸐\ ⸏²⸐\ ⸏³⸐\ ⸏⁴⸐\ ⸏⁵⸐\ ⸏⁶⸐\ ⸏⁷⸐\ ⸏⁸⸐\ ⸏⁹⸐\ ⸏ᵃ⸐\ ⸏ᵇ⸐\ ⸏ᶜ⸐\ ⸏ᵈ⸐\ ⸏ᵉ⸐\ ⸏ᶠ
  " set listchars+=leadmultispace:⸐¹⸐²⸐³⸐⁴⸐⁵⸐⁶⸐⁷⸐⁸⸐⁹⸐ᵃ⸐ᵇ⸐ᶜ⸐ᵈ⸐ᵉ⸐ᶠ
  " set listchars+=leadmultispace:⸐\ ⸐²⸐\ ⸐⁴⸐\ ⸐⁶⸐\ ⸐⁸⸐\ ⸐ᵃ⸐\ ⸐ᶜ⸐\ ⸐ᵉ⸐\ 
  "
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
    "
  " set listchars+=multispace:⢀⢀⢀⢠⢀⢀⢀⢠⢀⢀⢀⢠⢀⢀⢀⢠
  " set listchars+=multispace:⁃⁃⁃∙⁃⁃⁃∙⁃⁃⁃∙
  " set listchars+=leadmultispace:├╶
  " set listchars+=leadmultispace:│\ 
