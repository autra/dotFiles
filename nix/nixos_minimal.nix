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
    # console.colors = [
    #   "FFFFFF" # black
    #   "8c8c8c" # darkgrey
    #   "18b218" # darkred, the "OK" at startup, the g and u x of eza 
    #   "e08e8e" # red
    #   "128612" # darkgreen
    #   "ffcd9b" # green
    #   "ec8320" # brown
    #   "005f87" # yellow
    #   "b21818" # darkblue
    #   "6dc2e1" # blue
    #   "b218b2" # darmagenta
    #   "e08ee0" # magenta
    #   "159a9a" # darkcyan
    #   "8bcbcb" # cyan
    #   "bcbcbc" # lightgrey
    #   "000000" # white
    # ];
    environment.systemPackages = with pkgs; [
      # utils
      ntfs3g
      inetutils
      pciutils
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
      inotify-tools

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

      p7zip


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
    system.stateVersion = "23.11"; # Did you read the comment?

  };
}
