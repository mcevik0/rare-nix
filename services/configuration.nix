release-manager:

{ config, pkgs, ... }:

let
  ## Switching generations involves deactivating and reactivating the
  ## freerouter service. Executing this from the freerouter service
  ## itself is a bit tricky because it confuses systemd. To work
  ## around this problem, we execute the switch-over in a transient
  ## unit with systemd-run. We use --no-block to force asynchronous
  ## execution, because, for some reason, normal execution leads to a
  ## one-minute delay.  However, if the current service terminates
  ## before the new unit is activated, the old service is restarted
  ## immediately due to "Restart=always". To avoid this, we add a
  ## couple of seconds of delay before exiting to let systemd converge
  ## to the new service units.
  maybeSwitchGeneration = pkgs.writeShellScript "freertr-switch-gen" ''
      file=/etc/freertr/switch-to-generation
      if [ -e $file ]; then
        gen=$(cat $file)
        echo "Switching to RARE profile generation $gen"
        ${pkgs.systemd}/bin/systemd-run --no-block ${release-manager}/bin/release-manager --switch-to-generation $gen
        rm -f $file
        ${pkgs.coreutils}/bin/sleep 5
      fi
  '';
in {
  ## Get rid of the warning about missing stateVersion during
  ## evaluation of the NixOS configuration. This can be kept in sync
  ## with the nixpkgs version.
  system.stateVersion = "23.11";
  systemd.services = {
    freerouter = {
      description = "freeRtr Daemon";
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      serviceConfig = {
        Environment = "TOFINO_MODEL_PORTINFO=/etc/freertr/ports.json";
        ExecStartPre = maybeSwitchGeneration;
        ExecStart = "${pkgs.freerouter}/bin/freerouter routerc /etc/freertr/rtr-";
        ExecStopPost = pkgs.writeShellScript "freertr-exec-stop-post" ''
          [ -z "$EXIT_STATUS" ] && exit 0
          if [ $EXIT_STATUS -eq 3 ]; then
            echo "Warm reload requested by freeRtr"
            . ${maybeSwitchGeneration}
          elif [ $EXIT_STATUS -eq 4 ]; then
            echo "Cold reload requested by freeRtr, initiating reboot"
            ${pkgs.systemd}/bin/systemctl reboot
          fi
          exit 0
        '';
        ## bf_switchd sometimes hangs after a SIGTERM. Decrease the
        ## default timeout for the final SIGKILL.
        TimeoutStopSec = "5";
        Restart = "always";
        Type = "simple";
      };
    };
    snabb-snmp-agent = {
      description = "Snabb SNMP subagent for interface MIBs";
      after = [ "snmpd.service" ];
      requires = [ "snmpd.service" ];
      serviceConfig = {
        ExecStart = "${pkgs.SNMPAgent}/bin/interface --ifindex=/etc/snmp/ifindex --shmem-dir=/var/run/rare-snmp";
        ExecStartPre = "+/bin/mkdir -p /var/run/rare-snmp";
        Restart = "on-failure";
        Type = "simple";
      };
    };
    snmpd = {
      description = "Simple Network Management Protocol (SNMP) Daemon";
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.net-snmp}/sbin/snmpd -Lsd -Lf /dev/null -I -smux,mteTrigger,mteTriggerConf -I -ifTable -f -p /run/snmpd.pid -c /etc/snmp/snmpd.conf";
        ExecStartPre = "/bin/mkdir -p /var/run/agentx";
        ExecReload = "/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
      };
    };
  };
}
