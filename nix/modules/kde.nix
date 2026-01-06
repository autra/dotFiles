{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  services.displayManager.ly.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    variant = "bepo";
    options = "caps:swapescape";
    layout = "fr";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable networkmanager
  networking.networkmanager = {
    enable = true;
    plugins = [
      networkmanager-fortisslvpn
      networkmanager-openvpn
    ];
  };

  programs.kdeconnect.enable = true;
  programs.kclock.enable = true;

  environment.systemPackages = with pkgs.kdePackages; [
    kate
    kcalc
    kcolorchooser
    plasma-browser-integration
    skanpage
    skanlite
    partitionmanager
    dolphin-plugins
    ktorrent
    kup
    pkgs.wl-clipboard
  ];
}
