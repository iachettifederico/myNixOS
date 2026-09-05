{ ... }: {
  flake.nixosModules.pi = { pkgs, ... }:
    let
      # gentle-pi intentionally uses an absolute trusted extractor path, while
      # NixOS exposes tar through the system profile instead of /usr/bin.
      piUpdateExtensions = pkgs.buildFHSEnv {
        name = "pi-update-extensions";
        targetPkgs = packages: [ packages.gnutar ];
        runScript = pkgs.writeShellScript "pi-update-extensions" ''
          exec ${pkgs.pi-coding-agent}/bin/pi update --extensions "$@"
        '';
      };
    in
    {
      environment.systemPackages = [
        pkgs.pi-coding-agent
        piUpdateExtensions
      ];
    };
}
