{ buildUBoot
, lib
, python3
, armTrustedFirmwareRK3399
, fetchpatch
, fetchFromGitLab
, fetchFromGitHub
}:

let
  pw = id: sha256: fetchpatch {
    inherit sha256;
    name = "${id}.patch";
    url = "https://patchwork.ozlabs.org/patch/${id}/raw/";
  };

  atf = armTrustedFirmwareRK3399.overrideAttrs(oldAttrs: {
    src = fetchFromGitHub {
      owner = "ARM-software";
      repo = "arm-trusted-firmware";
      rev = "38aac6d4059ed11d6c977c9081a9bf4364227b5a";
      sha256 = "0s08zrw0s0dvrc7229dwk6rzasrj3mrb71q232aiznnv9n5aszkz";
    };
    version = "2019-01-16";
  });
in
(buildUBoot {
  defconfig = "roc-pc-rk3399_defconfig";
  extraMeta.platforms = ["aarch64-linux"];
  BL31 = "${atf}/bl31.elf";
  filesToInstall = [
    "idbloader.img"
    "u-boot.itb"
    ".config"
  ];

  extraPatches = [
  ];
})
.overrideAttrs(oldAttrs: {
  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
    python3
  ];
  postPatch = oldAttrs.postPatch + ''
    patchShebangs arch/arm/mach-rockchip/
  '';

  patches = [
  ];

  src = fetchFromGitLab {
    domain = "gitlab.denx.de";
    owner = "u-boot";
    repo = "u-boot";
    rev = "2d2f91a480f6849a8548414003d36fa030d434f1";
    sha256 = "1p13ajiiyr6gpy8qlwwy08q4mc7c76zmm5vjiqq0wqajgwn3kxkc";
  };
})
