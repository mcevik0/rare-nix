## Python overlays are currently not composable, see
## https://github.com/NixOS/nixpkgs/issues/44426. As a crude
## workaround, we just add them as regular packages.

self: super:
{
  python3Pkgs = {
    ## yappi 1.2.5 from nixpkgs is marked as broken. This is a
    ## backport from nixpkgs 21.11
    yappi = self.python3.pkgs.buildPythonPackage rec {
      pname = "yappi";
      version = "1.3.2";
      src = self.fetchFromGitHub {
        owner = "sumerc";
        repo = pname;
        rev = "8bf7a650066f104f59c3cae4a189ec15e7d51c8c";
        sha256 = "1q8lr9n0lny2g3mssy3mksbl9m4k1kqn1a4yv1hfqsahxdvpw2dp";
      };
      doCheck = false;
    };
  };
}
