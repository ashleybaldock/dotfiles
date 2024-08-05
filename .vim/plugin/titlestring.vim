if exists("g:mayhem_loaded_titlestring")
  finish
endif
let g:mayhem_loaded_titlestring = 1



set titlestring=│\ %{SessionName()}\ │\ %t\ │\ %{substitute\(pathshorten\(expand(\"%:p:~:h\"),8),\"/\",\" / \",\"g\"\)}\ / %t

