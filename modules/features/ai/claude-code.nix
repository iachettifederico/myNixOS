{ ... }: {
  flake.nixosModules.claudeCode = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.claude-code
    ];
  };
}
