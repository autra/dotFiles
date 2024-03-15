# Edit this configration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  options = {
    mine.common.user = lib.mkOption	{
      type = lib.types.str;
      default = "augustin";
      example = "augustin";
      description = lib.mdDoc "The user to configure for this system";
    };
  };
  config = {
    # configure nix itself
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Bootloader.
    # TODO how to dynamize that? (cf also the device in hardware-config)
    boot.loader.grub.enable = true;
    boot.loader.grub.useOSProber = true;

    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Paris";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LANG = "en_US.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    # Configure keymap in X11
    services.xserver = {
      layout = "fr";
      xkbVariant = "bepo";
      xkbOptions = "caps:swapescape";
    };

    # Configure console keymap
    console.keyMap = "fr";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      # utils
      unzip
      htop
      iotop
      tree
      nethogs
      progress

      xclip
      wget
      curl
      lsb-release
      dua
      dysk
      eza
      fd
      fzf
      bat
      jq
      neofetch

      # shell
      tmux

      # editor
      neovim

      # git
      git
      git-extras
      tig
      delta
      glab
      lazygit

      # python
      virtualenv

      # postgres
      postgresql_16

    ];

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${config.mine.common.user} = {
      # TODO home manager? 
      # TODO link dotfiles ?
      # TODO how to deploy git-scripts ?
      shell = pkgs.zsh;
      isNormalUser = true;
      description = config.mine.common.user;
      extraGroups = [ "networkmanager" "wheel" ];
    };
    programs.zsh.enable = true;


    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?

    # my own config
    #services.nextcloud-client = {
    #  enable = true;
    #  startInBackground = true;
    #};

  };

}
