{
  description = "atr's config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:nixos/nixos-hardware?rev=11f2d9ea49c3e964315215d6baa73a8d42672f06";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    osladoc = {
      url = "git+ssh://git@git.oslandia.net:10022/Oslandia/technique/osladoc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flox = {
      url = "github:flox/flox/v1.5.0";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, stylix, nixos-hardware, ... }:
    let lib = nixpkgs.lib;
    in {
      # sd images
      images = {
        pi = (self.nixosConfigurations.pi.extendModules {
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
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
        minimal = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [
            stylix.homeModules.stylix
            ./home-manager/stylix.nix
            ./home-manager/minimal.nix
            # ./home-manager/nix_niceties.nix
          ];
        };
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
            stylix.homeModules.stylix
            ./home-manager/stylix.nix
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
        pi = nixpkgs.lib.nixosSystem {
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
