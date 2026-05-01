self: super: {
  python3 = super.python3.override (old: {
    packageOverrides = super.lib.composeExtensions
      (old.packageOverrides or (_: _: { }))
      (pyfinal: pyprev: {
        cli-helpers = pyprev.cli-helpers.overridePythonAttrs (_: {
          doCheck = false;
        });
      });
  });
}
