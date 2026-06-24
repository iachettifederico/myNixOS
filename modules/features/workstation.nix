{ self, inputs, ... }:
{
  flake.nixosModules.workstation = { pkgs, ... }:
  {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "1password"
      "1password-gui"
    ];

    programs.firefox.enable = true;
    programs.zsh.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "fedex" ];
    };

    programs.weylus = {
      enable = true;
      openFirewall = true;
      users = [ "fedex" ];
    };

    environment.sessionVariables = {
      PATH = "$HOME/bin:$PATH";
      XCURSOR_THEME = "Adwaita";
    };

    xdg.portal = {
      enable = true;
      config.common.default = [ "gtk" ];
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    environment.systemPackages = with pkgs; [
      audacity
      brave
      cheese
      claude-code
      cargo
      difftastic
      discord
      docker
      docker-compose
      entr
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
      graphviz
      hledger
      hledger-interest
      hledger-ui
      hledger-web
      jdk21
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
      python3Packages.weasyprint
      rustc
      git-lfs
      slack
      tangram
      telegram-desktop
      terminator
      tilda
      transmission_4-gtk
      unzip
      vault
      vim
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
