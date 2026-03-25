# svg-syntax

---

## Raster to SVG

### Convert pixel images


## <path> Transformations


```pre
 ├─────────────┼────────────────────────┼──────────────────────────────────────┤
 │    viewBox: │        𝝼ˣ️ 𝝼ʸ️ 𝝼ʷ️ 𝝼ʰ️     │                                      │
 │             │  Absolute  [MLHVQTCSA] │  to        Relative  [mlhvqtcsa]     │
 ├─────────────┼────────────────────────│──────────────────────────────────────┤
 │       Move: │ M  x y [x y …️]         ┊         m  ᵈx ᵈy [ᵈx ᵈy …️]           │
 │             │       to abs coords    ┊         by distance in x and y       │
 │             │                        ┊                                      │
 │     LineTo: │ L  x y [x y …️]         ┊         l  ᵈx ᵈy [ᵈx ᵈy …️]           │
 │             │       to abs coords    ┊         by distance in x and y       │
 │             │                        ┊                                      │
 │  Horizontal │ H  x [x …️]             ┊         h  ᵈx [ᵈx …️]                 │
 │             │       to abs x coord   ┊         by distance x                │
 │    Vertical │ V  y [y …️]             ┊         v  ᵈy [ᵈy …️]                 │
 │             │       to abs y coord   ┊         by distance y                │
 ├─────────────│────────────────────────┊──────────────────────────────────────┤
 │  Quadratic: │ Q  𝓍¹ 𝓎¹ 𝓍  𝓎          ┊         q  ᵈx¹ ᵈy¹ ᵈx  ᵈy            │
 │  Quadratic: │ Q  𝛼ˣ️ 𝛼ʸ️ 𝓍  𝓎          ┊         q   𝛼ˣ⃗ 𝛼ʸ⃗   𝓍⃗  𝓎⃗             │
 │             │   ╰╴p¹╶╯╰╴pᵉ️╶╯         ┊           ╰─╴p¹╶─╯╰─╴pᵉ️╶─╯           │
 │             │                        ┊ 𝙥ˣ️ 𝙥ʸ️ ◄───────╯───────╯              │
 │             │                        ┊                                      │
 │╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️│︎╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️┊︎╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️│︎
 │             │ T    →️   x  y          ┊         t     →️    ᵈx  ᵈy            │
 │             │                        ┊           (𝙥ˣ️  𝙥ʸ️) +𝙥ˣ️ +𝙥ʸ️           │
 │             │   ╰╴p¹╶╯╰╴pᵉ️╶╯         ┊           ╰─╴p¹╶─╯╰─╴pᵉ️╶─╯           │
 │─️─️─️─️─️─️─️─️─️─️─️─️─️│︎────────────────────────┊──────────────────────────────────────┤
 │      Cubic: │ C  𝑎ˣ️ 𝑎ʸ️ 𝑏ˣ️ 𝑏ʸ️ x  y    ┊         c  𝑎ˣ⃗ 𝑎ʸ⃗ 𝑏ˣ⃗ 𝑏ʸ⃗ ᵈx  ᵈy        │
 │             │   ╰╴p¹╶╯╰╴p²╶╯╰╴pᵉ️╶╯   ┊           ╰─╴p¹╶─╯╰─╴pᵉ️╶─╯           │
 │╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️│︎╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️┊︎╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️│︎
 │             │ S    →️   x² y² x  y    ┊         s     →️    ᵈx² ᵈy² ᵈx  ᵈy    │
 │             │                        ┊                                      │
 ├─────────────┼────────────────────────┊──────────────────────────────────────┤
 │ Elliptical: │ A  xᴿ yᴿ 𝑎 𝐹̍ 𝐹̎ x y     ┊         a  xᴿ yᴿ 𝑎 𝐹̍ 𝐹̎ ᵈx ᵈy         │
 ├─────────────┼────────────────────────┊──────────────────────────────────────┤
 │  ClosePath: │ Z                      ┊         z                            │
 ╰─────────────┴────────────────────────┴──────────────────────────────────────╯
  Hh:                  [x]…️
  Vv:                  [y]…️
  Mm Ll Qq Tt Cc Ss: [x y]…️
  Aa:      [x y →️ →️ →️ x y]…️
 
  A rx ry angle large-arc-flag sweep-flag x y

```

