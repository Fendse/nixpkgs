{stdenv, autoPatchelfHook, dpkg, fetchurl,
 SDL2, glibc, openssl, libgcc, zlib, libcap, glib, pango, cairo, gdk-pixbuf, gtk2, x11, xorg
}:
  let remoteVersion = "2.2.8";
      libraries = [
        SDL2
        glibc
        openssl
        libgcc
        zlib
        libcap
        glib
        pango
        cairo
        gdk-pixbuf
        gtk2
        x11
        xorg.libXxf86vm
        xorg.sessreg
      ];
  in
    stdenv.mkDerivation {
      pname = "RuneScape";
      version = "${remoteVersion}.0";

      system = "x86_64-linux";

      runtimeDependencies = libraries;
      buildInputs = libraries;

      nativeBuildInputs = [
        autoPatchelfHook
        dpkg
      ];

      unpackPhase = ''dpkg-deb -x "$src" .'';

      patches = [ ./find-binary.patch ];

      installPhase = ''
        substituteInPlace usr/bin/runescape-launcher --subst-var out
        mkdir -p "$out"
        mv --target-directory="$out" -- usr/*
      '';

      src = fetchurl {
        url = "https://content.runescape.com/downloads/ubuntu/pool/non-free/r/runescape-launcher/runescape-launcher_${remoteVersion}_amd64.deb";
        sha256 = "4855b844aa222ad844f0a169a3ac9a5e46e9e97e1e2140efe65096a776fea3c6";
      };
    }
