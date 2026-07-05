{ config
, pkgs
, lib
, ...
}:
{
  imports = [ ../common/options.nix ];
  config.environment.systemPackages =
    with pkgs;
    [
      lxc
      vagrant
      ansible
      # for vagrant shared folders
      # nfs-utils
    ]
    ++ lib.optionals (config.specialisation != { }) [
      virt-manager
      libvirt
    ];

  # Minimal configuration for NFS support with Vagrant.
  config.services.nfs.server.enable = true;

  # Add firewall exception for libvirt provider when using NFSv4
  config.networking.firewall = {
    allowedTCPPorts = [
      53
      2049
    ];
    allowedUDPPorts = [
      53
      67
      68
      2049
    ];
  };

  # docker
  config.virtualisation.docker.enable = true;

  # lxc/lxd
  config.virtualisation.incus.enable = true;
  config.networking.nftables.enable = true;

  config.virtualisation.spiceUSBRedirection.enable = true;

  config.virtualisation.libvirtd = lib.mkIf (config.specialisation != { }) {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  # config.virtualisation.waydroid.enable = true;
  config.specialisation = {
    virtualbox.configuration = {

      config.virtualisation.virtualbox = {
        host = {
          enable = true;
          enableExtensionPack = true;
        };
        guest = {
          enable = true;
          clipboard = true;
          dragAndDrop = true;

        };
      };
      config.users.users.${config.mine.common.user}.extraGroups = [
        "vboxusers"
      ];
    };

  };

  config.users.users.${config.mine.common.user}.extraGroups = [
    "docker"
  ]
  ++ lib.optionals (config.specialisation != { }) [ "libvirtd" ];
}
