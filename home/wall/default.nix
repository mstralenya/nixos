{ pkgs, config, ... }:
let
  wallpapers = {
    fischl = {
      url = "https://github.com/mstralenya/nixos/blob/master/wallpaper.png?raw=true";
      sha256 = "7a80f8a87c79c7090099fbe7a2dedfbf1ad2b134c8212fb90989a6d0395b9d9a";
    };
  };
  default_wall = wallpapers.fischl or (throw "Unknown theme");
  wallpaper = pkgs.fetchurl {
    inherit (default_wall) url sha256;
  };
in
{
  systemd.user.services = {
    swww = {
      Unit = {
        Description = "Efficient animated wallpaper daemon for wayland";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.swww}/bin/swww-daemon
        '';
        ExecStop = "${pkgs.swww}/bin/swww kill";
        Restart = "on-failure";
      };
    };
    "1password" = {
      Unit.Description = "1password manager GUI application.";
      Install.WantedBy = [
        "graphical-session.target"
        "hyprland-session.target"
      ];
      Service = {
        ExecStart = "${pkgs._1password-gui}/bin/1password} --silent";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
    default_wall = {
      Unit = {
        Description = "default wallpaper";
        Requires = [ "swww.service" ];
        After = [ "swww.service" ];
        PartOf = [ "swww.service" ];
      };
      Install.WantedBy = [ "swww.service" ];
      Service = {
        ExecStart = ''${pkgs.swww}/bin/swww img "${wallpaper}" --transition-type random'';
        Restart = "on-failure";
        Type = "oneshot";
      };
    };

  };
}
