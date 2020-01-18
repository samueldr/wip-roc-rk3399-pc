{ stdenv
, fetchFromGitHub
, buildLinux
, modDirVersionArg ? null
, ... } @ args:

let
  inherit (stdenv.lib)
    concatStrings
    intersperse
    take
    splitString
    optionalString
  ;
in
(
  buildLinux (args // rec {
    version = "5.5.0-rc6";

    # modDirVersion needs to be x.y.z, will automatically add .0 if needed
    modDirVersion = if (modDirVersionArg == null) then concatStrings (intersperse "." (take 3 (splitString "." "${version}.0"))) else modDirVersionArg;

    # branchVersion needs to be x.y
    extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

    src = fetchFromGitHub {
      owner = "torvalds";
      repo = "linux";
      rev = "244dc2689085d7ff478f7b61841e62e59bea4557";
      sha256 = "0awqab6a7rsmyd87icg4yir3za084664j50hclgw6hkpl0ppmpsd";
    };

    postInstall = (optionalString (args ? postInstall) args.postInstall) + ''
      mkdir -p "$out/nix-support"
      cp -v "$buildRoot/.config" "$out/nix-support/build.config"
    '';
  } // (args.argsOverride or {}))
)
