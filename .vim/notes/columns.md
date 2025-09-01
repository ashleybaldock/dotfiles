
 ```pre 
  ╻[·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️０·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️]╻  cols  unset : Implicit column group [0]
  ┃     centered text not in a column      ┃                (Lines not given a column group)
  ▼[·️１·️·️▼·️·️·️·️·️·️2·️·️·️·️·️·️▼·️３·️▼·️·️·️·️·️·️４·️·️·️·️·️]▼  cols=[1234] : A column group (sub group of [0])
  ┃      │  2center2   │    │              ┃                Defined on first use.
  ╏·️·️１·️·️╎·️·️·️·️·️·️2·️·️·️·️·️·️╎·️３·️╎·️·️·️·️·️·️４·️·️·️·️·️·️╏  cols=[1234] : Line uses previously defined group
  ┃      │     22222end│    │              ┃                 
  ╏·️·️１·️·️╎·️·️·️·️·️·️2·️·️·️·️·️·️╎·️３·️╎·️·️·️·️·️·️４·️·️·️·️·️·️╏  cols=...    : (shorthand) Line continues using
  ┃      │̬start222     │̬    │̬              ┃                previous line's column group 
  ╏·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️０·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️╏  cols unset  : Back to no column (group [0])
  ┃0000000000000000000000000000000000000000┃ 
  ╏·️·️１·️·️▼[·️·️5₂·️▼·️·️6₂·️]▼·️３·️╷̌·️·️·️·️·️·️４·️·️·️·️·️·️╏  cols=[12[56]34] : Define a sub group.
  ┃      │555   │66    │    │              ┃      The parent group can be defined at the same time,
  ╏·️·️１·️·️╎·️·️·️5·️·️╎·️·️6·️·️·️╎·️３·️╎·️·️·️·️·️·️４·️·️·️·️·️·️╏      or a previously defined group can be extended.
  ┃      │   555╵̬ 66   │    │              ┃      
  ╏·️·️１·️·️╎·️·️·️·️·️·️2·️·️·️·️·️·️╎·️３·️╎·️·️·️·️·️·️４·️·️·️·️·️·️╏   [0[12[56]34]] Sub-groups split the width of
  ┃      │2longesttext2│    │              ┃     their parent.
  ╏·️·️１·️·️╎·️·️·️5·️·️╷̌·️·️6·️·️·️╎·️３·️╎·️·️·️·️·️·️４·️·️·️·️·️·️╏     Sub groups override their parent, it's either-or,
  ┃      │ 555  │  6   │    │              ┃     e.g. [12[56]34] (columns 1,5,6,3,4)
  ┃      │  5555│666666│    │              ┃           OR [1234] (columns 1,2,3,4)
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

 ┃      ╎·️·️５·️·️╷·️·️６·️·️╎    │              ┃
```
