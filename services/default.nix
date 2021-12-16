{ pkgs, bf-sde, platform, scripts }:

let
  eval = import (pkgs.path + "/nixos/lib/eval-config.nix") {
    inherit pkgs;
    modules = [ (import ./configuration.nix { inherit bf-sde platform scripts; }) ];
  };
  units = eval.config.systemd.units;

  ## NixOS doesn't manage the [Install] section of units because it
  ## requires a stateful interaction with "systemctl enable" to
  ## activate the unit. But [Install] is required on a non-NixOS
  ## system, hence we add that section here.
  addWantedBy = name: wantedBy:
    let
      unit = units.${name}.unit;
    in pkgs.runCommand "${name}" {} ''
      dest=$out/etc/systemd/system
      mkdir -p $dest
      cp ${unit}/*service $dest
      chmod a+w $dest/*.service
      cat <<EOF >>$dest/*.service
      [Install]
      WantedBy=${wantedBy}
      EOF
    '';
in {
  freerouter-service = addWantedBy "freerouter.service" "multi-user.target";
  bf-switchd-service = addWantedBy "bf-switchd.service" "freerouter.service";
  bf-forwarder-service = addWantedBy "bf-forwarder.service" "bf-switchd.service";
  snabb-snmp-agent-service = addWantedBy "snabb-snmp-agent.service" "snmpd.service";
  snmpd-service = addWantedBy "snmpd.service" "multi-user.target";
}
