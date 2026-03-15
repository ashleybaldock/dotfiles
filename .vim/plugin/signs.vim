if exists("g:mayhem_loaded_signs")
  finish
endif
let g:mayhem_loaded_signs = 1

"
" show count of search results above/below current view
" - after jumping within file, indicate direction jumped from
" show errors above/below current view
" make option-a/option-s work with tabs
" fix option-d
"  - handle list of options
"  - only call coc when it is available
"  - jump in split if needed
"  - open pum with other options
"

let s:prefix = 'mayhem_'
let s:group = 'signs_of_mayhem'

let g:mayhem = get(g:, 'mayhem', {})
let g:mayhem.sl = get(g:mayhem, 'sl', {})

let g:mayhem.signs = get(g:mayhem, 'signs', {})

" let sp = #{ s:' ⎛', m:' ⎢', e:' ⎝', t: '' }
" let sp = #{ s:' ╭', m:' │', e:' ╰', t: '' }

"            \ {
"            \  'n[ame]':     'mysign',
"          ⎧ \  's[igntext]': '⌖⃝ ',
"          ⎪ \  't[exthl]':   'SignTextHlGroup',
" optional ⎨ \  'l[inehl]':   'LineHlGroup',
"          ⎪ \  'c[ulhl]':    'CurrentLineHlGroup',
"          ⎩ \  'n[umhl]':    'NumberColumnHlGroup'
"            \ },
let g:mayhem.signs.git = [
      \ { 'n': 'add',         's': '+', 't': 'SignGitAdd', 'l': 'DiffAdd'   ,  },
      \ { 'n': 'mod',         's': '𐰇', 't': 'SignGitChg', 'l': 'DiffChange',  },
      \ { 'n': 'del',         's': '◇', 't': 'SignGitDel', 'l': 'DiffDelete',  },
      \ { 'n': 'd_first',     's': '◇̅', 't': 'SignGitDel', 'l': 'DiffDelete',},
      \ { 'n': 'd_abovebelow','s': '◇̲̅', 't': 'SignGitDel', 'l': 'DiffDelete',},
      \ { 'n': 'd_mod',       's': '◇̲', 't': 'SignGitCgD', 'l': 'DiffDelete',},
      \]
let s:diagsigns = [
      \ {'sign': '✘', 'hlt': 'SignDgErr',  'hll': 'LineDgErr',  'name': 'diag_error',        },
      \ {'sign': '‼︎', 'hlt': 'SignDgWarn', 'hll': 'LineDgWarn', 'name': 'diag_warning',      },
      \ {'sign': '𝓲', 'hlt': 'SignDgInfo', 'hll': 'LineDgInfo', 'name': 'diag_info',         },
      \ {'sign': '⌁', 'hlt': 'SignDgHint', 'hll': 'LineDgHint', 'name': 'diag_hint',         },
      \]

" ┃ ╭╴texthl
" ┃ │  ╭╴numhl   ╭╴linehl (or culhl if cursor on line)
" ╭─∇╌─∇─╌───────∇────────────────────────────────────────╮   
" ╻ ⚑ 123 A Line of the sig̲ns
" ┃  ╵   ╵
" ┃  ╵   ╵
" ┃  ╵   ╵
" ┃  ╵   ╵
" ┃  ╵991╵
" ┃  ╵992╵
" ┃  ╵   ╵
" ┃􀰫1123  A Line of the sig̲ns
" ┃1234567      sign/text  hlt: texthl; hll: linehl; hlc: curhl;
" ┃􀅃
" ┃􀑂
" ┃􀬚
" ┃􀓜
" ┃  
" ┃􀌼
" ┃􀌸
" ┃􀌨


sign define mhsearch text=􀊫 texthl=Directory
sign define mhtarget text=􂇏 texthl=Directory
sign define mhring text=􃊌️⃝ texthl=Directory
sign define mhring text=􃊌️⃝ texthl=Directory
function! s:MarkThisLine(line = getcurpos()[1])
  exec ':sign place 2 line=' .. a:line .. ' name=target file=' .. expand('%:p')