```pre
m6.148 18.473 1.863-1.003 1.615-.839-2.568-4.816h4.332l-11.379-11.408v16.015l3.316-3.221z
```

### Reverse <path> winding order

```pre

   fill-rule  =    evenodd      nonzero
 
  ▽╶───────╴◁    ▄︎⃪ ▄︎⃪ ▄︎⃪ ▄︎⃪ ▄︎⃪     ▄︎⃪ ▄︎⃪ ▄︎⃪ ▄︎⃪ ▄︎⃪  
  │ ▽╶───╴◁ │    █︎⃓ ▀︎⃪ ▀︎⃪ ▀︎⃪ █︎⃓     █︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓  
  │ │     │ │    █︎⃓       █︎⃓     █︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓  
  │ │     │ │    █︎⃓       █︎⃓     █︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓  
  │ ▶︎╶────△ │    █︎⃓ ▄︎⃪▄︎⃪▄︎⃪ ▄︎⃪ █︎⃓     █︎⃓ █︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓█︎⃓  
  ▶︎╶────────△    ▀︎⃪ ▀︎⃪▀︎⃪▀︎⃪ ▀︎⃪ ▀︎⃪     ▀︎⃪ ▀︎⃪▀︎⃪▀︎⃪ ▀︎⃪ ▀︎⃪ 
                               
  ▽╶───────╴◁    ▄︎⃪ ▄︎⃪ ▄︎⃪ ▄︎⃪ ▄︎⃪     ▄︎⃪ ▄︎⃪ ▄︎⃪ ▄︎⃪ ▄︎⃪ 
  │ ▷╶───╴▽ │    █︎⃓ ▀︎⃪ ▀︎⃪ ▀︎⃪ █︎⃓     █︎⃓ ▀︎⃪ ▀︎⃪ ▀︎⃪ █︎⃓
  │ │     │ │    █︎⃓       █︎⃓     █︎⃓       █︎⃓
  │ │     │ │    █︎⃓       █︎⃓     █︎⃓       █︎⃓
  │ ▲╶────◁ │    █︎⃓ ▄︎⃪▄︎⃪▄︎⃪ ▄︎⃪ █︎⃓     █︎⃓ ▄︎⃪▄︎⃪▄︎⃪ ▄︎⃪ █︎⃓
  ▶︎╶────────△    ▀︎⃪ ▀︎⃪▀︎⃪▀︎⃪ ▀︎⃪ ▀︎⃪     ▀︎⃪ ▀︎⃪▀︎⃪▀︎⃪ ▀︎⃪ ▀︎⃪

```

```html
<svg viewBox="-1 -1 30 30" xmlns="http://www.w3.org/2000/svg">
<defs>
    <!-- A marker to be used as an arrowhead -->
    <marker id="coord" style="
fill-opacity: 1;
stroke: blue;
fill: goldenrod;
"
refX="5" refY="5"
orient="auto"
markerWidth="15" markerHeight="15"
viewBox="0 0 40 40">
      <path d="M 0 0 L 20 5 L 0 20 z"></path>
    </marker>
  </defs>
<path d="M0 8h8v-8h-8zm1-1h6v-6h-6z" marker-end="url(#coord)" marker-start="url(#coord)"></path>
<path d="M10 8h8v-8h-8zm1-1h6v-6h-6z"></path>
<path d="M20 8h8v-8h-8zm1-1h6v-6h-6z"></path>

<path d="M0 18h8v-8h-8zm1-1v-6h6v6z"
         M0 18h8v-8h-8zm1-1h6v-6h-6z" marker-end="url(#coord)" marker-start="url(#coord)"></path>
<path d="M10 8h8v-8h-8zm1-1h6v-6h-6z"></path>
<path d="M20 8h8v-8h-8zm1-1h6v-6h-6z"></path>
</svg>
```

