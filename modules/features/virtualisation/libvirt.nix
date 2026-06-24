{ self, inputs, ... }:
{
  flake.nixosModules.libvirt = { pkgs, ... }:
  {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        vhostUserPackages = [ pkgs.virtiofsd ];
      };
    };

    programs.virt-manager.enable = true;
  };
}
