{
  pkgs,
  lib,
  user,
  ...
}:
{
  programs = {
    dconf.enable = true;
  };

  programs.nm-applet = {
    enable = true;
    indicator = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    hyprland.enableGnomeKeyring = true;
  };

  services.xserver.displayManager.sessionCommands = ''
    ${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
  '';

  security.pam.services.swaylock = { };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    configPackages = [ pkgs.gnome-session ];
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      libnotify
      wl-clipboard
      wlr-randr
      wf-recorder
      wlprop
      nemo
      wev
      pulsemixer
      sshpass
      imagemagick
      grim
      slurp
      qbittorrent
      sddm-astronaut
      where-is-my-sddm-theme
      (pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        #font = "Noto Sans";
        fontSize = "18";
        #background = "${./wallpaper.png}";
        loginBackground = true;
      })
    ];
    variables.NIXOS_OZONE_WL = "1";
  };

  services.xserver = {
    xkb.options = "caps:escape";
  };
  console.useXkbConfig = true;

  programs = {
    light.enable = true;
    hyprland.enable = true;
  };
  services = {
    dbus.packages = [ pkgs.gcr ];
    getty.autologinUser = "${user}";
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  programs.adb.enable = true;
  users.users.${user}.extraGroups = [ "adbuser" ];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
