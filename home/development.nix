{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    bun
    pnpm
    yarn
    deno
    python3
    uv
    ruff
    go
    rustup
    gh
    lazygit
    lazydocker
  ];
}
