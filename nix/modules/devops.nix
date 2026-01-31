{ config, pkgs, ... }:
{
  imports = [ ../common/options.nix ];
  config.environment.systemPackages = with pkgs; [
    lxc
    vagrant
    ansible
    virt-manager
    libvirt

    # for vagrant shared folders
    # nfs-utils
  ];

  # Minimal configuration for NFS support with Vagrant.
  config.services.nfs.server.enable = true;

  # Add firewall exception for libvirt provider when using NFSv4 
  config.networking.firewall = {
    allowedTCPPorts = [ 53 2049 ];
    allowedUDPPorts = [ 53 67 68 2049 ];
  };

  # docker
  config.virtualisation.docker.enable = true;

  # lxc/lxd
  config.virtualisation.incus.enable = true;
  config.networking.nftables.enable = true;

  config.virtualisation.spiceUSBRedirection.enable = true;

  config.virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = [pkgs.virtiofsd ];
    };
  };

  config.virtualisation.waydroid.enable = true;

  config.users.users.${config.mine.common.user}.extraGroups = [ "docker" "libvirtd" ];
}
