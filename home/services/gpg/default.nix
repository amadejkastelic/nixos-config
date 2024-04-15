{pkgs, ...}: {
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableSshSupport = true;
    enableScDaemon = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  services.ssh-agent.enable = true;

  programs.gpg.enable = true;
}
