  finish
if exists("g:mayhem_loaded_menu")
endif
let g:mayhem_loaded_menu = 1

"
" See: $VIMRUNTIME/menu.vim
"




" Make sure the '<' and 'C' flags are not included in 'cpoptions', otherwise
" <CR> would not be recognized.  See ":help 'cpoptions'".
let s:cpo_save = &cpo
set cpo&vim

" Avoid installing the menus twice
if !exists("did_install_default_menus")
let did_install_default_menus = 1


" MacVim Window menu (should be next to Help so give it a high priority)
if has("gui_macvim")
  an <silent> 9998.300 Window.Minimize		    <Nop>
  an <silent> 9998.301 Window.Minimize\ All	    <Nop>
  an <silent> 9998.310 Window.Zoom		    <Nop>
  an <silent> 9998.311 Window.Zoom\ All		    <Nop>
  an 9998.318 Window.-SEP1-			    <Nop>
  an <silent> 9998.320 Window.Toggle\ Full\ Screen\ Mode :set invfullscreen<CR>
  tln <silent> 9998.320 Window.Toggle\ Full\ Screen\ Mode <C-W>:set invfullscreen<CR>
  an 9998.330 Window.-SEP2-			    <Nop>
  " TODO! Grey out if no tabs are visible.
  an <silent> 9998.340 Window.Show\ Next\ Tab	    :tabnext<CR>
  tln <silent> 9998.340 Window.Show\ Next\ Tab	<C-W>:tabnext<CR>
  an <silent> 9998.350 Window.Show\ Previous\ Tab :tabprevious<CR>
  tln <silent> 9998.350 Window.Show\ Previous\ Tab <C-W>:tabprevious<CR>
  an 9998.360 Window.-SEP3-			    <Nop>
  an <silent> 9998.370 Window.Bring\ All\ To\ Front <Nop>
  an <silent> 9998.380 Window.Stay\ in\ Front <Nop>
  an <silent> 9998.390 Window.Stay\ in\ Back <Nop>
  an <silent> 9998.400 Window.Stay\ Level\ Normal <Nop>
endif

an 9999.50 &Help.&Credits		:help credits<CR>
an 9999.60 &Help.Co&pying		:help copying<CR>
an 9999.70 &Help.&Sponsor/Register	:help sponsor<CR>
an 9999.70 &Help.O&rphans		:help kcc<CR>
an 9999.75 &Help.-sep2-			<Nop>
an 9999.80 &Help.&Version		:version<CR>
an 9999.90 &Help.&About			:intro<CR>

if exists(':tlmenu')
  tlnoremenu 9999.50 &Help.&Credits			<C-W>:help credits<CR>
  tlnoremenu 9999.60 &Help.Co&pying			<C-W>:help copying<CR>
  tlnoremenu 9999.70 &Help.&Sponsor/Register		<C-W>:help sponsor<CR>
  tlnoremenu 9999.70 &Help.O&rphans			<C-W>:help kcc<CR>
  tlnoremenu 9999.75 &Help.-sep2-			<Nop>
  tlnoremenu 9999.80 &Help.&Version			<C-W>:version<CR>
  tlnoremenu 9999.90 &Help.&About			<C-W>:intro<CR>
endif

" File menu
if has("gui_macvim")
  an <silent> 10.290 &File.New\ Window                          <Nop>
  an <silent> 10.291 &File.New\ Clean\ Window		        <Nop>
  an <silent> 10.292 &File.New\ Clean\ Window\ (No\ Defaults)   <Nop>
  an  10.295 &File.New\ Tab			    :tabnew<CR>
  tln 10.295 &File.New\ Tab			    <C-W>:tabnew<CR>
  an <silent> 10.310 &File.Open…		    <Nop>
  an <silent> 10.325 &File.Open\ Recent		    <Nop>
  an 10.328 &File.-SEP0-			    <Nop>
  an <silent> 10.330 &File.Close\ Window<Tab>:qa    :conf qa<CR>
  tln <silent> 10.330 &File.Close\ Window<Tab>:qa   <C-W>:conf qa<CR>
  an <silent> 10.332 &File.Close<Tab>:q		    :conf q<CR>
  tln <silent> 10.332 &File.Close<Tab>:q		    <C-W>:conf q<CR>
  an <silent> 10.341 &File.Save\ All		    :browse conf wa<CR>
  an 10.350 &File.Save\ As…<Tab>:sav	    :browse confirm saveas<CR>
else
endif
if !has("gui_macvim")
  an 10.310 &File.&Open\.\.\.<Tab>:e		:browse confirm e<CR>
endif
an 10.320 &File.Sp&lit-Open\.\.\.<Tab>:sp	:browse sp<CR>
an 10.320 &File.Open\ &Tab\.\.\.<Tab>:tabnew	:browse tabnew<CR>
if !has("gui_macvim")
  an 10.325 &File.&New<Tab>:enew		:confirm enew<CR>
  an <silent> 10.330 &File.&Close<Tab>:close
	\ :if winheight(2) < 0 && tabpagewinnr(2) == 0 <Bar>
	\   confirm enew <Bar>
	\ else <Bar>
	\   confirm close <Bar>
	\ endif<CR>
  tln <silent> 10.330 &File.&Close<Tab>:close
      \ <C-W>:if winheight(2) < 0 && tabpagewinnr(2) == 0 <Bar>
      \   confirm enew <Bar>
      \ else <Bar>
      \   confirm close <Bar>
      \ endif<CR>
endif
an 10.335 &File.-SEP1-				<Nop>
an <silent> 10.340 &File.&Save<Tab>:w		:if expand("%") == ""<Bar>browse confirm w<Bar>else<Bar>confirm w<Bar>endif<CR>
if !has("gui_macvim")
  an 10.350 &File.Save\ &As\.\.\.<Tab>:sav	:browse confirm saveas<CR>
endif

