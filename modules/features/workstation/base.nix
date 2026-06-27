{ ... }: {
  flake.nixosModules.workstationBase = { pkgs, ... }: {
    programs.firefox.enable = true;
    programs.zsh.enable = true;

    environment.sessionVariables = {
      PATH = "$HOME/bin:$PATH";
      XCURSOR_THEME = "Adwaita";
    };

    xdg.portal = {
      enable = true;
      config.common.default = [ "gtk" ];
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