endfunc

command MarkThisLine echo <SID>MarkThisLine()

"
" -----------------------------------   Signs   -----------
"
function! s:PlaceSign()
  let aSign = sign_define(s:prefix .. 'testsign', { 
        \ 'text': '✘+',
        \ 'linehl': 'TestHint5', 
        \ 'numhl': '', 
        \ 'texthl': '',
        \ 'culhl': '', 
        \})            
  let signid = sign_place(0, s:group, s:prefix .. 'testsign', bufnr(), { 'lnum': line('.') }) 
  return signid        
endfunc                
                       
command! TestSign echo <SID>PlaceSign()
                       
"
" Place:
"
" function s:PlaceSign(name)
  " Look up sign name
" endfunc

" 
"┏ {…}  javascript
"┃
"┃ let a = () => 'hello world' 
"┃ console.log(a())            
"╹────────────────────────────────
let s:styles = #{
      \ curl:   #{s:' ⎧',
      \ se:  ' {',m:' ⎪',
      \           e:' ⎩',},
      \
      \ curlinv:#{s:' ⎫',
      \ se:  ' {',m:' ⎪',
      \           e:' ⎭',},
      \
      \ crlcave:#{s:'⎫⎧',
      \ se:  ' {',m:'⎪⎪',
      \           e:'⎭⎩',},
      \
      \ curlvex:#{s:'⎧⎫',
      \ se:  '{}',m:'⎪⎪',
      \           e:'⎩⎭',},
      \
      \ esh:    #{s:' ⎧',
      \ se:  ' ʃ️',m:' ⎪',
      \           e:' ⎭',},
      \
      \ eshinv: #{s:' ⎫',
      \ se:  ' ʅ️',m:' ⎪',
      \           e:' ⎩',},
      \
      \ round:  #{s:' ╭',
      \ se:  ' (️',m:' │',
      \           e:' ╰',},
      \
      \ rect:   #{s:' ⎡',
      \ se:  ' [',m:' ⎜',
      \           e:' ⎣',},
      \
      \ thkrect:#{s:' ┏',
      \ se:  ' [️',m:' ┃',
      \           e:' ┗',},
      \ thinthk:#{s:' ┍',
      \ se:  ' [️',m:' │',
      \           e:' ┕',},
      \ thkthin:#{s:' ┎',
      \ se:  ' [️',m:' ┃',
      \           e:' ┖',},
      \
      \ boxes  :#{s:'𓉘𓉝',
      \ se:  '𓉘𓉝',m:'𓉘𓉝',
      \           e:'𓉘𓉝',},
      \
      \ rule:   #{s:' 𓉘',
      \ se:  ' 𓉘',m:' 𓉘',
      \           e:' 𓉘',},
      \
      \ ruleinv:#{s:' 𓉝',
      \ se:  ' 𓉝',m:' 𓉝',
      \           e:' 𓉝',},
      \
      \ double :#{s:' ╓',
      \ se:  ' ⟦',m:' ║',
      \           e:' ╙',},
      \
      \ bracket:#{s:' ⎛',
      \  se: ' (',m:' ⎢',
      \           e:' ⎝',},
      \
      \ concave:#{s:'⎞⎛',
      \  se: ' (',m:'⎥⎢',
      \           e:'⎠⎝',},
      \
      \ convex :#{s:'⎛⎞',
      \  se: ' (',m:'⎢⎥',
      \           e:'⎝⎠',},
      \
      \
      \ solidin:#{s:'╲',
      \ se:  ' ❱',m:'⦉⦊',
      \           e:'╱',},
      \
      \ solidot:#{s:' ╱',
      \ se:  ' ❮',m:'⦉⦊',
      \           e:' ╲',},
      \
      \ integrl:#{s:' ⌠',
      \ se:  ' ∫',m:' ⎮',
      \           e:' ⌡',},
      \
      \ short:  #{s:' ┌', 
      \ se:  ' ⌶',m:' │', 
      \           e:' └',},
      \ xshort: #{s:' _', 
      \ se:  ' |̲̅',m:' │', 
      \           e:' ‾',},
      \
      \ xlong:  #{s:' │̅', 
      \ se:  ' │̲̅',m:' │', 
      \           e:' │̲',},
      \
      \ xlonghv:#{s:' ┃̅', 
      \ se:  ' ┃̲̅',m:' ┃', 
      \           e:' ┃̲',},
      \
      \ xlongdb:#{s:' ║̅', 
      \ se:  ' ║̲̅',m:' ║', 
      \           e:' ║̲',},
      \
      \ thicend:#{s:' ╿', 
      \ se:  ' ¦',m:' │', 
      \           e:' ╽',},
      \
      \ thinend:#{s:' ╽', 
      \ se:  ' ¦',m:' ┃', 
      \           e:' ╿',},
      \
      \ dash2s: #{s:' ¦', 
      \ se:  ' ¦',m:' ¦', 
      \           e:' ¦',},
      \ dash2l: #{s:' ╷', 
      \ se:  ' ╎',m:' ╎', 
      \           e:' ╵',},
      \ dash3l: #{s:' ╷', 
      \ se:  ' ┆',m:' ┆', 
      \           e:' ╵',},
      \ dash4l: #{s:' ╷', 
      \ se:  ' ┊',m:' ┊', 
      \           e:' ╵',},
      \
      \ dash2h: #{s:' ╻', 
      \ se:  ' ╏',m:' ╏', 
      \           e:' ╹',},
      \ dash3h: #{s:' ╻', 
      \ se:  ' ┇',m:' ┇', 
      \           e:' ╹',},
      \ dash4h: #{s:' ╻', 
      \ se:  ' ┋',m:' ┋', 
      \           e:' ╹',},
      \
      \ heavy:  #{s:' ▛', 
      \ se:  ' ▌̲̅',m:' ▌', 
      \           e:' ▙',},
      \ hvyrnd: #{s:' ▞', 
      \ se:  ' ▌̲̅',m:' ▌', 
      \           e:' ▚',},
      \ hvycnr: #{s:' ▛️', 
      \ se:  ' ▌̲̅',m:'  ', 
      \           e:' ▙️',},
      \ hvyline:#{s:' ▄', 
      \ se:  ' ▌̲̅',m:' █', 
      \           e:' ▀',},
      \}
