## Implementation of the activate()/deactivate() functions of the
## standard release-manager provided by bf-sde-nixpkgs. It is sourced
## by the release-manager script.

SYSTEMD_DIR=/etc/systemd/system
CONFIG_DIR=/etc/freertr
CONFIG_SW=$CONFIG_DIR/rtr-sw.txt
CONFIG_HW=$CONFIG_DIR/rtr-hw.txt
P4_PROFILE=$CONFIG_DIR/p4-profile
SNMP_CONFIG_DIR=/etc/snmp
SNMPD_CONFIG=$SNMP_CONFIG_DIR/snmpd.conf
IFINDEX=$SNMP_CONFIG_DIR/ifindex.init
SNMP_STATE_DIR=/var/lib/snmp
INTERFACE_CONFIG=$SNMP_STATE_DIR/interface.conf
SHELL_PROFILE=/etc/profile.d/RARE.sh
activate () {
    check_root
    INFO "Enabling services"
    for service in $PROFILE$SYSTEMD_DIR/*.service; do
        ln -fs $service $SYSTEMD_DIR
        systemctl enable $(basename $service)
    done
    ! ischroot && systemctl daemon-reload
    for dir in $CONFIG_DIR $SNMP_CONFIG_DIR $SNMP_STATE_DIR; do
        [ -d $dir ] || mkdir -p $dir
    done
    for file in $IFINDEX $INTERFACE_CONFIG; do
        cp $PROFILE$file $file
    done
    for config in $CONFIG_SW $P4_PROFILE $SNMPD_CONFIG; do
        [ -e $config ] || cp $PROFILE$config $config
    done
    for config in $CONFIG_HW; do
	ln -fs $PROFILE$config $config
    done
    if [ ! -e $SHELL_PROFILE ]; then
        echo PATH=$PROFILE/bin:\$PATH >$SHELL_PROFILE
    fi
    if ! ischroot; then
        INFO "Starting services"
        systemctl start freerouter snmpd
    fi
}

deactivate () {
    check_root
    INFO "Stopping services"
    systemctl stop snmpd freerouter || true
    INFO "Disabling services"
    for service in $PROFILE/$SYSTEMD_DIR/*.service; do
        systemctl disable $(basename $service) || true
    done
    if [ -e $CONFIG_HW ]; then
	if [ "$(printf $(md5sum $CONFIG_HW))" == "$(printf $(md5sum $PROFILE$CONFIG_HW))" ]; then
	    INFO "Removing $CONFIG_HW"
	    rm -f $CONFIG_HW
	else
	    hash=$(md5sum $CONFIG_HW)
	    save=${CONFIG_HW}.${hash:1:6}
	    INFO "$CONFIG_HW was modified after installation, keeping it as $save"
	    mv $CONFIG_HW $save
	fi
    fi
    INFO "Unloading kernel modules"
    for module in $(lsmod | awk '{print $1}'); do
        [[ $module =~ bf_ ]] && rmmod $module || true
    done
}
