# Stolen from github.com/evanjs/nixos_cfg (with minor modification)
{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  pname = "runescape-launcher";
  version = "2.2.8";

  src = fetchurl {
    url = "https://content.runescape.com/downloads/ubuntu/pool/non-free/r/runescape-launcher/runescape-launcher_${version}_amd64.deb";
    sha256 = "4855b844aa222ad844f0a169a3ac9a5e46e9e97e1e2140efe65096a776fea3c6";
  };

  dontPatchELF = true;
  dontStrip = true;

  nativeBuildInputs = [ dpkg ];
  unpackCmd = "dpkg -x $curSrc .";

  installPhase = ''
    cp -r . $out
    substituteInPlace $out/bin/runescape-launcher --replace /usr/share $out/share
  '';

  meta = with stdenv.lib; {
    description = "Runescape NXT client";
    homepage = https://www.runescape.com;
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
