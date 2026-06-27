{ ... }: {
  flake.nixosModules.browsers = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      brave
      firefox-devedition
    ];
  };
}
