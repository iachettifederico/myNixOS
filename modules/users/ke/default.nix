{ ... }: {
  flake.nixosModules.ke = { pkgs, ... }:
  let
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
        makeWrapper ${pkgs.nodejs_22}/bin/node $out/bin/bower \
          --add-flags $out/lib/node_modules/bower/bin/bower \
          --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.git ]}
      '';

      meta.mainProgram = "bower";
    };
  in {
    users.users.ke = {
      isNormalUser = true;
      description = "Kalkomey Work";
      home = "/home/ke";
      createHome = true;
      homeMode = "700";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [
        awscli2
        nodejs_22
        nomad
        openvpn
        vault
        yarn
        legacyBower
      ];
    };
  };
}
