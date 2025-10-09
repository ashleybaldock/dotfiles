
echo matchadd('Conceal', '^\s*\%([^"]\|$\).*\n\s*\zs"\ze.*\n\s*\%([^"]\|$\)', 10, -1, #{conceal: '▶︎'})
echo matchadd('Conceal', '^\s*\%([^"]\|$\).*\n\s*\zs"\ze.*\n\s*"', 10, -1, #{conceal: '◣'})
echo matchadd('Conceal', '^\s*".*\n\s*\zs"\ze.*\n\s*"', 10, -1, #{conceal: '┃'})
echo matchadd('CommentSt', '^\s*".*\n\s*\zs"\ze.*\n\s*"', 10, -1, #{conceal: '┃'})

syn match CommentSt /^\s*\zs"/ contained containedin=Comment,vimLineComment contains=NONE conceal cchar=⎢
syn match CommentSt /^\s*\zs"/ contained containedin=Comment,vimLineComment contains=NONE conceal cchar=❯

hi def CommentSt guifg=#cf28df guibg=#cf28df gui=none

syn region CommentMultiLn
      \ start=/^\s*\zs"/
      \ skip=/^$/
      \ end=/\ze^\s*\%([^"]\|$\)/
      \ contains=CommentFirstLn,CommentLastLn,CommentSt,Comment
syn match CommentFirstLn /\(^\s*\)\@10<=\zs"/ contained conceal cchar=◣
