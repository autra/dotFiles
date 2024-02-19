{
  description = "My first flake!";

  input = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
  };

  outputs = {self, nixpkgs, ...}: 
    let lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        augustin-Oslandia-vm = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration.nix ];
        };
      };
    };
}
