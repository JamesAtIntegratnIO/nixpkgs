{ lib, stdenv, fetchFromSourcehut, pkg-config, glib, mpv-unwrapped }:

let
  rev = "21205d733b42106a1f19b59e142d637fd27eca83";
  sha256 = "2649357841f69712c37b71200b7cc0e8c2b8b67e0be7c1f4387cb74d8553d791";
in
stdenv.mkDerivation rec {
  pname = "mpv-inhibit-suspend";
  version = "unstable-2021-07-08";
  passthru.scriptName = "inhibit-suspend.so";

  src = fetchFromSourcehut {
    owner = "~anteater";
    repo = pname;
    inherit rev sha256;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ glib mpv-unwrapped ];

  postPatch = ''
    substituteInPlace Makefile --replace 'PKG_CONFIG =' 'PKG_CONFIG ?='
  '';

  installFlags = [ "SCRIPTS_DIR=$(out)/share/mpv/scripts" ];

  # Otherwise, the shared object isn't `strip`ped. See:
  # https://discourse.nixos.org/t/debug-why-a-derivation-has-a-reference-to-gcc/7009
  stripDebugList = [ "share/mpv/scripts" ];

  meta = with lib; {
    description = "mpv plugin that prevents the system from suspending while media are playing";
    homepage = "https://git.sr.ht/~anteater/mpv-inhibit-suspend";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nicoo ];
    changelog = "https://git.sr.ht/~anteater/mpv-inhibit-suspend/log?from=${rev}";
  };
}
