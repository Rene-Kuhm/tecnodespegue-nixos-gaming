# NixOS Gaming — Mapa de Configuración

## Ubicación del Flake

```
~/nixos-gaming-flake/
```

> /etc/nixos está vacío. El flake vive en el home del usuario.

## Comando para aplicar cambios

```bash
sudo nixos-rebuild switch --flake ~/nixos-gaming-flake#nixos-gaming
```

## Estructura completa

```
nixos-gaming-flake/
├── flake.nix                        ← Entry point. Inputs: nixpkgs-unstable, home-manager, disko, hyprland, nixos-hardware, stylix
├── flake.lock                       ← Lockfile de versiones
├── configuration.nix                ← Config principal del sistema (boot, kernel, networking, usuarios, servicios)
├── hardware-configuration.nix       ← Hardware detectado (generado por nixos-hardware)
├── disko-config.nix                 ← Layout de particiones BTRFS (gestionado por disko)
│
├── modules/
│   ├── audio.nix                    ← PipeWire, audio config
│   ├── gaming.nix                   ← Steam, Wine, Proton, gamemode, gamescope
│   ├── locale.nix                   ← Idioma, timezone (America/Argentina/Buenos_Aires)
│   └── rgb.nix                      ← OpenRGB, iluminación
│
├── home/
│   ├── default.nix                  ← Home-manager: paquetes, zsh, git, direnv, starship, variables de sesión
│   ├── hyprland.nix                 ← Hyprland WM (Wayland compositor)
│   ├── waybar/
│   │   ├── config                   ← Barra de estado
│   │   └── style.css
│   ├── zellij/
│   │   └── opencode.kdl             ← Layout de zellij para opencode
│   └── opencode/
│       ├── opencode.json            ← Config de opencode
│       ├── AGENTS.md                ← Agentes de opencode
│       ├── tui.json                 ← UI de opencode
│       └── gentleman-pro.json       ← Tema gentleman pro
│
├── hosts/
│   └── iso/default.nix              ← Perfil para generar ISO de instalación
│
├── scripts/
│   └── install.sh                   ← Script de instalación manual
│
└── NIXOS-CONFIG.md                  ← Este archivo

## Stack principal

| Componente | Valor |
|-----------|-------|
| Kernel | linux_latest (7.0.1) |
| Filesystem | BTRFS |
| Display | Wayland / Hyprland |
| Login | SDDM (auto-login tecnodespegue) |
| Shell | zsh |
| Terminal | Ghostty / Warp |
| GPU | AMD (amdgpu, ROCm, Vulkan) |
| Audio | PipeWire |

## Claude Code en NixOS

Instalado como paquete nativo nix en `home/default.nix`:

```nix
home.packages = with pkgs; [
  ...
  claude-code   # paquete nativo nixpkgs
];
```

Requiere variable de entorno:

```bash
export ANTHROPIC_API_KEY=sk-ant-...
```

Para persistirla, agregar en `home/default.nix` → `home.sessionVariables`:

```nix
ANTHROPIC_API_KEY = sk-ant-...;
```

## Auto-upgrade

El sistema se actualiza automáticamente desde GitHub:

```
github:tecnodespegue/nixos-gaming (04:00 diario, con reboot)
```
