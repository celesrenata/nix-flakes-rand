{ config, lib, pkgs, pkgs-unstable, ... }:
{
  config = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      supportedFilesystems = [ "ntfs" "nfs" ];
      plymouth.enable = true;
      kernelPackages = pkgs-unstable.linuxPackages_latest;
      kernelModules = [ "uinput" ];
    };
  };
}
