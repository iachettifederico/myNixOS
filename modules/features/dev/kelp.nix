{ ... }: {
  flake.nixosModules.kelp = { pkgs, ruby-packages, ... }:
  let
    nodejs_22_14 = pkgs.nodejs_22.overrideAttrs (_old: {
      version = "22.14.0";
      src = pkgs.fetchurl {
        url = "https://nodejs.org/dist/v22.14.0/node-v22.14.0.tar.xz";
        hash = "sha256-xgmUa/eTtVx5VMJlgnYICNVMFhhdecsvuIBl5S3iGRQ=";
      };
    });

    legacyBower = pkgs.stdenvNoCC.mkDerivation {
      pname = "bower";
      version = "1.8.14";

      src = pkgs.fetchurl {
        url = "https://registry.npmjs.org/bower/-/bower-1.8.14.tgz";
        hash = "sha512-8Rq058FD91q9Nwthyhw0la9fzpBz0iwZTrt51LWl+w+PnJgZk9J+5wp3nibsJcIUPglMYXr4NRBaR+TUj0OkBQ==";
      };

      nativeBuildInputs = [ pkgs.makeWrapper ];

      unpackPhase = ''
        tar -xzf $src
      '';

      installPhase = ''
        mkdir -p $out/lib/node_modules $out/bin
        cp -r package $out/lib/node_modules/bower
        makeWrapper ${nodejs_22_14}/bin/node $out/bin/bower \
          --add-flags $out/lib/node_modules/bower/bin/bower \
          --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.git ]}
      '';

      meta.mainProgram = "bower";
    };

    kelpPackages = with pkgs; [
      autoconf
      automake
      binutils
      bison
      cargo
      curl
      file
      gcc
      gnumake
      git
      gnupg
      imagemagick
      libffi
      libtool
      libxml2
      libxslt
      libyaml
      mariadb.client
      nasm
      netcat-openbsd
      nodejs_22_14
      openssh
      openssl
      pkg-config
      protobuf
      python3
      readline
      rustc
      ruby-packages."ruby-3.4.9"
      unzip
      vim
      wget
      libX11
      libXext
      libXrender
      yarn
      zlib
      legacyBower
    ];
  in {
    users.users.fedex.packages = kelpPackages;
  };
}
