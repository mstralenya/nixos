{ pkgs, lib, inputs, ... }:
{
  programs.doom-emacs = {
    enable = true;
    emacsPackage = pkgs.emacs-nox;
    extraPackages = with pkgs; [ gcc ripgrep git pandoc ];
    doomPrivateDir = ./doom.d;
  };
}
