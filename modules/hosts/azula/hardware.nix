{ self, inputs, ... }: {

  flake.nixosModules.azulaHardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ "dm-snapshot" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

fileSystems."/" =
    { device = "/dev/mapper/vg_main-os";
    fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A6DB-3131";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/home" =
    { device = "/dev/mapper/vg_main-home";
    fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/mapper/vg_main-swap"; }
    ];

  fileSystems."/home/fedex/Data" = {
    device = "/dev/vg_main/data";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/home/fedex/Books" = {
    device = "/dev/vg_main/books";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  # fileSystems."/home/fedex/Isos" = {
  #   device = "/dev/vg-data/isos";
  #   fsType = "ext4";
  #   options = [ "nofail" ];
  # };

  fileSystems."/home/fedex/.local/share/Steam" = {
    device = "/dev/vg_main/gaming";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/home/fedex/VMs" = {
    device = "/dev/vg_main/vms";
    fsType = "ext4";
    options = [ "nofail" ];
  };

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
