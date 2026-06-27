{ self, inputs, ... }: {

  flake.nixosModules.azulaConfiguration = { config, pkgs, lib, ... }:
  let
    systemdSystemGenerators = pkgs.runCommand "system-generators" {
      preferLocalBuild = true;
      packages = config.systemd.packages;
    } ''
      set -e
      shopt -s nullglob
      mkdir -p "$out"
      for package in $packages
      do
        for hook in "$package"/lib/systemd/system-generators/*
        do
          ln -s "$hook" "$out/"
        done
      done
      ${lib.concatStrings (lib.mapAttrsToList (name: target: "ln -s ${target} $out/${name};\n") config.systemd.generators)}
    '';
  in {
    imports = [
      /etc/nixos/hardware-configuration.nix

      self.nixosModules.cli
      self.nixosModules.emacs
      self.nixosModules.fonts
      self.nixosModules.pipewire
      self.nixosModules.ruby
      self.nixosModules.npm
      self.nixosModules.openssh
      self.nixosModules.i3
      self.nixosModules.docker
      self.nixosModules.libvirt
      self.nixosModules.workstation
      self.nixosModules.opencode
      self.nixosModules.fedex
      self.nixosModules.ke
      self.nixosModules.jarvis
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "azula";
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

    services.xserver.deviceSection = ''
      Option "AllowFlipping" "off"
    '';

    services.xserver.screenSection = ''
      Option "nvidiaXineramaInfoOrder" "DP-5,DP-0,DP-3"
      Option "XVideoSyncToDisplayID" "DP-0"

      Option "metamodes" "DP-5: nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DP-0: nvidia-auto-select +2560+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DP-3: nvidia-auto-select +6400+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
      Option "TripleBuffer" "on"
    '';

    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.xrandr}/bin/xrandr --output DP-0 --primary
    '';

    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "fedex";

    services.picom = {
      enable = true;
      vSync = true;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      nvidiaSettings = true;
    };

    environment.sessionVariables = {
      __GL_SYNC_TO_VBLANK = "1";
      __GL_SYNC_DISPLAY_DEVICE = "DP-0";
    };

    console.keyMap = "us-acentos";

    services.printing.enable = true;
    environment.etc."systemd/system-generators".source = lib.mkForce systemdSystemGenerators;

    security.sudo.extraRules = [
      {
        groups = [ "wheel" ];
        commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
      }
    ];

    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    boot.kernel.sysctl."net.ipv6.ip_forward" = 1;

    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
      config.hardware.nvidia.package
    ];

    services.jellyfin = {
      enable = true;
      openFirewall = true;
      user = "fedex";
    };

    services.syncthing = {
      enable = true;
      user = "fedex";
      dataDir = "/home/fedex/.local/share/syncthing";
      configDir = "/home/fedex/.config/syncthing";
      openDefaultPorts = true;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "fiachetti@omashu.com";
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;

      virtualHosts."jellyfin.omashu.org" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
        };
      };

      virtualHosts."kraken.omashu.org" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://192.168.122.50:4568";
          proxyWebsockets = true;
        };
      };
    };

    services.qdrant = {
      enable = true;
      settings = {
        service = {
          host = "127.0.0.1";
          http_port = 6333;
          grpc_port = 6334;
        };
        storage = {
          storage_path = "/var/lib/qdrant/storage";
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
    };

    system.stateVersion = "25.05";
  };
}
