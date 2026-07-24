{ ... }: {
  flake.nixosModules.desktopUtils = { pkgs, ... }: {
    environment.etc."xdg/flameshot/flameshot.ini".text = ''
      [General]
      useX11LegacyScreenshot=true
    '';

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
