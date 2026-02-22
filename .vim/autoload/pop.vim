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


"   \  bd:' ╶╮'..
"   \     '⎨ ⎬'..
"   \     '╰╴ ',

"  mk:'x x'..
"    \'   '..
"    \'xxx'

"   bd:'mmm'..   
"     \'│ │'..   
"     \'mmm',    

"􀰬  􂀙 
" ╭╴ popinfo ╶─╮
" ⎬            ⎨───────╮          
" │ 􀫌 evt􂇏 x,y       │
" │    win􀆃22 􂇏 x,y           │
" │  􂠹 33   􂠷 22         │
" ╰────────────────────╯
func MyFilter(popwid, key)
  if a:key == "\<LeftMouse>"
    let mpos = getmousepos()
    let ev_x = get(mpos, 'screencol')
    let ev_y = get(mpos, 'screenrow')
    let ev_wid = get(mpos, 'winid')
    let ev_wix = get(mpos, 'wincol')
    let ev_wiy = get(mpos, 'winrow')
    let line = get(mpos, 'line')
    let column = get(mpos, 'column')
    let coladd = get(mpos, 'coladd')

    " Click was on a window (if not, probably command line)
    let overwin = evtwid > 0
    " Click was on this popup
    let over = evtwid == a:popwid
    " Highest popup at click location
    let locwid = popup_locate(srow, scol)
    let locmismatch = locwid > 0 && locwid != evtwid
    " Click was on a line between windows
    let oversep = line == 0 || column == 0

    " Popup options
    let popts = popup_getoptions(a:popwid)
    let border = get(popts, 'border', [0,0,0,0])
    let padding = get(popts, 'padding', [0,0,0,0])

    " Popup sizes
    let popos = popup_getpos(a:popwid)
    let pop_x = get(popos, 'col')
    let pop_y = get(popos, 'line')
    let pop_w = get(popos, 'width')
    let pop_h = get(popos, 'height')
    let core_x = get(popos, 'core_col')
    let core_y = get(popos, 'core_line')
    let core_w = get(popos, 'core_width')
    let core_h = get(popos, 'core_height')
    let firstline = get(popos, 'firstline')
    let lastline = get(popos, 'lastline')
    let scrollbar = get(popos, 'scrollbar')
    let visible = get(popos, 'visible')

    return 1
  endif
  if a:key == 'x'
    call popup_close(a:winid)
    return 1
  endif
  return 0
endfunc

function propup()
	call prop_type_add('propup', {})

endfunc
