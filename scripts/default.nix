{ bf-sde, moduleWrappers, runCommand, lib, makeWrapper,
  buildEnv, coreutils, utillinux, inetutils }:

let
  install = name: ''
    cp ${./. + "/${name}.bfsh"} $out/share/bfshell/${name}.bfsh
    substitute ${./. +"/${name}.sh"} $out/bin/${name}.sh \
      --subst-var-by BFSH_SCRIPTS $out/share/bfshell
    chmod a+x $out/bin/${name}.sh
    wrapProgram $out/bin/${name}.sh \
      --set PATH "${lib.strings.makeBinPath [ bf-sde ]}"
  '';
  scripts = [ "sh_tna_ports" "sh_tna_temp" ];
  wrappersEnv = buildEnv {
    name = "RARE-wrapper-env";
    paths = builtins.attrValues moduleWrappers;
  };
in runCommand "RARE-scripts" {
  buildInputs = [ makeWrapper ];
} (''
  mkdir -p $out/bin
  mkdir -p $out/share/bfshell
  '' + lib.concatStrings (map install scripts)
  + ''

    substitute ${./start_bfswd.sh} $out/bin/start_bfswd.sh \
      --subst-var-by WRAPPERS ${wrappersEnv}
    chmod a+x $out/bin/start_bfswd.sh

    cp ${./if-wrapper.sh} $out/bin/if-wrapper.sh
    wrapProgram $out/bin/if-wrapper.sh \
      --set PATH "${lib.strings.makeBinPath [ inetutils ]}"
    chmod a+x $out/bin/if-wrapper.sh

    patchShebangs $out/bin
  '')
