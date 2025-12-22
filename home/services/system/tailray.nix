{ inputs, ... }:
{
  imports = [ inputs.tailray.homeManagerModules.default ];

  services.tailray.enable = true;

  systemd.user.services.tailray.Unit.After = [ "graphical-session.target" ];
}
