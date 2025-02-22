{pkgs, ...}: {
  # graphics drivers / HW accel
  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      libva
      libvdpau
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Bleeding-edge mesa
  chaotic.mesa-git.enable = true;
}