if has("diff")
  an 10.400 &File.-SEP2-			<Nop>
  an 10.410 &File.Split\ &Diff\ With\.\.\.	:browse vert diffsplit<CR>
  an 10.420 &File.Split\ Patched\ &By\.\.\.	:browse vert diffpatch<CR>
endif

if !has("gui_macvim")
  an 10.600 &File.-SEP4-				<Nop>
  an 10.610 &File.Sa&ve-Exit<Tab>:wqa		:confirm wqa<CR>
  an 10.620 &File.E&xit<Tab>:qa			:confirm qa<CR>
endif

def s:SelectAll()
  exe "norm! gg" .. (&slm == "" ? "VG" : "gH\<C-O>G")
enddef

" Edit menu
an 20.310 &Edit.&Undo<Tab>u			u
an 20.320 &Edit.&Redo<Tab>^R			<C-R>
an 20.330 &Edit.Rep&eat<Tab>\.			.

an 20.335 &Edit.-SEP1-				<Nop>
vnoremenu 20.340 &Edit.Cu&t<Tab>"+x		"+x
vnoremenu 20.350 &Edit.&Copy<Tab>"+y		"+y
cnoremenu 20.350 &Edit.&Copy<Tab>"+y		<C-Y>
if exists(':tlmenu')
  tlnoremenu 20.350 &Edit.&Copy<Tab>"+y 	<C-W>:<C-Y><CR>
endif
nnoremenu 20.360 &Edit.&Paste<Tab>"+gP		"+gP
cnoremenu	 &Edit.&Paste<Tab>"+gP		<C-R>+
if exists(':tlmenu')
  tlnoremenu	 &Edit.&Paste<Tab>"+gP		<C-W>"+
endif
exe 'vnoremenu <script> &Edit.&Paste<Tab>"+gP	' .. paste#paste_cmd['v']
exe 'inoremenu <script> &Edit.&Paste<Tab>"+gP	' .. paste#paste_cmd['i']
nnoremenu 20.370 &Edit.Put\ &Before<Tab>[p	[p
inoremenu	 &Edit.Put\ &Before<Tab>[p	<C-O>[p
nnoremenu 20.380 &Edit.Put\ &After<Tab>]p	]p
inoremenu	 &Edit.Put\ &After<Tab>]p	<C-O>]p
if has("win32")
  vnoremenu 20.390 &Edit.&Delete<Tab>x		x
endif
noremenu  <script> <silent> 20.400 &Edit.&Select\ All<Tab>ggVG	:<C-U>call <SID>SelectAll()<CR>
inoremenu <script> <silent> 20.400 &Edit.&Select\ All<Tab>ggVG	<C-O>:call <SID>SelectAll()<CR>
cnoremenu <script> <silent> 20.400 &Edit.&Select\ All<Tab>ggVG	<C-U>call <SID>SelectAll()<CR>

an 20.405	 &Edit.-SEP2-				<Nop>
if has("win32") || has("gui_gtk") || has("gui_kde") || has("gui_motif")
  an 20.410	 &Edit.&Find\.\.\.			:promptfind<CR>
  vunmenu	 &Edit.&Find\.\.\.
  vnoremenu <silent>	 &Edit.&Find\.\.\.		y:promptfind <C-R>=<SID>FixFText()<CR><CR>
  an 20.420	 &Edit.Find\ and\ Rep&lace\.\.\.	:promptrepl<CR>
  vunmenu	 &Edit.Find\ and\ Rep&lace\.\.\.
  vnoremenu <silent>	 &Edit.Find\ and\ Rep&lace\.\.\. y:promptrepl <C-R>=<SID>FixFText()<CR><CR>
elseif has("gui_macvim")
  an <silent> 20.410.10 &Edit.Find.Find…	:promptfind<CR>
  vunmenu &Edit.Find.Find…
  vnoremenu <silent> &Edit.Find.Find…	y:promptfind <C-R>=<SID>FixFText()<CR><CR>
  an 20.410.20 &Edit.Find.Find\ Next			<Nop>
  an 20.410.30 &Edit.Find.Find\ Previous		<Nop>
  vnoremenu 20.410.35 &Edit.Find.Use\ Selection\ for\ Find	<Nop>
else
  an 20.410	 &Edit.&Find<Tab>/			/
  an 20.420	 &Edit.Find\ and\ Rep&lace<Tab>:%s	:%s/
  vunmenu	 &Edit.Find\ and\ Rep&lace<Tab>:%s
  vnoremenu	 &Edit.Find\ and\ Rep&lace<Tab>:s	:s/
endif

an 20.425	 &Edit.-SEP3-				<Nop>
an 20.430	 &Edit.Settings\ &Window		:options<CR>
an 20.435	 &Edit.Startup\ &Settings		:call <SID>EditVimrc()<CR>

def s:EditVimrc()
  var fname: string
  if $MYVIMRC != ''
    fname = $MYVIMRC
  elseif has("win32")
    if $HOME != ''
      fname = $HOME .. "/_vimrc"
    else
      fname = $VIM .. "/_vimrc"
    endif
  elseif has("amiga")
    fname = "s:.vimrc"
  else
    fname = $HOME .. "/.vimrc"
  endif
  fname = fnameescape(fname)
  if &mod
    exe "split " .. fname
  else
    exe "edit " .. fname
  endif
enddef