"  ᖰᖳᒥᒣᒋᒍᒋᒉᖴᖷᓱᓴᔦᔨᖸᖻᖹᖺᖼᖿᗀᗁᗂᗁ ᘂᘃ ᐅᐳ ᐳᐅ ᗄᐱ ᗅ ᐃ ᗑ ᗋ ᗏᗌ ᗏ ↱↱️ ',
"    ▏ ⍑⌊⍑⌊┃️   ⏐⃓ ⏐⃒ ⏐⃦ ⏐⃥ ⏐̸ ⏐⃫ ⏐̷ ⏐̶ ⏐̵ ⏐⃪ ⏐⃝ ⏐⃞ ⏐⃣  ⏐⃓⏐⃓⃒⏐⃒⏐⃔⏐⃡⏐⃗⏐⃤ ⏐⃠ ⏐⃟⏐⃘        ⏐ ',
"  ᖲᖱᒪᒧᒐᒉᒐᒍᖶᖵᓭᓯᔪᔭᖺᖹᖻᖸᖾᖽᗂᗃᗀᗃ ᘇᘄ ᐸᐊ ᐊᐸ ᗅᐯ ᗄ ᐁ ᗐ ᗊ   ᒪᒧ ↳↳️ ',},
"  
"   ⦧ ⸢ ﹇ ⎴ ︻︼︗︘⁀︷︸ ⌄⌃̩⏐̩̍⏐̣̇⍋̩̩ ⍐ ⎰ ‾⏐│️⏐⎾ ‾⎯꛱  ꛱ ⎯꛱  ⎯꛱⃤  ⎯ ',
"  ⦙⧛️ ⸠ ⏐  ⎶         ⁐⏐⃓    ⏐⏐̩̍⏐̩̍⏐̣̇   ⎕ ⏐ ⎯⃓⎯⃒  ⎯⃦ ⎯⃥⎯̸  ⎯⏐⎯⏐ ',
"   ⦦ ⸤ ﹈ ⎵ ︼︻︘︗‿︸︷ ⌃⌄̍⏐̩̍⏐̣̇⍒̍̍⍒̩̩  ⍗ ⎱   ⏐⏐⎿ ',},
let s:definedSigns = {}

