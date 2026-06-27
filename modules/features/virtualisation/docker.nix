{ self, inputs, ... }:
{
  flake.nixosModules.docker = { pkgs, ... }:
  {
    users.groups.docker = { };

    environment.systemPackages = with pkgs; [
      docker
      docker-compose
      lazydocker
    ];

    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;

      daemon.settings = {
        dns = [ "1.1.1.1" "8.8.8.8" ];
        experimental = true;
        features.buildkit = true;
      };
    };
  };
}