def s:FixFText(): string
  # Fix text in nameless register to be used with :promptfind.
  return substitute(@", "[\r\n]", '\\n', 'g')
enddef

" Edit/Global Settings
an 20.440.100 &Edit.&Global\ Settings.Toggle\ Pattern\ &Highlight<Tab>:set\ hls!	:set hls! hls?<CR>
an 20.440.110 &Edit.&Global\ Settings.Toggle\ &Ignoring\ Case<Tab>:set\ ic!	:set ic! ic?<CR>
an 20.440.110 &Edit.&Global\ Settings.Toggle\ &Showing\ Matched\ Pairs<Tab>:set\ sm!	:set sm! sm?<CR>

an 20.440.120 &Edit.&Global\ Settings.&Context\ Lines.\ 1\  :set so=1<CR>
an 20.440.120 &Edit.&Global\ Settings.&Context\ Lines.\ 2\  :set so=2<CR>
an 20.440.120 &Edit.&Global\ Settings.&Context\ Lines.\ 3\  :set so=3<CR>
an 20.440.120 &Edit.&Global\ Settings.&Context\ Lines.\ 4\  :set so=4<CR>
an 20.440.120 &Edit.&Global\ Settings.&Context\ Lines.\ 5\  :set so=5<CR>
an 20.440.120 &Edit.&Global\ Settings.&Context\ Lines.\ 7\  :set so=7<CR>
an 20.440.120 &Edit.&Global\ Settings.&Context\ Lines.\ 10\  :set so=10<CR>
an 20.440.120 &Edit.&Global\ Settings.&Context\ Lines.\ 100\  :set so=100<CR>

an 20.440.130.40 &Edit.&Global\ Settings.&Virtual\ Edit.Never :set ve=<CR>
an 20.440.130.50 &Edit.&Global\ Settings.&Virtual\ Edit.Block\ Selection :set ve=block<CR>
an 20.440.130.60 &Edit.&Global\ Settings.&Virtual\ Edit.Insert\ Mode :set ve=insert<CR>
an 20.440.130.70 &Edit.&Global\ Settings.&Virtual\ Edit.Block\ and\ Insert :set ve=block,insert<CR>
an 20.440.130.80 &Edit.&Global\ Settings.&Virtual\ Edit.Always :set ve=all<CR>
an 20.440.140 &Edit.&Global\ Settings.Toggle\ Insert\ &Mode<Tab>:set\ im!	:set im!<CR>
an 20.440.145 &Edit.&Global\ Settings.Toggle\ Vi\ C&ompatibility<Tab>:set\ cp!	:set cp!<CR>
an <silent> 20.440.150 &Edit.&Global\ Settings.Search\ &Path\.\.\.  :call <SID>SearchP()<CR>
an <silent> 20.440.160 &Edit.&Global\ Settings.Ta&g\ Files\.\.\.  :call <SID>TagFiles()<CR>
"
" GUI options
an 20.440.300 &Edit.&Global\ Settings.-SEP1-				<Nop>
an <silent> 20.440.310 &Edit.&Global\ Settings.Toggle\ &Toolbar		:call <SID>ToggleGuiOption("T")<CR>
an <silent> 20.440.320 &Edit.&Global\ Settings.Toggle\ &Bottom\ Scrollbar :call <SID>ToggleGuiOption("b")<CR>
an <silent> 20.440.330 &Edit.&Global\ Settings.Toggle\ &Left\ Scrollbar	:call <SID>ToggleGuiOption("l")<CR>
an <silent> 20.440.340 &Edit.&Global\ Settings.Toggle\ &Right\ Scrollbar :call <SID>ToggleGuiOption("r")<CR>

def s:SearchP()
  if !exists("g:menutrans_path_dialog")
    g:menutrans_path_dialog = "Enter search path for files.\nSeparate directory names with a comma."
  endif
  var n = inputdialog(g:menutrans_path_dialog, substitute(&path, '\\ ', ' ', 'g'))
  if n != ""
    &path = substitute(n, ' ', '\\ ', 'g')
  endif
enddef

def s:TagFiles()
  if !exists("g:menutrans_tags_dialog")
    g:menutrans_tags_dialog = "Enter names of tag files.\nSeparate the names with a comma."
  endif
  var n = inputdialog(g:menutrans_tags_dialog, substitute(&tags, '\\ ', ' ', 'g'))
  if n != ""
    &tags = substitute(n, ' ', '\\ ', 'g')
  endif
enddef

def s:ToggleGuiOption(option: string)
  # If a:option is already set in guioptions, then we want to remove it
  if match(&guioptions, "\\C" .. option) > -1
    exec "set go-=" .. option
  else
    exec "set go+=" .. option
  endif
enddef

" Edit/File Settings

" Boolean options
an 20.440.100 &Edit.F&ile\ Settings.Toggle\ Line\ &Numbering<Tab>:set\ nu!	:set nu! nu?<CR>
an 20.440.105 &Edit.F&ile\ Settings.Toggle\ Relati&ve\ Line\ Numbering<Tab>:set\ rnu!	:set rnu! rnu?<CR>
an 20.440.110 &Edit.F&ile\ Settings.Toggle\ &List\ Mode<Tab>:set\ list!	:set list! list?<CR>
an 20.440.120 &Edit.F&ile\ Settings.Toggle\ Line\ &Wrapping<Tab>:set\ wrap!	:set wrap! wrap?<CR>
an 20.440.130 &Edit.F&ile\ Settings.Toggle\ W&rapping\ at\ Word<Tab>:set\ lbr!	:set lbr! lbr?<CR>
an 20.440.160 &Edit.F&ile\ Settings.Toggle\ Tab\ &Expanding<Tab>:set\ et!	:set et! et?<CR>
an 20.440.170 &Edit.F&ile\ Settings.Toggle\ &Auto\ Indenting<Tab>:set\ ai!	:set ai! ai?<CR>
an 20.440.180 &Edit.F&ile\ Settings.Toggle\ &C-Style\ Indenting<Tab>:set\ cin!	:set cin! cin?<CR>

" other options
an 20.440.600 &Edit.F&ile\ Settings.-SEP2-		<Nop>
an 20.440.610.20 &Edit.F&ile\ Settings.&Shiftwidth.2	:set sw=2 sw?<CR>
an 20.440.610.30 &Edit.F&ile\ Settings.&Shiftwidth.3	:set sw=3 sw?<CR>
an 20.440.610.40 &Edit.F&ile\ Settings.&Shiftwidth.4	:set sw=4 sw?<CR>
an 20.440.610.50 &Edit.F&ile\ Settings.&Shiftwidth.5	:set sw=5 sw?<CR>
an 20.440.610.60 &Edit.F&ile\ Settings.&Shiftwidth.6	:set sw=6 sw?<CR>
an 20.440.610.80 &Edit.F&ile\ Settings.&Shiftwidth.8	:set sw=8 sw?<CR>

an 20.440.620.20 &Edit.F&ile\ Settings.Soft\ &Tabstop.2	:set sts=2 sts?<CR>
an 20.440.620.30 &Edit.F&ile\ Settings.Soft\ &Tabstop.3	:set sts=3 sts?<CR>
an 20.440.620.40 &Edit.F&ile\ Settings.Soft\ &Tabstop.4	:set sts=4 sts?<CR>
an 20.440.620.50 &Edit.F&ile\ Settings.Soft\ &Tabstop.5	:set sts=5 sts?<CR>
an 20.440.620.60 &Edit.F&ile\ Settings.Soft\ &Tabstop.6	:set sts=6 sts?<CR>
an 20.440.620.80 &Edit.F&ile\ Settings.Soft\ &Tabstop.8	:set sts=8 sts?<CR>

an <silent> 20.440.630 &Edit.F&ile\ Settings.Te&xt\ Width\.\.\.  :call <SID>TextWidth()<CR>
an <silent> 20.440.640 &Edit.F&ile\ Settings.&File\ Format\.\.\.  :call <SID>FileFormat()<CR>

def s:TextWidth()
  if !exists("g:menutrans_textwidth_dialog")
    g:menutrans_textwidth_dialog = "Enter new text width (0 to disable formatting): "
  endif
  var n = inputdialog(g:menutrans_textwidth_dialog, &tw .. '')
  if n != ""
    # Remove leading zeros to avoid it being used as an octal number.
    # But keep a zero by itself.
    var tw = substitute(n, "^0*", "", "")
    &tw = tw == '' ? 0 : str2nr(tw)
  endif
enddef

def s:FileFormat()
  if !exists("g:menutrans_fileformat_dialog")
    g:menutrans_fileformat_dialog = "Select format for writing the file"
  endif
  if !exists("g:menutrans_fileformat_choices")
    g:menutrans_fileformat_choices = "&Unix\n&Dos\n&Mac\n&Cancel"
  endif
  var def_choice: number
  if &ff == "dos"
    def_choice = 2
  elseif &ff == "mac"
    def_choice = 3
  else
    def_choice = 1
  endif
  var n = confirm(g:menutrans_fileformat_dialog, g:menutrans_fileformat_choices, def_choice, "Question")
  if n == 1
    set ff=unix
  elseif n == 2
    set ff=dos
  elseif n == 3
    set ff=mac
  endif
enddef

let s:did_setup_color_schemes = 0

" Setup the Edit.Color Scheme submenu
def s:SetupColorSchemes()
  if s:did_setup_color_schemes
    return
  endif
  s:did_setup_color_schemes = 1

  var n = globpath(&runtimepath, "colors/*.vim", 1, 1)
  n += globpath(&packpath, "pack/*/start/*/colors/*.vim", 1, 1)
  n += globpath(&packpath, "pack/*/opt/*/colors/*.vim", 1, 1)

  # Ignore case for VMS and windows, sort on name
  var names = sort(map(n, 'substitute(v:val, "\\c.*[/\\\\:\\]]\\([^/\\\\:]*\\)\\.vim", "\\1", "")'), 'i')

  # define all the submenu entries
  var idx = 100
  for name in names
    exe "an 20.450." .. idx .. ' &Edit.C&olor\ Scheme.' .. name .. " :colors " .. name .. "<CR>"
    idx += 10
  endfor
  silent! aunmenu &Edit.Show\ C&olor\ Schemes\ in\ Menu
enddef

if exists("do_no_lazyload_menus")
  call s:SetupColorSchemes()
else
  an <silent> 20.450 &Edit.Show\ C&olor\ Schemes\ in\ Menu :call <SID>SetupColorSchemes()<CR>
endif


" Setup the Edit.Keymap submenu
if has("keymap")
  let s:did_setup_keymaps = 0

  def s:SetupKeymaps()
    if s:did_setup_keymaps
      return
    endif
    s:did_setup_keymaps = 1

    var names = globpath(&runtimepath, "keymap/*.vim", 1, 1)
    if !empty(names)
      var idx = 100
      an 20.460.90 &Edit.&Keymap.None :set keymap=<CR>
      for name in names
	# Ignore case for VMS and windows
	var mapname = substitute(name, '\c.*[/\\:\]]\([^/\\:_]*\)\(_[0-9a-zA-Z-]*\)\=\.vim', '\1', '')
	exe "an 20.460." .. idx .. ' &Edit.&Keymap.' .. mapname .. " :set keymap=" .. mapname .. "<CR>"
	idx += 10
      endfor
    endif
    silent! aunmenu &Edit.Show\ &Keymaps\ in\ Menu
  enddef

  if exists("do_no_lazyload_menus")
    call s:SetupKeymaps()
  else
    an <silent> 20.460 &Edit.Show\ &Keymaps\ in\ Menu :call <SID>SetupKeymaps()<CR>
  endif
endif

if has("win32") || has("gui_motif") || has("gui_gtk") || has("gui_kde") || has("gui_photon") || has("gui_mac")
  an 20.470 &Edit.Select\ Fo&nt\.\.\.	:set guifont=*<CR>
elseif has("gui_macvim")
  an 20.470 &Edit.-SEP4-                       <Nop>
  an 20.475.10 &Edit.Font.Show\ Fonts          <Nop>
  an 20.475.20 &Edit.Font.-SEP5-               <Nop>
  an 20.475.30 &Edit.Font.Bigger               <Nop>
  an 20.475.40 &Edit.Font.Smaller              <Nop>
endif

" Programming menu
if !exists("g:ctags_command")
  if has("vms")
    let g:ctags_command = "mc vim:ctags *.*"
  else
    let g:ctags_command = "ctags -R ."
  endif
endif

an 40.300 &Tools.&Jump\ to\ This\ Tag<Tab>g^]	g<C-]>
vunmenu &Tools.&Jump\ to\ This\ Tag<Tab>g^]
vnoremenu &Tools.&Jump\ to\ This\ Tag<Tab>g^]	g<C-]>
an 40.310 &Tools.Jump\ &Back<Tab>^T		<C-T>
an 40.320 &Tools.Build\ &Tags\ File		:exe "!" .. g:ctags_command<CR>