```pre
d="M0 18h8v-8h-8zm1-1v-6h6v6z"

                
                 ║   scale(-1, 1)  
                 ║                 
   ▽╶───────╴◁   ║   ▷╶────────▽  
   │ ▽╶───╴◁ │   ║   │ ▷╶────▽ │   
   │ │     │ │   ║   │ │     │ │   
   │ │     │ │   ║   │ │     │ │   
   │ ▶︎󠅐╶────△ │   ║   │ △╶───╴◀︎󠅐 │   
   ▶︎󠅐╶────────△   ║   △╶───────╴◀︎󠅐   
                 ║                 
 ════════════════╬═════════════════
                 ║                 
   ▶︎󠅐╶────────▽   ║   ▽╶───────╴◀︎󠅐   
   │ ▶︎󠅐╶────▽ │   ║   │ ▽╶───╴◀︎󠅐 │   
   │ │     │ │   ║   │ │     │ │   
   │ │     │ │   ║   │ │     │ │   
   │ △╶───╴◁ │   ║   │ ▷╶────△ │   
   △╶───────╴◁   ║   ▷╶────────△   
                 ║                 
   scale(1,-1)   ║   scale(-1,-1)  
    
```

### Change starting point of a <path>

TODO

### Convert shapes/lines etc. into a <path>

TODO

```pre

    0 1 2 3 4 5 6 7 8 9
  0 ■ ■ □ □ ■ ■ ■ □ □ ■
  1 □ ■ ■ □ ■ ■ ■ □ □ ■
  2 □ □ □ □ □ □ □ □ □ □  whole line discontinuity
  3 □ □ ■ ■ ■ □ ■ □ ■ □
  4 □ □ ■ □ ■ □ □ ■ ■ □
  5 □ □ ■ ■ ■ □ ■ ■ □ □

 ╷                                                                       
 ∇  i  i+k i₂  i₂+k₂                                                     
 j₁╶️╺━╍━╸╶️╶️╺︎━╍━╍━╸╶️   1x1 square for each unit line segment, all         
 j₂╶️╺━╍━╸╶️╶️╺︎━╍━╍━╸╶️   clockwise, opposing vectors cancel out             
 j₃╶️╺━╍━╸╶️╶️╶️╶️╶️╶️╶️╶️╶️╶️     ╭─▷╶╮╭─▷╶╮╭─▷╶╮   ╭─▷╶───▷╶───▷╶╮                
    ┌─╥─┐  ┌─╥─╥─┐      ∆   ∇∆   ∇∆   ∇   ∆   ∇∆   ∇∆   ∇                
    ╞═╬═╡  ╞═╬═╬═╡      ╰╴◁─╯╰╴◁─╯╰╴◁─╯   │ ◁    ◁ ╭─╴◁─╯                
    ╞═╬═╡  └─╨─╨─┘      ╭─▷╶╮╭─▷╶╮        │ ▷    ▷ │                     
    └─╨─┘               ∆   ∇∆   ∇        ∆   ∇∆   ∇                     
    ┏━━̩━︎┓  ┏━━̩━━̩━┓      ╰╴◁─╯╰╴◁─╯        ╰╴◁───╴◁─╯                     
    ┠ +️ ┨  ┠ +️ +️ ┨    Since all the initial shapes are squares that      
    ┠ +️ ┨  ┗━━̍━━̍━┛    can share each edge only with one other the        
    ┗━━̍━︎┛             result will be closed, non-overlapping paths       
                                                                         
    ╭─▷╶╮╭─▷╶╮╭─▷╶╮  ╭─▷╶───▷╶───▷╶╮  Holes end up anti-clockwise, with  
    ∆   ∇∆   ∇∆   ∇  ∆   ∇∆   ∇∆   ∇  each level of nesting reversing    
    ╰╴◁─╯╰╴◁─╯╰╴◁─╯  │ ◁ ╭─╴◁──╮ ◁ │                                     
    ╭─▷╶╮     ╭─▷╶╮  │ ▷ │     │ ▷ │  ╭─▷╶╮       ╭─▷╶╮                  
    ∆   ∇     ∆   ∇  ∆   ∇     ∆   ∇  ∆   ∇       ∆   ∇                  
    ╰╴◁─╯     ╰╴◁─╯  │ ◁ │     │ ◁ │  ╰╴◁─╯       ╰╴◁─╎─▷╶╮              
    ╭─▷╶╮╭─▷╶╮╭─▷╶╮  │ ▷ ╰──▷╶─╯ ▷ │       ╭─▷╶╮      ∆   ∇              
    ∆   ∇∆   ∇∆   ∇  ∆   ∇∆   ∇∆   ∇       ∆   ∇      ╰╴◁─╯              
    ╰╴◁─╯╰╴◁─╯╰╴◁─╯  ╰╴◁───╴◁───╴◁─╯       ╰╴◁─╯                         
                                                                         
```

