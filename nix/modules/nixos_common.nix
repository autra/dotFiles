{ config, lib, pkgs, ... }:
let
  common = import ../common/common.nix {};
in
{
  config = {
    boot.plymouth.enable = true;
    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
      drivers = with pkgs; [ hplip hplipWithPlugin cnijfilter_4_00 ];
    };
    hardware.sane.enable = true; # enables support for SANE scanners
    hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
    # enable printer discovery (among other things?)
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      ipv4 = true;
      # apparently ipv6 often timeout, and we need to disable it
      ipv6 = false;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    programs.steam.enable = true;

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) common.unfreePkgs; 

    # TODO I'd like this to be in home-manager...
    programs.ccache.enable = true;

    # Enable networkmanager
    networking.networkmanager.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    networking.firewall.allowedUDPPortRanges = [
      # that's what fedora does (also for TCP) and I need this to make upnp work at home
      { from = 1025; to = 65535; }
    ];
    networking.firewall.allowedTCPPortRanges = [
      { from = 15432; to = 15600; }
    ];
    networking.firewall.enable = true;
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 30d --keep 20";
      flake = "/home/augustin/dotFiles/nix";
    };
    environment.systemPackages = with pkgs; [
      neovim
    ];
  };
}
