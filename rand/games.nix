{ pkgs, pkgs-unstable, ... }:
{
  config = {
    programs.alvr = {
      enable = true;
      package = pkgs.alvr;
    };
    environment.systemPackages = with pkgs; [
      immersed-vr
      heroic
      lutris
      protonup-qt
    ];
  };
}
