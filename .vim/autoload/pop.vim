echo popup_create('popped', #{line:'cursor', col:'cursor', pos:'topleft', posinvert:0, fixed:0, flip:1, maxheight:5,minheight:1,maxwidth:10,minwidth:4,title:'up',wrap:1,highlight:'Comment',borderhighlight:['Conceal'],padding:[1,1,1,1],border:[1,1,1,1],borderchars:['-','𐔃','╶','𐔠','𐔏','𐔕','╯','𐔦'],drag:1,resize:1,mask:[[2,-2,2,-2]]})

 h:'1,10',w:'4,10'
 h:',10',w:'4,'

let s:borders = #{
  \ thinsharp: #{
  \  bd:'┌─┐'..
  \     '│ │'..
  \     '└─┘',
  \ },
  \ thinround: #{
  \  bd:'╭─╮'..
  \     '│ │'..
  \     '╰─╯',
  \ },
  \ brace: #{
  \  bd:'╭ ╮'..
  \     '│ │'..
  \     '╰ ╯', 
  \ },
  \ bracelong: #{
  \  bd:'⎧ ⎫'..
  \     '│ │'..
  \     '⎩ ⎭',
  \ },
  \}


  \  bd:' ╶╮'..
  \     '⎨ ⎬'..
  \     '╰╴ ',

 mk:'x x'..
   \'   '..
   \'xxx'

  bd:'mmm'..   
    \'│ │'..   
    \'mmm',    


func MyFilter(winid, key)
  if a:key == "\<F2>"
    " do something
    return 1
  endif
  if a:key == 'x'
    call popup_close(a:winid)
    return 1
  endif
  return 0
endfunc
function propup()

endfunc
