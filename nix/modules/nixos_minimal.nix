{ config, lib, pkgs, ... }:
{
  config = {
    # enable some shortcut with alt+print_scr+key. (h to get help in journalctl)
    boot.kernel.sysctl."kernel.sysrq" = 1;
    # for nixos build-vms
    virtualisation.vmVariant = {
      # following configuration is added only when building VM with build-vm
      virtualisation = {
        useEFIBoot = true;
        memorySize =  6128;
        cores = 4;
      };
    };

    # configure nix itself
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    # for flox
    nix.settings.trusted-substituters = [ "https://cache.flox.dev" ];
    nix.settings.trusted-public-keys = [ "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=" ];

    # test nix-ld
    programs.nix-ld.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Paris";

    # Select internationalisation properties.
    i18n.supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
    ];
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

    environment.systemPackages = with pkgs; [
      # utils
      bat
      curl
      dua
      dysk
      fd
      file
      htop
      inetutils
      inotify-tools
      iotop
      jq
      # killall, fuser and others
      psmisc
      lm_sensors
      lsb-release
      lshw
      lsof
      neofetch
      nethogs
      ntfs3g
      p7zip
      pciutils
      usbutils
      progress
      ripgrep
      tree
      unzip
      wget

      # shell
      tmux

      # editor
      nano

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
      extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "cdrom"];
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

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?

  };
}
