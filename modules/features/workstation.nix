{ self, inputs, ... }:
{
  flake.nixosModules.workstation = { pkgs, ... }:
  {
    imports = [
      self.nixosModules.claudeCode
      self.nixosModules.workstationBase
      self.nixosModules.workstationDev
      self.nixosModules.workstationBrowsers
      self.nixosModules.workstationChat
      self.nixosModules.workstationDesktopUtils
      self.nixosModules.workstationFinance
      self.nixosModules.jellyfin
      self.nixosModules.godot
      self.nixosModules.workstationMedia
      self.nixosModules.workstationStreaming
      self.nixosModules.workstationTerminals
      self.nixosModules.steam
      self.nixosModules.onepassword
      self.nixosModules.weylus
    ];

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "1password"
      "1password-gui"
    ];

    environment.systemPackages = with pkgs; [
    ];
  };
}
