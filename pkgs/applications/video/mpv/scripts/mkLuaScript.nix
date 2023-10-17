{ lib
, stdenvNoCC }:

lib.makeOverridable (
  { pname, scriptPath ? "${pname}.lua", ... }@args:
  stdenvNoCC.mkDerivation (lib.attrsets.recursiveUpdate {
    dontBuild = true;
    dontCheck = true;
    preferLocalBuild = true;

    outputHashMode = "recursive";
    installPhase = "install -m644 -Dt $out/share/mpv/scripts ${scriptPath}";
    passthru.scriptName = with lib; last (splitString "/" scriptPath);

    meta.platforms = lib.platforms.all;
  } args)
)
