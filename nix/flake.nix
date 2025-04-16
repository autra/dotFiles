{
  description = "atr's config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgsMaster.url = "nixpkgs/master";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix/release-24.11";
    osladoc.url = "git+ssh://git@git.oslandia.net:10022/Oslandia/technique/osladoc?ref=2-ajout-d-une-option-template-pour-specifier-un-template-custom-pour-projet-notamment";
    flox.url = "github:flox/flox/v1.3.15";
  };

  outputs = inputs @ { self, nixpkgs, nixpkgsMaster, home-manager, stylix, nixos-hardware, ... }:
    let lib = nixpkgs.lib;
    in {
      # sd images
      images = {
        pi = (self.nixosConfigurations.pi.extendModules {
          modules = [
            "${nixpkgsMaster}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
            ({ pkgs, ... }:
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
              })
          ];
        }).config.system.build.sdImage;
      };

      # Non nixos
      homeConfigurations = {
        augustin-Oslandia = home-manager.lib.homeManagerConfiguration {
          # pkgs = nixpkgs.legacyPackages.${system};
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [ ./other_os_common.nix ./home-manager/cli.nix ];
        };
        "augustin@augustin-Oslandia2" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          extraSpecialArgs = {
            osladoc = inputs.osladoc.packages."x86_64-linux";
            flox = inputs.flox.packages."x86_64-linux";
          };
          modules = [
            stylix.homeManagerModules.stylix
            ./common/stylix.nix
            ({config, flox, ...}: {config.home.packages = [flox.default]; })
            ./home-manager/oslandia.nix
            ./home-manager/android.nix
            ./home-manager/nix_niceties.nix
          ];
        };
        carlos = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          targets.genericLinux.enable = true;
        };
        augustin-perso = lib.nixosSystem {
          system = "x86_64-linux";
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
            ./hardware/carlos-config.nix
            ./modules/nixos_minimal.nix
            ./modules/nixos_common.nix
            ./modules/devops.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.augustin = import ./home-manager/cli.nix;
            }
          ];
        };
        augustin-Oslandia2 = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.framework-16-7040-amd
            stylix.nixosModules.stylix
            ./hardware/augustin-Oslandia2-config.nix
            ./common/stylix.nix
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
        pi = nixpkgsMaster.lib.nixosSystem {
          system = "armv6l-linux";
          modules = [
            # override the system, see README
            # stylix.nixosModules.stylix
            ./hardware/raspi-hardware.nix
            ./modules/nixos_minimal.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              home-manager.users.augustin = import ./home-manager/cli.nix;
            }
          ];
        };
      };
    };
}
