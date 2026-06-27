{ ... }: {
  flake.nixosModules.workstationChat = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      discord
      ferdium
      slack
      telegram-desktop
      tangram
    ];
  };
}
