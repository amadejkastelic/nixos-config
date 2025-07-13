{ pkgs, ... }:
{
  users.users.amadejk = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "adbusers"
      "input"
      "libvirtd"
      "networkmanager"
      "plugdev"
      "transmission"
      "video"
      "wheel"
      "gamemode"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIN7DVOB0DJ1x6G9WetQGxzKhj2TgH8DitfTf2xof/Ep amadejkastelic7@gmail.com"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJC7gpWcNY0I6YCsfr1GPu2q+sODgQlBj4b6K/WGaMJxAAAABHNzaDo= amadejk@ryzen"
    ];
  };
}
