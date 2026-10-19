{
  lib,
  stdenvNoCC,
  stdenv,
  fetchurl,
  gzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "tfm";
  version = "1.1.0";

  suffix = if stdenv.hostPlatform.isx86_64 then "x86_64-linux" else "aarch64-linux";

  src = fetchurl {
    url = "https://github.com/clarkarch/tfm-tui/releases/download/v${version}/tfm-${suffix}.gz";
    sha256 = "sha256-s9mnz4hVUB15y+8jDu3HMOyKhKyqqM9bM75c2SgsbQ4=";
  };

  nativeBuildInputs = [ gzip ];

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true; # crítico: strip rompe el payload de Bun
  dontPatchELF = true; # no tocar el ELF en el fixup

  installPhase = ''
    gunzip -c "$src" > tfm
    install -Dm755 tfm "$out/bin/tfm"
    ln -s tfm "$out/bin/terminal-file-manager"
  '';

  meta = with lib; {
    description = "Mouse-first terminal file manager";
    homepage = "https://github.com/clarkarch/tfm-tui";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "tfm";
  };
}
