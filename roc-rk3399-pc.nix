# This configuration file can be safely imported in your system configuration.
{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  boot.kernelPackages = pkgs.linuxPackagesROCRK3399PC;

  # This list of modules is not entirely minified, but represents
  # a set of modules that is required for the display to work in stage-1.
  # Further minification can be done, but requires trial-and-error mainly.
  boot.initrd.kernelModules = [
    # Rockchip modules
    "rockchip_rga"
    "rockchip_saradc"
    "rockchip_thermal"
    "rockchipdrm"

    # GPU/Display modules
    "analogix_dp"
    "cec"
    "drm"
    "drm_kms_helper"
    "dw_hdmi"
    "dw_mipi_dsi"
    "gpu_sched"
    "panel_simple"
    "panfrost"
    "pwm_bl"
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [
    # TODO: appropriate firmwares for early display init.
  ];
}
