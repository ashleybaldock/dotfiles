if exists("g:mayhem_loaded_jq")
  finish
endif
let g:mayhem_loaded_jq = 1


command! -range=% JsonQuery <line1>,<line2> !jq --input - 

function! s:JsonQuery() range
  let lines = readfile(expand('~/somefile.json'))
  let selectedlines = systemlist('jq -r ".[] | select(.key==\"value\")"', lines)
  let seletedids = systemlist('jq -r ".id"', selectedlines)
  let count = len(selectedids)
endfunc

