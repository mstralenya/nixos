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
    catppuccin.url = "github:catppuccin/nix";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ### anime game launcher
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming/master";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://ezkea.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" # aagl
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" # nix-gaming
    ];
    trusted-users = [ "root" "@wheel" ];
  };
}
