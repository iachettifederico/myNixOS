{ self, inputs, ... }: {
  flake.nixosModules.systemStorage = { config, lib, ... }:
    lib.mkMerge [
      {
        nix = {
          gc = {
            automatic = true;
            dates = "Sun 03:15";
            options = "--delete-older-than 14d";
          };

          optimise = {
            automatic = true;
            dates = "Sun 04:15";
          };

          settings = {
            min-free = lib.mkDefault (5 * 1024 * 1024 * 1024);
            max-free = lib.mkDefault (10 * 1024 * 1024 * 1024);
          };
        };
      }

      (lib.mkIf config.boot.loader.systemd-boot.enable {
        boot.loader.systemd-boot.configurationLimit = 10;
      })

      (lib.mkIf config.boot.loader.grub.enable {
        boot.loader.grub.configurationLimit = 10;
      })
    ];
}
