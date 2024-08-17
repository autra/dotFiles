{ config, pkgs, ... }:
{
  config.environment.systemPackages = with pkgs; [
    lxc
    lxd-lts
    vagrant
    ansible
    # libvirt

    # for vagrant shared folders
    # nfs-utils
  ];

  # Minimal configuration for NFS support with Vagrant.
  config.services.nfs.server.enable = true;

  # Add firewall exception for VirtualBox provider 
  config.networking.firewall.extraCommands = ''
    ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
  '';

  # Add firewall exception for libvirt provider when using NFSv4 
  config.networking.firewall.interfaces."virbr1" = {
    allowedTCPPorts = [ 2049 ];
    allowedUDPPorts = [ 2049 ];
  };

  # virtualbox
  config.nixpkgs.config.allowUnfree = true;
  config.virtualisation.virtualbox.host.enable = true;
  config.users.extraGroups.vboxusers.members = [ config.mine.common.user ];
  config.virtualisation.virtualbox.host.enableExtensionPack = true;
  config.virtualisation.virtualbox.guest.enable = true;

  # docker
  config.virtualisation.docker.enable = true;

  # lxc/lxd
  config.virtualisation.lxc.enable = true;
  config.virtualisation.lxd.enable = true;


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
