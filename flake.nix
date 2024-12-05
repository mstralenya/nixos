{
  description = "Ruixi-rebirth's NixOS Configuration";

  outputs = inputs @ { self, ... }:
    let
      selfPkgs = import ./pkgs;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = [ "x86_64-linux" ];
      imports = [
        ./home/profiles
        ./hosts
        ./modules
      ] ++ [
        inputs.flake-root.flakeModule
        inputs.treefmt-nix.flakeModule
      ];
      flake = {
        overlays = {
          default = selfPkgs.overlay;
          emacs = inputs.emacs-overlay.overlay;
        };
      };
      perSystem = { config, pkgs, system, ... }:
        {
          # NOTE: These overlays apply to the Nix shell only. See `modules/nix.nix` for system overlays.
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              #inputs.foo.overlays.default
            ];
          };

          treefmt.config = {
            inherit (config.flake-root) projectRootFile;
            package = pkgs.treefmt;
            programs.nixpkgs-fmt.enable = true;
            programs.prettier.enable = true;
            programs.taplo.enable = true;
            programs.shfmt.enable = true;
          };

          devShells = {
            # run by `nix devlop` or `nix-shell`(legacy)
            # Temporarily enable experimental features, run by`nix develop --extra-experimental-features nix-command --extra-experimental-features flakes`
            default = pkgs.mkShell {
              nativeBuildInputs = with pkgs; [ git neovim sbctl just ];
              inputsFrom = [
                config.flake-root.devShell
              ];
            };
          };
          # used by the `nix fmt` command
          formatter = config.treefmt.build.wrapper;
        };
    };

  inputs = {
    # update single input: `nix flake lock --update-input <name>`
    # update all inputs: `nix flake update`
    disko.url = "github:nix-community/disko";
    emanote.url = "github:srid/emanote";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-root.url = "github:srid/flake-root";
    flake-registry = {
      url = "github:NixOS/flake-registry";
      flake = false;
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    flameshot-git = {
      url = "github:flameshot-org/flameshot";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hypr-contrib.url = "github:hyprwm/contrib";
    hyprland-plugins =
      {
        url = "github:hyprwm/hyprland-plugins";
        inputs.hyprland.follows = "hyprland";
      };
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = {
      #please read this doc -> https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md 
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixd.url = "github:nix-community/nixd";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvim-flake.url = "github:Ruixi-rebirth/nvim-flake";
    nur.url = "github:nix-community/NUR";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    rust-overlay.url = "github:oxalica/rust-overlay";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    ### Theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-base16 = {
      url = "github:catppuccin/base16";
      flake = false;
    };
    catppuccin-nix = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.stylix.follows = "nixpkgs";
    };

    ### EMACS, DOOM EMACS
    doom-emacs.url = "github:doomemacs/doomemacs/master";
    doom-emacs.flake = false;
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nix-doom-emacs = {
      #url = "github:nix-community/nix-doom-emacs/master";
      url = "github:thiagokokada/nix-doom-emacs/bump-doom-emacs";
      inputs.doom-emacs.follows = "doom-emacs";
      inputs.emacs-overlay.follows = "emacs-overlay";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://ruixi-rebirth.cachix.org"
      "https://cache.nixos.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ruixi-rebirth.cachix.org-1:sWs3V+BlPi67MpNmP8K4zlA3jhPCAvsnLKi4uXsiLI4="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
    trusted-users = [ "root" "@wheel" ];
  };
}
