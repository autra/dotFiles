{
  description = "atr's config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, ...}: 
    let lib = nixpkgs.lib;
    in {

      # Non nixos 
      homeConfigurations = {
        augustin-Oslandia = home-manager.lib.homeManagerConfiguration {
          # pkgs = nixpkgs.legacyPackages.${system};
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          # targets.genericLinux.enable = true;
          modules = [ ./home_cli.nix ];
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
      nixosConfigurations = {
        nixos-vm = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos-vm-config.nix ./nixos_common.nix ./devops.nix ./home_desktop.nix ];
        };
        augustin-Oslandia2 = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ 
            ./nixos_common.nix
            ./devops.nix
            ./home_desktop.nix
          ];
        };
      };
    };
}
