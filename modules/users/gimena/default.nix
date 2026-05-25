{ ... }: {
  flake.nixosModules.gimena = { pkgs, ... }: {
    users.users.gimena = {
      isNormalUser = true;
      description = "Gimena";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [ ];
    };
  };
}
