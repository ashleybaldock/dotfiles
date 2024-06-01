let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/dotfiles
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +532 .vim/plugin/shortcuts.vim
badd +152 .vim/gvimrc
badd +9 .vim/vimrc
badd +16 .vim/plugin/commands.vim
badd +14 .vim/plugin/commands.coc.vim
badd +151 .vim/coc-settings.json
badd +164 .vim/colors/vividmayhem.vim
badd +2182 .vim/doc/unicode.md
badd +250 .vim/plugin/chars.vim
badd +1 .vim/plugin/statusline.vim
badd +193 .vim/plugin/home.vim
badd +89 .vim/plugin/css.vim
badd +534 /System/Library/Input\ Methods/CharacterPalette.app/Contents/Resources/UnicodeBlocks_Category.loctable
badd +1 ~/Desktop/Category-Favorites.plist
badd +2 ~/Desktop/Category-BoxDrawing.plist
badd +1 /System/Library/Input\ Methods/CharacterPalette.app/Contents/PkgInfo
badd +11 /System/Library/Input\ Methods/CharacterPalette.app/Contents/Resources/Categories.plist
badd +370 /System/Library/Input\ Methods/CharacterPalette.app/Contents/Info.plist
badd +44 .vim/plugin/highlight.vim
badd +436 /Applications/MacVim.app/Contents/Resources/vim/runtime/menu.vim
badd +1 /Applications/MacVim.app/Contents/Resources/vim/runtime/doc/let
badd +3 .vim/ftplugin/vimmessages.vim
badd +4 .vim/ftplugin/javascript.vim
badd +4 .vim/ftplugin/python.vim
badd +6 .vim/ftplugin/typescript.vim
badd +1 .vim/ftplugin/typescriptreact.vim
badd +1 .vim/ftplugin/vim.vim
badd +5 .vim/ftplugin/css.vim
badd +2 .vim/ftplugin/mayhemwinfo.vim
badd +15 .vim/syntax/vimmessages.vim
badd +4 .vim/plugin/colorcolumn.vim
badd +32 .vim/plugin/Session.vim
badd +27 bin/spotifyplay.sh
badd +8 bin/spotifyscript.sh
badd +86 bin/spotifyinfo.sh
badd +4 .vim/plugin/unicode.vim
badd +1 .vim/plugin/debug.vim
badd +13 .vim/plugin/copy.vim
badd +41 .vim/plugin/borders.vim
badd +5 .vim/plugin/reload.vim
badd +5 .vim/plugin/commands.typescript.vim
badd +5 .vim/plugin/wincolor.vim
badd +9 .vim/plugin/winbar.vim
badd +1 .vim/plugin/temp
badd +1 /Applications/MacVim.app/Contents/Resources/vim/runtime/doc/temp2
badd +1 .vim/plugin/search.vim
badd +1 .vim/plugin/openCSS.vim
badd +1 .vim/plugin/prettier.vim
badd +6 .vim/plugin/projectRoot.vim
badd +28 .vim/plugin/modechanged.vim
badd +54 .vim/plugin/signs.vim
badd +42 /Applications/MacVim.app/Contents/Resources/vim/runtime/gvimrc_example.vim
badd +1 .vim/.vim/plugin/home.vim
badd +1 /Applications/MacVim.app/Contents/Resources/vim/gvimrc\\
badd +1 /Applications/MacVim.app/Contents/Resources/vim/gvimrc
badd +1 .vim/plugin/highlight.vim\\
badd +1 .vim/plugin/menu.vim
argglobal
%argdel
edit /Applications/MacVim.app/Contents/Resources/vim/gvimrc
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
3wincmd h
wincmd w
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
wincmd w
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
2wincmd h
wincmd w
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 32 + 26) / 52)
exe 'vert 1resize ' . ((&columns * 11 + 89) / 179)
exe '2resize ' . ((&lines * 32 + 26) / 52)
exe 'vert 2resize ' . ((&columns * 60 + 89) / 179)
exe '3resize ' . ((&lines * 2 + 26) / 52)
exe 'vert 3resize ' . ((&columns * 38 + 89) / 179)
exe '4resize ' . ((&lines * 29 + 26) / 52)
exe 'vert 4resize ' . ((&columns * 38 + 89) / 179)
exe '5resize ' . ((&lines * 32 + 26) / 52)
exe 'vert 5resize ' . ((&columns * 67 + 89) / 179)
exe '6resize ' . ((&lines * 17 + 26) / 52)
exe 'vert 6resize ' . ((&columns * 80 + 89) / 179)
exe '7resize ' . ((&lines * 17 + 26) / 52)
exe 'vert 7resize ' . ((&columns * 11 + 89) / 179)
exe '8resize ' . ((&lines * 17 + 26) / 52)
exe 'vert 8resize ' . ((&columns * 86 + 89) / 179)
argglobal
balt /Applications/MacVim.app/Contents/Resources/vim/gvimrc\\
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=3
setlocal fdn=4
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 37 - ((1 * winheight(0) + 16) / 32)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 37
normal! 0
lcd /Applications/MacVim.app/Contents/Resources/vim
wincmd w
argglobal
if bufexists(fnamemodify("~/dotfiles/.vim/gvimrc", ":p")) | buffer ~/dotfiles/.vim/gvimrc | else | edit ~/dotfiles/.vim/gvimrc | endif
balt ~/dotfiles/.vim/plugin/winbar.vim
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=3
setlocal fdn=4
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 151 - ((1 * winheight(0) + 16) / 32)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 151
normal! 025|
lcd ~/dotfiles/.vim
wincmd w
argglobal
if bufexists(fnamemodify("~/dotfiles/.vim/plugin/home.vim", ":p")) | buffer ~/dotfiles/.vim/plugin/home.vim | else | edit ~/dotfiles/.vim/plugin/home.vim | endif
balt ~/dotfiles/.vim/plugin/shortcuts.vim
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=3
setlocal fdn=4
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 12 - ((0 * winheight(0) + 1) / 2)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 12
normal! 014|
lcd ~/dotfiles/.vim/plugin
wincmd w
argglobal
if bufexists(fnamemodify("~/dotfiles/.vim/plugin/menu.vim", ":p")) | buffer ~/dotfiles/.vim/plugin/menu.vim | else | edit ~/dotfiles/.vim/plugin/menu.vim | endif
balt ~/dotfiles/.vim/plugin/home.vim
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=3
setlocal fdn=4
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 973 - ((1 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 973
normal! 0108|
lcd ~/dotfiles/.vim/plugin
wincmd w
argglobal
if bufexists(fnamemodify("~/dotfiles/.vim/colors/vividmayhem.vim", ":p")) | buffer ~/dotfiles/.vim/colors/vividmayhem.vim | else | edit ~/dotfiles/.vim/colors/vividmayhem.vim | endif
balt ~/dotfiles/.vim/plugin/commands.coc.vim
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=3
setlocal fdn=4
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 242 - ((1 * winheight(0) + 16) / 32)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 242
normal! 054|
lcd ~/dotfiles/.vim/colors
wincmd w
argglobal
enew | setl bt=help
help Select-mode@en
balt /Applications/MacVim.app/Contents/Resources/vim/gvimrc
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=3
setlocal fdn=4
setlocal nofen
silent! normal! zE
let &fdl = &fdl
let s:l = 493 - ((0 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 493
normal! 049|
lcd /Applications/MacVim.app/Contents/Resources/vim/runtime/doc
wincmd w
argglobal
if bufexists(fnamemodify("~/dotfiles/.vim/plugin/copy.vim", ":p")) | buffer ~/dotfiles/.vim/plugin/copy.vim | else | edit ~/dotfiles/.vim/plugin/copy.vim | endif
balt ~/dotfiles/.vim/plugin/highlight.vim
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=3
setlocal fdn=4
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 45 - ((1 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 45
normal! 029|
lcd ~/dotfiles/.vim/plugin
wincmd w
argglobal
if bufexists(fnamemodify("~/dotfiles/.vim/plugin/statusline.vim", ":p")) | buffer ~/dotfiles/.vim/plugin/statusline.vim | else | edit ~/dotfiles/.vim/plugin/statusline.vim | endif
balt ~/dotfiles/.vim/plugin/copy.vim
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=3
setlocal fdn=4
setlocal fen
let s:l = 17 - ((1 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 17
normal! 013|
lcd ~/dotfiles/.vim/plugin
wincmd w
exe '1resize ' . ((&lines * 32 + 26) / 52)
exe 'vert 1resize ' . ((&columns * 11 + 89) / 179)
exe '2resize ' . ((&lines * 32 + 26) / 52)
exe 'vert 2resize ' . ((&columns * 60 + 89) / 179)
exe '3resize ' . ((&lines * 2 + 26) / 52)
exe 'vert 3resize ' . ((&columns * 38 + 89) / 179)
exe '4resize ' . ((&lines * 29 + 26) / 52)
exe 'vert 4resize ' . ((&columns * 38 + 89) / 179)
exe '5resize ' . ((&lines * 32 + 26) / 52)
exe 'vert 5resize ' . ((&columns * 67 + 89) / 179)
exe '6resize ' . ((&lines * 17 + 26) / 52)
exe 'vert 6resize ' . ((&columns * 80 + 89) / 179)
exe '7resize ' . ((&lines * 17 + 26) / 52)
exe 'vert 7resize ' . ((&columns * 11 + 89) / 179)
exe '8resize ' . ((&lines * 17 + 26) / 52)
exe 'vert 8resize ' . ((&columns * 86 + 89) / 179)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=12 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
nohlsearch
let g:this_session = v:this_session
let g:this_obsession = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
