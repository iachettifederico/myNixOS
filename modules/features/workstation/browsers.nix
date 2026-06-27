{ ... }: {
  flake.nixosModules.workstationBrowsers = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      brave
      firefox-devedition
    ];
  };
}
