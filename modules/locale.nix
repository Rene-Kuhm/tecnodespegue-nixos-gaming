{ pkgs, ... }:

{
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  environment.systemPackages = with pkgs; [
    hunspell
    hunspellDicts.es_AR
    aspell
    aspellDicts.es
  ];
}
