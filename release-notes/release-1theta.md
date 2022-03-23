# Release 1theta

Eigth test release.

The change to have separate systemd services for the bf_switchd and
bf_forwarder processes introduced in 1eta is reverted in this release.
Freerouter now supports logging of the output of external processes,
the lack of which was the main motivation for creating the systemd
processes.

The SDE version is moved to 9.7.1 to address a deficiency in the
Tofino ASIC (see issue P4C-3974 in 9.7.1 release notes).

**Do not use in production **
