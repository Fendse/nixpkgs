{ buildFHSUserEnvBubblewrap, callPackage, lib,
  glib, pango, cairo, gdk_pixbuf, gtk2, SDL2, zlib,
  xdg_utils, libglvnd, libcap, openssl, xorg,
  libSM ? xorg.libSM, libX11 ? xorg.libX11, libXxf86vm ? xorg.libXxf86vm
}:
let
  runtime = callPackage ./runtime.nix { };
  pname = "runescape-launcher";
  version = runtime.version;
  name = "${pname}-${version}";
in
  buildFHSUserEnvBubblewrap {
    inherit name;

    runScript = ''${runtime}/bin/runescape-launcher'';

    extraInstallCommands = ''
      cp -r -- ${runtime}/share "$out"
      mv -- "$out/bin/${name}" "$out/bin/${pname}"
      substituteInPlace "$out/share/applications/runescape-launcher.desktop" --replace '/usr/bin/' ""
    '';

    targetPkgs = lib.const [
      libSM
      libX11
      libXxf86vm
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

    meta = with lib; {
      description = "A free MMORPG from Jagex LTD";
      homepage = "https://runescape.com";
      license = licenses.unfree;
      maintainers = maintainers.Fendse;
      platforms = [ "x86_64-linux" ]; # TODO: Figure out what other platforms might work
    };
  }
