{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    cmake
    pkg-config
    openssl
    docker-compose
    kubectl
    k9s
    terraform
    ansible
  ];
}
