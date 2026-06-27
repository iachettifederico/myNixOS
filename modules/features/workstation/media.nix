{ ... }: {
  flake.nixosModules.workstationMedia = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      audacity
      ffmpeg
      foliate
      vlc
    ];
  };
}
