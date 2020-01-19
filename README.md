WIP stuff to get started on the Libre Computer ROC-RK3399-PC (Renegade Elite)

## Using in your configuration

Clone this repository somwhere, and in your configuration.nix

```
{
  imports = [
    .../libre-computer_roc-rk3399-pc/roc-rk3399-pc.nix
  ];
}
```

That entry point will try to stay unopinionated, while maximizing the hardware
compatibility.

## Compatibility

### Tested

### Untested

### Known issues

## Image build

```
$ ./build.sh
$ lsblk /dev/mmcblk0 && sudo dd if=$(echo result/sd-image/*.img) of=/dev/mmcblk0 bs=8M oflag=direct status=progress
```

The `build.sh` script transmits parameters to `nix-build`, so e.g. `-j0` can
be used.

Once built, this image is self-sufficient, meaning that it should already be
booting, no need burn u-boot to it.

The required modules (and maybe a bit more) are present in stage-1 so the
display should start early enough in the boot process.

The LED should start up with the amber colour ASAP with this u-boot
configuration, as a way to show activity early. The kernel should set it to
green as soon as it can.

## Note about cross-compilation

This will automatically detect the need for cross-compiling or not.

When cross-compiled, all caveats apply. Here this mainly means that the kernel
will need to be re-compiled on the device on the first nixos-rebuild switch,
while most other packages can be fetched from the cache.

## `u-boot`

Assuming `/dev/mmcblk0` is an SD card.

```
$ nix-build -A pkgs.ubootROCRK3399PC
$ lsblk /dev/mmcblk0 && sudo dd if=result/idbloader.img of=/dev/mmcblk0 bs=512 seek=64 oflag=direct,sync && sudo dd if=result/u-boot.itb of=/dev/mmcblk0 bs=512 seek=16384 oflag=direct,sync
```

Installing to SPI has yet to be investigated.

### Updating SD card u-boot from NixOS

**Caution:** this could render your system unbootable. Do this when you are in
a situation where you can debug and fix the system if this happens. With this
said, it should be safe enough.

```
$ nix-build -A pkgs.ubootROCRK3399PC
$ lsblk /dev/disk/by-path/platform-fe320000.sdhci && sudo dd if=result/idbloader.img of=/dev/disk/by-path/platform-fe320000.sdhci bs=512 seek=64 oflag=direct,sync && sudo dd if=result/u-boot.itb of=/dev/disk/by-path/platform-fe320000.sdhci bs=512 seek=16384 oflag=direct,sync
```

