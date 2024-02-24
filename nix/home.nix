{ config, pkgs, ... }:

let
  ohMyZshPath = fetchGit { 
    url = "https://github.com/ohmyzsh/ohmyzsh.git";
    ref = "master";
  };
in {

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "augustin";
  home.homeDirectory = /home/augustin;

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
    # shell
    oh-my-zsh
    fd
    fzf
    autojump
    bat
    jq
    # powerline
    powerline
    powerline-symbols
    # editors
    lunarvim
    kate
    # desktop utilitis
    thunderbird
    nextcloud-client
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.

    # SCMS
    ".gitconfig".source = ~/dotFiles/.gitconfig;
    ".localgitconfig".text = ''
      [user]
        name = Augustin Trancart
        email = augustin.trancart@gmail.com
      [commit]
        # gpgsign = true
      [credential "https://git.environnement.brussels"]
        helper = store
    '';
    ".git_commit_msg.txt".source = ~/dotFiles/.git_commit_msg.txt;
    ".hgrc".source = ~/dotFiles/.hgrc;
    # git scripts
    "bin/git-sw".source = ~/dotFiles/git_scripts/git-sw;
    "bin/git-delete-branches".source = ~/dotFiles/git_scripts/git-delete-branches;

    # Editor
    ".config/lvim/config.lua".source = ~/dotFiles/lunarvim/config.lua;

    # shells
    ".aliases".source = ~/dotFiles/.aliases;
    ".bashrc".source = ~/dotFiles/.bashrc;
    ".zshrc".source = ~/dotFiles/.zshrc;
    ".oh-my-zsh".source = ohMyZshPath;
    # TODO zsh plugins
    # tmux
    ".tmux.conf".source = ~/dotFiles/.tmux.conf;
    # TODO clone tpm ?
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
