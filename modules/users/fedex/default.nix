{ ... }: {
  flake.nixosModules.fedex = { pkgs, ... }: {
    users.users.fedex = {
      isNormalUser = true;
      description = "Federico M. Iachetti";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [ ];
    };
  };
}
