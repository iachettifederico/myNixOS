{ ... }: {
  flake.nixosModules.terminals = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      ghostty
      kitty
      terminator
      tilda
    ];
  };
}