### Split <path>

#### ...at z (absolute)

```pre
    […️]z ╱ Mx y             ┊ …️ \n …️
Mx y[…️]z ╱ Lx y             ┊ …️ \nMx y …️
Mx y[…️]z ╱ Hx               ┊     "         
Mx y[…️]z ╱ Vy               ┊     "         
Mx y[…️]z ╱ Qx¹ y¹ x y       ┊
Mx y[…️]z ╱       Tx y       ┊
Mx y[…️]z ╱ Cx¹ y¹ x² y² x y ┊
Mx y[…️]z ╱       Sx² y² x y ┊
Mx y[…️]z ╱ Axᴿ yᴿ 𝑎 𝐹̍ 𝐹̎ x y ┊
```

#### ...at z (relative)

#### ...at 2 arbitrary points

```pre
Cx¹ y¹ x² y² x y ╱ *        ┊ …️ "\nMx" y …️

    […️]z ╱ Mx y             ┊ …️ \n …️
Mx y[…️]z ╱ Lx y             ┊ …️ \nMx y …️
Mx y[…️]z ╱ Hx               ┊     "         
Mx y[…️]z ╱ Vy               ┊     "         
Mx y[…️]z ╱ Qx¹ y¹ x y       ┊
Mx y[…️]z ╱       Tx y       ┊
Mx y[…️]z ╱ Cx¹ y¹ x² y² x y ┊
Mx y[…️]z ╱       Sx² y² x y ┊
Mx y[…️]z ╱ Axᴿ yᴿ 𝑎 𝐹̍ 𝐹̎ x y ┊
```
#### ...by intersection with a line

### ...into individual line segments

## Merge <path>s
- Apply 


### Scale <path>: (×x ×y)

```pre
1. split on [mMlLhvVcCsSqQtTaAzZ]
2. split those on [ -]
3. parse each value as float
4. multiply by x or y
 Hh:                  [x]…️
 Vv:                  [y]…️
 Mm Ll Qq Tt Cc Ss: [x y]…️
 Aa:      [x y →️ →️ →️ x y]…️
5. fix precision
6. format as string + join back together


m6.148 18.473 1.863-1.003 1.615-.839-2.568-4.816h4.332l-11.379-11.408v16.015l3.316-3.221z

      X      Y
m   6.148  18.473(1.863 -1.003)(1.615 -.839)(-2.568 -4.816)
 l  1.863  -1.003
 l  1.615   -.839
 l -2.568  -4.816
h   4.332
l -11.379 -11.408
v          16.015
l   3.316  -3.221
z

```

### Translate <path>: (±x ±y)

```pre
Only absolute coordinates need to be changed

 H:                  [x]…️  1
 V:                  [y]…️  1
 M L Q T C S:      [x y]…️  2
 A:      [x y →️ →️ →️ x y]…️  7
 h v m l q t c s a:  [→️]…️  1

```


