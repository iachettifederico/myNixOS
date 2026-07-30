{ ... }: {
  flake.nixosModules.notes = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