if has("diff")
  an 40.350.100 &Tools.&Diff.&Update		:diffupdate<CR>
  an 40.350.110 &Tools.&Diff.&Get\ Block	:diffget<CR>
  vunmenu &Tools.&Diff.&Get\ Block
  vnoremenu &Tools.&Diff.&Get\ Block		:diffget<CR>
  an 40.350.120 &Tools.&Diff.&Put\ Block	:diffput<CR>
  vunmenu &Tools.&Diff.&Put\ Block
  vnoremenu &Tools.&Diff.&Put\ Block		:diffput<CR>
endif

an 40.358 &Tools.-SEP2-					<Nop>
an 40.360 &Tools.&Make<Tab>:make			:make<CR>
an 40.370 &Tools.&List\ Errors<Tab>:cl			:cl<CR>
an 40.380 &Tools.L&ist\ Messages<Tab>:cl!		:cl!<CR>
an 40.390 &Tools.&Next\ Error<Tab>:cn			:cn<CR>
an 40.400 &Tools.&Previous\ Error<Tab>:cp		:cp<CR>
an 40.410 &Tools.&Older\ List<Tab>:cold			:colder<CR>
an 40.420 &Tools.N&ewer\ List<Tab>:cnew			:cnewer<CR>
an 40.430.50 &Tools.Error\ &Window.&Update<Tab>:cwin	:cwin<CR>
an 40.430.60 &Tools.Error\ &Window.&Open<Tab>:copen	:copen<CR>
an 40.430.70 &Tools.Error\ &Window.&Close<Tab>:cclose	:cclose<CR>

