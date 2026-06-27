{ ... }: {
  flake.nixosModules.jellyfin = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-desktop
      jellyfin-ffmpeg
      jellyfin-media-player
      jellyfin-web
    ];
  };
}
