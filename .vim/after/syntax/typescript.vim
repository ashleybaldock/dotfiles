"
" TypeScript Syntax Extensions
"
" au BufWritePost <buffer> syn on
"
" See Also:
"       $VIMRUNTIME/syntax/typescript.vim


source <script>:p:h/common.vim


hi typescriptCall guifg=#88eeff
hi typescriptFuncCallArg guifg=#88eeff
hi typescriptParamExp  guifg=#88eeff

hi link typescriptExport Special
hi typescriptAliasKeyword guifg=#ffaa00
hi typescriptAliasDefinition guifg=#ffaa00

hi typescriptTypeQuery guifg=#ffaa00
hi typescriptUnion guifg=#ffaa00
hi typescriptTypeAnnotation guifg=#ffaa00
hi typescriptTypeBrackets guifg=#ffaa00
hi typescriptTypeReference guifg=#ffaa00

hi typescriptIdentifierName guifg=#ffaa00
hi typescriptDefaultParam guifg=#ffaa00

hi typescriptVariable guifg=#ffaa00
hi typescriptKeywordOp guifg=#ffaa00

hi typescriptTemplateLiteralType guifg=#ffaa00
hi typescriptTemplateSubstitutionType guifg=#ffaa00
hi typescriptTemplate guifg=#ffaa00
hi typescriptTemplateSubstitution guifg=#ffaa00
hi typescriptTemplateSB guifg=#ffaa00

hi typescriptBOMWindowProp guifg=#ffaa00

hi link typescriptAssign Operator
hi link typescriptUnaryOp Operator
hi link typescriptBinaryOp Operator
hi link typescriptTernaryOp Operator
hi link typescriptDotNotation Operator

hi link typescriptParens Delimiter
"hi typescriptConditionalParen 

hi typescriptProp guifg=#ffee77
hi clear typescriptStringMethod
hi link typescriptStringMethod typescriptProp
hi link typescriptArrayMethod typescriptProp

hi link typescriptMathStaticMethod typescriptProp
hi link typescriptRegExpMethod typescriptProp
hi link typescriptBOMLocationMethod typescriptProp
hi link typescriptObjectStaticMethod typescriptProp
hi link typescriptES6SetMethod typescriptProp
hi link typescriptDOMFormProp typescriptProp
hi link typescriptDOMDocMethod typescriptProp

