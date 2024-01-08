let
  overlay = self: super:
    {
      jdk = self.jdk21_headless;
      freerouter-jar = super.callPackage freerouter/jar.nix {};
      freerouter = super.callPackage ./freerouter {};
      freerouter-native = super.callPackage ./freerouter/native.nix {
        stdenv = self.gcc12Stdenv;
        clang = self.clang_14;
        openssl = self.openssl_3;
      };

      ## The standard net-snmp package does not enabled Perl modules
      net-snmp = (super.net-snmp.overrideAttrs (oldAttrs: rec {
        configureFlags = oldAttrs.configureFlags ++
          [ "--with-perl-modules"
            "--with-persistent-directory=/var/lib/snmp"
          ];

        buildInputs = oldAttrs.buildInputs ++ [ self.libxcrypt ];

        ## Install Perl modules to $out rather than the Perl package
        preConfigure = ''
          perlversion=$(perl -e 'use Config; print $Config{version};')
          perlarchname=$(perl -e 'use Config; print $Config{archname};')
          installFlags="INSTALLSITEARCH=$out/lib/perl5/site_perl/$perlversion/$perlarchname INSTALLARCHLIB=$out/lib/perl5/site_perl/$perlversion/$perlarchname INSTALLSITEMAN3DIR=$out/share/man/man3"
        '';

        ## The standard package uses multiple outputs, but this fails
        ## when Perl modules are enabled.  This override should be fixed
        ## to support this.
        outputs = [ "out" ];

        ## Skip multi-output logic
        postInstall = "true";
      })).override { withPerlTools = true; };

      SNMPAgent = super.callPackage ./snmp {};
    };
in [ overlay ]
