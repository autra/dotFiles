{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    variant = "bepo";
    options = "caps:swapescape";
    layout = "fr";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    libsForQt5.kcalc
    libsForQt5.kcolorchooser
    libsForQt5.plasma-browser-integration
    kup
  ];
    

}
