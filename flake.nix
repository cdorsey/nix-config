{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, home-manager, vscode-server, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs; };
        modules = [
          vscode-server.nixosModules.default
          ./wsl.nix
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };

      homeConfigurations.nixos = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { rootDir = ./.; };
        modules = [ ./home.nix ];
      };
    };
}
