{ self, ... }: {
  flake.nixosModules.godotDevelopment = { pkgs, ... }: {
    imports = [ self.nixosModules.godot ];

    environment.systemPackages = with pkgs; [
      blender
      krita
    ];
  };
}