```pre
transform: 
            
  translate(-35%, 1%)
  scale(0.68, 0.44)

transform-origin: 75% 25%;

         ╭╴𝝼ˣ️ᵐⁱⁿ ╭╴𝝼ˣ️ᵐᵃˣ      ( 𝝼ˣ️ᵐⁱⁿ − 𝝼ˣ️ᵐᵃˣ = 𝝼ʷ️ )
viewBox="0  0  640  640"
      𝝼ʸ️ᵐⁱⁿ╶╯  𝝼ʸ️ᵐᵃˣ╶╯        ( 𝝼ʸ️ᵐⁱⁿ − 𝝼ʸ️ᵐᵃˣ = 𝝼ʰ️ )

  ╷       |                           |     ╷
 ╴󠅀╷╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀|╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀|╴󠅀 ╴󠅀 ╴󠅀╷╴󠅀 ╴󠅀
  ╷       𝟢%️                         𝟣𝟢𝟢%️   ╷
  ╷ 𝝼ʸ️ᵐⁱⁿ↘︎|↙︎𝝼ˣ️ᵐⁱⁿ                     |     ╷
 -️╷-️-️𝟢%️-️-️-️┌︎⃝─️─️─️─️─️─️─️─️─️─️─️─️─️─️─️─️─️─️─️─️─️─️─️─️─️─️─️┐️↖︎-️-️-️-️╷-️
  ╷       │                           │𝝼ˣ️ᵐᵃˣ╷
  ╷       │                           │     ╷
  ╷       │                           │     ╷
  ╷       │                           │     ╷
  ╷       │                           │     ╷
  ╷       │                           │     ╷
  ╷       │                           │     ╷
 -️╷-️𝟣𝟢𝟢%️-️↗︎└───────────────────────────┘-️-️-️-️-️╷-️
  ╷ 𝝼ʸ️ᵐᵃˣ |                           |     ╷
  ╷       |                           |     ╷
 ╴󠅀╷╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀|╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀 ╴󠅀|╴󠅀 ╴󠅀 ╴󠅀╷╴󠅀 ╴󠅀
  ╷       |                           |     ╷


 M534.6 182.6C547.1 170.1 547.1 149.8 534.6 137.3L470.6 73.3C461.4 64.1 447.7 61.4 435.7 66.4C423.7 71.4 416 83.1 416 96L416 224C416 236.9 423.8 248.6 435.8 253.6C447.8 258.6 461.5 255.8 470.7 246.7L534.7 182.7z

𝝙x = 𝖵ᵪᵥₓᘁᘁᵥᕽᴴᵂᶹᑋʷ️ʰ️ˣ️ʸ️

𝝼ʷʷ️ 𝝼ʰ️ 𝝼ˣ️ 𝝼ʸ️  ʋʷ️ ʋʰ️ ʋˣ️ ʋʸ️
𝞶ʷ️ 𝞶ʰ️ 𝞶ˣ️ 𝞶ʸ️ 
𝝂ʷ️ 𝝂ʰ️ 𝝂ˣ️ 𝝂ʸ️  

 
```


### Rotate <path>

#### ...by 90deg increments

#### ...by an arbitrary amount



## Modifying Color & Alpha

### Remove alpha channel

Replace with opaque colour generated by mixing with a base color.


## Filters

### Outlining

### Dot-matrix


## Element Reference

### filter
- primitiveUnits: userSpaceOnUse|objectBoundingBox
- clipPathUnits: userSpaceOnUse|objectBoundingBox

### feMorphology
- in: <ident>|SourceGraphic|SourceAlpha|BackgroundAlpha|FillPaint|StrokePaint
- operator: erode|dilate
- radius: x[ y]
- result: <ident>

### feComposite
- in: <ident>|SourceGraphic|SourceAlpha|BackgroundAlpha|FillPaint|StrokePaint
- in2: <ident>|SourceGraphic|SourceAlpha|BackgroundAlpha|FillPaint|StrokePaint
- operator: over|in|out|atop|xor|lighter|arithmetic 
- result: <ident>

