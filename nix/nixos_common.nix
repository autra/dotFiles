{ config, lib, pkgs, ... }:

{
  options = {
    mine.common.user = lib.mkOption	{
      type = lib.types.str;
      default = "augustin";
      example = "augustin";
      description = "The user to configure for this system";
    };
  };
  config = {
    # enable some shortcut with alt+print_scr+key. (h to get help in journalctl)
    boot.kernel.sysctl."kernel.sysrq" = 1;
    # for nixos build-vms
    virtualisation.vmVariant = {
      # following configuration is added only when building VM with build-vm
      virtualisation = {
        useEFIBoot = true;
        memorySize =  2048; # Use 2048MiB memory.
        cores = 3;         
      };
    };

    # configure nix itself
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 30d --keep 20";
      flake = "/home/augustin/dotFiles/nix";
    };
    # test nix-ld
    # programs.nix-ld.enable = true;

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

    # Configure console keymap
    console.useXkbConfig = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      # utils
      inetutils
      lshw
      lm_sensors
      file
      killall
      unzip
      htop
      iotop
      tree
      nethogs
      progress

      wget
      curl
      lsb-release
      dua
      dysk
      fd
      bat
      jq
      neofetch
      ripgrep

      # shell
      tmux

      # editor
      neovim

      # git
      git
      git-extras
      tig


    ];

    # doc
    documentation = { 
      dev.enable = true;
      man.enable = true;
      info.enable = true;
      doc.enable = true;
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${config.mine.common.user} = {
      shell = pkgs.zsh;
      isNormalUser = true;
      description = config.mine.common.user;
      extraGroups = [ "networkmanager" "wheel" ];
      initialPassword = "test";
    };
    programs.zsh.enable = true;


    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
    };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    programs.ssh.startAgent = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    networking.firewall.allowedUDPPortRanges = [ 
      # that's what fedora does (also for TCP) and I need this to make upnp work at home
      { from = 1025; to = 65535; }
    ];
    networking.firewall.enable = true;

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
