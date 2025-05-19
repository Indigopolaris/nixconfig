 # COSMIC DE
{
    description = "Freds minimal Nixos configuration flake.";
    inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
     nix-flatpak.url = "github:gmodena/nix-flatpak";
   };
   
   outputs = { self, nixpkgs, nix-flatpak, ...} @ inputs: {
    nixosConfigurations = {
       # NOTE: change "host" to your system's hostname
       system = "x86_64-linux";
       nixos = nixpkgs.lib.nixosSystem {
         modules = [
           nix-flatpak.nixosModules.nix-flatpak
          ./configuration.nix
        ];
         specialArgs = { inherit inputs; };
      };
    };
  };
}
