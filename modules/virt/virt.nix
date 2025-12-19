{ config, pkgs, lib, ... }:

{

  options.virtUtils.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable virt tools (virt-manager, kvm, etc.)";
  };

 config = lib.mkIf config.sysUtils.enable {

   virtualisation.libvirtd = {
     enable = true;
     qemu = {
       package = pkgs.qemu_kvm;
       runAsRoot = true;
       swtpm.enable = true;

      };
    };
  };
}
