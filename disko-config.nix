{ disko.devices = {
  disk.main = {
    type = "disk";
    device = builtins.getEnv "DISK";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            extraArgs = [ "-n" "BOOT" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-L" "nixos" "-f" ];
            subvolumes = {
              "@" = { mountpoint = "/"; mountOptions = [ "compress=zstd" "noatime" ]; };
              "@home" = { mountpoint = "/home"; mountOptions = [ "compress=zstd" "noatime" ]; };
              "@nix" = { mountpoint = "/nix"; mountOptions = [ "compress=zstd" "noatime" ]; };
              "@log" = { mountpoint = "/var/log"; mountOptions = [ "compress=zstd" "noatime" ]; };
            };
          };
        };
      };
    };
  };
}; }
