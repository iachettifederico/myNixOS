{ ... }: {
  flake.nixosModules.qtile = { pkgs, ... }: {
    services.xserver.windowManager.qtile = {
      enable = true;
      package = pkgs.python3Packages.qtile.overrideAttrs (oldAttrs: {
        passthru = oldAttrs.passthru // {
          providedSessions = [ "qtile-generic" ];
        };
      });
      configFile = ./qtile/config.py;
    };
  };
}
