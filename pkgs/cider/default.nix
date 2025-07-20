{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  # Required dependencies for autoPatchelfHook
  alsa-lib,
  at-spi2-atk,
  cairo,
  cups,
  expat,
  gcc,
  gtk3,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  xorg,
}:
stdenv.mkDerivation rec {
  pname = "cider";
  version = "3.0.0";

  src = fetchurl {
    url = "https://repo.cider.sh/apt/pool/main/cider-v${version}-linux-x64.deb";
    hash = "sha256-XKyzt8QkPNQlgFxR12KA5t+PCJki7UuFpn4SGmoGkpg=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    expat
    gcc.cc.lib
    gtk3
    libxkbcommon
    mesa
    nspr
    nss
    pango
    systemd
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile $src | tar x --no-same-owner --no-same-permissions
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share,lib}
    cp -r usr/share/* $out/share/
    cp -r usr/lib/* $out/lib/

    # Make the executable actually executable
    chmod +x $out/lib/cider/Cider

    runHook postInstall
  '';

  postFixup = ''
    # Create wrapper script with Wayland, sandbox, and scaling flags (matching nixpkgs pattern)
    makeWrapper $out/lib/cider/Cider $out/bin/cider \
      --add-flags "\$\{NIXOS_OZONE_WL:+\$\{WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true\}\}" \
      --add-flags "--no-sandbox --disable-gpu-sandbox"

    # Fix desktop file
    substituteInPlace $out/share/applications/cider.desktop \
      --replace-warn 'Exec=cider' 'Exec=${pname}' \
      --replace-warn 'Exec=/usr/lib/cider/Cider' 'Exec=${pname}'

    # Install icon in proper location
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp $out/share/pixmaps/cider.png $out/share/icons/hicolor/256x256/apps/cider.png
  '';

  meta = {
    description = "Powerful music player that allows you listen to your favorite tracks with style";
    homepage = "https://cider.sh";
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "cider";
  };
}
