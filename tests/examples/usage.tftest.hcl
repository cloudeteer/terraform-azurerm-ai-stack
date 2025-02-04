run "test_example_usage" {
  command = apply

  module {
    source = "./examples/usage"
  }
}
