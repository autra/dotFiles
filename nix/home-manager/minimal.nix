# basic cli and editor setup that I'm likely to *always* need
{ config, pkgs, ... }:
let
  ohMyZshPath = fetchGit { 
    url = "https://github.com/ohmyzsh/ohmyzsh.git";
    ref = "master";
  };
  tpmPath = builtins.fetchGit {
    url = "https://github.com/tmux-plugins/tpm.git";
    ref = "refs/tags/v3.1.0";
    allRefs = true;
  };
in {
  imports = [ ../common/options.nix ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = config.mine.common.user;
  home.homeDirectory = "/home/${config.home.username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    starship.enable = true;
    zsh.enable = true;

    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.fira-code
    # shell
    fzf
    oh-my-zsh
    autojump
    eza
    # powerline
    powerline
    powerline-symbols
    # editors
    neovim
    (lunarvim.overrideAttrs(e: {
      version = "1.5.0-beta1";

      src = fetchFromGitHub {
        owner = "autra";
        repo = "LunarVim";
        rev = "db34eab551ba95aad1eb30b92e2a63791d7b9311";
        hash = "sha256-86fPeJAeWgsC8QNgh91DWxp8h8AD6eA3Iif5PaP4hUQ=";
      };

      # for markdownpreview
      runtimeDeps = e.runtimeDeps ++ [ 
        # for markdownpreview
        yarn 
        # for sqls
        gcc 
        go
        # for ruby :-O
        ruby
        # rust
        rustfmt
        # needed by clangd lsp server
        clang-tools_17
      ];
    }))
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.

    # SCMS
    ".gitconfig".source = config.home.homeDirectory + "/dotFiles/.gitconfig";
    ".git_commit_msg.txt".source = config.home.homeDirectory + "/dotFiles/.git_commit_msg.txt";
    ".hgrc".source = config.home.homeDirectory + "/dotFiles/.hgrc";
    # git scripts
    "bin/git-sw".source = config.home.homeDirectory + "/dotFiles/git_scripts/git-sw";
    "bin/git-delete-branches".source = config.home.homeDirectory + "/dotFiles/git_scripts/git-delete-branches";

    # Editor
    ".config/lvim/config.lua".source = config.home.homeDirectory + "/dotFiles/lunarvim/config.lua";

    # shells
    ".aliases".source = config.home.homeDirectory + "/dotFiles/.aliases";
    ".bashrc".source = config.home.homeDirectory + "/dotFiles/.bashrc";
    ".zshrc".source = config.home.homeDirectory + "/dotFiles/.zshrc";
    ".oh-my-zsh".source = ohMyZshPath;
    ".config/starship.toml".source = config.home.homeDirectory + "/dotFiles/starship.toml";
    ".tmux.conf".source = config.home.homeDirectory + "/dotFiles/.tmux.conf";
    ".tmux/plugins/tpm".source = tpmPath;


    # pgclients
    ".psqlrc".source = config.home.homeDirectory + "/dotFiles/.psqlrc";
    ".pspgconf".source = config.home.homeDirectory + "/dotFiles/.pspgconf";

    # rust
    ".rustup/settings.toml".source = config.home.homeDirectory + "/dotFiles/rustup_settings.toml";

    # npm
    ".npmrc".source = config.home.homeDirectory + "/dotFiles/.npmrc";
  };
}
