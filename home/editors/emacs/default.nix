{ pkgs, lib, inputs, home, ... }:
{
  home.file."./.config/doom/" = {
    source = ./doom.d;
    recursive = true;
  };
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;  # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
  };
  services.emacs = {
      enable = true;
      package = pkgs.emacs30-pgtk;
  };
  home.packages = with pkgs; [
      binutils
      git
      git-sync
      ripgrep
      gnutls

      fd
      imagemagick
      pinentry-emacs
      zstd

      mu
      editorconfig-core-c
      sqlite
      age
  ];
}
