{ inputs, ... }:
{
  imports = [ inputs.tailray.homeManagerModules.default ];

  services.tailray.enable = true;
}
