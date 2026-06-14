{ self, inputs, ... }: {
  flake.nixosModules.cli = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      bat
      curl
      fd
      gh
      htop
      jq
      mc
      ripgrep
      tree
    ];
  };
}
