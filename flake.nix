{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";

    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/Misterio77/nix-colors/pull/53
    nix-colors.url =
      "github:misterio77/nix-colors/d1a0aeae920bb10814645ba0f8489f8c74756507";

    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs-stable, nixpkgs, nix-colors, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs-stable = import nixpkgs-stable { inherit system; };
      pkgs = import nixpkgs {
        inherit system;

        overlays = with inputs;
          [
            (final: prev: {
              zjstatus = zjstatus.packages.${prev.system}.default;
            })
          ];
      };
    in {
      nixosConfigurations.wsl = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          inputs.vscode-server.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          ./system/wsl.nix
          ./system/configuration.nix
          ./system/hardware-configuration.nix
        ];
      };

      homeConfigurations.nixos =
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs-stable;
          inherit pkgs;
          extraSpecialArgs = {
            inherit nix-colors;
            rootDir = ./.;
          };
          modules = [ nix-colors.homeManagerModules.default ./user/home.nix ];
        };
    };
}