### feFlood
- flood-opacity: 0.0-1.0
- flood-color: <color>
- x
- y
- height
- width
- result: <ident>

### feColorMatrix
- in: 
  - <ident>|SourceGraphic|SourceAlpha|BackgroundAlpha|FillPaint|StrokePaint
  - SourceGraphic
  - SourceAlpha
  - BackgroundAlpha
  - BackgroundImage
  - FillPaint
  - StrokePaint
  - or a reference to another filter primitive.

type:
  - saturate
  - hueRotate
  - luminanceToAlpha
  - matrix
```pre

values="0.5 0.5 0.5 0 0 0 0.33 0 0 0 0 0 0.33 0 0 0.2 0.1 0.1 0.5 -0.52"

     ⏐   R   ⏐   G   ⏐   B   ⏐   A   ⏐   c
 ╶───⏐───────⏐───────⏐───────⏐───────⏐──────╴
  R' ⏐  0.5  ⏐  0.5  ⏐  0.5  ⏐  0    ⏐  0
 ╶───⏐───────⏐───────⏐───────⏐───────⏐──────╴
  G' ⏐  0    ⏐  0.33 ⏐  0    ⏐  0    ⏐  0
 ╶───⏐───────⏐───────⏐───────⏐───────⏐──────╴
  B' ⏐  0    ⏐  0    ⏐  0.33 ⏐  0    ⏐  0
 ╶───⏐───────⏐───────⏐───────⏐───────⏐──────╴
  A' ⏐  0.2  ⏐  0.1  ⏐  0.1  ⏐  0.5  ⏐ -0.52

| R' |     | r1 r2 r3 r4 r5 |   | R |
| G' |     | g1 g2 g3 g4 g5 |   | G |
| B' |  =  | b1 b2 b3 b4 b5 | * | B |
| A' |     | a1 a2 a3 a4 a5 |   | A |
| 1  |     | 0  0  0  0  1  |   | 1 |
```

values: The value for the matrix type set in the type attribute.


```css
*:has(> img) {
  background-size: 10% 10%;
  background-repeat: round round;
  background-image: repeating-conic-gradient(from 45deg,#111 0 90deg ,#191919 90deg 180deg);
}
img {
  height: 100%;
  width: 100%;
  object-fit: contain;
  filter: brightness(0.4) contrast(0.5);
  filter: contrast(0.5) brightness(0.4);
  filter: saturate(16) contrast(0.6) brightness(0.7);
  filter: var(--filter-feColorMatrix, brightness(0.4));
/*   filter: brightness(0.5) opacity(0.5); */
}

img:hover {
}


:root {
  --filter-feColorMatrix: url('data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22%3E%3Cdefs%3E%3Cfilter \
  id=%22\
filter-feColorMatrix\
%22  %3E%3CfeColorMatrix \
    type=%22\
matrix\
    %22 \
    values=%22\
    0.5  0.5    0.5   0    0 \
    0    0.33  0    0    0 \
    0    0    0.33  0    0 \
    0.2  0.1  0.1  0.5  -0.52 \
    %22/%3E%3C/filter%3E%3C/defs%3E%3C/svg%3E\
    #filter-feColorMatrix\
');;
}

/*

in: Values include 
  - SourceGraphic
  - SourceAlpha
  - BackgroundImage
  - BackgroundAlpha
  - FillPaint
  - StrokePaint
  - or a reference to another filter primitive.

type: Values include
  - matrix
  - saturate
  - hueRotate
  - luminanceToAlpha

values: The value for the matrix type set in the type attribute.

*/
```



## Attribute Reference

### A
- accumulate
- additive
- alignment-baseline
- amplitude
- attributeName
- attributeType
- azimuth

### B
- baseFrequency
- baseline-shift
- baseProfile
- begin
- bias
- by

### C
- calcMode
- class
- clip
- clipPathUnits
- clip-path
- clip-rule
- color
- color-interpolation
- color-interpolation-filters
- crossorigin
- cursor
- cx
- cy

