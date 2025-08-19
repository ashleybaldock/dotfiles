# svg-syntax

---

```pre

"─────────────┼────────────────────────┼──────────────────────────────┼
"             │       Absolute         │       Relative               │
"─────────────┼────────────────────────┼──────────────────────────────┼
"       Move: │ M   ┊ Mx y [(L)x y…]   │ m   ┊ m𝝙x 𝝙y [(l)𝝙x 𝝙y…]     │
"     LineTo: │ L,  ┊ Lx y [(L)x y…]   │ l,  ┊ l𝝙x 𝝙y [(l)𝝙x 𝝙y…]     │
"             │  H, ┊ Hx [(H)x…]       │  h, ┊ h𝝙x [(h)𝝙x…]           │
"             │   V ┊ Vy [(V)y…]       │   v ┊ v𝝙y [(v)𝝙y…]           │
"─────────────┼────────────────────────┼──────────────────────────────┼
"  Quadratic: │ Q   ┊ Qx¹ y¹ x y       │ q   ┊ q𝝙x¹ 𝝙y¹ 𝝙x 𝝙y         │
"             │ →️→️T ┊       qx y       │ →️→️t ┊         t𝝙x 𝝙y         │
"      Cubic: │ C   ┊ Cx¹ y¹ x² y² x y │ c   ┊ c𝝙x¹ 𝝙y¹ 𝝙x² 𝝙y² 𝝙x 𝝙y │
"             │ →️→️S ┊       Sx² y² x y │ →️→️s ┊         s𝝙x² 𝝙y² 𝝙x 𝝙y │
"─────────────┼────────────────────────┼──────────────────────────────┼
" Elliptical: │ A   ┊ Axᴿ yᴿ 𝑎 𝐹̍ 𝐹̎ x y │ a   ┊ axᴿ yᴿ 𝑎 𝐹̍ 𝐹̎ 𝝙x 𝝙y     │
"─────────────┼────────────────────────┼──────────────────────────────┼
"  ClosePath: │ Z   ┊ Z                │ z   ┊ z                      │
"─────────────┼────────────────────────┼──────────────────────────────┼
"  Hh:                  [x]…️
"  Vv:                  [y]…️
"  Mm Ll Qq Tt Cc Ss: [x y]…️
"  Aa:      [x y →️ →️ →️ x y]…️
 
" A rx ry angle large-arc-flag sweep-flag x y


" m6.148 18.473 1.863-1.003 1.615-.839-2.568-4.816h4.332l-11.379-11.408v16.015l3.316-3.221z

"
" Scale: (×x ×y)
"
" 1. split on [mMlLhvVcCsSqQtTaAzZ]
" 2. split those on [ -]
" 3. parse each value as float
" 4. multiply by x or y
"  Hh:                  [x]…️
"  Vv:                  [y]…️
"  Mm Ll Qq Tt Cc Ss: [x y]…️
"  Aa:      [x y →️ →️ →️ x y]…️
" 5. fix precision
" 6. format as string + join back together


" m6.148 18.473 1.863-1.003 1.615-.839-2.568-4.816h4.332l-11.379-11.408v16.015l3.316-3.221z

"       X      Y
" m   6.148  18.473(1.863 -1.003)(1.615 -.839)(-2.568 -4.816)
"  l  1.863  -1.003
"  l  1.615   -.839
"  l -2.568  -4.816
" h   4.332
" l -11.379 -11.408
" v          16.015
" l   3.316  -3.221
" z


"
" Translate: (±x ±y)
"
" Only absolute coordinates need to be changed
"
"  H:                  [x]…️  1
"  V:                  [y]…️  1
"  M L Q T C S:      [x y]…️  2
"  A:      [x y →️ →️ →️ x y]…️  7
"  h v m l q t c s a:  [→️]…️  1

```






<!-- vim: set ts=2 sw=2 conceallevel=2 nowrap: -->