if !exists("no_buffers_menu")

" Buffer list menu -- Setup functions & actions

" wait with building the menu until after loading 'session' files. Makes
" startup faster.
let s:bmenu_wait = 1

" Dictionary of buffer number to name. This helps prevent problems where a
" buffer as renamed and we didn't keep track of that.
let s:bmenu_items = {}

if !exists("bmenu_priority")
  let bmenu_priority = 60
endif

" invoked from a BufCreate or BufFilePost autocommand
def s:BMAdd()
  if s:bmenu_wait == 0
    # when adding too many buffers, redraw in short format
    if s:bmenu_count == &menuitems && s:bmenu_short == 0
      s:BMShow()
    else
      var name = expand("<afile>")
      var num = str2nr(expand("<abuf>"))
      if s:BMCanAdd(name, num)
	s:BMFilename(name, num)
	s:bmenu_count += 1
      endif
    endif
  endif
enddef

" invoked from a BufDelete or BufFilePre autocommand
def s:BMRemove()
  if s:bmenu_wait == 0
    var bufnum = expand("<abuf>")
    if s:bmenu_items->has_key(bufnum)
      var menu_name = s:bmenu_items[bufnum]
      exe 'silent! aun &Buffers.' .. menu_name
      s:bmenu_count = s:bmenu_count - 1
      unlet s:bmenu_items[bufnum]
    endif
  endif
enddef

" Return non-zero if buffer with number "name" / "num" is useful to add in the
" buffer menu.
def s:BMCanAdd(name: string, num: number): bool
  # no directory or unlisted buffer
  if isdirectory(name) || !buflisted(num)
    return false
  endif

  # no name with control characters
  if name =~ '[\x01-\x1f]'
    return false
  endif

  # no special buffer, such as terminal or popup
  var buftype = getbufvar(num, '&buftype')
  if buftype != '' && buftype != 'nofile' && buftype != 'nowrite'
    return false
  endif

  # only existing buffers
  return bufexists(num)
enddef

" Create the buffer menu (delete an existing one first).
def s:BMShow()
  s:bmenu_wait = 1
  s:bmenu_short = 1
  s:bmenu_count = 0
  s:bmenu_items = {}

  # Remove old menu, if it exists; keep one entry to avoid a torn off menu to
  # disappear.  Use try/catch to avoid setting v:errmsg
  try 
    unmenu &Buffers 
  catch 
  endtry
  exe 'noremenu ' .. g:bmenu_priority .. ".1 &Buffers.Dummy l"
  try 
    unmenu! &Buffers 
  catch 
  endtry

  # create new menu
  exe 'an <silent> ' .. g:bmenu_priority .. ".2 &Buffers.&Refresh\\ menu :call <SID>BMShow()<CR>"
  exe 'an ' .. g:bmenu_priority .. ".4 &Buffers.&Delete :confirm bd<CR>"
  exe 'an ' .. g:bmenu_priority .. ".6 &Buffers.&Alternate :confirm b #<CR>"
  exe 'an ' .. g:bmenu_priority .. ".7 &Buffers.&Next :confirm bnext<CR>"
  exe 'an ' .. g:bmenu_priority .. ".8 &Buffers.&Previous :confirm bprev<CR>"
  exe 'an ' .. g:bmenu_priority .. ".9 &Buffers.-SEP- :"
  unmenu &Buffers.Dummy

  # figure out how many buffers there are
  var buf = 1
  while buf <= bufnr('$')
    if s:BMCanAdd(bufname(buf), buf)
      s:bmenu_count = s:bmenu_count + 1
    endif
    buf += 1
  endwhile
  if s:bmenu_count <= &menuitems
    s:bmenu_short = 0
  endif

  # iterate through buffer list, adding each buffer to the menu:
  buf = 1
  while buf <= bufnr('$')
    var name = bufname(buf)
    if s:BMCanAdd(name, buf)
      call s:BMFilename(name, buf)
    endif
    buf += 1
  endwhile
  s:bmenu_wait = 0
  aug buffer_list
    au!
    au BufCreate,BufFilePost * call s:BMAdd()
    au BufDelete,BufFilePre * call s:BMRemove()
  aug END
