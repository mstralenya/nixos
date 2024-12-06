{ pkgs, ... }:
{
  programs = {
    btop = {
      enable = true;
      settings = {
        color_theme = "catppuccin-frappe";
      };
    };
  };
  home.file = {
    ".config/btop/themes/catppuccin-frappe.theme".source = ./theme.nix;
  };
}
