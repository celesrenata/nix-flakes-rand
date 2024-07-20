{ pkgs, pkgs-unstable, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      immersed-vr
      heroic
      lutris
      protonup-qt
    ];
  };
}
