{
  description = "atr's config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
  };

  outputs = {self, nixpkgs, ...}: 
    let lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        nixos-vm = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos-vm-config.nix ./common.nix ];
        };
        augustin-Oslandia = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./augustin-oslandia-config.nix ./common.nix];
        };
        augustin-perso = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./augustin-perso-config.nix ./common.nix];
        };
      };
    };
}
