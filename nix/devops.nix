{config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    # devops
    docker
    virtualbox
    lxc
    lxd
    vagrant
  ];
}
