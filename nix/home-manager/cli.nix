{ config, pkgs, ... }:
# TODO param for refs?
{

  imports = [ ./minimal.nix ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [

    # util
    autossh
    bup # kde includes kup, which is a frontend integration into settings
    ipcalc

    # monitoring
    ctop

    # nixpkgs
    nix-output-monitor

    # utils
    tokei
    dogdns
    imagemagick
    exiftool

    gnumake
    # git 
    git-lfs
    glab
    gitlab-ci-local
    gh
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
    plan-exporter

    # c++
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

    nodejs_20

    sieve-connect

    ffmpeg
    pdftk
    pkgs.nodePackages."http-server"

    # search duckduckgo from cli
    ddgr

    khal
    vdirsyncer

    graphviz

    caligula # to flash sd card for raspberry

    # yazi, mediainfo, exiftool, mpv, but use xdg-open for yazi
    # also, alias it to y
    # nix-search-tv when it reaches master
    superfile

  ];
}
