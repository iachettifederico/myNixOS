{ ... }: {
  flake.nixosModules.i3 = { pkgs, ... }: {
    services.xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      windowManager.i3.enable = true;

      xkb = {
        layout = "us";
        variant = "intl";
      };
    };

    services.displayManager.defaultSession = "none+i3";

    environment.systemPackages = with pkgs; [
      arandr
      dunst
      i3status
      pavucontrol
      rofi
      xmodmap
    ];
  };
}
