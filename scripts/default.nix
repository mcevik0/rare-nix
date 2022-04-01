{ runtimeEnv, moduleWrappers, bfForwarder, p4Profiles, nixProfile,
  runCommand, lib, makeWrapper, buildEnv, inetutils, coreutils,
  ethtool, freerouter-native, acpi, bash }:

let
  bfshScripts = [ "sh_tna_ports" "sh_tna_temp" ];
  installBfshScript = name: ''
    cp ${./. + "/${name}.bfsh"} $out/share/bfshell/${name}.bfsh
    substitute ${./. +"/${name}.sh"} $out/bin/${name}.sh \
      --subst-var-by BFSH_SCRIPTS $out/share/bfshell
    chmod a+x $out/bin/${name}.sh
    wrapProgram $out/bin/${name}.sh \
      --set PATH "${lib.strings.makeBinPath [ runtimeEnv ]}"
  '';

  ## An environment that contains the module wrappers for all profiles
  ## of the bf_router P4 program
  moduleWrappersEnv = buildEnv {
    name = "module-wrapper-env";
    paths = builtins.attrValues moduleWrappers;
  };

  ## Create wrappers for bf_forwarder.py that use a profile-dependent
  ## set of arguments and collect all wrappers in an environment.
  profileNames = builtins.attrNames p4Profiles;
  profilesWithForwarderFlags = lib.filterAttrs (n: v: v ? bffwdFlags) p4Profiles;
  mkFwdWrapper = profile: flags:
    runCommand "bf-forwarder-${profile}" {
      inherit (flags) bffwdFlags;
    } ''
      mkdir -p $out/bin
      substitute ${./bf-forwarder-profile.sh} $out/bin/bf_forwarder_${profile} \
        --subst-var-by BF_FORWARDER ${bfForwarder} \
        --subst-var-by FLAGS "$bffwdFlags"
      chmod a+x $out/bin/bf_forwarder_${profile}
    '';
  forwardersEnv = buildEnv {
    name = "forwarders-env";
    paths = lib.mapAttrsToList mkFwdWrapper profilesWithForwarderFlags;
  };

  ## A bash snippet that checks whether the P4 profile referenced by
  ## the "profile" shell variable matches one of the supported
  ## profiles.
  profilesArrayDef = with builtins;
    concatStringsSep " " (
      map (p: "[${p}]=") profileNames
    );
  checkProfile = ''
    declare -A profiles=( ${profilesArrayDef} )
    profiles="${builtins.concatStringsSep ", " profileNames}"
    if [ -z "$profile" ]; then
      echo "Current profile: $(cat $profile_file)"
      echo "Available profiles: $profiles"
      exit 0
    fi
    if ! [ ''${profiles[$profile]+_} ]; then
      echo "Invalid profile $profile, must be one of \"$profiles\""
      exit 1
    fi
  '';
in runCommand "RARE-scripts" {
  buildInputs = [ makeWrapper ];
} (''
  mkdir -p $out/bin
  mkdir -p $out/share/bfshell
  '' + lib.concatStrings (map installBfshScript bfshScripts)
  + ''
    substitute ${./start_bfswd.sh} $out/bin/start_bfswd.sh \
      --subst-var-by CHECK_PROFILE '${checkProfile}' \
      --subst-var-by WRAPPERS ${moduleWrappersEnv}
    chmod a+x $out/bin/start_bfswd.sh

    substitute ${./start_bffwd.sh} $out/bin/start_bffwd.sh \
      --subst-var-by CHECK_PROFILE '${checkProfile}' \
      --subst-var-by WRAPPERS ${forwardersEnv} \
      --subst-var-by BF_FORWARDER ${bfForwarder}
    chmod a+x $out/bin/start_bffwd.sh

    cp ${./if-wrapper.sh} $out/bin/if-wrapper.sh
    wrapProgram $out/bin/if-wrapper.sh \
      --set PATH "${lib.strings.makeBinPath [ inetutils coreutils ]}"
    chmod a+x $out/bin/if-wrapper.sh

    cp ${./pcapInt-wrapper.sh} $out/bin/pcapInt-wrapper.sh
    wrapProgram $out/bin/pcapInt-wrapper.sh \
      --set PATH "${lib.strings.makeBinPath [ ethtool inetutils freerouter-native ]}"
    chmod a+x $out/bin/pcapInt-wrapper.sh

    substitute ${./exec} $out/bin/exec \
      --subst-var-by PATH "${lib.strings.makeBinPath [ coreutils acpi bash ]}"
    chmod a+x $out/bin/exec

    substitute ${./set-profile} $out/bin/set-profile \
      --subst-var-by CHECK_PROFILE '${checkProfile}'
    chmod a+x $out/bin/set-profile

    substitute ${./switch-to-generation} $out/bin/switch-to-generation \
      --subst-var-by NIX_PROFILE '${nixProfile}'
    chmod a+x $out/bin/switch-to-generation

    patchShebangs $out/bin
  '')