enddef

def s:BMHash(name: string): number
  # Make name all upper case, so that chars are between 32 and 96
  var nm = substitute(name, ".*", '\U\0', "")
  var sp: number
  if has("ebcdic")
    # HACK: Replace all non alphabetics with 'Z'
    #       Just to make it work for now.
    nm = substitute(nm, "[^A-Z]", 'Z', "g")
    sp = char2nr('A') - 1
  else
    sp = char2nr(' ')
  endif
  # convert first six chars into a number for sorting:
  return (char2nr(nm[0]) - sp) * 0x800000 + (char2nr(nm[1]) - sp) * 0x20000 + (char2nr(nm[2]) - sp) * 0x1000 + (char2nr(nm[3]) - sp) * 0x80 + (char2nr(nm[4]) - sp) * 0x20 + (char2nr(nm[5]) - sp)
enddef

def s:BMHash2(name: string): string
  var nm = substitute(name, ".", '\L\0', "")
  if nm[0] < 'a' || nm[0] > 'z'
    return '&others.'
  elseif nm[0] <= 'd'
    return '&abcd.'
  elseif nm[0] <= 'h'
    return '&efgh.'
  elseif nm[0] <= 'l'
    return '&ijkl.'
  elseif nm[0] <= 'p'
    return '&mnop.'
  elseif nm[0] <= 't'
    return '&qrst.'
  else
    return '&u-z.'
  endif
enddef

" Insert a buffer name into the buffer menu.
def s:BMFilename(name: string, num: number)
  var munge = s:BMMunge(name, num)
  var hash = s:BMHash(munge)
  var cmd: string
  if s:bmenu_short == 0
    s:bmenu_items[num] = munge
    cmd = 'an ' .. g:bmenu_priority .. '.' .. hash .. ' &Buffers.' .. munge
  else
    var menu_name = s:BMHash2(munge) .. munge
    s:bmenu_items[num] = menu_name
    cmd = 'an ' .. g:bmenu_priority .. '.' .. hash .. '.' .. hash .. ' &Buffers.' .. menu_name
  endif
  exe cmd .. ' :confirm b' .. num .. '<CR>'
enddef

" Truncate a long path to fit it in a menu item.
if !exists("g:bmenu_max_pathlen")
  let g:bmenu_max_pathlen = 35
endif

def s:BMTruncName(fname: string): string
  var name = fname
  if g:bmenu_max_pathlen < 5
    name = ""
  else
    var len = strlen(name)
    if len > g:bmenu_max_pathlen
      var amountl = (g:bmenu_max_pathlen / 2) - 2
      var amountr = g:bmenu_max_pathlen - amountl - 3
      var pattern = '^\(.\{,' .. amountl .. '}\).\{-}\(.\{,' .. amountr .. '}\)$'
      var left = substitute(name, pattern, '\1', '')
      var right = substitute(name, pattern, '\2', '')
      if strlen(left) + strlen(right) < len
	name = left .. '...' .. right
      endif
    endif
  endif
  return name
enddef

def s:BMMunge(fname: string, bnum: number): string
  var name = fname
  if name == ''
    if !exists("g:menutrans_no_file")
      g:menutrans_no_file = "[No Name]"
    endif
    name = g:menutrans_no_file
  else
    name = fnamemodify(name, ':p:~')
  endif
  # detach file name and separate it out:
  var name2 = fnamemodify(name, ':t')
  if bnum >= 0
    name2 = name2 .. ' (' .. bnum .. ')'
  endif
  name = name2 .. "\t" .. s:BMTruncName(fnamemodify(name, ':h'))
  name = escape(name, "\\. \t|")
  name = substitute(name, "&", "&&", "g")
  name = substitute(name, "\n", "^@", "g")
  return name
enddef

" When just starting Vim, load the buffer menu later.  Don't do this for MacVim
" because it makes the menu flicker each time a new editor window is opened.
if has("vim_starting") && !has("gui_macvim")
  augroup LoadBufferMenu
    au! VimEnter * if !exists("no_buffers_menu") | call <SID>BMShow() | endif
    au  VimEnter * au! LoadBufferMenu
  augroup END
else
  call <SID>BMShow()
endif

endif " !exists("no_buffers_menu")

" The popup menu
if has("gui_macvim")
  vnoremenu 1.05 PopUp.Look\ Up     :<C-U>call macvim#ShowDefinitionSelected()<CR>
  vnoremenu 1.06 PopUp.-SEPLookUp-      <Nop>
endif

an 1.10 PopUp.&Undo			u
an 1.15 PopUp.-SEP1-			<Nop>
vnoremenu 1.20 PopUp.Cu&t		"+x
vnoremenu 1.30 PopUp.&Copy		"+y
cnoremenu 1.30 PopUp.&Copy		<C-Y>
nnoremenu 1.40 PopUp.&Paste		"+gP
cnoremenu 1.40 PopUp.&Paste		<C-R>+
exe 'vnoremenu <script> 1.40 PopUp.&Paste	' .. paste#paste_cmd['v']
exe 'inoremenu <script> 1.40 PopUp.&Paste	' .. paste#paste_cmd['i']
vnoremenu 1.50 PopUp.&Delete		x
an 1.55 PopUp.-SEP2-			<Nop>
vnoremenu 1.60 PopUp.Select\ Blockwise	<C-V>

nnoremenu 1.70 PopUp.Select\ &Word	vaw
onoremenu 1.70 PopUp.Select\ &Word	aw
vnoremenu 1.70 PopUp.Select\ &Word	<C-C>vaw
inoremenu 1.70 PopUp.Select\ &Word	<C-O>vaw
cnoremenu 1.70 PopUp.Select\ &Word	<C-C>vaw

