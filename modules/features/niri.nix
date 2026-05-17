{ self, inputs, ... }: {
  
  perSystem = { pkgs, lib, ... }: {
    
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;

      settings = {
        input.keyboard.xkb = {
          layout = "us";
          variant = "intl";
        };

        layout.gaps = 5;

        binds = {
          "Alt+Return".spawn-sh = lib.getExe pkgs.terminator;
          "Mod+Return".spawn-sh = lib.getExe pkgs.terminator;
          "Mod+A".spawn-sh = lib.getExe pkgs.terminator;
          # "Mod+a".spawn-sh = lib.getExe pkgs.xterm;
          "Mod+Q".close-window = null;
        };
      };
    };

  };

}
