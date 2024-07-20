{ pkgs, ... }:
{
  config = {
    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ libva vaapiVdpau libvdpau-va-gl amdvlk rocmPackages.clr.icd ];
      extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    };

    # Load AMD driver for Xorg and Waylandard
    environment.variables.LIBVA_DRIVER_NAME = "amdgpu";
    environment.variables.VDPAU_DRIVER = "amdgpu";
    services.xserver.videoDrivers = ["amdgpu"];
    hardware.amdgpu.opencl.enable = true;
    systemd.tmpfiles.rules = 
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];
    
    services.ollama = {
      enable = true;
      acceleration = "rocm";
      listenAddress = "0.0.0.0:11434";
      environmentVariables = {
         #SQUID: change this value to match the version for your gfx card as per https://github.com/ollama/ollama/blob/main/docs/gpu.md#overrides
         #HSA_OVERRIDE_GFX_VERSION = "10.1.2";
      };
#      models = "/opt/ollama/models";
    };
    security.wrappers.sunshine = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+p";
        source = "${pkgs.sunshine}/bin/sunshine";
    };
  };
}
