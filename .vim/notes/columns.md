
 ```pre 

０１２３４５６７８９ＡＢＣＤＥＦ
  ┃no columns                              ┃  cols=          : 1 column, left aligned (no columns)
  ┃left aligned text                       ┃  cols=[<]       : 1 column, left aligned
  ┃             centered text              ┃  cols=[]        : 1 column, centered
  ┃                      right aligned text┃  cols=[>]       : 1 column, right aligned
                                                          
  ┃    11111    │    22222   │     3333    ┃  cols=[||]       : 3 columns, centered
  ┃11111        │22222       │         3333┃  cols=[<|<|>]    : 3 columns, with alignments
  ┃    :    │         :2         │    :    ┃  cols=[:|:2|:] : 3 columns, proportional (aka [:1|:2|:1]
((total width (42) - separator width (4) = 38) / (sum of weights (1+2+1) = 4) = 9.5) * column weight
  ┃   =10    │        =20         │   =8   ┃  cols=[=10|=20|=8]   : 3 columns, fixed widths
  ┃content co│content content cont│content ┃
  ┃ntent     │ent content content │content ┃

  ┃   ~   │        =20         │           ┃  cols=[~|=20|]   : 3 columns, fit content, fixed, remainder
  ┃content│content content cont│content    ┃
  ┃       │ent                 │           ┃

  ┃  ~:   │        │        │     <:2      ┃  cols=42[~:|||<:2] : 4 columns, max width 42,
  ┃content│        │        │content       ┃                     fit content, , , proportional
  ┃   ~:    │     │     │       <:2        ┃
  ┃content++│     │     │content++         ┃

  ┃  ~:   │ =5  │      :2      ┃╱╳╲╲╱╱╱╱╱╱╱┃  cols=42[~:|=10|:2] : 3 columns, max width 42,
  ┃content│conte│content       ┃╱╱╲╳╱╱╱╱╱╱╱┃︎                      fit content, fixed, proportional
  ┃  ~:     │ =5  │      :2          ┃╱╱╱╱╱┃
  ┃content++│conte│content++         ┃╱╱╱╱╱┃
  ┃  ~:       │ =5  │      :2              ┃
  ┃content++++│conte│content++++           ┃
  ┃  ~:       │ =5  │      :2              ┃
  ┃content++++│conte│content++++++         ┃
  ┃++         │     │                      ┃

                                              [=10] : fixed, 10
  ┃       │ntent     │t             ┋      ┃  [~6-20] : fit content, min 6, max 20

  [ 1<          |     2      |          3> ]  cols=[1<|2|3>] : 3 columns, with default alignments
  ┃1111111      │   2222222  │      3333333┃  cols=[1|2|3]
  [    １      |      2     |       ３    ]   cols=[1:1|2:1|3:1]  : Column group with 3 columns.

  [   A  |     B       | C  |        D     ]   cols=[ABCD] : Column group with 4 columns.
  ┃      │   5555555   │    │              ┃                (Sub group of [0], aka [0[ABCD]])
  [ ４         ５       ６        ７     ]   cols=[4567] : Use previously defined group
  ┃      │     55555555│    │              ┃                 
  ╏[               ...                    ]   cols=...    : (shorthand) Line continues using
  ┃      │̬55555555     │̬    │̬              ┃                previous line's column group 
   [                 ０                   ]   cols=       : No column ([0])
  ┃0000000000000000000000000000000000000000┃ 
  ╏  １  ▼[  5₂ ▼  6₂ ]▼ ３ ╷̌      ４      ╏  cols=[12[56]34] : Define a sub group.
  ┃      │555   │66    │    │              ┃      The parent group can be defined at the same time,
  ╏  １  ╎   5  ╎  6   ╎ ３ ╎      ４      ╏      or a previously defined group can be extended.
  ┃      │   555╵̬ 66   │    │              ┃      
  ╏  １  ╎      2      ╎ ３ ╎      ４      ╏   [0[12[56]34]] Sub-groups split the width of
  ┃      │2longesttext2│    │              ┃     their parent.
  ╏  １  ╎   5  ╷̌  6   ╎ ３ ╎      ４      ╏     Sub groups override their parent, it's either-or,
  ┃      │ 555  │  6   │    │              ┃     e.g. [12[56]34] (columns 1,5,6,3,4)
  ┃      │  5555│666666│    │              ┃           OR [1234] (columns 1, 2, 3,4)
  ╎      ╎      ╎      ╎    ╎              ╎
  :️      :️      :️      :️    :️              :️
                                            
                 <---->
                 Find longest in both 2:1 and 2:2 to determine which
                 of the two gets more space
          <---->
          5's width is the remaining portion of 2's width,
          after 6 is subtracted

sub-columns can determine parent column width
or have their width determined by the parent column

A line can only use one group, but groups   
 can be broken by lines with other groups   
  (...or no group)                          

 ┃      ╎  ５  ╷  ６  ╎    │              ┃
```
