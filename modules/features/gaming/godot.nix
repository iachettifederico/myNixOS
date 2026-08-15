{ ... }: {
  flake.nixosModules.godot = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.godot
      pkgs.godot_4_7-export-templates-bin
    ];

    systemd.tmpfiles.rules = [
      "L+ /home/fedex/.local/share/godot/export_templates - - - - ${pkgs.godot_4_7-export-templates-bin}/share/godot/export_templates"
    ];
  };
}
