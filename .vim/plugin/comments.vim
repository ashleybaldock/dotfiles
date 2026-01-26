if exists("g:mayhem_loaded_comments")
  finish
endif
let g:mayhem_loaded_comments = 1


hi def CommentSt guifg=#cf28df guibg=#cf28df gui=none

" syn match CommentSt /^\s*\zs"/ contained containedin=Comment,vimLineComment contains=NONE conceal cchar=⎢
" syn match CommentSt /^\s*\zs"/ contained containedin=Comment,vimLineComment contains=NONE conceal cchar=❯

syn region CommentMultiLn
      \ start=/^\s*\zs"/
      \ skip=/^$/
      \ end=/\ze^\s*\%([^"]\|$\)/
      \ contains=CommentFirstLn,CommentLastLn,CommentSt,Comment
" syn match CommentFirstLn /\(^\s*\)\@10<=\zs"/ contained conceal cchar=◣

" " Non-blank first comment line
" echo matchadd('Conceal', '^\s*\%([^"]\|$\).*\n\(\s*\)\zs"\ze.*\n\1"', 10, -1, #{conceal: '│'})
" " Blank first comment line
" echo matchadd('Conceal', '^\s*\%([^"]\|$\).*\n\(\s*\)\zs"\ze\s*\n\1"', 10, -1, #{conceal: '╷'})
" " Non-blank last comment line
" echo matchadd('Conceal', '^\s*\zs"\ze.*\n\s*\%([^"]\|$\)', 10, -1, #{conceal: '│'})
" " Blank last comment line
" echo matchadd('Conceal', '^\(\s*\)".*\n\1\zs"\ze\s*\n\s*\%([^"]\|$\)', 10, -1, #{conceal: '╵'})
" " echo matchadd('Conceal', '^\s*".*\n\s*\zs"\ze.*\n\s*"', 10, -1, #{conceal: '┃'})
" " echo matchadd('CommentSt', '^\s*".*\n\s*\zs"\ze.*\n\s*"', 10, -1, #{conceal: '┃'})
" echo matchadd('Conceal', '^\s*\%([^"]\|$\).*\n\s*\zs"\ze.*\n\s*\%([^"]\|$\)', 10, -1, #{conceal: '|'})
" echo matchadd('Conceal', '^\s*".*\n\s*\zs"\ze.*\n\s*"', 10, -1, #{conceal: '┃'})
" echo matchadd('CommentSt', '^\s*".*\n\s*\zs"\ze.*\n\s*"', 10, -1, #{conceal: '┃'})

"
"
" ol / ob : o̲nly   l̲ine / b̲lank
" fl / fb : f̲irst  l̲ine / b̲lank
" ml / mb : m̲iddle l̲ine / b̲lank
" ll / lb : l̲ast   l̲ine / b̲lank
"
let s:parts = #{
      \line: #{
      \  fl: '│⎖', fb: '⎝️⌢️⌜⎝⌢⌜⌐⌈⌃⁝¦️¦',
      \  ml: '⍭│', mb: '⎨️  ⎨  |⎮¦️|️|⁝',
      \  ll: '│', lb:  '⎛️⌣️⌞⎛⌣⌞⌙⌊⌄⁝¦',
      \ 
      \ 
      \ 
      \  ol: '│⎯⏐⎯⏐⎯⏐⎯⏐⎯⏐⎯⏐⎯⏐⎯⏐',
      \  ol: '│⎯⏐⎯⏐⎯▛️▀️▜️⎯⏐⎯⏐⎯⏐⎯⏐',
      \  ol: '│⎯⏐⎯⏐⎯   ⎯⏐⎯⏐⎯⏐⎯⏐',
      \  ob: '╎',
      \ },
      \ lcurl: #{
      \  fl: '⎫',
      \  fb: '╮',
      \  ml: '│',
      \  mb: '│',
      \  lb: '╯',
      \  ll: '⎭',
      \  ol: 'ᩕ',
      \  ob: '╎',
      \ },
      \ rcurl: #{
      \  fl: '⎧', fb: '╭',
      \  ml: '│', mb: '┊',
      \  ll: '⎩', lb: '╰',
      \  ol: 'ᩕ', ob: '⁞',
      \  bl: '>', bb: '+',
      \  sl: '<', sb: '-',
      \ },
      \}



function! comments#blockConceal(parts = get(s:parts, 'line'))
"
" Single-line comments
"
" Non-blank single line
echo matchadd('Conceal', '^\s*\%([^" ].*\)\?\n\s*\zs"\ze.*\n\s*\%([^" ].*\)\?$', 10, -1, #{conceal: s:parts.ol})
" Blank single line
echo matchadd('Conceal', '^\s*\%([^" ].*\)\?\n\s*\zs"\ze\s*\n\s*\%([^" ].*\)\?$', 10, -1, #{conceal: s:parts.ob})

"
" Multi-line comments
"
" Non-blank first line
echo matchadd('Conceal', '^\s*\%([^" ]\|$\).*\n\(\s*\)\zs"\ze.*\n\1"', 10, -1, #{conceal: s:parts.fl})
" Blank first line
echo matchadd('Conceal', '^\s*\%([^" ]\|$\).*\n\(\s*\)\zs"\ze\s*\n\1"', 10, -1, #{conceal: s:parts.fb})
" Non-blank last line
echo matchadd('Conceal', '^\(\s*\)".*\n\1\zs"\ze.*\n\s*\%([^" ]\|$\)', 10, -1, #{conceal: s:parts.ll})
" Blank last line
echo matchadd('Conceal', '^\(\s*\)".*\n\1\zs"\ze\s*\n\s*\%([^" ]\|$\)', 10, -1, #{conceal: s:parts.lb})
" Non-blank middle line
echo matchadd('Conceal', '^\(\s*\)".*\n\1\zs"\ze.*\n\1"', 10, -1, #{conceal: s:parts.ml})
" Blank middle line
echo matchadd('Conceal', '^\(\s*\)".*\n\1\zs"\ze\s*\n\1"', 10, -1, #{conceal: s:parts.mb})

" Non-blank middle line, bigger indent
echo matchadd('Conceal', '^\(\s*\)".*\n\(\1\s\+\)\zs"\ze.*\n\2"', 10, -1, #{conceal: s:parts.bl})
" Blank middle line, bigger indent
echo matchadd('Conceal', '^\(\s*\)".*\n\(\1\s\+\)\zs"\ze\s*\n\2"', 10, -1, #{conceal: s:parts.bb})
" Non-blank middle line, smaller indent
" echo matchadd('Conceal', '^\(\s*\)".*\n\(\1\s\+\)\zs"\ze.*\n\2"', 10, -1, #{conceal: s:parts.sl})

" echo matchadd('Conceal', '^\(\s*\)".*\n\(\s*\)\zs"\ze.*\n\2\s\+"', 10, -1, #{conceal: s:parts.sb})
endfunc
