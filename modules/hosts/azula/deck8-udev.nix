{ self, inputs, ... }: {
  flake.nixosModules.azulaDeck8Udev = { pkgs, ... }: {
    services.udev.packages = [
      (pkgs.writeTextDir "etc/udev/rules.d/70-deck8-hid-uaccess.rules" ''
        # Priority 70 runs after USB device identification.
        SUBSYSTEM=="hidraw", ENV{ID_BUS}=="usb", ENV{ID_VENDOR_ID}=="cbbc", ENV{ID_MODEL_ID}=="c101", ENV{ID_USB_INTERFACE_NUM}=="01", TAG+="uaccess"
      '')
    ];
  };
}
