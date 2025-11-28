{
  description = "idk flake for blog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, ... }@inputs: 
  let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      ];
    forEachSupportedSystem =
      f:
      inputs.nixpkgs.lib.genAttrs supportedSystems (
      system:
      f {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.self.overlays.default ];
        };
      }
    );
  in {

    overlays.default = final: prev: rec {
      nodejs = prev.nodejs;
    };

    devShells = forEachSupportedSystem (
      { pkgs }:
      {
        default = pkgs.mkShellNoCC
        {
          packages = with pkgs; [
            node2nix
            nodejs
            nodePackages.pnpm
          ];
        };
      }
    );
  };
}
