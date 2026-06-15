{
  description = "atr's config";

  inputs = {
    self.submodules = true;
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    osladoc = {
      url = "git+ssh://git@git.oslandia.net:10022/Oslandia/technique/osladoc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    oslandiaGrubTheme = {
      url = "gitlab:Oslandia/oslandia-grub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/v1.13.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    robotnix.url = "github:nix-community/robotnix";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , home-manager
    , stylix
    , nixos-hardware
    , robotnix
    , ...
    }:
    let
      lib = nixpkgs.lib;
    in
    {
      # sd images
      images = {
        pi =
          (self.nixosConfigurations.pi.extendModules {
            modules = [
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
              (
                { pkgs, ... }:
                {
                  disabledModules = [ "profiles/base.nix" ];
                  nixpkgs.config.allowUnsupportedSystem = true;
                  nixpkgs.hostPlatform = {
                    system = "armv6l-linux";
                    gcc = {
                      arch = "armv6k";
                      fpu = "vfp";
                    };
                  };
                  nixpkgs.buildPlatform.system = "x86_64-linux";
                }
              )
            ];
          }).config.system.build.sdImage;

        # nix build .#images.FP4.releaseScript -o release
        # ./release <path-to-keys> 
        FP4 = robotnix.lib.robotnixSystem {
          stateVersion = "3";
          flavor = "lineageos";
          device = "FP4";
          variant = "userdebug"; # Other options are userdebug, or eng. Builds used in production should use "user"
          flavorVersion = "23.2";
          apps.fdroid.enable = true;
          microg.enable = true;
          apps.updater.enable = true;
          apps.updater.url = "https://ota.trancart.eu/lineageos";
          signing.avb.size = 4096;

          # Enables ccache for the build process. Remember to add /var/cache/ccache as
          # an additional sandbox path to your Nix config.
          ccache.enable = false;
        };
      };

      generateMinimalHomeConfig =
        username: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [
            (
              { config, ... }:
              {
                mine.common.user = username;
              }
            )
            stylix.homeModules.stylix
            ./home-manager/stylix.nix
            ./home-manager/minimal.nix
            # ./home-manager/nix_niceties.nix
          ]
          ++ modules;
        };

      # Non nixos
      homeConfigurations = {
        ubuntu-vm = self.outputs.generateMinimalHomeConfig "ubuntu" [ ];
        augustin-Oslandia = self.outputs.generateMinimalHomeConfig "atr" [ ./home-manager/cli.nix ];
        "augustin@augustin-Oslandia2" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          extraSpecialArgs = {
            osladoc = inputs.osladoc.packages."x86_64-linux";
          };
          modules = [
            stylix.homeModules.stylix
            ./home-manager/stylix.nix
            ./home-manager/oslandia.nix
            ./home-manager/android.nix
            ./home-manager/nix_niceties.nix
          ];
        };
      };

      # nixos
      nixosConfigurations = {
        nixos-vm = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hardware/nixos-vm-config.nix
            ./modules/nixos_minimal.nix
            # ./modules/nixos_common.nix
            home-manager.nixosModules.home-manager
            # {
            #   home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.backupFileExtension = "backup";

            #   home-manager.users.augustin = import ./home-manager/desktop.nix;
            # }
          ];
        };
        carlos = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            inputs.disko.nixosModules.disko
            ./hardware/carlos-config.nix
            ./modules/nixos_minimal.nix
            ./modules/nixos_common.nix
            ./modules/devops.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.augustin =
                { pkgs, ... }:
                {
                  imports = [
                    ./home-manager/cli.nix
                    ./home-manager/android.nix
                  ];
                };
            }
          ];
        };
        augustin-Oslandia2 = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # pin nixpkgs registry to my current flake input
            ({ config, ... }: { nix.registry.nixpkgs.flake = nixpkgs; })
            nixos-hardware.nixosModules.framework-16-7040-amd
            inputs.oslandiaGrubTheme.nixosModules.default
            stylix.nixosModules.stylix
            ./hardware/augustin-Oslandia2-config.nix
            ./modules/stylix.nix
            ./modules/nixos_minimal.nix
            ./modules/nixos_common.nix
            ./modules/kde.nix
            ./modules/devops.nix
            ./modules/pg.nix
            # home-manager.nixosModules.home-manager {
            #   home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.backupFileExtension = "backup";

            #   home-manager.users.augustin = import ./home-manager/oslandia.nix;
            # }
          ];
        };
        pi = nixpkgs.lib.nixosSystem {
          system = "armv6l-linux";
          modules = [
            # override the system, see README
            # stylix.nixosModules.stylix
            ./hardware/raspi-hardware.nix
            ./modules/nixos_minimal.nix
            ./common/options.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              home-manager.users.augustin = import ./home-manager/minimal.nix;
            }
          ];
        };
      };
    };
}
