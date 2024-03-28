{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    # devops
    docker
    virtualbox
    lxc
    lxd
    vagrant
  ];
}
