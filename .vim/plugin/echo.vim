if exists("g:mayhem_loaded_echo")
  finish
endif
let g:mayhem_loaded_echo = 1

"
" Related:
"     $VIMHOME/autoload/echo.vim
"


"
" (Crudely) Formatted echo commands
"
" e.g. :EcN 'normal ' | EcB 'bold ' | EcI 'italic ' | EcN 'back to normal'
"
" - Resets hl group at the end of each command
" - Formatting isn't additive, one hl group at a time
" - Spaces at the end of each command aren't preserved
"
"   EcN hello | EcN world!     ->  helloworld! 
"   EcN hello ' ' | EcN world!  ->  hello world!
"
" command! -nargs=1 EcN echoh EchoText | echon <q-args> | echoh None
" command! -nargs=1 EcI echoh EchoItalic | echon <q-args> | echoh None
command! -bar -nargs=1 EcN exec 'echoh EchoText | echon ''' .. <q-args> .. ''' | echoh None'
command! -bar -nargs=1 EcB exec 'echoh HlBold | echon ''' .. <q-args> .. ''' | echoh None'
command! -bar -nargs=1 EcI exec 'echoh HlItalic | echon ''' .. <q-args> .. ''' | echoh None'
command! -bar -nargs=1 EcBI exec 'echoh HlBoldItalic | echon ''' .. <q-args> .. ''' | echoh None'

"
" Echo a highlight group name in its own highlighting
"
" e.g. :EcN See hl group | EcH Constant | EcN for info
"
command! -bar -nargs=1 EcH exec 'echoh ' .. <q-args> .. ' | echon ''' .. <q-args> .. ''' | echoh None'