### D
- d
- data-*
- decoding
- diffuseConstant
- direction
- display
- divisor
- dominant-baseline
- dur
- dx
- dy

### E
- edgeMode
- elevation
- end
- exponent

### F
- fetchpriority
- fill
- fill-opacity
- fill-rule
- filter
- filterUnits
- flood-color
- flood-opacity
- font-family
- font-size
- font-size-adjust
- font-stretch
- font-style
- font-variant
- font-weight
- fr
- from
- fx
- fy

### G
- glyph-orientation-horizontal
- glyph-orientation-vertical
- gradientTransform
- gradientUnits

### H
- height
- href
- hreflang

### I
- id
- image-rendering
- in
- in2
- intercept

### K
- k1
- k2
- k3
- k4
- kernelMatrix
- kernelUnitLength
- keyPoints
- keySplines
- keyTimes

### L
- lang
- lengthAdjust
- letter-spacing
- lighting-color
- limitingConeAngle

### M
- marker-end
- marker-mid
- marker-start
- markerHeight
- markerUnits
- markerWidth
- mask
- maskContentUnits
- maskUnits
- max
- media
- method
- min
- mode

### N
- numOctaves

### O
- offset
- opacity
- operator
- order
- orient
- origin
- overflow

### P
- paint-order
- path
- pathLength
- patternContentUnits
- patternTransform
- patternUnits
- ping
- pointer-events
- points
- pointsAtX
- pointsAtY
- pointsAtZ
- preserveAlpha
- preserveAspectRatio
- primitiveUnits

### R
- r
- radius
- referrerPolicy
- refX
- refY
- rel
- repeatCount
- repeatDur
- requiredExtensions
- requiredFeatures
- restart
- result
- rotate
- rx
- ry

### S
- scale
- seed
- shape-rendering
- side
- slope
- spacing
- specularConstant
- specularExponent
- spreadMethod
- startOffset
- stdDeviation
- stitchTiles
- stop-color
- stop-opacity
- stroke
- stroke-dasharray
- stroke-dashoffset
- stroke-linecap
- stroke-linejoin
- stroke-miterlimit
- stroke-opacity
- stroke-width
- style
- surfaceScale
- systemLanguage

### T
- tabindex
- tableValues
- target
- targetX
- targetY
- text-anchor
- text-decoration
- text-rendering
- textLength
- to
- transform
- transform-origin
- type

### U
- unicode-bidi

### V
- values
- vector-effect
- version
- viewBox
- visibility

### W
- width
- word-spacing
- writing-mode

### X
- x
- x1
- x2
- xChannelSelector
- xlink:actuate
- xlink:arcrole
- xlink:href Deprecated
- xlink:role
- xlink:show
- xlink:title
- xlink:type
- xml:lang
- xml:space

### Y
- y
- y1
- y2
- yChannelSelector

### Z
- z
- zoomAndPan


### CSS Properties

alignment-baseline
baseline-shift
clip
clip-path
clip-rule
color
color-interpolation
color-interpolation-filters
cursor
cx
cy
d
direction
display
dominant-baseline
fill
fill-opacity
fill-rule
filter
flood-color
flood-opacity
font-family
font-size
font-size-adjust
font-stretch
font-style
font-variant
font-weight
glyph-orientation-horizontal
glyph-orientation-vertical
height
image-rendering
letter-spacing
lighting-color
marker-end
marker-mid
marker-start
mask
mask-type
opacity
overflow
pointer-events
r
rx
ry
shape-rendering
stop-color
stop-opacity
stroke
stroke-dasharray
stroke-dashoffset
stroke-linecap
stroke-linejoin
stroke-miterlimit
stroke-opacity
stroke-width
text-anchor
text-decoration
text-rendering
transform
transform-origin
unicode-bidi
vector-effect
visibility
width
word-spacing
writing-mode
x
y



<!-- vim: set ts=2 sw=2 conceallevel=2 nowrap: -->

