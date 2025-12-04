# specific for oslandia
{ config, pkgs, osladoc, ... }:
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
      ../../timewarrior/oslandia_report.py
      ../../timewarrior/totals.py
      ../../timewarrior/totals2.py
      ../../timewarrior/catreport.py
    ]
  ;
  tw_extensions = pkgs.symlinkJoin {
    name = "My timewarrior extensions";
    paths = tw_reports;
  };
  list_unworked_days =
    pkgs.stdenv.mkDerivation {
      pname = "ls_unworked_days";
      version = "1.0";

      src = ../../scripts; # directory containing conges.py

      buildInputs = [
        (pkgs.python3.withPackages(ps: with ps; [tabulate]))
        pkgs.khal
        pkgs.makeWrapper
      ];

      installPhase = ''
        mkdir -p $out/bin
        install -m755 list_unworked_days.py $out/bin/list_unworked_days

        wrapProgram $out/bin/list_unworked_days \
          --prefix PATH : ${pkgs.lib.makeBinPath [
            pkgs.python3
            pkgs.khal
          ]}
      '';
    };
  last_week_imputations = affairesRepertoire: pkgs.writeShellApplication {
    name = "last_week_imputations";
    runtimeInputs = with pkgs; [ coreutils khal fzf bat gnugrep gnused ];
    text = (builtins.readFile ../../scripts/last_week_imputations.sh);
    runtimeEnv = {
      AFFAIRES_REPERTOIRE = affairesRepertoire;
    };
  };
in
{
  imports = [ ./desktop.nix ./3d.nix ];

  home.file = {
    ".timewarrior/extensions/".source = "${tw_extensions}/bin";
  };

  # TODO oslcli
  # TODO separate in different file ? Especially weechat
  home.packages = with pkgs; [
    pass
    qtpass
    pwgen
    timewarrior
    libnotify
    cloudcompare
    blender
    osladoc.default
    seer
    list_unworked_days
    (last_week_imputations "${config.home.homeDirectory}/repos/oslandia/affaires")
  ];

  systemd.user.services.pyrnotify = {
    Unit = {
      Description = "Pyrnotify daemon for weechat";
    };

    Service = {
      Type = "simple";
      WorkingDirectory = config.home.homeDirectory;
      ExecStart = "${pkgs.python3}/bin/python ${pyrnotify} ${pyrnotify_port}";
      # I prefer not to have automatic restart because it will probably not work anyway
      SyslogIdentifier = "pyrnotify";
      Environment = "DISPLAY=:0";
    };
    Install = {
      # for some reasons, notifications are broken when the computer resume from sleep
      # a restart solves that. 
      # It's probably either how socket behaves or something with the reverse ssh tunneling, but I didn't figure this out yet
      WantedBy = [ "default.target" "suspend.target" ];
    };
  };
}
