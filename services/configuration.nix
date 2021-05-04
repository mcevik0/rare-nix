{ config, pkgs, ... }:

{
  systemd.services = {
    freerouter = {
      description = "freeRtr Daemon";
      after = [ "networking.service" ];
      requires = [ "networking.service" ];
      serviceConfig = {
        ExecStart = "${pkgs.freerouter}/bin/freerouter router /etc/freertr/rtr-";
        Restart = "on-failure";
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
