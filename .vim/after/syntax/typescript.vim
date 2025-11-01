"
" TypeScript Syntax Extensions
"
" au BufWritePost <buffer> syn on
"
" See Also:
"       $VIMRUNTIME/syntax/typescript.vim


source <script>:p:h/common.vim

hi typescriptBraces          guifg=#eebb11

" hi typescriptBoolean
hi typescriptUnion           guifg=#ffaa00

hi typescriptCall            guifg=#bbeeff
hi typescriptFuncCallArg     guifg=#bbeeff
hi typescriptParamExp        guifg=#bbeeff

hi typescriptExport          guifg=#3300aa gui=italic
hi typescriptExport          guifg=#33aa00 gui=italic
" hi typescriptDefaultImportName

hi typescriptAliasKeyword    guifg=#c248fe gui=italic
hi typescriptAliasDefinition guifg=#bb66ff
hi typescriptAliasDeclaration guifg=#8097ff

hi typescriptConstraint      guifg=#718bff 

hi typescriptPredefinedType  guifg=#7766ff gui=italic
hi typescriptUserDefinedType guifg=#718bff
hi link typescriptConditional Conditional
hi clear typescriptConditionalParen
hi typescriptConditionalElse guifg=#ff0000
hi typescriptConditionalType guifg=#ff0000

hi typescriptTypeParameter   guifg=#88ddff

hi typescriptTypeCast        guifg=#aa44ff
hi typescriptTypeArguments   guifg=#aa44ff

hi typescriptComputedMember  guifg=#ffaa00
hi typescriptProperty        guifg=#ffaa00
hi typescriptMember          guifg=#ffaa00
hi typescriptMemberOptionality    guifg=#c248fe gui=italic 
hi typescriptComputedPropertyName guifg=#ffaa00
" keyof
hi typescriptTypeQuery        guifg=#718bff

hi typescriptTupleLable       guifg=#ff6600
hi typescriptTupleType        guifg=#ff0060

hi typescriptObjectSpread     guifg=#ff6600
hi typescriptRestOrSpread     guifg=#ffaa00
hi typescriptArrayDestructure guifg=#ffee77
hi clear typescriptObjectDestructure
hi link typescriptDestructureLabel Function
hi link typescriptDestructureString String
hi link typescriptDestructureVariable PreProc
" Colons
hi typescriptDestructureAs    guifg=#33aa00 gui=italic
hi typescriptEndColons        guifg=#ff6600
hi typescriptObjectColon      guifg=#ffaa44
" Commas
hi typescriptDestructureComma guifg=#ff6600
hi typescriptMixinComma       guifg=#ff6600
hi typescriptFuncComma        guifg=#ff6600
hi typescriptInterfaceComma   guifg=#ff6600

hi typescriptTypeAnnotation   guifg=#dd55dd
hi typescriptTypeBrackets     guifg=#ee55ee
hi typescriptTypeBracket      guifg=#ee55ee
hi typescriptTypeReference    guifg=#77aaff

hi typescriptReadonlyArrayKeyword guifg=#ff6600
hi typescriptReadonlyModifier     guifg=#ff6600

hi typescriptIdentifier       guifg=#ffaa00
hi typescriptIdentifierName   guifg=#ffaa00
hi typescriptDefaultParam     guifg=#ffaa00

hi link typescriptType Type
hi clear typescriptTypeBlock
hi clear typescriptTypeOperator
hi clear typescriptTypeParameters

hi typescriptVariable         guifg=#aabcc7 gui=italic
hi typescriptKeywordOp        guifg=#ffaa00

hi typescriptStringLiteralType        guifg=#66fa00 gui=italic
hi typescriptTemplateLiteralType      guifg=#ffaa00
hi typescriptTemplateSubstitutionType guifg=#ffaa00
hi typescriptTemplate                 guifg=#ffaa00
hi typescriptTemplateSubstitution     guifg=#ffaa00
hi typescriptTemplateSB               guifg=#ffaa00

hi typescriptBOM              guifg=#ffaa00
hi typescriptBOMHistoryProp   guifg=#ffaa00
hi typescriptBOMLocationProp  guifg=#ffaa00
hi typescriptBOMNavigatorProp guifg=#ffaa00
hi typescriptBOMNetworkProp   guifg=#ffaa00
hi typescriptBOMWindowProp    guifg=#ffaa00
" hi typescriptBOMWindowCons
" hi typescriptBOMWindowEvent

hi link typescriptAssign Operator
hi link typescriptUnaryOp Operator
hi link typescriptBinaryOp Operator
hi link typescriptTernaryOp Operator
hi link typescriptDotNotation Operator
hi link typescriptDotStyleNotation Operator
hi link typescriptForOperator Operator

hi link typescriptCase Operator
hi link typescriptDefault Operator

hi link typescriptParens Delimiter
"hi typescriptConditionalParen 

hi typescriptProp           guifg=#ffee77
hi typescriptStaticProp     guifg=#ffee77 gui=italic
hi typescriptMethod         guifg=#eebb11
hi typescriptStaticMethod   guifg=#eebb11 gui=italic
hi clear typescriptArrayMethod | hi link typescriptArrayMethod typescriptMethod
hi link typescriptGlobalMethod typescriptStaticMethod

