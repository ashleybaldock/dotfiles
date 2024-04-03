

function! MenuBuild()
  call popup_notification("      🙈 🙉 🙊", #{ line: 2, col: 10, highlight: 'ToolbarLine', time: 2000} )
endfunc

nunmenu WinBar
nnoremenu 1.10 WinBar.‼️\     :
nnoremenu 1.20 WinBar.🔶     :
nnoremenu 1.30 WinBar.🌈     :
nnoremenu 1.40 WinBar.🐵     :call MenuBuild()
nnoremenu 1.50 WinBar.🍆     :

if !exists("g:mayhem_did_toolbar_init")
  let g:mayhem_did_toolbar_init = 1

  aunmenu ToolBar.Open
  aunmenu ToolBar.Save
  aunmenu ToolBar.SaveAll
  aunmenu ToolBar.Print
  aunmenu ToolBar.Undo
  aunmenu ToolBar.Redo
  aunmenu ToolBar.Cut
  aunmenu ToolBar.Copy
  aunmenu ToolBar.Paste
  aunmenu ToolBar.RunScript
  aunmenu ToolBar.Make
  aunmenu ToolBar.Help
endif
