{ ... }: {
  flake.nixosModules.media = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      audacity
      ffmpeg
      foliate
      vlc
    ];
  };
}
