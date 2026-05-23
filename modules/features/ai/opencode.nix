{ self, inputs, ... }: {
  flake.nixosModules.opencode = { pkgs-master, ... }: {
    environment.systemPackages = [
      pkgs-master.opencode
    ];
  };
}
