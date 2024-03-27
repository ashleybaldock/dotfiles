
if has('gui_running')

  function! MenuBuild()
    call popup_notification("      🙈 🙉 🙊", #{ line: 2, col: 10, highlight: 'ToolbarLine', time: 2000} )
  endfunc

  nunmenu WinBar
  nnoremenu 1.10 WinBar.‼️\     :
  nnoremenu 1.20 WinBar.🔶     :
  nnoremenu 1.30 WinBar.🌈     :
  nnoremenu 1.40 WinBar.🐵     :call popup_notification("      🙈 🙉 🙊", #{ line: 2, col: 10, highlight: 'ToolbarLine', time: 2000} )
  nnoremenu 1.50 WinBar.🍆     :

  " aunmenu Toolbar.Open
  " aunmenu ToolBar.Save
  " aunmenu ToolBar.SaveAll
  " aunmenu ToolBar.Print
  " aunmenu ToolBar.Undo
  " aunmenu ToolBar.Redo
  " aunmenu ToolBar.Cut
  " aunmenu ToolBar.Copy
  " aunmenu ToolBar.Paste
  " aunmenu ToolBar.RunScript
  " aunmenu ToolBar.Make
  " aunmenu ToolBar.Help

endif
