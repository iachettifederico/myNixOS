{ ... }: {
  flake.nixosModules.sofi = { pkgs, ... }: {
    users.users.sofi = {
      isNormalUser = true;
      description = "Sofi";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [ ];
    };

    environment.loginShellInit = ''
      if [ "$USER" = "sofi" ]; then
        export LANG="es_AR.UTF-8"
        export LANGUAGE="es_AR:es"
      fi
    '';
  };
}
