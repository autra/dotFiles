{ config, pkgs, ... }:
{
  imports = [ ../common/options.nix ];
  config.environment.systemPackages = with pkgs; [
    lxc
    lxd-lts
    vagrant
    ansible
    virt-manager
    # libvirt

    # for vagrant shared folders
    # nfs-utils
  ];

  # Minimal configuration for NFS support with Vagrant.
  config.services.nfs.server.enable = true;

  # Add firewall exception for libvirt provider when using NFSv4 
  config.networking.firewall.interfaces."virbr1" = {
    allowedTCPPorts = [ 2049 ];
    allowedUDPPorts = [ 2049 ];
  };

  # docker
  config.virtualisation.docker.enable = true;

  # lxc/lxd
  config.virtualisation.lxc.enable = true;
  config.virtualisation.lxd.enable = true;


  config.virtualisation.spiceUSBRedirection.enable = true;

  config.virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };

  config.users.users.${config.mine.common.user}.extraGroups = [ "docker" "libvirtd" ];
}
