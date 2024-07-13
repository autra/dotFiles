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
    fira-code-nerdfont 

    # util
    autossh
    bup # kde includes kup, which is a frontend integration into settings
    ipcalc

    # monitoring
    ctop

    # shell
    fzf
    oh-my-zsh
    autojump
    eza
    # utils
    tokei
    dogdns
    imagemagick
    # powerline
    powerline
    powerline-symbols
    # editors
    neovim
    lunarvim
    gnumake
    # needed by clangd lsp server
    clang-tools_17
    # git 
    git-lfs
    delta
    glab
    lazygit
    git-crypt
    pre-commit
    git-filter-repo
    devenv
    #
    onefetch
    # pg
    pspg
    pgcli
    # do I need:
    # - pgenv
    # - pgxnclient
    # - pgxn 
    # with nix?

    # c++
    ccache
    llvmPackages.bintools

    # rust
    rustup

    # python
    (python3.withPackages(ps: with ps; [ debugpy ]))
    virtualenv

    # sig
    gdal
    pdal

    # gpg
    gnupg
    gpg-tui

    # python311Packages.pynvim
    # node
    nodejs_20

    sieve-connect

    ffmpeg
    pdftk
    pkgs.nodePackages."http-server"

    # search duckduckgo from cli
    ddgr

    khal
    vdirsyncer

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

    # npm
    ".npmrc".source = home.homeDirectory + "/dotFiles/.npmrc";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    starship.enable = true;

    direnv = {
        enable = true;
        enableBashIntegration = true; # see note on other shells below
        enableZshIntegration = true;
        nix-direnv = {
          enable = true;
        };
      };
  };
}
