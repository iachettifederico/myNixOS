{ ... }: {
  flake.nixosModules.i3 = { pkgs, ... }: {
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
