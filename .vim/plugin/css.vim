if exists("g:mayhem_loaded_css")
  finish
endif
let g:mayhem_loaded_css = 1


" Extract variable

" Change hex color codes to uppercase
command! UppercaseHex %s/\<\(#\x\{8}\|#\x\{6}\|#\x\{4}\|#\x\{3}\)\>/\U&/g
" command! UppercaseHex :%s/\<\(#[0-9a-fA-F]\{8}\|#[0-9a-fA-F]\{6}\|#[0-9a-fA-F]\{4}\|#[0-9a-fA-F]\{3}\)\>/\U&/g
" Change hex color codes to lowercase
command! LowercaseHex %s/\<\(#\x\{8}\|#\x\{6}\|#\x\{4}\|#\x\{3}\)\>/\L&/g
" Expand short hex codes (#F0E ▬▶︎ #FF00EE, #FB3A ▬▶︎ #FFBB33AA)
command! ExpandHex :%s/\<#\(\x\)\(\x\)\(\x\)\>/#\1\1\2\2\3\3/g

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
