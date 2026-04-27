{ pkgs, ... }:

{
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
    server.port = 6742;
  };

  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];

  environment.systemPackages = with pkgs; [
    openrgb
    liquidctl
    lm_sensors
  ];

  systemd.services.hydrotemp-monitor = {
    description = "HydroTemp monitor equivalent for Corsair/AIO sensors";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.liquidctl}/bin/liquidctl initialize all";
    };
  };
}
