
:function! OpenCSSFile()
: if filereadable(expand('%:r') . ".scss")
:   :execute 'vsp' expand('%:r') . ".scss"
: elseif filereadable(expand('%:r') . ".module.scss")
:   :execute 'vsp' expand('%:r') . ".module.scss"
: elseif filereadable(expand('%:r') . ".module.css")
:   :execute 'vsp' expand('%:r') . ".module.css"
: else
:   echo "No matching CSS file found"
: endif
:endfunction
:command! OpenCSS call OpenCSSFile()
