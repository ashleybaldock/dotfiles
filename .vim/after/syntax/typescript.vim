"
" TypeScript Syntax Extensions
"
" au BufWritePost <buffer> syn on
"
" See Also:
"       $VIMRUNTIME/syntax/typescript.vim


source <script>:p:h/common.vim

hi typescriptBraces          guifg=#eebb11

hi typescriptUnion           guifg=#ffaa00

hi typescriptCall            guifg=#88eeff
hi typescriptFuncCallArg     guifg=#88eeff
hi typescriptParamExp        guifg=#88eeff

hi typescriptExport          guifg=#3300aa gui=italic
hi typescriptExport          guifg=#33aa00 gui=italic
hi typescriptAliasKeyword    guifg=#c248fe gui=italic
hi typescriptAliasDefinition guifg=#bb66ff
hi typescriptAliasDeclaration guifg=#8097ff

hi typescriptConstraint      guifg=#718bff 
"conceal cchar=⊃
hi typescriptPredefinedType  guifg=#7766ff gui=italic
hi typescriptUserDefinedType guifg=#718bff

hi typescriptTypeParameter   guifg=#88ddff

hi typescriptTypeCast        guifg=#aa44ff
hi typescriptTypeArguments   guifg=#aa44ff

hi typescriptComputedMember  guifg=#ffaa00
hi typescriptProperty        guifg=#ffaa00
hi typescriptMember          guifg=#ffaa00
hi typescriptMemberOptionality guifg=#ffaa00
hi typescriptComputedPropertyName guifg=#ffaa00
" keyof
hi typescriptTypeQuery       guifg=#718bff

hi typescriptObjectSpread    guifg=#ff6600
hi typescriptRestOrSpread    guifg=#ffaa00

hi typescriptTypeAnnotation  guifg=#dd55dd
hi typescriptTypeBrackets    guifg=#ee55ee
hi typescriptTypeBracket     guifg=#ee55ee
hi typescriptTypeReference   guifg=#77aaff

hi typescriptIdentifier      guifg=#ffaa00
hi typescriptIdentifierName  guifg=#ffaa00
hi typescriptDefaultParam    guifg=#ffaa00

hi typescriptVariable        guifg=#aabcc7 gui=italic
hi typescriptKeywordOp       guifg=#ffaa00

hi typescriptTemplateLiteralType guifg=#ffaa00
hi typescriptTemplateSubstitutionType guifg=#ffaa00
hi typescriptTemplate        guifg=#ffaa00
hi typescriptTemplateSubstitution guifg=#ffaa00
hi typescriptTemplateSB      guifg=#ffaa00

hi typescriptBOMWindowProp   guifg=#ffaa00

hi link typescriptAssign Operator
hi link typescriptUnaryOp Operator
hi link typescriptBinaryOp Operator
hi link typescriptTernaryOp Operator
hi link typescriptDotNotation Operator

hi link typescriptParens Delimiter
"hi typescriptConditionalParen 

hi typescriptProp           guifg=#ffee77
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

