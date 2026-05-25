{ ... }: {
  flake.nixosModules.emma = { pkgs, ... }: {
    users.users.emma = {
      isNormalUser = true;
      description = "Emma";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [ ];
    };
  };
}
