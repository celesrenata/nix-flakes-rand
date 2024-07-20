{ config, lib, pkgs, pkgs-unstable, ... }:
{
  config = {
    nixpkgs.config.allowUnsupportedSystem = true;
    boot = {
      binfmt.emulatedSystems = [ "aarch64-linux" ];
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      supportedFilesystems = [ "ntfs" "nfs" ];
      plymouth.enable = true;
      kernelPackages = pkgs-unstable.linuxPackages_latest;
      kernelModules = [ "uinput" "amdgpu" ];
    };
  };
}
