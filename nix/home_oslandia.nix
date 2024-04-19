# specific for oslandia
{ config, pkgs, ... }:
let
  # TODO extract in its own package
  pyrnotify = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/weechat/scripts/master/python/pyrnotify.py";
    hash = "sha256-sC9R3c8zpSaiBZCbs6guUVvLVCUIC4J97Bw72d1r6a8=";
  };
in
{
  imports = [ ./home_desktop.nix ];
  # TODO osladoc, oslcli
  # TODO separate in different file ? Especially weechat
  home.packages = with pkgs; [
    pass
    qtpass
    timewarrior
    libnotify
  ];

  systemd.user.services.pyrnotify = {
    Unit = {
      Description = "Pyrnotify daemon for weechat";
      After = "network.target";
    };

    Service = {
      Type = "simple";
      WorkingDirectory = "/home/augustin";
      ExecStart = "${pkgs.python3}/bin/python ${pyrnotify} 4321";
      Restart = "on-failure";
      SyslogIdentifier = "pyrnotify";
      Environment = "DISPLAY=:0";
    };
  };
}
