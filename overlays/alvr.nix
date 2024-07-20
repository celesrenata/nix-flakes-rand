final: prev: {
  alvrOverride = prev.alvr.overrideAttrs (oldAttrs: rec {
    pname = "alvr";
    version = "20.9.1";
    src = prev.fetchurl {
      url = "https://github.com/alvr-org/ALVR/releases/download/v${version}/ALVR-x86_64.AppImage";
      hash = "sha256-RJ6DN2Na35PaWa5hp7G37eZAIPsSi7otEmyU7vikqMs=";
    };
  });
}