"
" Add a multi-part sign spanning the rows specified
" Each sign style can have a start, middle and end part
" Returns a list of the ids of the signs created
"
function! s:CodeBlockBackground(fromLineNr, toLineNr, style = 'xshort', bufnr = bufnr())
  let parts = {}
  let bufnr = a:bufnr
  let startLine = a:fromLineNr
  let endLine = a:toLineNr

  " lazily define these as needed when first used
  for part in keys(s:styles[a:style])
    let name = printf("%s_codeblock_%s_%s", s:prefix, a:style, part)

    call sign_define(name, #{
        \ text: get(s:styles, a:style, {})->get(part, '?s'),
        \ linehl: 'markdownHighlight_sh', 
        \ culhl: 'markdownHighlight_sh',
        \})
    let parts[part] = name
  endfor

  if startLine == endLine
    return [ sign_place(0, s:group, parts.se, bufnr, #{ lnum: startLine }) ]
  else
    let midStart = startLine + 1
    let midEnd = endLine - 1
    return extend(
          \ [ sign_place(0, s:group, parts.s, bufnr, #{ lnum: startLine }) ],
          \ range(midStart, midEnd, 1)->map({_, val -> 
          \   sign_place(0, s:group, parts.m, bufnr, #{ lnum: val }) }),
          \ [ sign_place(0, s:group, parts.e, bufnr, #{ lnum: endLine }) ])
  endif
endfunc

function! s:SignBracketComplete(ArgLead, CmdLine, CursorPos)
  return keys(s:styles)->join("\n")
endfunc

command! -range -nargs=? -complete=custom,<SID>SignBracketComplete
      \ SignBracket call <SID>CodeBlockBackground(<line1>, <line2>, <q-args>)

command! CodeLine echo <SID>CodeBlockLine()



"
" ----------------------------------- TextProps -----------
"
"  prop_type_add(name, props)
"  prop_type_change(name, props)
" bufnr      : buffer local
" highlight  : hlgroup
" priority   : highest wins, def. 0
" combine    : with syntax, def true
" override   : anything else
" start_incl : inserts @ start included
" end_incl   : inserts @ end included
"
"  prop_type_delete(name, [props])
"  prop_type_get(name, [props])
"  prop_type_list(props)
"
" prop_add(lnum, col, props)
" prop_add_list(props, [item, ...])
"
" prop_clear(lnum [, lnum-end [, bufnr]])
" prop_find(props [, direction])
" prop_list(lnum [, props])
" prop_remove(props [, lnum [, lnum-end]])
"

function! AddTestTextPropType()
  return prop_type_add(s:prefix .. '', {
        \ 'bufnr': bufnr(),
        \ 'highlight': 'TestHint5',
        \ 'priority': 4,
        \ 'combine': 1,
        \ 'override': 0,
        \ 'start_incl': 1,
        \ 'end_incl': 1 
        \ })
endfunc

function! s:ListTextPropsInCurrentBuffer()
  return prop_list(1, {
        \ 'bufnr': bufnr(),
        \ 'end_lnum': -1,
        \ })
endfunc

function! s:ListTextPropsInCurrentLine()
  return prop_list(line('.'), {
        \ 'bufnr': bufnr(),
        \ 'end_lnum': line('.'),
        \ })
endfunc

function! s:ListTextsOfMayhemInCurrentBuffer()
  return prop_list(1, {
        \ 'bufnr': bufnr(),
        \ 'end_lnum': -1,
        \ 'types': [],
        \ 'ids': [] 
        \ })
endfunc
function! s:ListTextsOfMayhemInCurrentLine()
  return prop_list(line('.'), {
        \ 'bufnr': bufnr(),
        \ 'end_lnum': line('.'),
        \ 'types': [],
        \ 'ids': [] 
        \ })
endfunc

command! AllTextPropsInThisLine echo <SID>ListTextPropsInCurrentLine()
command! AllTextPropsInThisBuffer echo <SID>ListTextPropsInCurrentBuffer()
command! OurTextPropsInThisLine echo <SID>ListTextsOfMayhemInCurrentLine()
command! OurTextPropsInThisBuffer echo <SID>ListTextsOfMayhemInCurrentBuffer()




command! AllSignsInThisLine echo <SID>ListSignsInCurrentLine()
command! AllSignsInThisBuffer echo <SID>ListSignsInCurrentBuffer()
command! OurSignsInThisLine echo <SID>ListSignsOfMayhemInCurrentLine()
command! OurSignsInThisBuffer echo <SID>ListSignsOfMayhemInCurrentBuffer()




" let matchid = matchadd(hlgroup, pattern, priority, id, {conceal = 'X', window = N}]]])
" call matchdelete(matchid)
" priority default 10
" id, positive int, -1 = choose automatically
"
" Save Restore:
" echo getmatches()     ⮕  [{},{},...]
" let matches = getmatches()
" call clearmatches()
" echo getmatches()    ⮕  []
" setmatches(matches)
" echo getmatches()     ⮕  [{},{},...]





"  +⎫
"  +⎪
"  ‼
"  ‼︎
"  +⎪
"  𐰇⎫
"  𐰇⎪
"  𐰇⎪
"  𐰇⎭
"  +⎪
"   ✘
"   ✘
"  +⎭

" echo prop_type_add('test1', {'bufnr': bufnr(), 'highlight': 'TestHint1', 'priority': 1, 'combine': 0, 'override': 0 }

" call prop_type_list({ bufnr })
" call prop_type_[get/delete](name, { bufnr })
" call prop_type_[add/change](name, {
"   \ bufnr
"   \ highlight  (group name)
"   \ priority   (larger = higher priority, default 0)
"   \ combine    (false = ignore/overwrite syntax)
"   \ override   (true = override any other highlight)
"   \ start_incl (true = inserts at start/end
"   \ end_incl           position are included)
" \})

" (end_col == col && lnum == end_lnum): zero-width prop

" prop_find({props} [, {direction}])
" prop_list({lnum} [, {props}])
" prop_clear({lnum} [, {lnum-end} [, {bufnr}]])
" prop_remove({props} [, {lnum} [, {lnum-end}]])





function! s:updateCache() abort
  " TODO
  " make this async with a callback
  " - to update the cache
  " - to update summary for all matching buffers

  for [bufnr, severities] in items(signs#diagnostics())
    if bufexists(bufnr)
      call s:UpdateDiagnosticSummary(bufnr)
    endif
  endfor
endfunc






call autocmd_add([
      \#{
      \ event: 'User',
      \ pattern: 'MayhemDiagnosticsUpdated',
      \ cmd: 'call signs#diagnosticsPlaceProps()',
      \ group: 'mayhem_signs_update', replace: v:true,
      \},
      \])

