{ config, pkgs, ...}:

{
  home.packages = with pkgs; [
    nix-inspect
  ];
  
}

