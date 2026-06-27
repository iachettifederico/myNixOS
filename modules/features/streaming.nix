{ ... }: {
  flake.nixosModules.streaming = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      obs-studio
    ];
  };
}
