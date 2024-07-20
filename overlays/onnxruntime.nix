final: prev:
rec {
  onnxruntimeOverride = prev.onnxruntime.overrideAttrs (old: {
    rocmSupport = true;
  });
}
