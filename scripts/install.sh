#!/usr/bin/env bash
set -euo pipefail

echo "=== Tecnodespegue NixOS Gaming Autoinstaller ==="

if [[ $EUID -ne 0 ]]; then
  echo "Ejecutalo con sudo."
  exit 1
fi

if [[ -z "${DISK:-}" ]]; then
  DISK="/dev/$(lsblk -d -n -o NAME,TYPE | awk '$2 == "disk" { print $1; exit }')"
fi

if [[ -z "$DISK" || ! -b "$DISK" ]]; then
  echo "ERROR: no encontré disco válido. Usá: sudo DISK=/dev/nvme0n1 bash scripts/install.sh"
  exit 1
fi

export DISK

echo "Disco destino: $DISK"
echo "Se borra TODO el disco. No hay prompts. Esto es intencional para instalación automática."

nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko-config.nix
nixos-install --no-root-passwd --flake .#nixos-gaming

echo "Instalación completa. Reiniciando..."
reboot
