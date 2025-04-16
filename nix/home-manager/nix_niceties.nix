{ config, pkgs, ...}:

{
  environment.systemPackages = with pkgs.kdePackages; [
    nix-inspect
  ];
  
}

