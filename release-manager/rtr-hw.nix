{ lib, bf-sde, platform, scripts, freerouter-native, runCommand }:

let
  forwarderExtraArgs = lib.optionalString (platform == "stordis_bf2556x_1t")
    "--sal-grpc-server-address=127.0.0.1:${bf-sde.pkgs.bf-platforms.aps_bf2556.salRefApp.salGrpcPort}";
in runCommand "rtr-hw.txt" {} ''
  mkdir -p $out/etc/freertr
  substitute ${./rtr-hw.txt} $out/etc/freertr/rtr-hw.txt \
    --subst-var-by SCRIPTS ${scripts} \
    --subst-var-by FREERTR_NATIVE ${freerouter-native} \
    --subst-var-by PLATFORM ${platform} \
    --subst-var-by BFFWD_EXTRA_ARGS "${forwarderExtraArgs}" \
    --subst-var-by BF_UTILS ${bf-sde.pkgs.bf-utils}
''
