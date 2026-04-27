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

    monitor = [ ",3440x1440@144,auto,1" ];

    exec-once = [
      "waybar"
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
      repeat_rate = 35;
      repeat_delay = 250;
      touchpad = {
        natural_scroll = true;
        tap-to-click = true;
        drag_lock = true;
      };
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 3;
      workspace_swipe_distance = 300;
      workspace_swipe_cancel_ratio = 0.2;
    };

    general = {
      gaps_in = 5;
      gaps_out = 12;
      border_size = 2;
      "col.active_border" = "rgba(89b4faff) rgba(cba6f7ff) 45deg";
      "col.inactive_border" = "rgba(313244aa)";
      layout = "dwindle";
      allow_tearing = true;
      resize_on_border = true;
    };

    decoration = {
      rounding = 12;
      blur = {
        enabled = true;
        size = 8;
        passes = 3;
        vibrancy = 0.2;
        noise = 0.01;
        new_optimizations = true;
        xray = false;
      };
      shadow = {
        enabled = true;
        range = 20;
        render_power = 4;
        color = "rgba(00000080)";
        color_inactive = "rgba(00000040)";
      };
      dim_inactive = true;
      dim_strength = 0.06;
    };

    animations = {
      enabled = true;
      bezier = [
        "easeOutQuint, 0.23, 1, 0.32, 1"
        "easeInOutCubic, 0.65, 0.05, 0.35, 0.95"
        "linear, 0, 0, 1, 1"
        "almostLinear, 0.5, 0.5, 0.75, 1"
        "quick, 0.15, 0, 0.1, 1"
      ];
      animation = [
        "border, 1, 5, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.73, almostLinear"
        "fadeLayersOut, 1, 1.46, almostLinear"
        "workspaces, 1, 1.94, almostLinear, fade"
        "workspacesIn, 1, 1.21, almostLinear, fade"
        "workspacesOut, 1, 1.94, almostLinear, fade"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
      smart_split = true;
    };

    misc = {
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      vrr = 1;
      enable_swallow = true;
      swallow_regex = "^(warp-terminal|kitty|ghostty)$";
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
    };

    layerrule = [
      "blur, waybar"
      "blur, rofi"
      "blur, notifications"
      "ignorezero, waybar"
      "ignorezero, notifications"
    ];

    windowrulev2 = [
      "immediate, class:^(steam_app_.*)$"
      "immediate, class:^(gamescope)$"
      "fullscreen, class:^(gamescope)$"
      "float, class:^(pavucontrol)$"
      "size 900 600, class:^(pavucontrol)$"
      "float, class:^(org.openrgb.OpenRGB)$"
      "float, class:^(blueman-manager)$"
      "float, class:^(nm-applet)$"
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      "opacity 0.94 0.90, class:^(warp-terminal|ghostty|kitty)$"
      "workspace 2, class:^(firefox|brave-browser)$"
      "workspace 4, class:^(steam)$"
      "workspace 4, class:^(lutris)$"
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
      "$mod, T, togglesplit"
      "$mod, G, togglegroup"
      "$mod, S, exec, hyprshot -m region"
      "$mod SHIFT, S, exec, hyprshot -m output"
      "$mod, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      "$mod CTRL, L, exec, hyprlock"
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
      "$mod CTRL, J, resizeactive, 0 40"
      "$mod CTRL, K, resizeactive, 0 -40"
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
