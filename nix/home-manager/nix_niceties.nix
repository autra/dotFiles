{ config, pkgs, ...}:

{
  home.packages = with pkgs; [
    nix-inspect
    nix-update
    # nix-search-tv?
    # https://discourse.nixos.org/t/npc-cli-to-view-and-bisect-nixpkgs-channel-history/71242
# https://github.com/blitz/hydrasect
  ];
  
}

