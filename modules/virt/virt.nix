{ config, pkgs, lib, ... }:

{

  options.virtUtils.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable virt tools (virt-manager, kvm, etc.)";
  };

 config = lib.mkIf config.sysUtils.enable {

   virtualisation.docker = {
     enable = true; # The main daemon must be enabled
     rootless = {
       enable = true;
       setSocketVariable = true; # Sets DOCKER_HOST automatically
     };
   };

   virtualisation.libvirtd = {
     enable = true;
     qemu = {
       package = pkgs.qemu_kvm;
       runAsRoot = true;
       swtpm.enable = true;
       ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
          }).fd];
        };
      };
    };
  };
}
