{
  self,
  inputs,
  ...
}: let
  gentleAiRelease = system: let
    releases = {
      x86_64-linux = {
        url = "https://github.com/Gentleman-Programming/gentle-ai/releases/download/v2.6.0/gentle-ai_2.6.0_linux_amd64.tar.gz";
        hash = "sha256-Hb9OTrwrDQ4PPwA6d8os8P7ce00+X4WTmr64d2lGMPA=";
      };
      aarch64-linux = {
        url = "https://github.com/Gentleman-Programming/gentle-ai/releases/download/v2.6.0/gentle-ai_2.6.0_linux_arm64.tar.gz";
        hash = "sha256-n8Q2eUdkhvsjTDAskfjhX9fYeOQ94RBMLr3d1ouqqVs=";
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
      version = "2.6.0";
      src = pkgs.fetchurl release;

      sourceRoot = ".";
      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        install -Dm755 gentle-ai "$out/bin/gentle-ai"
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
