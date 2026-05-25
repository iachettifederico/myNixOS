{ ... }: {
  flake.nixosModules.ke = { pkgs, ... }: {
    users.users.ke = {
      isNormalUser = true;
      description = "Kalkomey Work";
      home = "/home/ke";
      createHome = true;
      homeMode = "700";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [ ];
    };
  };
}
