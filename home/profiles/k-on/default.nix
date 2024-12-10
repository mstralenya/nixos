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

  # Autostart QEMU/KVM in the first initialization of NixOS
  # realted link: https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
