## Export symbols from SF Symbols app

## Group similar together

name[.inverse]

name[.(square|.circle)][.on.<X>]

````pre
  [.fill]
  [.badge[.(ellipsis|plus|minus|checkmark|questionmark|exclamationmark|xmark|person.crop|gearshape|wifi)]]
  [.fill]
  [.and.<Y>]

 ⧓⃞ ₁︎⃞ ₁⃞ ₁⃞︎  ⁴ ⁴⃞ ⁴️⃞   ⁴︎⃞  ⁴⃞ ⁴⃞️ ⁴⃞︎   ⁴  ⁴⃞ ²⃞   ³⃞ ⁵⃞ ⧔⃞

  ⧕⃞ (1̲________________)   (2̲_______________________) (3̲____)   (4̲________________)  ②  (5̲___________________________________________________________________)
```pre

```reg
%s/\(\%([^a-z0-9]\)\s\)\+\(\%(\<[a-z0-9]\+\>\.\)\+\)\(\.\+\)\n\(\%([^a-z0-9]\)\s\)\+\2\(\.\<circle\>\|\.\<square\>\|\.\<fill\>\|\.\<dotted\>\|\.\<inverse\>\)\+/\1\4\2 (\3\5)/
%s/
````

````pre
⧕⃞ _______1̲________
\(\%([^a-z0-9]\)\s\)\+
  ____________2̲____________
\(\%(\.\?\<[a-z0-9]\+\>\)\+\)
  _3̲_  ⏎️
\(\.*\)\n
  _______4̲________    ()
\(\%([^a-z0-9]\)\s\)\+
②
\2
  ________________________________5̲__________________________________
\(\.\<circle\>\|\.\<square\>\|\.\<fill\>\|\.\<dotted\>\|\.\<inverse\>\)\+

/\1\4\2 (\3\5)/

```pre
 􀓅 􀄧 􀁬 􀁭 􀃼 􀃽  arrowtriangle.right .fill .circle .circle.fill .square .square.fill
````

```reg
   \(\%([^a-z0-9]\)\s\)\+\(\%(\.\?\<[a-z0-9]\+\>\)\+\)\(\.*\)\n\(\%([^a-z0-9]\)\s\)\+\2\(\.\<circle\>\|\.\<square\>\|\.\<fill\>\|\.\<dotted\>\|\.\<inverse\>\)\+/\1\4\2 (\3\5)/
```

```reg
%s/\(\%([^a-z0-9]\s\)\+\)\(\%(\.\?\<[a-z0-9]\+\>\)\+\)\(.*\)\n\(\%([^a-z0-9]\s\)\+\)\2\(\.\<circle\>\|\.\<square\>\|\.\<fill\>\|\.\<dotted\>\|\.\<inverse\>\)\+\(\s\?.*\)$/\1\4\2\3 (\5\6)/
```

skip uncastable spells.

```reg
'<,'>s/sign\n/\\|/

/\(bitcoin\|brazilianreal\|cedi\|cent\|chineseyuanrenminbi\|coloncurrency\|cruzeiro\|danishkrone\|dong\|dollar\|euro\|eurozone\|florin\|franc\|guarani\|hryvnia\|indianrupee\|kip\|lari\|lira\|malaysianringgit\|manat\|mill\|naira\|norwegiankrone\|peruviansoles\|peseta\|peso\|polishzloty\|ruble\|rupee\|shekel\|singaporedollar\|sterling\|swedishkrona\|tenge\|tugrik\|turkishlira\|won\|yen\)sign/
```
