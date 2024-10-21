

syn match tsTypeOpenBracket +<+ conceal cchar=❮
      \ contained
      \ contains=NONE 
      \ containedin=typescriptBlock,typescriptTypeBrackets,
      \  typescriptTypeArguments,typescriptTypeParameters

syn match tsTypeCloseBracket +<+ conceal cchar=❯
      \ contained
      \ contains=NONE 
      \ containedin=typescriptBlock,typescriptTypeBrackets,
      \  typescriptTypeArguments,typescriptTypeParameters


hi def tsTypeOpenBracket guibg=#ff0000 guifg=#00ffff
hi def tsTypeCloseBracket guibg=#00ff00 guifg=#00ffff
