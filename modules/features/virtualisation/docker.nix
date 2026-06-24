{ self, inputs, ... }:
{
  flake.nixosModules.docker = { ... }:
  {
    users.groups.docker = { };

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
