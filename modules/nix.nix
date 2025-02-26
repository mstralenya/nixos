{ pkgs
, inputs
, self
, lib
, ...
}:
{
  nix = {
    channel.enable = false;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings = {
      nix-path = lib.mkForce "nixpkgs=flake:nixpkgs";
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "cgroups"
      ];
      auto-allocate-uids = true;
      use-cgroups = true;
      auto-optimise-store = true; # Optimise syslinks
      accept-flake-config = true;
      flake-registry = "${inputs.flake-registry}/flake-registry.json";
      builders-use-substitutes = true;
      keep-derivations = true;
      keep-outputs = true;
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ruixi-rebirth.cachix.org-1:sWs3V+BlPi67MpNmP8K4zlA3jhPCAvsnLKi4uXsiLI4="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.latest;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      keep-outputs            = true
      keep-derivations        = true
    '';
  };

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnsupportedSystem = true;
      allowUnfree = true;
    };
    overlays = [
      self.overlays.default
      inputs.rust-overlay.overlays.default
    ];
  };
}
