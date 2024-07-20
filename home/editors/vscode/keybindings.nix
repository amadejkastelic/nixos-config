{...}: {
  programs.vscode.keybindings = [
    {
      key = "ctrl+shift+o";
      command = "workbench.action.quickOpen";
    }
    {
      key = "ctrl+d";
      command = "editor.action.copyLinesDownAction";
    }
  ];
}
