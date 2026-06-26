{ self, inputs, ... }: {
  flake.nixosConfigurations.iroh = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      emacsWithGrammars = self.packages.x86_64-linux.emacsWithGrammars;
      pkgs-master = import inputs.nixpkgs-master { system = "x86_64-linux"; };
      ruby-packages = inputs.nixpkgs-ruby.packages.x86_64-linux;
    };

    modules = [
      self.nixosModules.irohConfiguration
    ];
  };
}
