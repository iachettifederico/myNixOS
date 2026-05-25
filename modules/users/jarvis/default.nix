{ ... }: {
  flake.nixosModules.jarvis = { pkgs, ... }: {
    users.users.jarvis = {
      isNormalUser = true;
      description = "Jarvis";
      home = "/home/jarvis";
      createHome = true;
      homeMode = "700";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [ ];
    };
  };
}
