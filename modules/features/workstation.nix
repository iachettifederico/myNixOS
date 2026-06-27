{ self, inputs, ... }:
{
  flake.nixosModules.workstation = { pkgs, ... }:
  {
    imports = [
      self.nixosModules.workstationBase
      self.nixosModules.workstationDev
      self.nixosModules.workstationBrowsers
      self.nixosModules.workstationChat
      self.nixosModules.workstationDesktopUtils
      self.nixosModules.workstationMedia
      self.nixosModules.workstationTerminals
      self.nixosModules.steam
      self.nixosModules.onepassword
      self.nixosModules.weylus
    ];

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "1password"
      "1password-gui"
    ];

    environment.systemPackages = with pkgs; [
      claude-code
      docker
      docker-compose
      ffmpeg
      godot
      hledger
      hledger-interest
      hledger-ui
      hledger-web
      jellyfin
      jellyfin-desktop
      jellyfin-ffmpeg
      jellyfin-media-player
      jellyfin-web
      lazydocker
      ledger
      obs-studio
      openvpn
      pavucontrol
      git-lfs
      unzip
      vault
      virtiofsd
      watchman
      awscli2
      nomad
    ];
  };
}
