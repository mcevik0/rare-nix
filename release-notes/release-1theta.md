# Release 1theta

Eigth test release, candidate for first production release

The change to have separate systemd services for the bf_switchd and
bf_forwarder processes introduced in 1eta is reverted in this release.
Freerouter now supports logging of the output of external processes,
the lack of which was the main motivation for creating the systemd
processes.

The SDE version is moved to 9.7.1 to address a deficiency in the
Tofino ASIC (see issue P4C-3974 in 9.7.1 release notes).

The installers can be built for a subset of the supported kernels and
platforms if desired. The objects to build (release, installers) must
be selected explicitly in release.nix. The ONIE installer can now be
built for a specific set of binary caches.

The release-manager is made accessible from the freerouter CLI through
a set of aliases at the exec level

tna-install-latest       Install the latest commit of the master branch
tna-install-git          Install the version from a specific Git commit
tna-install-release      Install the specified release
tna-update-release       Install the latest update of the specified release
tna-list-installed       List all currently installed releases
tna-list-available       List all available releases
tna-uninstall-generation Delete the specified generation, use tna-cleanup to permanently remove packages
tna-cleanup              Permanently remove unused packages
tna-switch-to-generation Select the RARE profile generation to activate and restart freerouter

Two more aliases are available to show and change the active P4
profile

tna-set-profile   Set the p4 profile and restart the data-plane processes
tna-list-profiles List the available p4 profiles

**Do not use in production **
