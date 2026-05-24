{ ... }: {
  flake.nixosModules.ruby = { pkgs, ruby-packages, ... }: {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    environment.systemPackages = with pkgs; [
      bundix
      direnv
      ruby-packages."ruby-4"
    ];

    programs.zsh.interactiveShellInit = ''
      export GEM_HOME="$HOME/.local/share/gem/ruby/4.0.0"
      export PATH="$GEM_HOME/bin:$PATH"
    '';

    nixpkgs.overlays = [
      (final: prev: ruby-packages)
    ];
  };
}
