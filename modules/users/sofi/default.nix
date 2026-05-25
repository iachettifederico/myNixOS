{ ... }: {
  flake.nixosModules.sofi = { pkgs, ... }: {
    users.users.sofi = {
      isNormalUser = true;
      description = "Sofi";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [ ];
    };
  };
}
