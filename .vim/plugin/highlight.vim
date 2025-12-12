if exists("g:mayhem_loaded_highlight")
  finish
endif
let g:mayhem_loaded_highlight = 1

let s:conceal_guixx_matchids = []

function s:Conceal_guixx() abort
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

" Foreground text shown in a contrasting colour to the colour background
function ColourHighlightTextContrast() abort
endfunc

" Foreground text hidden (same colour as the background)
function ColourHighlightTextHidden() abort
  call hlset(hlget()
        \ ->filter({_, x -> x.name =~ '^BG.*' && has_key(x, 'guibg')})
        \ ->map({_, x -> #{name: x.name, guifg: x.guibg}}))
  call s:Conceal_guixx()
endfunc

" Background hidden, show only text in colour
function ColourHighlightTextOnly() abort
  call hlset(hlget()
        \ ->filter({_, x -> x.name =~ '^BG.*' && has_key(x, 'guibg')})
        \ ->map({_, x -> #{name: x.name, guifg: x.guibg, guibg: 'NONE'}}))
  call s:Conceal_guixx()
endfunc

" TODO convert this to vim9script for speed
function! s:HighlightHighlight() abort

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
      echom 'HiHi: caught exception from hl group ''' .. hlgroup .. ''''
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
      echom 'HiHi: caught exception from hl group ''' .. hlgroup .. ''''
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
        \ cmd: 'call s:HighlightHighlight()',
        \ group: 'mayhem_hihi_colorscheme_event', replace: v:true,
        \},
        \#{
        \ event: 'Syntax', pattern: 'vim',
        \ cmd: 'call s:HighlightHighlight()',
        \ group: 'mayhem_hihi_colorscheme_event', replace: v:true,
        \}
        \])
endfunc

function! s:NoHighlightHighlight() abort
  call autocmd_delete([
        \#{
        \ event: 'ColorScheme', pattern: 'vividmayhem',
        \ group: 'mayhem_hihi_colorscheme_event',
        \},
        \#{
        \ event: 'Syntax', pattern: 'vim',
        \ group: 'mayhem_hihi_colorscheme_event',
        \}
        \])

  syn enable
endfunc

command! -bar HiHi call <SID>HighlightHighlight()

