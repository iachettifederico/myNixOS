{ self, inputs, ... }: {

  flake.nixosModules.myMachineConfiguration = { config, pkgs, lib, ... }:
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
    imports = [ # Include the results of the hardware scan.
      self.nixosModules.myMachineHardware

      self.nixosModules.cli
      self.nixosModules.emacs
      self.nixosModules.fonts
      self.nixosModules.kalkomey
      self.nixosModules.npm
      self.nixosModules.workstation
      self.nixosModules.workstationDev
      self.nixosModules.desktopUtils
      self.nixosModules.terminals
      self.nixosModules.pipewire
      self.nixosModules.ruby
      self.nixosModules.openssh
      self.nixosModules.i3
      self.nixosModules.docker
      self.nixosModules.libvirt
      self.nixosModules.opencode
      self.nixosModules.fedex
      self.nixosModules.sofi
      self.nixosModules.ke
    ];

    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      cores = 1;
      max-jobs = 1;
    };

    # Bootloader.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/vda";
    boot.loader.grub.useOSProber = true;

    networking.hostName = "my-machine"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.xrandr}/bin/xrandr --output DP-0 --primary
    '';

    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "fedex";

    # Set your time zone.
    time.timeZone = "America/Argentina/Cordoba";

    # Select internationalisation properties.
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

    # Configure console keymap
    console.keyMap = "us-acentos";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Open ports in the firewall.
    networking.firewall = {
      allowedTCPPorts = [ 22 80 443 ];
      interfaces."virbr0".allowedTCPPorts = [ 11434 ];
    };
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    environment.etc."systemd/system-generators".source = lib.mkForce systemdSystemGenerators;

    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    boot.kernel.sysctl."net.ipv6.ip_forward" = 1;

    security.sudo.wheelNeedsPassword = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.11"; # Did you read the comment?

  };

}
