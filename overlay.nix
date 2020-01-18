final: super:

let
  inherit (final) callPackage kernelPatches linuxPackagesFor;
in
{
  ubootROCRK3399PC = callPackage ./u-boot {};
  linuxROCRK3399PC = callPackage ./kernel {
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      #kernelPatches.export_kernel_fpu_functions
      {
        name = "config-fixes";
        patch = null;
        extraConfig = ''
          # It looks like the *moment* the typec module is loaded, all power
          # is cut to the device. This is likely from "tablet/laptop" assumptions.
          TYPEC n
        '';
      }
    ];
  };
  linuxPackagesROCRK3399PC = linuxPackagesFor final.linuxROCRK3399PC;
}
