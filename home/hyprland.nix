{ config, pkgs, ... }:

let
  terminal = "terminal-launcher";
in

{
  enable = true;
  systemd.enable = true;
  xwayland.enable = true;
  settings = {
    "$mod" = "SUPER";
    monitor = [ ",preferred,auto,1" ];
    exec-once = [
      "waybar"
      "dunst"
      "hyprpaper"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
      "nm-applet --indicator"
      "blueman-applet"
      "openrgb --startminimized --server --server-port 6742"
      "liquidctl initialize all"
      terminal
    ];
    env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
      "WLR_NO_HARDWARE_CURSORS,1"
      "NIXOS_OZONE_WL,1"
      "MOZ_ENABLE_WAYLAND,1"
      "QT_QPA_PLATFORM,wayland;xcb"
      "GDK_BACKEND,wayland,x11"
      "SDL_VIDEODRIVER,wayland"
      "CLUTTER_BACKEND,wayland"
    ];
    input = {
      kb_layout = "latam";
      follow_mouse = 1;
      sensitivity = 0;
      accel_profile = "flat";
      touchpad = {
        natural_scroll = true;
        tap-to-click = true;
        drag_lock = true;
      };
    };
    general = {
      gaps_in = 4;
      gaps_out = 8;
      border_size = 2;
      "col.active_border" = "rgba(4da6ffff) rgba(b388ffff) 45deg";
      "col.inactive_border" = "rgba(2a2a3aaa)";
      layout = "dwindle";
      allow_tearing = true;
    };
    decoration = {
      rounding = 10;
      blur = {
        enabled = true;
        size = 6;
        passes = 3;
        vibrancy = 0.18;
      };
      shadow = {
        enabled = true;
        range = 18;
        render_power = 3;
        color = "rgba(00000066)";
      };
    };
    animations = {
      enabled = true;
      bezier = [
        "fast,0.08,0.9,0.1,1.0"
        "smooth,0.25,0.1,0.25,1"
      ];
      animation = [
        "windows,1,4,fast,popin 80%"
        "border,1,6,smooth"
        "fade,1,5,smooth"
        "workspaces,1,4,fast,slide"
      ];
    };
    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };
    misc = {
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      vrr = 1;
      enable_swallow = true;
      swallow_regex = "^(warp-terminal|kitty|ghostty)$";
    };
    windowrulev2 = [
      "immediate, class:^(steam_app_.*)$"
      "immediate, class:^(gamescope)$"
      "fullscreen, class:^(gamescope)$"
      "float, class:^(pavucontrol)$"
      "float, class:^(org.openrgb.OpenRGB)$"
      "float, class:^(blueman-manager)$"
      "opacity 0.94 0.90, class:^(warp-terminal|ghostty)$"
    ];
    bind = [
      "$mod, RETURN, exec, ${terminal}"
      "$mod SHIFT, RETURN, exec, ghostty"
      "$mod, D, exec, rofi -show drun"
      "$mod, W, exec, firefox"
      "$mod, E, exec, nautilus"
      "$mod, Q, killactive"
      "$mod SHIFT, Q, exit"
      "$mod, F, fullscreen"
      "$mod, V, togglefloating"
      "$mod, P, pseudo"
      "$mod, J, togglesplit"
      "$mod, G, togglegroup"
      "$mod, S, exec, hyprshot -m region"
      "$mod SHIFT, S, exec, hyprshot -m output"
      "$mod, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      "$mod, L, exec, hyprlock"
      "$mod, X, exec, wlogout"
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      "$mod, H, movefocus, l"
      "$mod, L, movefocus, r"
      "$mod, K, movefocus, u"
      "$mod, J, movefocus, d"
      "$mod SHIFT, H, movewindow, l"
      "$mod SHIFT, L, movewindow, r"
      "$mod SHIFT, K, movewindow, u"
      "$mod SHIFT, J, movewindow, d"
      "$mod CTRL, H, resizeactive, -40 0"
      "$mod CTRL, L, resizeactive, 40 0"
      "$mod CTRL, K, resizeactive, 0 -40"
      "$mod CTRL, J, resizeactive, 0 40"
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"
    ] ++ builtins.concatLists (builtins.genList (i:
      let ws = toString (i + 1); in [
        "$mod, ${ws}, workspace, ${ws}"
        "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
      ]) 9);
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
    bindel = [
      ",XF86AudioRaiseVolume, exec, pamixer -i 5"
      ",XF86AudioLowerVolume, exec, pamixer -d 5"
      ",XF86AudioMute, exec, pamixer -t"
      ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
    ];
  };
}
