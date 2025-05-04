{ pkgs ? import <nixpkgs> {} }:
let
  pname = "cob-cli";
  version = "2.46.0";
  nodejs = pkgs.nodejs;

  cob-cli = pkgs.buildNpmPackage {
    pname = pname;
    version = version;
    src = pkgs.fetchFromGitHub {
      owner = "alt-romes";
      repo = "cob-cli";
      rev = "0e0fe5480da8d8e449b6a4558653c4f177c7f5da";
      hash = "sha256-ivo+zJ0A8X7gaj2r6l0eW3SbgKAGse0VGnO4CPFnYIc=";
    };

    nodejs = nodejs;
    dontNpmBuild = true;
    npmDepsHash = "sha256-VU7W2x5XTnPk2FwUvCNsHAJ4rATPMq3mKGVYGROm4/Q=";
  };

  # The cob-cli exe is a wrapper which sets the path to rsync and git properly.
  cob-cli-wrapper = pkgs.stdenv.mkDerivation {
    pname = "${pname}-wrapper";
    version = version;

    src = pkgs.writeShellScriptBin pname ''
      export PATH="${pkgs.rsync}/bin:${pkgs.git}/bin:${nodejs}/bin:$PATH"
      ${cob-cli}/bin/${pname} $@
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp $src/bin/${pname} $out/bin/${pname}-${version}
      ln -s $out/bin/${pname}-${version} $out/bin/${pname}
    '';
  };

in cob-cli-wrapper
