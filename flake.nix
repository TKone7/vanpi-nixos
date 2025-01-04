{
  description = "Raspberry Pi running home assistant in the van";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }@inputs: {
    # Please replace nixos with your hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "aarch64-linux";
      specialArgs = { 
        inherit inputs;
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
        };
      };
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
