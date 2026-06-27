{ ... }: {
  flake.nixosModules.desktopUtils = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      cheese
      evince
      feh
      flameshot
      gnome-calculator
      libnotify
      nemo
      transmission_4-gtk
      xclip
      xhost
    ];
  };
}
