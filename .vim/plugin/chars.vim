
"""""""""""""""""""""""""""""""""""""  None 
" Almost nothing, base for other configs
"
function! ListNoneA()
  set showbreak=\\
  set listchars=precedes:<,extends:>,tab:\ \ 
  set fillchars=vert:|,eob:~,lastline:@,foldclose:+,foldopen:-,foldsep:|,fold:-m,diff:-
endfunc
function! ListNone8()
  set showbreak=↪︎
  set listchars=precedes:❰,extends:❱
  set fillchars=
  set fillchars+=vert:║
  set fillchars+=eob:｢
  set fillchars+=lastline:@
  set fillchars+=foldclose:◉
  set fillchars+=foldopen:◯
  set fillchars+=foldsep:▫︎
  set fillchars+=fold:⌶
endfunc

function! HighlightNone() abort
  augroup HighlightOverride
    autocmd!
    autocmd ColorScheme vividmayhem call HighlightNone()
  augroup END

  highlight NonText       guifg=#1a1a1a ctermfg=8
  highlight SpecialKey    guifg=#1a1a1a ctermfg=8
endfunc

function! ListNone()
  if has("multi_byte_encoding") && &encoding == "utf-8"
    call ListNone8()
  else
    call ListNoneA()
  endif

  " enable autocommand for colour overrides
  call HighlightMinimal()
endfunc

:command! ListNone :exec ListNone()


"""""""""""""""""""""""""""""""""""""  Minimal 
function! ListMinimalA()
  call ListNoneA()
endfunc
function! ListMinimal8()
  call ListNone8()
  set listchars+=eol:⌟
  set listchars+=tab:⊩⇀⇀
  " ┄‒┈⫟ ⊢⊢܈̲̳ ⇀⇀⇀⇀⇁⇁⇁⇁⇢⇉⇶⇛⇏↛↣↠↦⇥⇝⇸⇻⤞⤠→⇾⫞
  " set listchars+=tab:⊪ ⊦⫣ ⫦ ⟛⫣ ⫢⟛⫞⊣
  " ╶⊳ ⊦⊢ ⊧⊨ ⫢ ⊩ ⊪ ⊫ ⊬ ⊭ ⊮ ⊯ 
  "    ⫞⊣  ⫤   ⫣   ⫥         ⫦
  set listchars+=nbsp:◌
  " set listchars+=multispace:⢀⢀⢀⢠⢀⢀⢀⢠⢀⢀⢀⢠⢀⢀⢀⢠
  set listchars+=multispace:···∙···∙···∙
  " set listchars+=multispace:⁃⁃⁃∙⁃⁃⁃∙⁃⁃⁃∙
  " ⁃⁃⁃•∙
  " ∙∙∙∙•‣ ▬◆ ●▬▬▬▬▬● ▸◆▶︎◖■◄◗▶︎◂ ◀︎▰▰▰▰▶︎ ■▬▬▶︎ ▷◂▪︎▪︎▪︎▶︎
  " ✦✦✦▪︎▪︎▪︎▪︎ ▫︎▫︎▫︎▫︎ ◻︎◻︎◻︎◻︎ ◼︎◼︎◼︎◼︎ ◆◆◆◆ ◁◃◇◇◇◇▹▷ ➤➣➢
  " ‣‣‣▶︎▸❱
  set listchars+=leadmultispace:├╶
endfunc

function! HighlightMinimal() abort
  augroup HighlightOverride
    autocmd!
    autocmd ColorScheme vividmayhem call HighlightMinimal()
  augroup END

  highlight NonText       guifg=#303030 ctermfg=8
  highlight SpecialKey    guifg=#505050 ctermfg=8
endfunc

function! ListMinimal()
  if has("multi_byte_encoding") && &encoding == "utf-8"
    call ListMinimal8()
  else
    call ListMinimalA()
  endif

  " enable autocommand for colour overrides
  call HighlightMinimal()
endfunc

:command! ListMinimal :exec ListMinimal()


"""""""""""""""""""""""""""""""""""""  Diagnostic 
" More obvious
function! ListDiagnosticA()
  call ListNoneA()
  set listchars+=eol:¬
  set listchars+=tab:>-
  set listchars+=trail:~
  set listchars+=conceal:_
  set listchars+=leadmultispace:\ \ 1\|\ \ 2\|\ \ 3\|\ \ 4\|\ \ 5\|\ \ 6\|\ \ 7\|\ \ 8\|\ \ 9\|\ \ A\|\ \ B\|\ \ C\|\ \ D\|\ \ E\|\ \ F\|
endfunc
function! ListDiagnostic8()
  call ListNone8()
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
endfunc

function! HighlightDiagnostic() abort
  augroup HighlightOverride
    autocmd!
    autocmd ColorScheme vividmayhem call HighlightDiagnostic()
  augroup END

  highlight NonText       guifg=#606060 ctermfg=8
  highlight SpecialKey    guifg=#d70000 ctermfg=8
endfunc

function! ListDiagnostic()
  set listchars=
  highlight NonText guifg=#4a4a59
  highlight SpecialKey guifg=#4a4a59
  if has("multi_byte_encoding") && &encoding == "utf-8"
    call ListDiagnostic8()
  else
    call ListDiagnosticA()
  endif

  " enable autocommand for colour overrides
  call HighlightDiagnostic()
endfunc

:command! ListDiagnostic :exec ListDiagnostic()




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
