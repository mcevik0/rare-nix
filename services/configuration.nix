{ platform, scripts }:

{ config, pkgs, ... }:

let
  maybeReboot = pkgs.writeShellScript "freertr-exec-stop-post" ''
    if [ $EXIT_STATUS -eq 4 ]; then
      echo "cold reload requested by freeRtr, initiating reboot"
      ${pkgs.systemd}/bin/systemctl reboot
    fi
    exit 0
  '';
in {
  systemd.services = {
    freerouter = {
      description = "freeRtr Daemon";
      after = [ "networking.service" ];
      requires = [ "networking.service" ];
      serviceConfig = {
        ExecStart = "${pkgs.freerouter}/bin/freerouter router /etc/freertr/rtr-";
        ExecStopPost = "${maybeReboot}";
        Restart = "on-failure";
        Type = "simple";
      };
    };
    bf-switchd = {
      description = "bf_switchd process for freerouter";
      after = [ "freerouter.service" ];
      requires = [ "freerouter.service" ];
      serviceConfig = {
        ExecStart = "${scripts}/bin/start_bfswd.sh /etc/freertr/p4-profile";
        Type = "simple";
      };
      unitConfig = {
        ConditionFileNotEmpty = "/etc/freertr/p4-profile";
      };
    };
    bf-forwarder = {
      description = "bf_forwarder process for freerouter";
      after = [ "bf-switchd.service" ];
      requires = [ "bf-switchd.service" ];
      serviceConfig = {
        ExecStart = "${scripts}/bin/start_bffwd.sh /etc/freertr/p4-profile --no-log-keepalive --platform=${platform} --snmp --ifmibs-dir /var/run/rare-snmp --ifindex /etc/snmp/ifindex ";
        Type = "simple";
      };
      unitConfig = {
        ConditionFileNotEmpty = "/etc/freertr/p4-profile";
      };
    };
    snabb-snmp-agent = {
      description = "Snabb SNMP subagent for interface MIBs";
      after = [ "snmpd.service" ];
      requires = [ "snmpd.service" ];
      serviceConfig = {
        ExecStart = "${pkgs.SNMPAgent}/bin/interface --ifindex=/etc/snmp/ifindex --shmem-dir=/var/run/rare-snmp";
        ExecStartPre = "+/bin/mkdir -p /var/run/rare-snmp";
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
      };
    };
  };
}
