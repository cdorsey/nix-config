{
  description = "Nixos config flake";

  inputs = {
    ### MAIN ###
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "nixpkgs/nixos-23.11";

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

    ### PERSIONAL ###
    work-values = {
      url = "git+ssh://git@gitlab.com/cdorseyQ2/nix-values.git";
    };

    ### OTHER ###
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # gBar.url = "github:scorpion-26/gBar";

    # hyprland = {
    #   url = "git+https://github.com/hyprwm/Hyprland.git?submodules=1";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    #   inputs.nixpkgs.follows = "hyprland/nixpkgs";
    # };

    # https://github.com/Misterio77/nix-colors/pull/53
    nix-colors.url = "github:misterio77/nix-colors/d1a0aeae920bb10814645ba0f8489f8c74756507";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zjstatus = {
      url = "github:dj95/zjstatus/v0.17.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
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
      colorScheme = nix-colors.colorSchemes."material-darker";
      pkgs-stable = import nixpkgs-stable { inherit system; };
    in
    {
      nixosConfigurations.atlas = nixpkgs.lib.nixosSystem {
        inherit system;
        pkgs = import nixpkgs {
          inherit system;
          overlays = import ./overlays.nix { inherit inputs; };
        };
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [ ./hosts/atlas/configuration.nix ];
      };

      nixosConfigurations.hermes = nixpkgs.lib.nixosSystem {
        inherit system;
        # pkgs = nixpkgs.legacyPackages.${system};
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [ ./hosts/hermes/configuration.nix ];
      };

      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
        inherit system;
        pkgs = import nixpkgs-stable { inherit system; };
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [ ./hosts/wsl/configuration.nix ];
      };

      darwinConfigurations."JNLQ1FQ95N-MBP" =
        let
          system = "aarch64-darwin";
        in
        nix-darwin.lib.darwinSystem {
          pkgs = import nixpkgs {
            inherit system;
            overlays = import ./overlays.nix {
              inherit inputs;
              config = self;
            };
          };
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/workMac/configuration.nix
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.cdorsey = import ./hosts/workMac/home.nix;

              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit nix-colors;
                inherit colorScheme;
              };
            }
          ];
        };

      homeConfigurations."nixos@wsl" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-stable;

        extraSpecialArgs = {
          inherit nix-colors;
        };
        modules = [ ./hosts/wsl/home.nix ];
      };

      homeConfigurations."chase@hermes" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = import ./overlays.nix {
            inherit inputs;
            config = self;
          };
        };
        extraSpecialArgs = {
          inherit self;
          inherit inputs;
          inherit nix-colors;
          inherit pkgs-stable;
          inherit colorScheme;
        };
        modules = [ ./hosts/hermes/home.nix ];
      };
    };
}
