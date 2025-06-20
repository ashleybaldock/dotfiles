if exists("g:mayhem_autoloaded_svg") || &cp
  finish
endif
let g:mayhem_autoloaded_svg = 1

"
" Set currrent selection to the SVG document closest to the cursor 
"
" - Enclosing tags take priority, then the next one after, and
"   finally the previous one)
"
" Look back for an <svg> or </svg> tag
"   - First found (S1) is <svg>
"     - Look forward from cursor for S1's end tag
"   - First found (S1) is </svg>
"     - Look forward from cursor for <svg> or </svg>
"       - First found (S2) is <svg>
"         - Pick (S3), closest of S1 or S2
"         - Look back/foward to find S3's start/end tag
"       - First found {S2) is </svg>
"         - Pick S2 (contains cursor)
"         - Look back to find S2's start tag
" Look forward for <svg> or </svg> tag
"   - First found (S1) is </svg>
"   - First found (S1) is <svg>
" position before
"
function! svg#selectClosestSvg() abort

endfunction

