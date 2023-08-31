{
  description = "NixOS systems and tools";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";

      # We want home-manager to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    let
      lib = import ./lib { inherit inputs; };
      inherit (lib) mkSystem mkDarwin mkHome forAllSystems;
      # Overlays is the list of overlays we want to apply from flake inputs.
    in
    rec {
      inherit lib;

      overlays = {
      };

      legacyPackages = forAllSystems (system:
        import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
      );

      nixosConfigurations = {
        wherangi = mkSystem {
          hostname = "wherangi";
          pkgs = legacyPackages."aarch64-linux";
        };
      };

      darwinConfigurations = {
        matawhero = mkDarwin {
          hostname = "matawhero";
          system = "aarch64-darwin";
          pkgs = legacyPackages."aarch64-darwin";
        };

        rapu = mkDarwin {
          hostname = "rapu";
          system = "aarch64-darwin";
          pkgs = legacyPackages."aarch64-darwin";
        };
      };

      homeConfigurations = {
        "keithschulze@matawhero" = mkHome {
          username = "keithschulze";
          hostname = "matawhero";
          features = [
            "alacritty"
            "starship"
          ];
          colorscheme = "catppuccin-frappe";
          pkgs = legacyPackages."aarch64-darwin";
        };

        "kschulze@rapu" = mkHome {
          username = "kschulze";
          hostname = "rapu";
          features = [
            "alacritty"
            "starship"
          ];
          colorscheme = "catppuccin-frappe";
          pkgs = legacyPackages."aarch64-darwin";
        };

        "keithschulze@wherangi" = mkHome {
          username = "keithschulze";
          hostname = "wherangi";
          features = [
            "alacritty"
            "starship"
          ];
          colorscheme = "catppuccin-frappe";
          pkgs = legacyPackages."aarch64-linux";
        };
      };
    } // inputs.utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ nixUnstable hm ];
        };
      });
}
