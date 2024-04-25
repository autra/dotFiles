{ config, pkgs, ... }:
# TODO param for refs?
let
  arch = if pkgs.system == "x86_64-linux" then 
      "linux-amd64" 
    else if pkgs.system == "aarch64-linux" then
      "linux-arm64" 
    else 
      "unknown";
  ohMyZshPath = fetchGit { 
    url = "https://github.com/ohmyzsh/ohmyzsh.git";
    ref = "master";
  };
  tpmPath = builtins.fetchGit {
    url = "https://github.com/tmux-plugins/tpm.git";
    ref = "refs/tags/v3.1.0";
    allRefs = true;
  };
  pgenvPath = fetchGit {
    url = "https://github.com/theory/pgenv";
    ref = "master";
  };
  planExporterPath = fetchTarball {
    url = "https://github.com/agneum/plan-exporter/releases/download/v0.0.6/plan-exporter-0.0.6-${arch}.tar.gz";
    sha256 = if arch == "linux-amd64" then
        "0lz2b4gpkbw0xriaqmcinscfscd57ixgy4x4y00jnqp59gx5mar0"
      else if arch == "linux-arm64" then
        "0crswadc3ds1xrn2knzh8p7x6g26lc8ahcxwyh4n81jcb336m3wi"
      else
        "none";
  };
  # osladoc = import /home/augustin/repos/Communication/pandoc;
in rec {

  # targets.genericLinux.enable = true;

  # nix = {
  #   package = pkgs.nix;
  #   settings.experimental-features = [ "nix-command" "flakes" ];
  # };
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "augustin";
  home.homeDirectory = "/home/augustin";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    # prerequisite
    fira-code-nerdfont 

    # util
    autossh
    bup # kde includes kup, which is a frontend integration into settings

    # monitoring
    ctop

    # shell
    fzf
    oh-my-zsh
    autojump
    starship
    eza
    # utils
    tokei
    # powerline
    powerline
    powerline-symbols
    # editors
    neovim
    lunarvim
    # git 
    git-lfs
    delta
    glab
    lazygit
    git-crypt
    onefetch
    # pg
    pspg
    pgcli
    # do I need:
    # - pgenv
    # - pgxnclient
    # - pgxn 
    # with nix?

    # rust
    rustup

    # python
    virtualenv

    # sig
    gdal
    pdal

    # gpg
    gnupg
    gpg-tui

    # python311Packages.pynvim
    nodejs_20

    sieve-connect

    ffmpeg
    pkgs.nodePackages."http-server"

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.

    # SCMS
    ".gitconfig".source = home.homeDirectory + "/dotFiles/.gitconfig";
    ".git_commit_msg.txt".source = home.homeDirectory + "/dotFiles/.git_commit_msg.txt";
    ".hgrc".source = home.homeDirectory + "/dotFiles/.hgrc";
    # git scripts
    "bin/git-sw".source = home.homeDirectory + "/dotFiles/git_scripts/git-sw";
    "bin/git-delete-branches".source = home.homeDirectory + "/dotFiles/git_scripts/git-delete-branches";

    # Editor
    ".config/lvim/config.lua".source = home.homeDirectory + "/dotFiles/lunarvim/config.lua";

    # shells
    ".aliases".source = home.homeDirectory + "/dotFiles/.aliases";
    ".bashrc".source = home.homeDirectory + "/dotFiles/.bashrc";
    ".zshrc".source = home.homeDirectory + "/dotFiles/.zshrc";
    ".oh-my-zsh".source = ohMyZshPath;
    ".config/starship.toml".source = home.homeDirectory + "/dotFiles/starship.toml";
    ".tmux.conf".source = home.homeDirectory + "/dotFiles/.tmux.conf";
    ".tmux/plugins/tpm".source = tpmPath;


    # pgclients
    ".psqlrc".source = home.homeDirectory + "/dotFiles/.psqlrc";
    ".pspgconf".source = home.homeDirectory + "/dotFiles/.pspgconf";
    ".pgenv".source = pgenvPath;
    "bin/plan-exporter".source = "${planExporterPath}/plan-exporter";

    # rust
    ".rustup/settings.toml".source = home.homeDirectory + "/dotFiles/rustup_settings.toml";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
