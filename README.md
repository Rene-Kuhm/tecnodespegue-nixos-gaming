# Tecnodespegue NixOS Gaming ISO

ISO NixOS para gaming, Hyprland, desarrollo terminal-first, audio low-latency, OpenRGB, liquidctl, Warp, Zsh, OpenCode, Claude Code y Codex.

## Build

```bash
nix build .#nixosConfigurations.iso.config.system.build.isoImage
```

La ISO queda en `result/iso/tecnodespegue-nixos-gaming.iso`.

## Instalar

Arrancar desde la ISO y ejecutar:

```bash
cd ~/nixos-iso
sudo nix run .#autoinstall
```

Alternativa directa:

```bash
sudo bash scripts/install.sh
```

Si querés forzar un disco concreto:

```bash
sudo DISK=/dev/nvme0n1 bash scripts/install.sh
```

Usuario final: `tecnodespegue`.

Contraseña: `1985`.

## Seguridad

Los tokens de `GH_TOKEN`, `HF_TOKEN`, `OPENROUTER_API_KEY` y similares NO se incluyen. Configuralos después como variables de entorno o con tu gestor de secretos.
