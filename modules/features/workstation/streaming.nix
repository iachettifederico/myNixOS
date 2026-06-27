{ ... }: {
  flake.nixosModules.workstationStreaming = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      obs-studio
    ];
  };
}
