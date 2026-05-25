{ self, inputs, ... }: {

  flake.nixosModules.myMachineConfiguration = { config, pkgs, ... }:
  let
    keShell = pkgs.writeShellScript "ke-shell" ''
      exec ${pkgs.sudo}/bin/sudo -u ke -H ${pkgs.zsh}/bin/zsh -l
    '';

    keEmacs = pkgs.writeShellScript "ke-emacs" ''
      exec ${pkgs.sudo}/bin/sudo --preserve-env=DISPLAY,XAUTHORITY,DBUS_SESSION_BUS_ADDRESS,XDG_RUNTIME_DIR -u ke -H ${pkgs.emacs}/bin/emacs "$@"
    '';

    keFirefox = pkgs.writeShellScript "ke-firefox" ''
      exec ${pkgs.sudo}/bin/sudo --preserve-env=DISPLAY,XAUTHORITY,DBUS_SESSION_BUS_ADDRESS,XDG_RUNTIME_DIR -u ke -H ${pkgs.firefox}/bin/firefox "$@"
    '';

    keFirefoxDevedition = pkgs.writeShellScript "ke-firefox-devedition" ''
      exec ${pkgs.sudo}/bin/sudo --preserve-env=DISPLAY,XAUTHORITY,DBUS_SESSION_BUS_ADDRESS,XDG_RUNTIME_DIR -u ke -H ${pkgs.firefox-devedition}/bin/firefox-devedition "$@"
    '';

    keGhostty = pkgs.writeShellScript "ke-ghostty" ''
      exec ${pkgs.sudo}/bin/sudo --preserve-env=DISPLAY,XAUTHORITY,DBUS_SESSION_BUS_ADDRESS,XDG_RUNTIME_DIR -u ke -H ${pkgs.ghostty}/bin/ghostty "$@"
    '';

    keRofi = pkgs.writeShellScript "ke-rofi" ''
      cmd_dir=/home/fedex/bin/ke
      choice=$(${pkgs.coreutils}/bin/printf '%s\n' \
        ke-shell \
        ke-emacs \
        ke-firefox \
        ke-firefox-devedition \
        ke-ghostty | ${pkgs.rofi}/bin/rofi -dmenu -p ke)

      test -n "$choice" || exit 0
      exec "$cmd_dir/$choice"
    '';
  in {
    imports = [ # Include the results of the hardware scan.
      self.nixosModules.myMachineHardware

      self.nixosModules.cli
      self.nixosModules.fonts
      self.nixosModules.pipewire
      self.nixosModules.ruby
      self.nixosModules.openssh
      self.nixosModules.i3
      self.nixosModules.opencode
      self.nixosModules.fedex
      self.nixosModules.sofi
      self.nixosModules.ke
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
      ${pkgs.xhost}/bin/xhost +SI:localuser:ke >/dev/null
    '';

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

    # Install firefox.
    programs.firefox.enable = true;

    programs.zsh.enable = true;

    security.sudo.extraConfig = ''
      fedex ALL=(ke) NOPASSWD:SETENV: ${pkgs.zsh}/bin/zsh, ${pkgs.emacs}/bin/emacs, ${pkgs.firefox}/bin/firefox, ${pkgs.firefox-devedition}/bin/firefox-devedition, ${pkgs.ghostty}/bin/ghostty
    '';

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [

      arandr
      emacs
      firefox-devedition
      ghostty
      git
      pandoc

    ];

    system.activationScripts.keLaunchers.text = ''
      ${pkgs.coreutils}/bin/mkdir -p /home/fedex/bin/ke
      ${pkgs.coreutils}/bin/chown fedex /home/fedex/bin /home/fedex/bin/ke

      ${pkgs.coreutils}/bin/ln -sfn ${keShell} /home/fedex/bin/ke/ke-shell
      ${pkgs.coreutils}/bin/ln -sfn ${keEmacs} /home/fedex/bin/ke/ke-emacs
      ${pkgs.coreutils}/bin/ln -sfn ${keFirefox} /home/fedex/bin/ke/ke-firefox
      ${pkgs.coreutils}/bin/ln -sfn ${keFirefoxDevedition} /home/fedex/bin/ke/ke-firefox-devedition
      ${pkgs.coreutils}/bin/ln -sfn ${keGhostty} /home/fedex/bin/ke/ke-ghostty
      ${pkgs.coreutils}/bin/ln -sfn ${keRofi} /home/fedex/bin/ke/ke-rofi
    '';

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 22 ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.11"; # Did you read the comment?

  };

}
