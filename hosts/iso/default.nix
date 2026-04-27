{ pkgs, lib, ... }:

{
  isoImage = {
    volumeID = "NIXOS_GAMING";
    makeEfiBootable = true;
    makeUsbBootable = true;
  };

  image.fileName = "tecnodespegue-nixos-gaming.iso";

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "1985";
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git
    vim
    disko
    parted
    gptfdisk
    btrfs-progs
  ];

  services.getty.autologinUser = lib.mkForce "nixos";

  systemd.services.copy-nixos-config = {
    description = "Copy bundled NixOS gaming config to ISO home";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /home/nixos/nixos-iso
      cp -r ${../../.}/* /home/nixos/nixos-iso/
      chown -R nixos:users /home/nixos/nixos-iso
    '';
  };
}
