if exists("g:mayhem_loaded_css")
  finish
endif
let g:mayhem_loaded_css = 1


" CSSO



"
"
" Extract individual copy of rule for selector under cursor                TODO
" e.g.
" .foo, .b̲ar, .baz {       .foo, .baz {
"   color: red;       ▬▶︎     color: red;...
"   ...                    .bar {
"                            color: red;...
"
" Same but for all selectors in list                                       TODO
"

"
" Prefix all CSS rules in selection/file                                   TODO
" e.g.
"  .foo {              #someid .foo {
"    color: red;  ▬▶︎      color: red;
"  }                   }
"
" command! -range=% PrefixRules <line1>,<line2>

"
" Remove units from zero values in CSS
"  - But not for:
"       <angle>  \(deg\|grad\|rad\|turn\)
"        <time>  \(s\|ms\)
"   <frequency>  \(Hz\|kHz\)
"  <resolution>  \(dpi\|dppx\|dpcm\)
"
command! -range=% NoZeroUnits <line1>,<line2> s/\%(\s\|,\)\zs[-+]\?0\+\.\?\0*\(cap\|ch\|em\|ex\|ic\|lh\|rcap\|rch\|rem\|rex\|ric\|rlh\|vh\|vw\|vmax\|vmin\|vb\|vi\|cqw\|cqh\|cqi\|cqb\|cqmin\|cqmax\|px\|cm\|mm\|Q\|in\|pc\|pt\)\ze\s/0/ge


" These properties use <time>
" Ensure zero values have units (0 -> 0s)
"
" directly:
"    transition           ⎫
"     transition-delay    ├ any word in these starting with
"     transition-duration ⎪  0 must be a <time>
"    animation            ⎪
"     animation-delay     ⎪
"     animation-duration  ⎭
"   
"
" These properties use <angle>
" Ensure zero values have units 
"
" directly:
"    image-orientation     any valid value starting
"                          with 0 must be an <angle>
"
" via: \%(linear-gradient\|repeating-linear-gradient\)(\s*0
"    background/background-image
"    mask/mask-image
"    border-image-source
"    shape-outside
" any valid linear-gradient def. if first property starts
"   with a 0, it must be an <angle>
"
" via: \%(skew\%(X\|Y\)([]0)\|rotate\%(3d\|X\|Y\|Z\)\?\)()
"    transform 
"
"    any valid value(s) in skew/rotate must be <angles>
"    any valid 4th value for rotate3d must be an <angle>

" 
" Add semicolon to end of last declaration in a rule
" (Anywhere else would be a syntax error)
" Useful for output from CSSO
command! -range=% AddTrailingCommas <line1>,<line2> s/[^;{}]\zs\ze$\n\s*}/;/

" 1. Extract variable
"
" color: #556677;
"   ▼▼
" color: var(--color001);
" --color001: #556677;
"
"
" 2. Extract component variables
"
" box-shadow: 1px 2px 0.1px 0 #449988 inset;
"   ▼
" box-shadow: var(--boxs01);
" --boxs01: 1px 2px 0.1px 0 #449988 inset;
"   ▼
" --boxs01-x: 1px;
" --boxs01-y: 2px;
" --boxs01-r: 0.1px;
" --boxs01-o: 0;
" --boxs01-c: #449988;
" --boxs01-i: inset;
" --boxs01: var(--boxs01-x) var(--boxs01-y) var(--boxs01-r) var(--boxs01-o) var(--boxs01-c) var(--boxs01-i); 
" box-shadow: var(--boxs01);
"
"
" color: #01020304;
" 
" color: var(--color02);
" --color02: #01020380;
"
" --c02r: 1;
" --c02g: 2;
" --c02b: 3;
" --c02a: 0.5;
" --color02: rgb(var(--c02r) var(--c02g) var(--c02b) / var(--c02a));

