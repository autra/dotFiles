{config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    virtualbox
    lxc
    lxd
    vagrant
    ansible
  ];

  # docker
  virtualisation.docker.enable = true;
  users.users.${config.mine.common.user} = {
    extraGroups = [ "docker" ];
  };
}
