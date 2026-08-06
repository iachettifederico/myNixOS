{ inputs, ... }: {
  flake.nixosModules.qdrant = { pkgs, ... }: {
    services.qdrant = {
      enable = true;
      package = inputs.nixpkgs-qdrant.legacyPackages.${pkgs.stdenv.hostPlatform.system}.qdrant;
    };

    systemd.services.qdrant.serviceConfig.WorkingDirectory = "/var/lib/qdrant";
  };
}
