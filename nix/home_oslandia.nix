# specific for oslandia
{ config, pkgs, pkgsMaster, osladoc, ... }:
let
  # TODO extract in its own package
  pyrnotify = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/weechat/scripts/master/python/pyrnotify.py";
    hash = "sha256-sC9R3c8zpSaiBZCbs6guUVvLVCUIC4J97Bw72d1r6a8=";
  };
  pyrnotify_port = "4321";
  # TODO is is really worthy? :-D
  # maybe I should just install python3 in system or home
  create_python3_script_from_file = 
    (
      path: 
        (pkgs.writers.writePython3Bin (builtins.baseNameOf path) {
          flakeIgnore = [ "E" "W" "F" ];
        }) 
        (builtins.readFile path)
    );
  # derivation to install properly the different reports of timewarrior (with python)
  tw_reports = map 
    create_python3_script_from_file 
    [
      ../timewarrior/oslandia_report.py 
      ../timewarrior/totals.py
      ../timewarrior/totals2.py
      ../timewarrior/catreport.py
    ]
  ;
  tw_extensions = pkgs.symlinkJoin {
    name = "My timewarrior extensions";
    paths = tw_reports;
  };
in
{
  imports = [ ./home_desktop.nix ./home_3d.nix ];

  home.file = {
    ".timewarrior/extensions/".source = "${tw_extensions}/bin";
  };

  # TODO osladoc, oslcli
  # TODO separate in different file ? Especially weechat
  home.packages = with pkgs; [
    pass
    qtpass
    pwgen
    timewarrior
    libnotify
    cloudcompare
    (pkgsMaster.freecad.override { ifcSupport = true; })
    blender
    osladoc.default
    seer
  ];

  systemd.user.services.pyrnotify = {
    Unit = {
      Description = "Pyrnotify daemon for weechat";
    };

    Service = {
      Type = "simple";
      WorkingDirectory = "/home/augustin";
      ExecStart = "${pkgs.python3}/bin/python ${pyrnotify} ${pyrnotify_port}";
      # I prefer not to have automatic restart because it will probably not work anyway
      # Restart = "on-failure";
      SyslogIdentifier = "pyrnotify";
      Environment = "DISPLAY=:0";
    };
    Install = {
      WantedBy=["default.target"];
    };
  };
}