"
" Data URLs:
" See also: ./dataurl.vim
"
" /url(\("\|'\|\)data:\([A-Za-z/]\+\);\(base64\)\?,\([A-Za-z0-9/+=]\+\)\1)/
"
" Split: across multiple lines
"
" Quotes: add if missing, change to ''
" (Assumes no syntax errors to start with)
" 
command! -range=% DataURLQuotesNone
      \ <line1>,<line2> s/url(\zs\("\|\'\|\)\(data:\_.\{-}\)\1\ze)/\2/
command! -range=% DataURLQuotesSingle
      \ <line1>,<line2> s/url(\zs\("\|\'\|\)\(data:\_.\{-}\)\1\ze)/\'\2\'/
command! -range=% DataURLQuotesDouble
      \ <line1>,<line2> s/url(\zs\("\|\'\|\)\(data:\_.\{-}\)\1\ze)/\"\2\"/



" Change hex color codes to uppercase
command! -range=% UppercaseHex
      \ <line1>,<line2> s/\<\(#\x\{8}\|#\x\{6}\|#\x\{4}\|#\x\{3}\)\>/\U&/g
" Change hex color codes to lowercase
command! -range=% LowercaseHex
      \ <line1>,<line2> s/\<\(#\x\{8}\|#\x\{6}\|#\x\{4}\|#\x\{3}\)\>/\L&/g
" Expand short hex codes (#F0E ▬▶︎ #FF00EE, #FB3A ▬▶︎ #FFBB33AA)
command! -range=% ExpandHex
      \ <line1>,<line2> s/\<#\(\x\)\(\x\)\(\x\)\>/#\1\1\2\2\3\3/g

"       #rrggbb[aa] ▬▶︎ rgb(r g b [/ aa])
"                                                           TODO
command! HexToRgb <Nop>
"  rgb(r g b [/ a]) ▬▶︎ #rrggbb[aa] 
"                                                           TODO
command! RgbToHex <Nop>
"       #rrggbb[aa] ▬▶︎ hsl(h s l [/ a])
"                                                           TODO
command! HexToHsl <Nop>
"  hsl(h s l [/ a]) ▬▶︎ #rrggbb[aa] 
"                                                           TODO
command! HslToHex <Nop>
"
"                                                           TODO
command! RgbToHsl <Nop>
"                                                           TODO
command! HslToRgb <Nop>
"            \1 H                \2 S                \3 L                    \4 A
"         ╭─────────╮      ╭─────────────╮      ╭─────────────╮           ╭────────────╮
/\<hsla\?(\(\d\{1,}\)[^ ]* \(100\|\d\d\?\)[^ ]* \(100\|\d\d\?\)[^ )]*\(\/ \(100\|\d\d?\)%\?\)\?)/

" Get color's complement (h+180deg)
"                                                           TODO
command! Complement <Nop>


" Edge cases and formats etc.
"           #xyz[f] | #xxyyzz[ff]  ▬▶︎  rgb(r g b)
"      #xyz[0-e] | #xxyyzz[00-ef]  ▬▶︎  rgb(r g b / a)
"
"   (legacy) rgb(R,G,B) | (legacy) rgba(R,G,B,1) |
" rgb(R G B) | rgb(R G B / 1) | rgb(R G B / 100%)  ▬▶︎ #xxyyzz
"
"   (legacy) rgba(R,G,B,A) |
" rgb(R G B / [0-0.999])| rgb(R G B / [0-99.99%])  ▬▶︎ #xxyyzzaa

" Absolute value syntax
" rgb(R G B[ / A])  R,G,B = 0-255 or 0%-100% or none
" let rgb = "\<rgb(\(\d\{1,3}\|0\?\d\?\d%\|100%\|none\)\s\+\(\d\{1,3}\|0\?\d\?\d%\|100%\|none\)\s\+\(\d\{1,3}\|0\?\d\?\d%\|100%\|none\)\(\s\+\/\s\+\(0\?\.\d\+\|1\(\.0*\)\?\|0\?\|none\))\|)\)"

let s:none = 'none'
" fast (false positives / non-validating)
"
" <number[0(000)-255(999)]>
let s:nF_0_255 = '\d{1,3}'
" <percentage[0%(00%)-100%]>      (…but also 000%,00% etc.)
let s:pF_0_100 = '100%\|\d{1,2}%'
" <number[0.0-1.0(1.999)]>        (…but also 1.0-1.9 etc.)
let s:dF_00_10 = '1\.0\|0\.0\+\|0\?\.\d\+'

let s:rgb_F = '\('..s:nF_0_255..'\|'..s:pF_0_100..'\|'..s:dF_00_10..'\|'..s:none..'\)'
let s:alpha_F = '\('..s:pF_0_100..'\|'..s:dF_00_10..'\)'

let s:rgbFast = '\<rgba\?('..s:rgb_F..'[^ ] '..s:rgb_F..'[^ ] '..s:rgb_F..'[^)/]\%()\| '..s:alpha_F..'[^)])\)'

"let byte = 
"      \ "\d{1,3}"
"      \ .."\d{1,3}"

" :%s/\<rgb(\s*\(\d{1,3}\|100%\|\d{1,2}%\|none\)\s\+\(\d{1,3}\|100%\|\d{1,2}%\|none\)\s\+\(\d{1,3}\|100%\|\d{1,2}%\|none\)\(\s+\/\s+[01]\?\.\?\d\+\|none\)\?)/

"
" strict (false negatives possible, but no false positives)
"
" <number[0-255]>
let s:nS_0_255 = '\([0-9]\|[1-9][0-9]\|1[0-9]\{2}\|2[0-4][0-9]\|25[0-5]\)'
" 
" <percentage[0%-100%]>
let s:pS_0_100 = '\(100%\|[1-9]\?[0-9]%\)'
"
" <number[0.0-1.0]>
let s:dS_00_10 = '\([01]\(\.0*\)\|0\.\d*\)'

"/\<rgb(\([01][0-9][0-9]\d\{1,3}\|0\?\d\?\d%\|100%\|none\)\s\+\(\d\{1,3}\|0\?\d\?\d%\|100%\|none\)\s\+\(\d\{1,3}\|0\?\d\?\d%\|100%\|none\)\(\s\+\/\s\+\(0\?\.\d\+\|1\(\.0*\)\?\|0\?\|none\))\|)\)/

      
" /\ze\(\s\|;\|,\)/







" Text outline, 8 sides, identical
"
"
" --➕: 1px;
" --➖: calc(var(--➕) * -1);
" --🟰: 0;
" --🔸: 0 #000f;
" text-shadow:
"   var(--➕) var(--🟰) var(--🔸),
"   var(--➕) var(--➕) var(--🔸),
"   var(--🟰) var(--➕) var(--🔸),
"   var(--➖) var(--➕) var(--🔸),
"   var(--➖) var(--🟰) var(--🔸),
"   var(--➖) var(--➖) var(--🔸),
"   var(--🟰) var(--➖) var(--🔸),
"   var(--➕) var(--➖) var(--🔸);
"
" text-shadow:
" --textoutline1px: 1px 0 0 #000f, 1px 1px 0 #000f, 0 1px 0 #000f, -1px 1px 0 #000f, -1px 0 0 #000f, -1px -1px 0 #000f, 0 -1px 0 #000f, 1px -1px 0 #000f;
" --textoutline1px: 1px 0 0.6px #ffff, 1px 1px 0.6px #ffff, 0 1px 0.6px #ffff, -1px 1px 0.6px #ffff, -1px 0 0.6px #ffff, -1px -1px 0.6px #ffff, 0 -1px 0.6px #ffff, 1px -1px 0.6px #ffff;
"
"  1px   0     0 #000f,
"  1px   1px   0 #000f,
"  0     1px   0 #000f,
"  -1px  1px   0 #000f,
"  -1px  0     0 #000f,
"  -1px  -1px  0 #000f,
"  0     -1px  0 #000f,
"  1px   -1px  0 #000f;

" Text border, 4 sides

"   --bcolor: rgb(0 0 0);
"   --bblur: 0;
"   --bthick: 0.01em;
"   --bct:var(--bcolor);--bcr:var(--bcolor);--bcb:var(--bcolor);--bcl:var(--bcolor);
"   --blt:var(--bblur);--blr:var(--bblur);--blb:var(--bblur);--bll:var(--bblur);
"   --bw: var(--bthick); --bh: var(--bthick);
"   --bxt: calc(var(--bw) * -1); --bxb: var(--bw); --bxr: 0; --bxl: 0;
"   --byl: calc(var(--bh) * -1); --byr: var(--bh); --byt: 0; --byb: 0;
"   text-shadow:
"     var(--bxt) var(--byt) var(--blt) var(--bct),
"     var(--bxr) var(--byr) var(--blr) var(--bcr),
"     var(--bxb) var(--byb) var(--blb) var(--bcb),
"     var(--bxl) var(--byl) var(--bll) var(--bcl),
"     0 0 #0000;

" Text border, 4 corners

"   --bcolor: rgb(0 0 0);
"   --bblur: 0;
"   --bthick: 0.01em;
"   --bctr:var(--bcolor);--bcbr:var(--bcolor);--bcbl:var(--bcolor);--bctl:var(--bcolor);
"   --bltr:var(--bblur);--blbr:var(--bblur);--blbl:var(--bblur);--bltl:var(--bblur);
"   --bw: var(--bthick); --bh: var(--bthick);
"   --bxtl: calc(var(--bw) * -1); --bxbl: var(--bxtl); --bxbr: var(--bw); --bxtr: var(--bxbr);
"   --bytl: calc(var(--bh) * -1); --bytr: var(--bytl); --bybr: var(--bh); --bybl: var(--bybr); 
"   text-shadow:
"     var(--bxtr) var(--bytr) var(--bltr) var(--bctr),
"     var(--bxbr) var(--bybr) var(--blbr) var(--bcbr),
"     var(--bxbl) var(--bybl) var(--blbl) var(--bcbl),
"     var(--bxtl) var(--bytl) var(--bltl) var(--bctl),
"     0 0 #0000;

" Text border, 4 sides & 4 corners

"   --bcolor: rgb(0 0 0);
"   --bblur: 0;
"   --bthick: 0.01em;
"   --bct:var(--bcolor);--bcr:var(--bcolor);--bcb:var(--bcolor);--bcl:var(--bcolor);
"   --bctr:var(--bcolor);--bcbr:var(--bcolor);--bcbl:var(--bcolor);--bctl:var(--bcolor);
"   --blt:var(--bblur);--blr:var(--bblur);--blb:var(--bblur);--bll:var(--bblur);
"   --bltr:var(--bblur);--blbr:var(--bblur);--blbl:var(--bblur);--bltl:var(--bblur);
"   --bw: var(--bthick); --bh: var(--bthick);
"   --bxt: calc(var(--bw) * -1); --bxb: var(--bw); --bxr: 0; --bxl: 0;
"   --byl: calc(var(--bh) * -1); --byr: var(--bh); --byt: 0; --byb: 0;
"   --bxtl: calc(var(--bw) * -1); --bxbl: var(--bxtl); --bxbr: var(--bw); --bxtr: var(--bxbr);
"   --bytl: calc(var(--bh) * -1); --bytr: var(--bytl); --bybr: var(--bh); --bybl: var(--bybr); 
"   text-shadow:
"     var(--bxt) var(--byt) var(--blt) var(--bct),
"     var(--bxr) var(--byr) var(--blr) var(--bcr),
"     var(--bxb) var(--byb) var(--blb) var(--bcb),
"     var(--bxl) var(--byl) var(--bll) var(--bcl),
"     var(--bxtr) var(--bytr) var(--bltr) var(--bctr),
"     var(--bxbr) var(--bybr) var(--blbr) var(--bcbr),
"     var(--bxbl) var(--bybl) var(--blbl) var(--bcbl),
"     var(--bxtl) var(--bytl) var(--bltl) var(--bctl),
"     0 0 #0000;

function! s:OpenCSSFile()
 if filereadable(expand('%:r')..'.scss')
   exec 'vsp '..expand('%:r')..'.scss'
 elseif filereadable(expand('%:r')..'.module.scss')
   exec 'vsp '..expand('%:r')..'.module.scss'
 elseif filereadable(expand('%:r')..'.module.css')
   exec 'vsp '..expand('%:r')..'.module.css'
 else
   echo 'No matching CSS file found'
 endif
endfunc
command! OpenCSSFile call <SID>OpenCSSFile()
