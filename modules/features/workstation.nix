{ ... }:
{
  flake.nixosModules.workstation = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "1password"
      "1password-gui"
    ];

    programs.firefox.enable = true;
    programs.zsh.enable = true;

    xdg.mime.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };

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
