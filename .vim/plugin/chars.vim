if exists("g:mayhem_loaded_chars")
  finish
endif
let g:mayhem_loaded_chars = 1

" Highlight non-ASCII characters.
" syntax match nonascii [^\x00-\x7F]
" highlight link nonascii ErrorMsg
" autocmd BufEnter * syn match ErrorMsg /[^\x00-\x7F]/
"
  "au WinEnter * if !exists("w:custom_hi1") | let w:custom_hi1 = matchadd('ErrorMsg', '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$') | endif
  "
  "au WinEnter * if !exists("w:custom_hi2") | 
  "
  " let w:custom_hi2 = matchadd('U8Whitespace',
  "   \ '[\x0b\x0c\u00a0\u1680\u180e\u2000-\u200a\u2028\u2029\u202f\u205f\u3000\ufeff]', 10, -1, {'conceal': '⌻' })
  

  " ⌸ ⌷ ⌹ ⌺ ⌻ ⌼ ⌾ ⍁ ⍂ ⍄ ⍃ ⍇ ⍈ ⍐ ⍗ ⍌ ⍓ ⍔ ⍞ ⍠ ⍯ ⍰ ⎕ ⌷  ⏍ 
  "⌷⌷▱▢⬜︎◙◘⌷⌷⌷▯▭▔⌷⁐‿⁔⁀⌂ 
  " 🁢🁣    ꘖǀǀǁǂ|‖⌷꜏꜊ǀǁ‖‡ǂ†|¦❢‖ ̅|‖ ꖔ̥̽ ꖔ̬̈ ꖔ̺̚ ꖔ̻ ᴦ ꖔ̝ ᴧʘlɨ
  
  
  " ╔════╦════╦════╦═⎡ Unicode Whitespace ⎦═╦════╗
  " ║char║ eo ║line╠════╦════╦════╦════╦════╣Oghm║
  " ║tab ║line║tab ║ FF ║ CR ║ Sp ║ NEL║NBSP║Mark║
  " ║0009║000A║000B║000C║000D║0020║0085║00A0║1680║
  " ╠╡	╞╬╡ "╬╡╞╬╡"╬╡"╬╡ ╞═╣"╡ ╞═╬╡ ╞═╣
  " ╠════╬════╬════╬════╬════╬════╬════╬════╬════╣
  " ║ En ║ Em ║ En ║ Em ║3pEm║4pEm║6pEm║Figr║Punc║
  " ║Quad║Quad║ Sp ║ Sp ║ Sp ║ Sp ║ Sp ║⎵Sp⍞║ Sp ║
  " ║2000║2001║2002║2003║2004║2005║2006║2007║2008║
  " ╠╡ ╞═╬╡ ╞═╬╡ ╞═╬╡ ╞═╬╡ ╞═╬╡ ╞═╬╡ ╞═╬╡ ╞═╬╡ ╞═╣
  " ║↳ ⍠╞╬╡⬜︎╞╬═╡ ╞╬═╡ ╞╬═╡ ╞╬═╡ ╞╬═╡ ╞╬═╡ ╞╬═╡ ╞╣
  " ╠════╬════╬════╬════╬════╬════╬════╬════╬════╣
  " ║Thin║Hair║Line║Para║NNBr║Math║Brle║Ideo║    ║
  " ║ Sp ║ Sp ║Sepr║Sepr║ Sp ║ Sp ║Blnk║ Sp ║    ║
  " ║2009║200A║2028║2029║202F║205F║2800║3000║    ║
  " ╠╡ ╞═╬╡ ╞═╬╡ ╞═╬╡ ╞═╬╡ ╞═╬╡ ╞═╬╡⠀╞═╣╡　╞╣  ╱ ║
  " ╠════╩═══╦╩════╩══╦═╩════╩═╦══╩════╩╦═══╩════╣
  " ║  ZWSP  ║  ZWNJ  ║  ZWJ   ║  RTLM  ║  LTRM  ║
  " ╠╡​╞╬╡‌╞╬╡‍╞╬╡‎╞╬╡‏╞║
  " ╚════════╩════════╩════════╩════════╩════════╝
  "
  " let w:mayhem_match_u8all_wsp = matchadd('U8Whitespace', '\(\%u0009\|\%u000A\|\%u000B\|\%u000C\|\%u000D\|\%u0020\|\%u0085\|\%u00A0\|\%u1680\|\%u2000\|\%u2001\|\%u2002\|\%u2003\|\%u2004\|\%u2005\|\%u2006\|\%u2007\|\%u2008\|\%u2009\|\%u200A\|\%u2028\|\%u2029\|\%u202F\|\%u205F\|\%u3000\)', 10, -1, {'conceal': '⌻' })
  " let w:mayhem_match_u8whitespace2 = matchadd('U8Whitespace', '[\x0b\x0c\u00a0\u1680\u180e\u2000-\u200a\u2028\u2029\u202f\u205f\u3000\ufeff]', 10, -1, {'conceal': '⌻' })

  " call matchdelete(w:mayhem_match_u8whitespace2)

