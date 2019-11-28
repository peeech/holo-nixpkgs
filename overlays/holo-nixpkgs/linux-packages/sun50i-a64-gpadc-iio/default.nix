{ stdenv, gitignoreSource, kernel }:

with stdenv.lib;

let
  inherit (stdenv.hostPlatform) system;
in

stdenv.mkDerivation (
  {
    name = "sun50i-a64-gpadc-iio-${kernel.version}";
    src = gitignoreSource ./.;

    hardeningDisable = [ "pic" ];

    KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
    INSTALL_MOD_PATH = "\${out}";

    nativeBuildInputs = kernel.moduleBuildDependencies;

    meta.platforms = platforms.linux;
  } // optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) {
    ARCH = {
      aarch64-linux = "arm64";
      x86_64-linux = "x86";
    }."${system}" or throw "unsupported host: ${system}";

    CROSS_COMPILE = stdenv.cc.targetPrefix;
  }
)
