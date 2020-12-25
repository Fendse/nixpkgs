# Stolen from github.com/evanjs/nixos_cfg
{ stdenv, callPackage, buildFHSUserEnv }:

buildFHSUserEnv rec {
  name = "runescape-launcher";

  runScript = "${callPackage ./runtime.nix {}}/bin/runescape-launcher";

  targetPkgs = pkgs: with pkgs; [
    xorg.libSM
    xorg.libX11
    xorg.libXxf86vm
    libpng12
    glib
    glib_networking
    pango
    cairo
    gdk_pixbuf
    curl
    gtk2
    expat
    SDL2
    zlib
    glew110
    mesa
    firefox
    xdg_utils
    libglvnd

    libcap
    openssl
  ];
}
