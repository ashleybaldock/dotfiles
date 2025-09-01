
 ```pre 
  ╻·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️０·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️╻ 0: implicit column group for anything
  ┃     centered text not in a column      ┃    not assigned to a column group
  ╏·️·️１·️·️╷·️·️·️·️·️·️2·️·️·️·️·️·️╷·️３·️╷·️·️·️·️·️·️４·️·️·️·️·️·️╏ [1234]: Defined together, forming a
  ┃      │             │    │              ┃  column group.
  ┃aaaaaa│  2center2   │cccc│dddddddddddddd┃                                           
  ┃aaaaaa│     22222end│cccc│dddddddddddddd┃ A line can only use one group, but groups 
  ┃aaaaaa│start222     │cccc│dddddddddddddd┃  can be broken by lines with other groups 
  ╏·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️０·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️·️╏
  ┃0000000000000000000000000000000000000000┃  (...or no group)
  ╏·️·️１·️·️╎·️2:５·️╷·️2:６·️╎·️３·️╎·️·️·️·️·️·️４·️·️·️·️·️·️╏ [12[56]34]: Sub-groups split the width of 
  ┃aaaaaa│555   │66    │cccc│dddddddddddddd┃  their parent. They can be used in the    
  ┃aaaaaa│   555│ 66   │cccc│dddddddddddddd┃  same line as their parent column's       
  ╏·️·️１·️·️╎·️·️·️·️·️·️2·️·️·️·️·️·️╎·️３·️╎·️·️·️·️·️·️４·️·️·️·️·️·️╏  siblings.
  ┃aaaaaa│2longesttext2│cccc│dddddddddddddd┃
  ╏·️·️１·️·️╎·️2:５·️╎·️2:６·️╎·️３·️╎·️·️·️·️·️·️４·️·️·️·️·️·️╏
  ┃aaaaaa│ 555  │  6   │cccc│dddddddddddddd┃ 
  ┃aaaaaa│  5555│666666│cccc│dddddddddddddd┃
  ╎      ╎      ╎      ╎    ╎              ╎
  :️      :️      :️      :️    :️              :️               
                 <---->
                 Find longest in both 5 and 6 to determine which
                 of the two gets more space
          <---->
          5's width is the remaining portion of 2's width,
          after 6 is subtracted

sub-columns can determine parent column width
or have their width determined by the parent column

 ┃      ╎·️·️５·️·️╷·️·️６·️·️╎    │              ┃
```
