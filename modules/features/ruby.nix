{ inputs, ... }: {
  flake.nixosModules.ruby = { pkgs, ruby-packages, lib, ... }: {
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

  perSystem = { pkgs, system, lib, ... }:
  let
    rubyPackages = inputs.nixpkgs-ruby.packages.${system};

    mkRubyShell = name: ruby: pkgs.mkShell {
      buildInputs = with pkgs; [
        ruby
        cargo
        rustc
        libyaml
        openssl
        zlib
        readline
        pkg-config
        gcc
        gnumake
        libffi
        gtk3
      ];

      shellHook = ''
        export GEM_HOME="$PWD/.direnv/gems/${name}"
        export GEM_PATH="$GEM_HOME"
        export PATH="$GEM_HOME/bin:$PATH"
        export LD_LIBRARY_PATH="${lib.makeLibraryPath [
          pkgs.gtk3
          pkgs.pango
          pkgs.cairo
          pkgs.gdk-pixbuf
          pkgs.glib
          pkgs.atk
        ]}:$LD_LIBRARY_PATH"
        mkdir -p "$GEM_HOME"
      '';
    };
  in {
    devShells = {
      ruby-2-7 = mkRubyShell "ruby-2-7" rubyPackages."ruby-2.7.6";
      ruby-3-4 = mkRubyShell "ruby-3-4" rubyPackages."ruby-3.4.9";
      default = mkRubyShell "ruby-3-4" rubyPackages."ruby-3.4.9";
    };
  };
}
