{ self, inputs, ... }: {
  flake.nixosConfigurations.toph = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      pkgs-master = import inputs.nixpkgs-master { system = "x86_64-linux"; };
    };

    modules = [
      self.nixosModules.tophConfiguration
    ];
  };
}
