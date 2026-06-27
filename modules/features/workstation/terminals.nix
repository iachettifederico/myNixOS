{ ... }: {
  flake.nixosModules.workstationTerminals = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      ghostty
      kitty
      terminator
      tilda
    ];
  };
}
