{ config
, lib
, pkgs
, ...
}:

{
  # Simply install just the packages
  environment.packages = with pkgs; [
    su
    # User-facing stuff that you really really want to have
    neovim # or some other editor, e.g. nano or neovim

    # Some common stuff that people expect to have
    procps
    killall
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    man
    gnugrep
    #gnupg
    #gnused
    git
    gnutar
    bzip2
    gzip
    #xz
    zip
    unzip

    openssh
    inetutils
    curl
    starship
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "25.11";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  time.timeZone = "Europe/Paris";

  # home manager
  home-manager.config =
    { pkgs, ... }:
    {
      # Read home-manager changelog before changing this value
      home.stateVersion = "24.05";

      # insert home-manager config

      # Let Home Manager install and manage itself.
      programs = {
        home-manager.enable = true;
        starship.enable = true;
      };

      home.packages = with pkgs; [
        nerd-fonts.fira-code
        # shell
        fzf
        # note: home manager has a programs.zsh.enable options, but this generates a .zshrc according to the conf
        # at the moment I have my own .zshrc
        zsh
        autojump
        eza
        # powerline
        powerline
        powerline-symbols
        # editors
        (neovim.overrideAttrs (e: {
          postFixup = ''
            wrapProgram $out/bin/nvim --prefix PATH : ${
              lib.makeBinPath (
                with pkgs;
                [
                  # dependencies for various plugins, lsp etc.
                  gcc
                  go
                  rustc
                  cargo
                  clang-tools
                  (python3.withPackages (ps: with ps; [ pip ]))
                  mermaid-cli
                ]
              )
            }
          '';
        }))
        # this should be installed at the same time as .gitconfig
        delta
      ];

      # Home Manager is pretty good at managing dotfiles. The primary way to manage
      # plain files is through 'home.file'.
      home.file = {
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.

        # SCMS
        ".gitconfig".source = ../../.gitconfig;
        ".git_commit_msg.txt".source = ../../.git_commit_msg.txt;
        ".hgrc".source = ../../.hgrc;
        # git scripts
        "bin/git-sw".source = ../../git_scripts/git-sw;
        "bin/git-delete-branches".source = ../../git_scripts/git-delete-branches;

        # Editor
        # ".config/lvim/config.lua".source = ../../lunarvim/config.lua;

        # shells
        ".aliases".source = ../../.aliases;
        ".bashrc".source = ../../.bashrc;
        ".zshrc".source = ../../.zshrc;
        ".oh-my-zsh".source = pkgs.oh-my-zsh;
        ".config/starship.toml".source = ../../starship.toml;
        ".tmux.conf".source = ../../.tmux.conf;
        ".tmux/plugins/tpm".source = ../../tmux_custom/tpm;

        # pgclients
        ".psqlrc".source = ../../.psqlrc;
        ".pspgconf".source = ../../.pspgconf;

        # rust
        ".rustup/settings.toml".source = ../../rustup_settings.toml;

        # npm
        ".npmrc".source = ../../.npmrc;
      };
    };
}
