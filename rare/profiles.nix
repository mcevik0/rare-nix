## P4 profiles to include in the release.  The attribute name defines
## the name of the profile as it appears in /etc/freertr/p4-profile on
## a running system.  Each profile can have two attributes
##
## <profile> = {
##   buildFlags = [ ... ];
##   bffwdFlags = [ ... ];
## }
##
## The buildFlags attribute must exist and specify a list of flags to
## use when compiling bf_router.p4.  The bffwdFlags attribute is
## optional.  If it is omitted, bf_forwarder.py is started directly
## with standard arguments.  If provided, it must be a list of valid
## arguments to be used for that specific profile, e.g.
##
##  no_mpls = {
##    buildFlags = [];
##    bffwdFlags = [ "--mpls false" ];
##  }
##
## would pass "--mpls false" to bf_forwarder.py when the "no_mpls"
## profile is selected.
##
## Note that, by default, all features are enabled for
## bf_forwarder.py.
{
  bier = {
    ## See Issue P4C-3974 in 9.7.1 release notes
    buildFlags = [ ''-DPROFILE_BIER -Xp4c="--disable-parse-depth-limit"'' ] ;
  };
  gre = {
    buildFlags = [ "-DPROFILE_GRE" ];
  };
  l2tp = {
    buildFlags = [ "-DPROFILE_L2TP" ];
  };
  mldp = {
    buildFlags = [ "-DPROFILE_MLDP" ];
  };
  mpls = {
    buildFlags = [ "-DPROFILE_MPLS" ];
  };
  pppoe = {
    buildFlags = [ "-DPROFILE_PPPOE" ];
  };
  rawip = {
    buildFlags = [ "-DPROFILE_RAWIP" ];
  };
  pbr = {
    buildFlags = [ "-DPROFILE_PBR" ];
  };
  ## Profiles with a mix of features used in the GEANT P4 lab
  p4lab_1 = {
    ## MPLS, BIER, MCAST, PBR, POLKA
    buildFlags = [ "-DPROFILE_P4LAB" ];
  };
}
