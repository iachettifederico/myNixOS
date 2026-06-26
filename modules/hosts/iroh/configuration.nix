{ self, inputs, ... }: {
  flake.nixosModules.irohConfiguration = { config, pkgs, lib, ... }:
  let
    syncthingHome = "/srv/syncthing";
  in {
    imports = [
      self.nixosModules.irohHardware

      self.nixosModules.cli
      self.nixosModules.openssh
      self.nixosModules.ruby
      self.nixosModules.fedex
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "iroh";
    networking.networkmanager.enable = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    time.timeZone = "America/Argentina/Cordoba";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "es_AR.UTF-8";
      LC_IDENTIFICATION = "es_AR.UTF-8";
      LC_MEASUREMENT = "es_AR.UTF-8";
      LC_MONETARY = "es_AR.UTF-8";
      LC_NAME = "es_AR.UTF-8";
      LC_NUMERIC = "es_AR.UTF-8";
      LC_PAPER = "es_AR.UTF-8";
      LC_TELEPHONE = "es_AR.UTF-8";
      LC_TIME = "es_AR.UTF-8";
    };

    console.keyMap = "us-acentos";

    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    services.syncthing = {
      enable = true;
      user = "syncthing";
      group = "syncthing";
      dataDir = syncthingHome;
      configDir = "${syncthingHome}/config";
      openDefaultPorts = true;
    };

    networking.firewall.allowedTCPPorts = [ 22 ];

    users.groups.syncthing = { };
    users.users.syncthing = {
      isSystemUser = true;
      group = "syncthing";
      home = syncthingHome;
      createHome = true;
      description = "Syncthing service account";
    };

    users.users.fedex.extraGroups = [ "syncthing" ];

    systemd.tmpfiles.rules = [
      "d ${syncthingHome} 0750 syncthing syncthing -"
      "d ${syncthingHome}/config 0750 syncthing syncthing -"
    ];

    environment.systemPackages = with pkgs; [
      jq
      tree
    ];

    security.sudo.extraRules = [
      {
        groups = [ "wheel" ];
        commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
      }
    ];

    system.stateVersion = "25.11";
  };
}
