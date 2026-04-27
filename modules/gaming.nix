{ pkgs, lib, ... }:

{
  programs.gamemode.enable = true;

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
    KERNEL=="ntsync", MODE="0666"
  '';

  environment.systemPackages = with pkgs; [
    steam
    steam-run
    heroic
    lutris
    bottles
    protonup-qt
    protontricks
    winetricks
    wineWow64Packages.staging
    mangohud
    goverlay
    gamescope
    vkbasalt
    vkbasalt-cli
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    dxvk
    vkd3d
    gamemode
    antimicrox
    input-remapper
    lact
    corectrl
    ryzenadj
    stress-ng
  ];
}
