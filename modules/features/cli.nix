{ self, inputs, ... }: {
  flake.nixosModules.cli = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      bat
      curl
      fd
      htop
      jq
      mc
      ripgrep
      tree
    ];
  };
}
