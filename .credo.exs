%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "src/", "web/", "apps/"],
        excluded: [~r"/_build/", ~r"/deps/"]
      },
      requires: [],
      strict: true,
      color: true,
      checks: [
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 120},
      ]
    }
  ]
}
