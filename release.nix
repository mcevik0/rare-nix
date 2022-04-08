{
  ## Hydra jobsets must declare src to be a specific version of this
  ## Git repository
  src
, buildRelease ? true
, buildStandaloneInstaller ? false
, buildOnieInstaller ? false
  ## See default.nix
, binaryCaches ? []
, installerPlatforms ? []
. installerKernels ? []
}:

let
  optionalAttrs = cond: set:
    if cond then set else {};
in
with import ./. {
  inherit (src) gitTag;
  inherit binaryCaches;
};

(optionalAttrs buildRelease {
  ## The releases and releasesClosure derivations have the same
  ## closure. releasesClosure is used by the Hydra post-build hook
  ## to copy the closure to a separate binary cache.
  inherit release releaseClosure;
}) //
(optionalAttrs buildStandaloneInstaller {
  inherit standaloneInstaller;
}) //
(optionalAttrs buildOnieInstaller {
  inherit onieInstaller;
})
