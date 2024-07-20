{ pkgs, ... }:
{
  config = {
    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
      extraPackages = with pkgs; [ intel-vaapi-driver libvdpau-va-gl ];
    };

    # Load Intel driver for Xorg and Waylandard
    environment.variables.LIBVA_DRIVER_NAME = "i965";
    services.xserver.videoDrivers = [ "intel" ];
    security.wrappers.sunshine = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+p";
        source = "${pkgs.sunshine}/bin/sunshine";
    };
  };
}
