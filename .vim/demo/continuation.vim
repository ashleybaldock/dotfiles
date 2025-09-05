if exists("g:mayhem_loaded_continuation")
  finish
endif
let g:mayhem_loaded_continuation = 1


echo 'line 1' ..
      \'line 2' ..
      "\'line 3' ..
      \ line 4 ..
      \ line 5






line 1
\ line 2
\ line 3


abc \ def
     abb


echo getline(3,6)->map({_,v -> v->split('^\s*"\s*\\')->get(0, '')})->join('')

^\s*\([^"\\].*\%(\n\s*\\.*\)\+\)\ze\n\s*\%("\|[^\\]\)
