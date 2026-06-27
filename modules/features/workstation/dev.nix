{ ... }: {
  flake.nixosModules.workstationDev = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      cargo
      difftastic
      entr
      graphviz
      jdk21
      python3Packages.weasyprint
      rustc
      git-lfs
      unzip
      vim
      watchman
    ];
  };
}
