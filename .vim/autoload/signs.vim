if exists("g:mayhem_autoloaded_signs") || &cp
  finish
endif
let g:mayhem_autoloaded_signs = 1

"
" See: ../plugin/signs.vim
"

let s:prefix = 'mayhem_'
let s:group = 'signs_of_mayhem'

"
" group:
"  '*' = all groups
"  ''  = global group only  
"
function! signs#list(bufnr = bufnr()) abort
  return sign_getplaced(a:bufnr, { 'group': '*'})
endfunc
function! signs#groupList(group = s:group, bufnr = bufnr()) abort
  return sign_getplaced(a:bufnr, { 'group': s:group })
endfunc


" echo prop_type_add('test1', {'bufnr': bufnr(), 'highlight': 'TestHint1', 'priority': 1, 'combine': 0, 'override': 0 }
      \  bufnr,
      \  highlight: 'ErrorHint',
      \  highlight: 'WarningHint',
let s:types_diag = #{
      \ Error:  prop_type_add(s:prefix .. 'diagError', #{
      \  highlight: 'TestHint1',
      \  priority: 6,
      \  combine: v:true,
      \  override: v:false,
      \  start_incl: v:false,
      \  end_incl: v:false,
      \  }),
      \ Warning:  prop_type_add(s:prefix .. 'diagWarning', #{
      \  highlight: 'TestHint4',
      \  priority: 5,
      \  combine: v:true,
      \  override: v:false,
      \  start_incl: v:false,
      \  end_incl: v:false,
      \  }),
      \ Hint:  prop_type_add(s:prefix .. 'diagHint', #{
      \  highlight: 'HintHint',
      \  priority: 3,
      \  combine: v:true,
      \  override: v:false,
      \  start_incl: v:false,
      \  end_incl: v:false,
      \  }),
      \ Info:  prop_type_add(s:prefix .. 'diagInfo', #{
      \  highlight: 'InfoHint',
      \  priority: 2,
      \  combine: v:true,
      \  override: v:false,
      \  start_incl: v:false,
      \  end_incl: v:false,
      \  }),
      \ }

let s:cachedFetch = []
let s:diagnosticsByFileAndSeverity = #{}

function! signs#fetch() abort
  let s:cachedFetch = CocAction('diagnosticList')
  return s:cachedFetch
endfunc

function! signs#cached() abort
  return s:cachedFetch
endfunc

function! signs#diagnosticsUpdate() abort
  let s:diagnosticsByFileAndSeverity = signs#fetch()
        \->reduce({acc, cur -> has_key(acc, bufnr(cur.file))
        \ ? add(acc[bufnr(cur.file)][cur.severity], cur)
        \ : extend(acc, {
        \   bufnr(cur.file): {[cur.severity]: [cur]}
        \  })
        \}, {})
endfunc

function! signs#diagnosticsPlaceProps() abort
  call foreach(get(s:, 'diagnosticsByFileAndSeverity', {}),
        \ {bufnr, severities -> foreach(severities,
        \  {severity, props -> prop_add_list(#{
        \   bufnr: bufnr,
        \   type: get(s:types_diag, severity)
        \   }, mapnew(props, {i, p -> [p.lnum, p.col, p.end_lnum, p.end_col]})
        \  )}
        \ )}
        \)
endfunc

function! signs#diagnostics() abort
  return s:diagnosticsByFileAndSeverity
endfunc



" ->json_encode()->FormatJSON()->append('$')

"
" call prop_add_list(#{bufnr: a:bufnr, type: s:types_diag_error[️, id: id]️}︎, [
"       \[lnum, col, endlnum, endcol][️, id]️]︎,
"        \])


" prop_add(lnum, col, {
"   id         (auto, or supply specific number)
"   bufnr
"   type       (same as use for prop_type_add)
"   length     (same-line only)(length of prop in bytes)
"   end_lnum   (line nr for end of prop, inclusive)
"   end_col    (column just after end of prop)
   
"   text          (col > 0: same line, before col)
"   └╴text_align  [col = 0]
"   ╎   :after    (eol)
"   ╎   :right    (aligned in window, 1 per line)
"   ╎   :above    (line before)
"   ╎   :below    (next screen line)
"   └╴text_padding_left
"   text_wrap
"       :wrap
"       :truncate)
"  }


" prop_add({lnum}, {col}, {props})
" prop_add_list({props}, [{item}, ...])
