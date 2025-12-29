{ ... }:
{
  programs.vscode.profiles.default.keybindings = [
    {
      key = "ctrl+shift+o";
      command = "workbench.action.quickOpen";
    }
    {
      key = "ctrl+d";
      command = "editor.action.copyLinesDownAction";
    }
    {
      key = "shift+enter";
      command = "workbench.action.terminal.sendSequence";
      args.text = "\\\r\n";
      when = "terminalFocus";
    }
  ];
}
