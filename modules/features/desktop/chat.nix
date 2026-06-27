{ ... }: {
  flake.nixosModules.chat = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      discord
      ferdium
      slack
      telegram-desktop
      tangram
    ];
  };
}
