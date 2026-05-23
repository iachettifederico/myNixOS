{ self, inputs, ... }: {

  flake.nixosModules.tophHardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/400ee862-467f-42b7-a7b2-2429ed081875";
       fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/ECCD-0246";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
      };

    fileSystems."/home" =
      { device = "/dev/disk/by-uuid/3b4a589c-5399-43e6-8483-6c8c017c7305";
        fsType = "ext4";
      };

    swapDevices = [ ];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

}
