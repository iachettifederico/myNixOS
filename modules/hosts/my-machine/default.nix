{ self, inputs, ... }: {
  flake.nixosConfigurations.myMachine = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      pkgs-master = import inputs.nixpkgs-master { system = "x86_64-linux"; };
    };

    modules = [
      self.nixosModules.myMachineConfiguration
    ];
  };
}
