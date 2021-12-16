{ platform, scripts, freerouter, runCommand }:

runCommand "rtr-hw.txt" {} ''
  mkdir -p $out/etc/freertr
  substitute ${./rtr-hw.txt} $out/etc/freertr/rtr-hw.txt \
    --subst-var-by SCRIPTS ${scripts} \
    --subst-var-by FREERTR_NATIVE ${freerouter.native} \
    --subst-var-by PLATFORM ${platform}
''
