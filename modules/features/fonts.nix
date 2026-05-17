{ self, inputs, ... }: {

  flake.nixosModules.fonts = { pkgs, ... }: {
    fonts = {
      enableDefaultPackages = true;
      fontconfig.enable = true;
      packages = with pkgs; [
        font-awesome
        inconsolata
        jetbrains-mono
        source-code-pro
        nerd-fonts.fira-code
      ];
      fontconfig.defaultFonts.monospace = [
        "JetBrains Mono"
        "Source Code Pro"
        "Inconsolata"
      ];
    };
  };

}
