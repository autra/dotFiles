{
  description = "atr's config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };
  };

  outputs = {self, nixpkgs, home-manager, grub2-themes, ...}:
    let lib = nixpkgs.lib;
    in {

      # Non nixos
      homeConfigurations = {
        augustin-Oslandia = home-manager.lib.homeManagerConfiguration {
          # pkgs = nixpkgs.legacyPackages.${system};
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [ ./other_os_common.nix ./home_cli.nix ];
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
            ./nixos_common.nix
            ./kde.nix
            ./devops.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.augustin = import ./home_desktop.nix;
            }
          ];
        };
        carlos = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./carlos-config.nix
            ./nixos_common.nix
            ./devops.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.augustin = import ./home_cli.nix;
            }
          ];
        };
        augustin-Oslandia2 = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            grub2-themes.nixosModules.default
            ./augustin-Oslandia2-config.nix
            ./nixos_common.nix
            ./kde.nix
            ./devops.nix
            ./pg.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.augustin = import ./home_oslandia.nix;
            }
          ];
        };
      };
    };
}
