{ ... }: {
  flake.nixosModules.i3 = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      dunst
      i3status
      pavucontrol
      rofi
      xmodmap
    ];
  };
}
