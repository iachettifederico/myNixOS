{
  self,
  inputs,
  ...
}: let
  gentleAiRelease = system: let
    releases = {
      x86_64-linux = {
        url = "https://github.com/Gentleman-Programming/gentle-ai/releases/download/v2.4.0-rc.8/gentle-ai_2.4.0-rc.8_linux_amd64";
        hash = "sha256-7imzqQ59ACs+8NK/8QgOt0Qc2ex93noqalQUC6DPPz0=";
      };
      aarch64-linux = {
        url = "https://github.com/Gentleman-Programming/gentle-ai/releases/download/v2.4.0-rc.8/gentle-ai_2.4.0-rc.8_linux_arm64";
        hash = "sha256-N7Yz42OUGastI7Hq9ljlGOVjdj+k5O12Ajfnl8/Haz4=";
      };
    };
  in
    if builtins.hasAttr system releases
    then releases.${system}
    else throw "gentle-ai is only packaged for x86_64-linux and aarch64-linux";
in {
  flake.nixosModules.gentleAi = {pkgs, ...}: let
    release = gentleAiRelease pkgs.stdenv.hostPlatform.system;
    gentleAi = pkgs.stdenvNoCC.mkDerivation {
      pname = "gentle-ai";
      version = "2.4.0-rc.8";
      src = pkgs.fetchurl release;

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        install -Dm755 "$src" "$out/bin/gentle-ai"
      '';

      meta = {
        description = "Gentle AI CLI";
        homepage = "https://github.com/Gentleman-Programming/gentle-ai";
        platforms = ["x86_64-linux" "aarch64-linux"];
        mainProgram = "gentle-ai";
      };
    };
  in {
    environment.localBinInPath = true;

    environment.variables.GENTLE_AI_NO_SELF_UPDATE = "1";

    environment.systemPackages = with pkgs; [
      bashInteractive
      curl
      git
      gentleAi
    ];
  };
}
