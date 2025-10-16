# svg-syntax

---

```pre
 ╭─────────────┬────────────────────────┬──────────────────────────────╮
 │             │       Absolute         │       Relative               │
 ├─────────────┼────────────────────────┼──────────────────────────────┤
 │       Move: │ M   ┊️ Mx y [(L)x y…]   │ m   ┊ m𝝙x 𝝙y [(l)𝝙x 𝝙y…]     │
 │     LineTo: │ L,  ┊️ Lx y [(L)x y…]   │ l,  ┊ l𝝙x 𝝙y [(l)𝝙x 𝝙y…]     │
 │             │  H, ┊️ Hx [(H)x…]       │  h, ┊ h𝝙x [(h)𝝙x…]           │
 │             │   V ┊️ Vy [(V)y…]       │   v ┊ v𝝙y [(v)𝝙y…]           │
 ├─────────────┼────────────────────────┼──────────────────────────────┤
 │  Quadratic: │ Q   ┊ Qx¹ y¹ x y       │ q   ┊ q𝝙x¹ 𝝙y¹ 𝝙x 𝝙y         │
 │             │ →️ T ┊       Tx y       │ →️ t ┊         t𝝙x 𝝙y         │
 │      Cubic: │ C   ┊ Cx¹ y¹ x² y² x y │ c   ┊ c𝝙x¹ 𝝙y¹ 𝝙x² 𝝙y² 𝝙x 𝝙y │
 │             │ →️ S ┊       Sx² y² x y │ →️ s ┊         s𝝙x² 𝝙y² 𝝙x 𝝙y │
 ├─────────────┼────────────────────────┼──────────────────────────────┤
 │ Elliptical: │ A   ┊ Axᴿ yᴿ 𝑎 𝐹̍ 𝐹̎ x y │ a   ┊ axᴿ yᴿ 𝑎 𝐹̍ 𝐹̎ 𝝙x 𝝙y     │
 ├─────────────┼────────────────────────┼──────────────────────────────┤
 │  ClosePath: │ Z   ┊ Z                │ z   ┊ z                      │
 ╰─────────────┴────────────────────────┴──────────────────────────────╯
  Hh:                  [x]…️
  Vv:                  [y]…️
  Mm Ll Qq Tt Cc Ss: [x y]…️
  Aa:      [x y →️ →️ →️ x y]…️
 
  A rx ry angle large-arc-flag sweep-flag x y

│ ┃ ╎ ╏ ┆ ┇ ┊ ┋
│️ ┃️ ╎️ ╏️ ┆️ ┇️ ┊️ ┋️  ┌┬┐┌️┬️️┐️┌┬┐┌️┬︎┐️┌┬┐┌⃞┬⃞┐⃞┌️⃞┬️⃞┐️⃞┌⃞┬⃞︎┐⃞︎ 
│ ┃ ╎ ╏ ┆ ┇ ┊ ┋  ├┼┤├┼┤├️┼️┤️├️┼︎︎┤️├┼┤├⃞  ┼⃞ ┤⃞     ◎️⃝ ├️⃝   ┼️⃝  ３➞️⃝   ➞⃝    A┤️⃝ ├️┼️┤️
│️ ┃️ ╎️ ╏️ ┆️ ┇️ ┊️ ┋️  └┴┘└️┴️┘️└┴┘└️┴︎┘️└️┴️┘️└️┴️┘️└️┴️┘️└️┴️┘️
│ ┃ ╎ ╏ ┆ ┇ ┊ ┋
│️ ┃️ ╎️ ╏️ ┆️ ┇️ ┊️ ┋️
│ ┃️ ╎️ ╏️ ┆️ ┇️ ┊️ ┋️
│️ ┃️ ╎️ ╏️ ┆️ ┇️ ┊️ ┋️

01234abcdefABCDEF

```

m6.148 18.473 1.863-1.003 1.615-.839-2.568-4.816h4.332l-11.379-11.408v16.015l3.316-3.221z


## Split <path>

### ...at z/Absolute

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

### ...at z/Relative

### ...at 2 arbitrary points

```pre
Cx¹ y¹ x² y² x y ╱ *        ┊ …️ \nMx y …️

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
### ...by intersection with a line

### ...into individual line segments

## Merge <path>s
- Apply 

### Scale: (×x ×y)

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

### Translate: (±x ±y)

```pre
Only absolute coordinates need to be changed

 H:                  [x]…️  1
 V:                  [y]…️  1
 M L Q T C S:      [x y]…️  2
 A:      [x y →️ →️ →️ x y]…️  7
 h v m l q t c s a:  [→️]…️  1

```

## Rotate: (90deg increments)


## Rotate: (Arbitrary)



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

