# Release 1delta

Fourth test release.

This release uses v10 of `bf-sde-nixpkgs`. The release management
functions have been generalized and factored out of
`rare-nix`. Additional functionality includes

   * Improved multi-platform support, e.g. per-platform settings for
     the serial console.
   * Customisable ONIE installer to include user accounts.

v10 also supports SDE 9.6.0 but RARE remains pinned to 9.5.0 due to
missing BSPs for the APS and Inventec platforms.

**Do not use in production **
