{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./development.nix
    ./neovim.nix
  ];

  home = {
    username = "tecnodespegue";
    homeDirectory = "/home/tecnodespegue";
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "terminal-launcher";
      BROWSER = "firefox";
      LANG = "es_AR.UTF-8";
      LC_ALL = "es_AR.UTF-8";
      OPENCODE_CAVEMAN_MODE = "full";
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      WINEESYNC = "1";
      WINEFSYNC = "1";
      WINE_NTSYNC = "1";
      PROTON_ENABLE_NTSYNC = "1";
      PROTON_USE_NTSYNC = "1";
      DXVK_ASYNC = "1";
      RADV_PERFTEST = "gpl,nggc,sam";
      MANGOHUD = "1";
    };
    packages = with pkgs; [
      firefox
      brave
      ghostty
      kitty
      zellij
      tmux
      git
      jq
      yq
      fd
      ripgrep
      bat
      eza
      sd
      fzf
      zoxide
      atuin
      carapace
      direnv
      nix-direnv
      fastfetch
      cava
      hyprpaper
      hypridle
      hyprlock
      hyprpicker
      hyprshot
      waybar
      rofi
      dunst
      awww
      wl-clipboard
      cliphist
      grim
      slurp
      swappy
      wf-recorder
      wlogout
      brightnessctl
      networkmanagerapplet
      blueman
      pavucontrol
      playerctl
      pamixer
      nautilus
      file-roller
      btop
      nvtopPackages.amd
      obs-studio
      discord
      vesktop
      spotify
      claude-code
    ] ++ lib.optionals (pkgs ? warp-terminal) [ pkgs.warp-terminal ]
      ++ lib.optionals (pkgs ? swaylock-effects) [ pkgs.swaylock-effects ];
  };

  home.file.".local/bin/terminal-launcher" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      if command -v warp-terminal >/dev/null 2>&1; then
        exec warp-terminal "$@"
      fi
      exec ghostty "$@"
    '';
  };


  stylix.targets.neovim.enable = false;
  stylix.targets.hyprland.enable = false;
  stylix.targets.spicetify.enable = false;

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "tecnodespegue";
        email = "renekuhm2@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";
      push.autoSetupRemote = true;
      advice.detachedHead = false;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    history = {
      path = "$HOME/.zsh_history";
      size = 20000;
      save = 40000;
      ignoreAllDups = true;
      share = true;
    };
    shellAliases = {
      ll = "eza -lah --icons --git";
      la = "eza -la --icons --git";
      l = "eza -l --icons";
      ls = "eza --icons";
      cat = "bat";
      grep = "rg";
      find = "fd";
      gs = "git status -sb";
      gd = "git diff";
      gl = "git log --oneline --graph --decorate -10";
      gp = "git push";
      gpl = "git pull";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-gaming-flake#nixos-gaming";
      update = "sudo nix flake update ~/nixos-gaming-flake && rebuild";
      openrgb-server = "openrgb --server --server-port 6742";
      audio = "pavucontrol";
      mixer = "qpwgraph";
    };
    initContent = ''
      # Secrets locales (API keys, no van en git)
      [[ -f ~/.secrets ]] && source ~/.secrets

      setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_MINUS PUSHD_SILENT
      setopt EXTENDED_GLOB INTERACTIVE_COMMENTS CORRECT_ALL GLOB_DOTS COMPLETE_IN_WORD
      unsetopt BEEP NOMATCH

      path=("$HOME/.npm-global/bin" "$HOME/.local/bin" "$HOME/.opencode/bin" "$HOME/.cargo/bin" "$HOME/.bun/bin" $path)
      typeset -U path

      export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
      export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
      export FZF_PREVIEW_COMMAND='bat --theme=gruvbox-dark --color=always {}'

      eval "$(zoxide init zsh)"
      eval "$(atuin init zsh)"
      eval "$(direnv hook zsh)"

      mkcd() { [[ -n "$1" ]] || return 1; mkdir -p -- "$1" && cd -- "$1"; }
      fe() { local file; file=$(fzf --preview="$FZF_PREVIEW_COMMAND") || return; "$VISUAL" "$file"; }

      ocd() {
        local layout="''${1:-opencode}"
        local session_name="''${2:-$(basename "$PWD")}"
        if zellij list-sessions 2>/dev/null | rg -q "^$session_name"; then
          zellij attach "$session_name"
        else
          zellij --layout "$layout" --session "$session_name"
        fi
      }

      ocdi() {
        local layout="''${1:-opencode}"
        local session_name="$(basename "$PWD")"
        if zellij list-sessions 2>/dev/null | rg -q "^$session_name"; then
          zellij attach "$session_name"
        else
          zellij --layout "$layout" --session "$session_name" options --default-shell "zsh -c 'opencode; exec zsh'"
        fi
      }

      ocp() { [[ -d "$1" ]] || return 1; cd "$1" && ocd; }
      caveman() { export OPENCODE_CAVEMAN_MODE="''${1:-full}"; print "caveman: $OPENCODE_CAVEMAN_MODE"; }
      caveman-off() { unset OPENCODE_CAVEMAN_MODE; }

      if [[ -z "$TMUX" && -z "$ZELLIJ" && "$TERM_PROGRAM" != "vscode" && "$AUTO_TMUX_ATTACH" == "1" ]]; then
        command -v zellij >/dev/null 2>&1 && zellij attach -c main
      fi
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$nix_shell$nodejs$rust$golang$python$character";
      character = { success_symbol = "[>](bold cyan)"; error_symbol = "[>](bold red)"; };
      directory = { style = "bold blue"; truncation_length = 4; };
    };
  };

  wayland.windowManager.hyprland = import ./hyprland.nix { inherit config pkgs; };

  xdg.configFile = {
    "opencode/opencode.json".source = ./opencode/opencode.json;
    "opencode/AGENTS.md".source = ./opencode/AGENTS.md;
    "opencode/tui.json".source = ./opencode/tui.json;
    "opencode/themes/gentleman-pro.json".source = ./opencode/gentleman-pro.json;
    "waybar/config".source = ./waybar/config;
    "waybar/style.css".source = ./waybar/style.css;
    "zellij/layouts/opencode.kdl".source = ./zellij/opencode.kdl;
    "OpenRGB/OpenRGB.json".source = ./openrgb/OpenRGB.json;
    "rofi/config.rasi".source = ./rofi/config.rasi;
    "rofi/catppuccin-mocha.rasi".source = ./rofi/catppuccin-mocha.rasi;
  };
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 340;
        height = 120;
        offset = "16x56";
        origin = "top-right";
        transparency = 8;
        frame_width = 2;
        frame_color = "#313244";
        corner_radius = 12;
        font = "JetBrainsMono Nerd Font 11";
        icon_theme = "Papirus-Dark";
        enable_recursive_icon_lookup = true;
        format = "<b>%s</b>\n%b";
        markup = "full";
        padding = 12;
        horizontal_padding = 16;
        gap_size = 6;
        separator_color = "frame";
        progress_bar = true;
        progress_bar_height = 6;
        progress_bar_corner_radius = 3;
      };
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#313244";
        timeout = 4;
      };
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#89b4fa";
        timeout = 6;
      };
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#f38ba8";
        frame_color = "#f38ba8";
        timeout = 0;
      };
    };
  };
}
