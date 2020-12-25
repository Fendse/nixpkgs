# Stolen from github.com/evanjs/nixos_cfg
{ stdenv, callPackage, buildFHSUserEnv }:

buildFHSUserEnv rec {
  name = "runescape-launcher";

  runScript = "${callPackage ./runtime.nix {}}/bin/runescape-launcher";

  targetPkgs = pkgs: with pkgs; [
    xorg.libSM
    xorg.libX11
    xorg.libXxf86vm
    glib
    pango
    cairo
    gdk_pixbuf
    gtk2
    SDL2
    zlib
    xdg_utils
    libglvnd

    libcap
    openssl
  ];
}
