{ inputs, ... }:
{
  imports = [
    ../../wall
    ../../shell
    ../../dev
    ../../editors/neovim
    ../../editors/emacs
    ../../terminals
    ../../programs
  ] ++ [ ../../wm/hyprland ];

}