hi link typescriptArrayStaticMethod typescriptStaticMethod
hi link typescriptDateStaticMethod typescriptStaticMethod
hi link typescriptJSONStaticMethod typescriptStaticMethod
hi link typescriptMathStaticMethod typescriptStaticMethod
hi link typescriptNumberStaticMethod typescriptStaticMethod
hi link typescriptObjectStaticMethod typescriptStaticMethod
hi link typescriptSymbolStaticMethod typescriptStaticMethod
hi link typescriptURLStaticMethod typescriptStaticMethod

hi link typescriptArrayMethod typescriptMethod
hi link typescriptBlobMethod typescriptMethod
hi link typescriptBOMLocationMethod typescriptMethod
hi link typescriptBOMHistoryMethod typescriptMethod
hi link typescriptBOMNavigatorMethod typescriptMethod
hi link typescriptBOMWindowMethod typescriptMethod
hi link typescriptCacheMethod typescriptMethod
hi link typescriptConsoleMethod typescriptMethod
hi link typescriptCryptoMethod typescriptMethod
hi link typescriptDOMDocMethod typescriptMethod
hi link typescriptDOMEventMethod typescriptMethod
hi link typescriptDOMEventTargetMethod typescriptMethod
hi link typescriptDOMFormMethod typescriptMethod
hi link typescriptDOMFormProp typescriptProp
hi link typescriptDOMNodeMethod typescriptMethod
hi link typescriptDOMStorageMethod typescriptMethod
hi link typescriptDateMethod typescriptMethod
hi link typescriptES6MapMethod typescriptMethod
hi link typescriptES6SetMethod typescriptMethod
hi link typescriptEncodingMethod typescriptMethod
hi link typescriptFileListMethod typescriptMethod
hi link typescriptFileMethod typescriptMethod
hi link typescriptFileReaderMethod typescriptMethod
hi link typescriptFunctionMethod typescriptMethod
hi link typescriptGeolocationMethod typescriptMethod
hi link typescriptHeadersMethod typescriptMethod
hi link typescriptIntlMethod typescriptMethod
hi link typescriptMethodAccessor typescriptMethod
hi link typescriptNumberMethod typescriptMethod
hi link typescriptObjectMethod typescriptMethod
hi link typescriptPaymentMethod typescriptMethod
hi link typescriptPaymentResponseMethod typescriptMethod
hi link typescriptReflectMethod typescriptMethod
hi link typescriptRequestMethod typescriptMethod
hi link typescriptResponseMethod typescriptMethod
hi link typescriptServiceWorkerMethod typescriptMethod
hi link typescriptSubtleCryptoMethod typescriptMethod
hi link typescriptXHRMethod typescriptMethod

hi typescriptGlobalDot guifg=#00ffff
" Array.…️
hi link typescriptGlobalArrayDot typescriptGlobalDot
" Console.…️
hi link typescriptGlobalConsoleDot typescriptGlobalDot
" Date.…️
hi link typescriptGlobalDateDot typescriptGlobalDot
" JSON.…️
hi link typescriptGlobalJSONDot typescriptGlobalDot
" Math.…️
hi link typescriptGlobalMathDot typescriptGlobalDot
" Number.…️
hi link typescriptGlobalNumberDot typescriptGlobalDot
" Object.…️
hi link typescriptGlobalObjectDot typescriptGlobalDot
" Promise.…️
hi link typescriptPromiseStaticMethod typescriptStaticMethod
hi link typescriptPromiseMethod typescriptMethod
hi link typescriptGlobalPromiseDot typescriptGlobalDot
" RegExp.…️
hi link typescriptRegExpProp typescriptProp
hi link typescriptRegExpStaticProp typescriptStaticProp
hi link typescriptRegExpMethod typescriptMethod
hi link typescriptGlobalRegExpDot typescriptGlobalDot
" typescriptRegexpBackRef
" typescriptRegexpBoundary
" typescriptRegexpCharClass
" typescriptRegexpGroup
" typescriptRegexpMod
" typescriptRegexpOr
" typescriptRegexpQuantifier
" typescriptRegexpString

" String.…️
hi link typescriptGlobalStringDot typescriptGlobalDot
hi clear typescriptStringMethod | hi link typescriptStringMethod typescriptMethod
hi link typescriptStringStaticMethod typescriptStaticMethod
hi link typescriptString String
hi link typescriptStringMember String
hi link typescriptStringProperty String

" Symbol.…️
hi link typescriptGlobalSymbolDot typescriptGlobalDot
" URL.…️
hi link typescriptGlobalURLDot typescriptGlobalDot

hi typescriptGlobal guifg=#55cc88
hi link typescriptEncodingGlobal typescriptGlobal
hi link typescriptNodeGlobal typescriptGlobal
hi link typescriptTestGlobal typescriptGlobal
hi link typescriptCryptoGlobal typescriptGlobal
hi link typescriptXHRGlobal typescriptGlobal
