{
  description = "My first flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
  };

  outputs = {self, nixpkgs, ...}: 
    let lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        nixos-vm = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hardware-configuration-nixos-vm.nix ./common.nix ];
        };
      };
    };
}