nnoremenu 1.73 PopUp.Select\ &Sentence	vas
onoremenu 1.73 PopUp.Select\ &Sentence	as
vnoremenu 1.73 PopUp.Select\ &Sentence	<C-C>vas
inoremenu 1.73 PopUp.Select\ &Sentence	<C-O>vas
cnoremenu 1.73 PopUp.Select\ &Sentence	<C-C>vas

nnoremenu 1.77 PopUp.Select\ Pa&ragraph	vap
onoremenu 1.77 PopUp.Select\ Pa&ragraph	ap
vnoremenu 1.77 PopUp.Select\ Pa&ragraph	<C-C>vap
inoremenu 1.77 PopUp.Select\ Pa&ragraph	<C-O>vap
cnoremenu 1.77 PopUp.Select\ Pa&ragraph	<C-C>vap

nnoremenu 1.80 PopUp.Select\ &Line	V
onoremenu 1.80 PopUp.Select\ &Line	<C-C>V
vnoremenu 1.80 PopUp.Select\ &Line	<C-C>V
inoremenu 1.80 PopUp.Select\ &Line	<C-O>V
cnoremenu 1.80 PopUp.Select\ &Line	<C-C>V

nnoremenu 1.90 PopUp.Select\ &Block	<C-V>
onoremenu 1.90 PopUp.Select\ &Block	<C-C><C-V>
vnoremenu 1.90 PopUp.Select\ &Block	<C-C><C-V>
inoremenu 1.90 PopUp.Select\ &Block	<C-O><C-V>
cnoremenu 1.90 PopUp.Select\ &Block	<C-C><C-V>

noremenu  <script> <silent> 1.100 PopUp.Select\ &All	:<C-U>call <SID>SelectAll()<CR>
inoremenu <script> <silent> 1.100 PopUp.Select\ &All	<C-O>:call <SID>SelectAll()<CR>
cnoremenu <script> <silent> 1.100 PopUp.Select\ &All	<C-U>call <SID>SelectAll()<CR>

if has("spell")
  " Spell suggestions in the popup menu.  Note that this will slow down the
  " appearance of the menu!
  def s:SpellPopup()
    if exists("s:changeitem") && s:changeitem != ''
      call s:SpellDel()
    endif

    # Return quickly if spell checking is not enabled.
    if !&spell || &spelllang == ''
      return
    endif

    var curcol = col('.')
    var w: string
    var a: string
    [w, a] = spellbadword()
    if col('.') > curcol		# don't use word after the cursor
      w = ''
    endif
    if w != ''
      if a == 'caps'
	s:suglist = [substitute(w, '.*', '\u&', '')]
      else
	s:suglist = spellsuggest(w, 10)
      endif
      if len(s:suglist) > 0
	if !exists("g:menutrans_spell_change_ARG_to")
	  g:menutrans_spell_change_ARG_to = 'Change\ "%s"\ to'
	endif
	s:changeitem = printf(g:menutrans_spell_change_ARG_to, escape(w, ' .'))
	s:fromword = w
	var pri = 1
	for sug in s:suglist
	  exe 'anoremenu 1.5.' .. pri .. ' PopUp.' .. s:changeitem .. '.' .. escape(sug, ' .')
		\ .. ' :call <SID>SpellReplace(' .. pri .. ')<CR>'
	  pri += 1
	endfor

	if !exists("g:menutrans_spell_add_ARG_to_word_list")
	  g:menutrans_spell_add_ARG_to_word_list = 'Add\ "%s"\ to\ Word\ List'
	endif
	s:additem = printf(g:menutrans_spell_add_ARG_to_word_list, escape(w, ' .'))
	exe 'anoremenu 1.6 PopUp.' .. s:additem .. ' :spellgood ' .. w .. '<CR>'

	if !exists("g:menutrans_spell_ignore_ARG")
	  g:menutrans_spell_ignore_ARG = 'Ignore\ "%s"'
	endif
	s:ignoreitem = printf(g:menutrans_spell_ignore_ARG, escape(w, ' .'))
	exe 'anoremenu 1.7 PopUp.' .. s:ignoreitem .. ' :spellgood! ' .. w .. '<CR>'

	anoremenu 1.8 PopUp.-SpellSep- :
      endif
    endif
    call cursor(0, curcol)	# put the cursor back where it was
  enddef

  def s:SpellReplace(n: number)
    var l = getline('.')
    # Move the cursor to the start of the word.
    call spellbadword()
    call setline('.', strpart(l, 0, col('.') - 1) .. s:suglist[n - 1]
	  \ .. strpart(l, col('.') + len(s:fromword) - 1))
  enddef

  def s:SpellDel()
    exe "aunmenu PopUp." .. s:changeitem
    exe "aunmenu PopUp." .. s:additem
    exe "aunmenu PopUp." .. s:ignoreitem
    aunmenu PopUp.-SpellSep-
    s:changeitem = ''
  enddef

  augroup SpellPopupMenu
    au! MenuPopup * call <SID>SpellPopup()
  augroup END
endif

