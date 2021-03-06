{fetchurl, stdenv, autoPatchelfHook, makeDesktopItem, writeScriptBin,
 gcc-unwrapped, SDL2, SDL2_image, SDL2_mixer, SDL2_net,
 system ? stdenv.hostPlatform.system
}:
let version = "3.62";
in
  stdenv.mkDerivation {
    pname = "unreal_world";
    inherit version;
    src = fetchurl {
      url = "https://www.unrealworld.fi/dl/${version}/linux/deb-ubuntu/urw-${version}-${system}-gnu.tar.gz";
      sha256 =
        if system == "i686-linux" then "13k7qvlcgklj0s86yn5hz7p6j8jgl78bd43qjl4im7574rqg5gj2"
        else if system == "x86_64-linux" then "95f21bafc3c64c52b3c3251637452ff2c3fd257a723b7ebcfbfe5a8ac6bb9ed6"
        else throw "Unsupported platform ${system}";
    };
    nativeBuildInputs = [
      autoPatchelfHook
    ];

    runtimeDependencies = [
      gcc-unwrapped.lib
      SDL2
      SDL2_image
      SDL2_mixer
      SDL2_net
    ];

    wrapper = ./launcher.bash;

    desktopItem = makeDesktopItem {
      name = "unreal-world";
      exec = "unreal-world";
      desktopName = "UnReal World";
    };

    installPhase = ''
      mkdir -p "$out/share/unreal-world" "$out/bin" "$out/share/applications"
      mv -- * "$out/share/unreal-world"
      substituteAll "$wrapper" "$out/bin/urw"
      chmod a=rx "$out/bin/urw"
      substituteAll "$desktopItem/share/applications/unreal-world.desktop" "$out/share/applications/unreal-world.desktop"
    '';

    meta = {
      description = "Survival based roguelike game";
      longDescription = "A unique low-fantasy roguelike game set in the far north during the late Iron-Age. The world of the game is highly realistic, rich with historical atmosphere and emphasized on survival in the harsh ancient wilderness. This package contains the latest free version of UnReal World, though there may be more recent releases available on itch.io and Steam";
      homepage = "https://unrealworld.fi";
      license = stdenv.lib.licenses.unfree;
      maintainers = with stdenv.lib.maintainers; [ Fendse ];
      platforms = [ "x86_64-linux" "i686-linux" ];
    };
  }
