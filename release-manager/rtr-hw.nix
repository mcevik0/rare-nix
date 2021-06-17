{ platform, nixProfile, runCommand }:

let
  hwId = {
    accton_wedge100bf_32x = "wedge100bf32x";
    accton_wedge100bf_32qs = "wedge100bf32qs";
    accton_wedge100bf_65x = "wedge100bf65x";
    inventec_d5264q28b = "d5264q28b";
    stordis_bf2556x_1t = "bf2556x1t";
    stordis_bf6064x_t = "bf6064xt";
  }.${platform};
in runCommand "rtr-hw.txt" {} ''
  mkdir -p $out/etc/freertr
  substitute ${./rtr-hw.txt} $out/etc/freertr/rtr-hw.txt \
    --subst-var-by NIX_PROFILE ${nixProfile} \
    --subst-var-by HWID ${hwId}
''
