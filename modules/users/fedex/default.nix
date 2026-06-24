{ ... }: {
  flake.nixosModules.fedex = { pkgs, ... }: {
    users.users.fedex = {
      isNormalUser = true;
      description = "Federico Martín Iachetti";
      uid = 1000;
      group = "fedex";
      extraGroups = [ "docker" "libvirtd" "networkmanager" "wheel" "users" ];
      shell = pkgs.zsh;
      packages = with pkgs; [ ];
    };

    users.groups.fedex = {
      gid = 1000;
    };
  };
}
