if exists("g:mayhem_loaded_tabline")
  finish
endif
let g:mayhem_loaded_tabline = 1


set guitabtooltip=%.400{GuiTabToolTip()}

function! GuiTabToolTip() abort
  return printf("tab %d/%d\n%s", tabpagenr(), tabpagenr('$'),
        \ tabpagenr()
        \->tabpagebuflist()
        \->map({i, bufnr -> printf("%d	%s %s", bufnr,
        \ bufname(bufnr),
        \ getbufvar(bufnr, "&modified") ? '+' : getbufvar(bufnr, "&modifiable") == 0 ? '-' : ''
        \)})->join("\n"))
endfunction

set guitablabel=%{GuiTabLabel()}

function! GuiTabLabel() abort
  return printf("tab %d/%d\n%s", tabpagenr(), tabpagenr('$'), bufname())
endfunction
