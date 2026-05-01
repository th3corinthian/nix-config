self: super: {
  python3 = super.python3.override (old: {
    packageOverrides = super.lib.composeExtensions
      (old.packageOverrides or (_: _: { }))
      (pyfinal: pyprev: {
        cli-helpers = pyprev.cli-helpers.overridePythonAttrs (oldAttrs: {
          disabledTests = (oldAttrs.disabledTests or [ ]) ++ [
            "test_style_output"
            "test_style_output_with_newlines"
            "test_style_output_custom_tokens"
          ];
        });
      });
  });
}
