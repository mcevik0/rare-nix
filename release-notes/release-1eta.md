# Release 1eta

Seventh test release.

This release includes support for the APS BF2556X-1T platform for SDE
versions 9.5.0 and 9.7.0. That platform contains a Marvell gear box to
provide 1GE ports. In contrast to the reference platforms, this device
requires that bf_switchd is started indirectly by a daemon called
salRefApp, which provides a "Switch Abstraction Layer" interface that
manages the gear box.

The systemd services that make up RARE has been redesigned to include
separate services for bf-switchd and bf-forwarder, which were
previously started as externel processes by freerouter.  This change
puts all major daemons on an equal footing and also provides logging
that was missing in the previous design.

RARE is now using SDE 9.7.0 and includes an additional P4 profile
called p4lab_1, which combines the features MPLS, PBR, BIER, MCAST and
POLKA.

The P4 profile ist selected by the file
/etc/freertr/p4-profile. Changing the profile requires a restart of
the freerouter service.

**Do not use in production **
