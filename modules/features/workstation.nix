{ self, inputs, ... }:
{
  flake.nixosModules.workstation = { pkgs, ... }:
  {
    imports = [
      self.nixosModules.workstationBase
      self.nixosModules.workstationDev
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
      audacity
      brave
      cheese
      claude-code
      discord
      docker
      docker-compose
      evince
      feh
      ferdium
      ffmpeg
      firefox-devedition
      flameshot
      foliate
      ghostty
      gnome-calculator
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
      kitty
      lazydocker
      ledger
      libnotify
      nemo
      obs-studio
      openvpn
      pavucontrol
      git-lfs
      slack
      tangram
      telegram-desktop
      terminator
      tilda
      transmission_4-gtk
      unzip
      vault
      virtiofsd
      vlc
      watchman
      xclip
      xhost
      awscli2
      nomad
    ];
  };
}