if has("gui_macvim")
  "
  " Set up menu key equivalents (these should always have the 'D' modifier
  " set), action bindings, and alternate items.
  "
  " Note: menu items which should execute an action are bound to <Nop>; the
  " action message is specified here via the :macmenu command.
  "
  macm File.New\ Window				key=<D-n> action=newWindow:
  macm File.New\ Clean\ Window		        key=<D-N> action=newWindowClean:
  macm File.New\ Clean\ Window\ (No\ Defaults)  key=<D-M-N> action=newWindowCleanNoDefaults: alt=YES
  macm File.New\ Tab				key=<D-t>
  macm File.Open…				key=<D-o> action=fileOpen:
  macm File.Open\ Tab\.\.\.<Tab>:tabnew		key=<D-T>
  macm File.Open\ Recent			action=recentFilesDummy:
  macm File.Close\ Window<Tab>:qa		key=<D-W>
  macm File.Close				key=<D-w> action=performClose:
  macm File.Save<Tab>:w				key=<D-s>
  macm File.Save\ All				key=<D-M-s> alt=YES
  macm File.Save\ As…<Tab>:sav		key=<D-S>
  macm File.Print				key=<D-p>

  macm Edit.Undo<Tab>u				key=<D-z> action=undo:
  macm Edit.Redo<Tab>^R				key=<D-Z> action=redo:
  macm Edit.Cut<Tab>"+x				key=<D-x> action=cut:
  macm Edit.Copy<Tab>"+y			key=<D-c> action=copy:
  macm Edit.Paste<Tab>"+gP			key=<D-v> action=paste:
  macm Edit.Select\ All<Tab>ggVG		key=<D-a> action=selectAll:
  macm Edit.Find.Find…			key=<D-f>
  macm Edit.Find.Find\ Next			key=<D-g> action=findNext:
  macm Edit.Find.Find\ Previous			key=<D-G> action=findPrevious:
  macm Edit.Find.Use\ Selection\ for\ Find	key=<D-e> action=useSelectionForFind:
  macm Edit.Font.Show\ Fonts			action=orderFrontFontPanel:
  macm Edit.Font.Bigger				key=<D-=> action=fontSizeUp:
  macm Edit.Font.Smaller			key=<D--> action=fontSizeDown:

  macm Tools.Spelling.To\ Next\ Error<Tab>]s	key=<D-;>
  macm Tools.Spelling.Suggest\ Corrections<Tab>z=   key=<D-:>
  macm Tools.Make<Tab>:make			key=<D-b>
  macm Tools.List\ Errors<Tab>:cl		key=<D-l>
  macm Tools.Next\ Error<Tab>:cn		key=<D-C-Right>
  macm Tools.Previous\ Error<Tab>:cp		key=<D-C-Left>
  macm Tools.Older\ List<Tab>:cold		key=<D-C-Up>
  macm Tools.Newer\ List<Tab>:cnew		key=<D-C-Down>

  macm Window.Minimize		key=<D-m>	action=performMiniaturize:
  macm Window.Minimize\ All	key=<D-M-m>	action=miniaturizeAll:	alt=YES
  macm Window.Zoom		key=<D-C-z>	action=performZoom:
  macm Window.Zoom\ All		key=<D-M-C-z>	action=zoomAll:		alt=YES
  macm Window.Toggle\ Full\ Screen\ Mode	key=<D-C-f>
  macm Window.Show\ Next\ Tab			key=<D-}>
  macm Window.Show\ Previous\ Tab		key=<D-{>
  macm Window.Bring\ All\ To\ Front		action=arrangeInFront:
  macm Window.Stay\ in\ Front 	action=stayInFront:
  macm Window.Stay\ in\ Back 	action=stayInBack:
  macm Window.Stay\ Level\ Normal action=stayLevelNormal:

  macm Help.MacVim\ Help			key=<D-?>
  macm Help.MacVim\ Website			action=openWebsite:
  macm Help.What's\ New			    action=showWhatsNew:
endif " if has("gui_macvim")

endif " !exists("did_install_default_menus")

" Restore the previous value of 'cpoptions'.
let &cpo = s:cpo_save
unlet s:cpo_save


if has("touchbar")
  " Set up default Touch Bar buttons.
  " 1. Smart fullscreen icon that toggles between going full screen or not.

  if !exists("g:macvim_default_touchbar_fullscreen") || g:macvim_default_touchbar_fullscreen
    an icon=NSTouchBarEnterFullScreenTemplate 1.20 TouchBar.EnterFullScreen :set fullscreen<CR>
    tln icon=NSTouchBarEnterFullScreenTemplate 1.20 TouchBar.EnterFullScreen <C-W>:set fullscreen<CR>
  endif

  let s:touchbar_fullscreen=0
  func! s:SetupFullScreenTouchBar()
    if &fullscreen && s:touchbar_fullscreen != 1
      silent! aun TouchBar.EnterFullScreen
      silent! tlun TouchBar.EnterFullScreen
      if !exists("g:macvim_default_touchbar_fullscreen") || g:macvim_default_touchbar_fullscreen
        an icon=NSTouchBarExitFullScreenTemplate 1.20 TouchBar.ExitFullScreen :set nofullscreen<CR>
        tln icon=NSTouchBarExitFullScreenTemplate 1.20 TouchBar.ExitFullScreen <C-W>:set nofullscreen<CR>
      endif
      let s:touchbar_fullscreen = 1
    elseif !&fullscreen && s:touchbar_fullscreen != 0
      silent! aun TouchBar.ExitFullScreen
      silent! tlun TouchBar.ExitFullScreen
      if !exists("g:macvim_default_touchbar_fullscreen") || g:macvim_default_touchbar_fullscreen
        an icon=NSTouchBarEnterFullScreenTemplate 1.20 TouchBar.EnterFullScreen :set fullscreen<CR>
        tln icon=NSTouchBarEnterFullScreenTemplate 1.20 TouchBar.EnterFullScreen <C-W>:set fullscreen<CR>
      endif
      let s:touchbar_fullscreen = 0
    endif
  endfunc
  aug FullScreenTouchBar
    au!
    au VimEnter * call <SID>SetupFullScreenTouchBar()
    au OptionSet fullscreen call <SID>SetupFullScreenTouchBar()
  aug END

  " 2. Character (i.e. emojis) picker. Only in modes where user is actively
  " entering text.
  if !exists("g:macvim_default_touchbar_characterpicker") || g:macvim_default_touchbar_characterpicker
    inoremenu 1.40 TouchBar.-characterpicker- <Nop>
    cnoremenu 1.40 TouchBar.-characterpicker- <Nop>
    tlnoremenu 1.40 TouchBar.-characterpicker- <Nop>
  endif
endif

" vim: set sw=2 tabstop=8 :
