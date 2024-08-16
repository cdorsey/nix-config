{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";

    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    # https://github.com/Misterio77/nix-colors/pull/53
    nix-colors.url = "github:misterio77/nix-colors/d1a0aeae920bb10814645ba0f8489f8c74756507";

    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland.git?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs =
    {
      self,
      nixpkgs-stable,
      nixpkgs,
      nix-colors,
      nix-darwin,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      root-dir = ./.;
      overlays = with inputs; [
        (final: prev: { zjstatus = zjstatus.packages.${prev.system}.default; })
        (final: prev: { nil = nil.packages.${prev.system}.default; })
      ];
      pkgs-stable = import nixpkgs-stable { inherit system; };
      pkgs = import nixpkgs {
        inherit system;
        inherit overlays;
      };
      darwinPackages = import nixpkgs {
        system = "aarch64-darwin";
        inherit overlays;
      };
    in
    {
      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
          inherit root-dir;
        };
        modules = [ ./hosts/wsl/configuration.nix ];
      };

      nixosConfigurations.hermes = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
          inherit root-dir;
        };
        modules = [ ./hosts/hermes/configuration.nix ];
      };

      darwinConfigurations."JNLQ1FQ95N-MBP" = nix-darwin.lib.darwinSystem {
        pkgs = darwinPackages;
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/workMac/configuration.nix
          inputs.home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.cdorsey = import ./hosts/workMac/home.nix;

            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit nix-colors;
              inherit root-dir;
            };
          }
        ];
      };

      darwinPackages = darwinPackages;

      homeConfigurations.nixos = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-stable;

        extraSpecialArgs = {
          inherit nix-colors;
          inherit root-dir;
          pkgs-unstable = pkgs;
        };
        modules = [ ./hosts/wsl/home.nix ];
      };

      homeConfigurations."chase@hermes" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit nix-colors;
          inherit root-dir;
          inherit pkgs-stable;
        };
        modules = [ ./hosts/hermes/home.nix ];
      };
    };
}
