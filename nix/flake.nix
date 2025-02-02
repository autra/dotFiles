{
  description = "atr's config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgsMaster.url = "github:nixos/nixpkgs/master";
    stylix.url = "github:danth/stylix/release-24.11";
    osladoc.url = "git+ssh://git@git.oslandia.net:10022/Oslandia/technique/osladoc?ref=2-ajout-d-une-option-template-pour-specifier-un-template-custom-pour-projet-notamment";
  };

  outputs = { self, nixpkgs, home-manager, nixpkgsMaster, stylix, nixos-hardware, osladoc, ... }:
    let lib = nixpkgs.lib;
    in {
      # sd images
      images = {
        pi = (self.nixosConfigurations.pi.extendModules {
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
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
          ];
        }).config.system.build.sdImage;
      };

      # Non nixos
      homeConfigurations = {
        augustin-Oslandia = home-manager.lib.homeManagerConfiguration {
          # pkgs = nixpkgs.legacyPackages.${system};
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [ ./other_os_common.nix ./home_cli.nix ];
        };
        "augustin@augustin-Oslandia2" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          extraSpecialArgs = {
            pkgsMaster = nixpkgsMaster.legacyPackages."x86_64-linux";
            osladoc = osladoc.packages."x86_64-linux";
          };
          modules = [ 
            stylix.homeManagerModules.stylix 
            ./stylix_common.nix 
            ./home_oslandia.nix 
            ./home_android.nix
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
            ./nixos-vm-config.nix
            ./nixos_minimal.nix
            ./nixos_common.nix
            ./kde.nix
            ./devops.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              home-manager.users.augustin = import ./home_desktop.nix;
            }
          ];
        };
        carlos = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./carlos-config.nix
            ./nixos_minimal.nix
            ./nixos_common.nix
            ./devops.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.augustin = import ./home_cli.nix;
            }
          ];
        };
        augustin-Oslandia2 = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.framework-16-7040-amd
            stylix.nixosModules.stylix
            ./stylix_common.nix
            ./augustin-Oslandia2-config.nix
            ./nixos_minimal.nix
            ./nixos_common.nix
            ./kde.nix
            ./devops.nix
            ./pg.nix
            # home-manager.nixosModules.home-manager {
            #   home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.backupFileExtension = "backup";

            #   home-manager.users.augustin = import ./home_oslandia.nix;
            #   home-manager.extraSpecialArgs = { pkgsMaster=nixpkgsMaster.legacyPackages."x86_64-linux"; };
            # }
          ];
        };
        pi = nixpkgs.lib.nixosSystem {
          system = "armv6l-linux";
          modules = [
            # override the system, see README
            # stylix.nixosModules.stylix
            ./raspi-hardware.nix
            ./nixos_minimal.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              # home-manager.users.augustin = import ./home_cli.nix;
            }
          ];
        };
      };
    };
}