function! s:ShowUnicodeWhitespace() abort
  if exists("w:mayhem_match_u8only_wsp")
    call matchdelete(w:mayhem_match_u8only_wsp)
  endif
  let w:mayhem_match_u8only_wsp = matchadd('U8Whitespace', '\(\%u000B\|\%u000C\|\%u000D\|\%u0085\|\%u00A0\|\%u1680\|\%u2000\|\%u2001\|\%u2002\|\%u2003\|\%u2004\|\%u2005\|\%u2006\|\%u2007\|\%u2008\|\%u2009\|\%u200A\|\%u2028\|\%u2029\|\%u202F\|\%u205F\|\%u3000\)', 10, -1, {'conceal': '⌻' })
endfunc



function! FoldTextMarker()
  let line = getline(v:foldstart)
  let sub = substitute(trim(line), '<!--\|-->\|/\*\|\*/\|{{{\d\=', '', 'g') 
  let folded = str2nr(v:foldend) - str2nr(v:foldstart)
  return '╴' ..  substitute(v:folddashes, '-', '❰', 'g') .. ' ' ..  sub .. ' ❱╶ ─ ╴❰ ' .. folded .. ' lines folded ❱' 
endfun

" gitgutter#fold#is_changed()
function! FoldTextIndent()
  let line = getline(v:foldstart)
  let sub = substitute(line, '<!--\|-->\|/\*\|\*/\|{{{\d\=', '', 'g') 
  let folded = str2nr(v:foldend) - str2nr(v:foldstart)
  return sub[:30] .. ' //════════❰ ' .. folded .. ' lines folded ❱'
endfun


"""""""""""""""""""""""""""""""""""""  None 
" Almost nothing, base for other configs
"
function! s:ListNoneA()
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
function! s:ListNone8()
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

function! s:HighlightNone() abort
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

  if exists('#User#MayhemList')
    doautocmd User MayhemList
  endif
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
  " set listchars+=multispace:⢀⢀⢀⢠⢀⢀⢀⢠⢀⢀⢀⢠⢀⢀⢀⢠
  set listchars+=multispace:···∙···∙···∙
  " set listchars+=multispace:⁃⁃⁃∙⁃⁃⁃∙⁃⁃⁃∙
  set listchars+=leadmultispace:\ ⢀\ ⢠
  set listchars+=leadmultispace:\ ⢀\ ⢠
  " set listchars+=leadmultispace:├╶
  " set listchars+=leadmultispace:│\ 
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

  if exists('#User#MayhemList')
    doautocmd User MayhemList
  endif
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

  if exists('#User#MayhemList')
    doautocmd User MayhemList
  endif
endfunc

command! CharsDiagnostic call <SID>ListDiagnostic()

" Default list style
function! s:ListDefault()
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




" Layout guides
" TODO
" - cursorline/cursorcol
" - colorcolumn
" - line number column
"
" Set number column width based on length of file
" autocmd BufRead * let &l:numberwidth =
" \ max([float2nr(log10(line('$')))+3, &numberwidth]) 








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
