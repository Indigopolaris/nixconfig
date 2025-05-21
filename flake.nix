{
  description = "Will's flake.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, nix-flatpak, ... }@inputs: {
    # Define the nixosConfigurations
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          ./config-laptop.nix
        ];
        specialArgs = { inherit inputs; };
      };

      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          ./config-desktop.nix
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
