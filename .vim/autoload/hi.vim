if exists("g:mayhem_autoloaded_hi") || &cp
  finish
endif
let g:mayhem_autoloaded_hi = 1

"
" See: ../plugin/highlight.vim
"

let s:conceal_guixx_matchids = []

function! hi#concealguixx() abort
  try
    call foreach(get(s:, 'conceal_guixx_matchids', []), {i, v -> matchdelete(v)})
  catch
    echom v:errmsg
  endtry

  let s:conceal_guixx_matchids = [
        \ matchadd('Conceal', '\<\zsg\zeui\([fbs]g\)\?\>=', 10, -1, #{conceal: ' '}),
        \ matchadd('Conceal', '\<g\zsu\zei\([fbs]g\)\?\>=', 10, -1, #{conceal: ' '}),
        \ matchadd('Conceal', '\<gu\zsi\ze\([fbs]g\)\?\>=', 10, -1, #{conceal: ' '}),
        \ matchadd('Conceal', '\<gui[fbs]\zsg\ze\>=', 10, -1, #{conceal: ' '}),
        \ matchadd('Conceal', '\<gui\([fbs]g\)\?\>\zs=\ze', 10, -1, #{conceal: ' '}),
        \]
        " \ matchadd('Conceal', '\<gui\zs[fbs]\zeg\>=', 10, -1, #{conceal: ' '}),
endfunc

"
" Foreground text shown in a contrasting colour to the colour background
" TODO
"
function hi#colorTextContrast() abort
endfunc

"
" Background hidden, show only text in colour
"
function hi#colorTextOnly() abort
  call hlset(hlget()
        \ ->filter({_, x -> x.name =~ '^BG.*' && has_key(x, 'guibg')})
        \ ->map({_, x -> #{ name: x.name, guifg: x.guibg, guibg: 'NONE' }}))
  call hi#concealguixx()
endfunc

"
" Foreground text hidden (same colour as the background)
"
function hi#colorTextHidden() abort
  call hlset(hlget()
        \ ->filter({_, x -> x.name =~ '^BG.*' && has_key(x, 'guibg')})
        \ ->map({_, x -> #{ name: x.name, guifg: x.guibg }}))
  call hi#concealguixx()
endfunc

"
" Highlight highlight group names
"
" TODO - convert this to vim9script for speed
"
function! hi#hi() abort

  " Can't use 'cluster add=' for this, as doing so adds the existing
  " syntax rule(s) with the group name alongside these new ones
  syn match vimHiHiKeyword
        \ /\%(\<hi\%[ghlight]!\?\s\+\%(def\%[ault]\s\+\)\?\%(link\s\+\)\?\)\@<=\%(def\%[ault]\s\|link\s\)\@!\i\+/
        \ contained containedin=vimHiKeyList,vimHiLink

  for hlgroup in hlget()
    try
      exec 'syn keyword' hlgroup['name'] 'contained' hlgroup['name']
            \ 'containedin=vimHiHiKeyword'
    catch
      echom 'HiHi: caught exception processing hl group ''' .. hlgroup .. ''''
      echom v:errmsg
    endtry
  endfor

  silent! syn clear vimGroup
  silent! syn clear vimHiGroup
  silent! syn clear vimHLGroup

  for [name, rgbhex] in get(g:, 'colornames', {})->items()
    try
      exec 'syn keyword' name 'contained' name
            \ 'containedin=vimHiKeyList'
    catch
      echom 'hi#hi: caught exception processing colorname ''' .. name .. ''''
      echom v:errmsg
    endtry

    if name =~ 'b$'
      exec 'hi def' name 'guifg=#222222' 'guibg=' .. rgbhex
    elseif name =~ 'f$'
      exec 'hi def' name 'guifg=' .. rgbhex
    else
      exec 'hi def' name 'guifg=' .. rgbhex
    endif
  endfor

  call autocmd_add([#{
        \ event: 'ColorScheme', pattern: 'vividmayhem',
        \ cmd: 'call hi#hi()',
        \ group: 'mayhem_hihi_colorscheme_event', replace: v:true,
        \},
        \#{
        \ event: 'Syntax', pattern: 'vim',
        \ cmd: 'call hi#hi()',
        \ group: 'mayhem_hihi_colorscheme_event', replace: v:true,
        \},
        \])
endfunc

function! hi#nohi() abort
  call autocmd_delete([
        \#{
        \ event: 'ColorScheme', pattern: 'vividmayhem',
        \ group: 'mayhem_hihi_colorscheme_event',
        \},
        \#{
        \ event: 'Syntax', pattern: 'vim',
        \ group: 'mayhem_hihi_colorscheme_event',
        \},
        \])

  syn enable
endfunc

