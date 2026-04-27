{ pkgs, ... }:

{
  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    extraConfig.pipewire = {
      "92-low-latency" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.allowed-rates = [ 44100 48000 88200 96000 176400 192000 ];
          default.clock.quantum = 64;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 1024;
        };
      };
    };
    extraConfig.pipewire-pulse = {
      "92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "32/48000";
              pulse.default.req = "64/48000";
              pulse.max.req = "1024/48000";
              pulse.min.quantum = "32/48000";
              pulse.max.quantum = "1024/48000";
            };
          }
        ];
        stream.properties = {
          node.latency = "64/48000";
          resample.quality = 10;
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
    crosspipe
    qpwgraph
    easyeffects
    calf
    lsp-plugins
    rnnoise-plugin
    jamesdsp
    alsa-utils
    playerctl
    pamixer
  ];
}
