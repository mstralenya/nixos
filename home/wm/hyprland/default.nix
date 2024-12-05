{ pkgs, inputs, ... }:
{
  imports = [ ../../programs/waybar/sway_waybar.nix ];
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
    ];
    settings = {
      "$mod" = "SUPER";
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod, R, exec, rofi -show drun"
        "$mod, Q, killactive"
        "$mod SHIFT, V, fullscreen"
        "$mod SHIFT, Q, exec, hyprctl dispatch exit"
        # Floating mode
        "$mod, V, togglefloating"
        # Screenshots
        "$mod, P, exec, hyprshot -m region"
        "$mod SHIFT, P, exec, hyprshot -m output"
        "$mod CONTROL, P, exec, hyprshot -m window"
        # Move focus
        "$mod, H, movefocus, l"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod, L, movefocus, r"
        # Swap windows with vim keys
        "$mod SHIFT, h, swapwindow, l"
        "$mod SHIFT, l, swapwindow, r"
        "$mod SHIFT, k, swapwindow, u"
        "$mod SHIFT, j, swapwindow, d"
        # Audio Control
        ", XF86AudioRaiseVolume, exec, pamixer -i 2"
        ", XF86AudioLowerVolume, exec, pamixer -d 2"
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPlay, exec, playerctl play-pause"
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList
          (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9
        ));
      exec-once = [
        "waybar"
      ];
      monitor = ",3840x2160@200,auto,1,bitdepth,10";
      input = {
        kb_layout = "us,ru";
        kb_options = "grp:win_space_toggle";
      };
    };
  };
  home.packages = [
    inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
  ] ++ (with pkgs;[
    swaylock-effects
    pamixer
    swayidle
    hyprshot
    hyprpaper
    waybar
    wttrbar
    waybar-mpris
  ]);

  systemd.user = {
    targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  };

  home = {
    sessionVariables = {
      QT_SCALE_FACTOR = "1";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      CLUTTER_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "hyprland";
      XDG_SESSION_DESKTOP = "hyprland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
