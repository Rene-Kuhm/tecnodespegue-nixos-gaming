{
  description = "NixOS Gaming ISO - tecnodespegue";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    stylix.url = "github:danth/stylix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, hyprland, nixos-hardware, stylix, sops-nix, ... }@inputs: {
    nixosConfigurations = {
      nixos-gaming = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; isIso = false; };
        modules = [
          ./configuration.nix
          ./modules/development.nix
          ./modules/stylix.nix
          ./modules/audio.nix
          ./modules/gaming.nix
          ./modules/locale.nix
          ./modules/rgb.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.tecnodespegue = import ./home/default.nix;
          }
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          disko.nixosModules.disko
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-ssd
        ];
      };

      iso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; isIso = true; };
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
          ./hosts/iso/default.nix
          ./configuration.nix
          ./modules/development.nix
          ./modules/stylix.nix
          ./modules/audio.nix
          ./modules/gaming.nix
          ./modules/locale.nix
          ./modules/rgb.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.tecnodespegue = import ./home/default.nix;
          }
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          disko.nixosModules.disko
        ];
      };
    };

    apps.x86_64-linux = {
      autoinstall = {
        type = "app";
        meta.description = "Automatic destructive NixOS gaming installer";
        program = toString (nixpkgs.legacyPackages.x86_64-linux.writeShellScript "autoinstall" ''
          echo "=== NixOS Gaming Autoinstaller ==="
          echo "Detecting primary disk..."
          DISK=$(lsblk -d -n -o NAME,SIZE,TYPE | grep disk | head -1 | awk '{print $1}')
          if [ -z "$DISK" ]; then
            echo "ERROR: No disk found!"
            exit 1
          fi
          export DISK="/dev/$DISK"
          echo "Using disk: $DISK"
          echo "WARNING: This will ERASE ALL DATA on $DISK. No prompts by design."

          echo "Partitioning disk..."
          nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko-config.nix

          echo "Installing NixOS..."
          nixos-install --no-root-passwd --flake .#nixos-gaming

          echo "Installation complete! Rebooting..."
          reboot
        '');
      };
    };
  };
}
